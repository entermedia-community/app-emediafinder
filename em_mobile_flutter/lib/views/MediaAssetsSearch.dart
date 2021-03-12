import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CustomSearchBar.dart';
import 'package:em_mobile_flutter/views/ImageView.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';

class MediaAssetsSearch extends StatefulWidget {
  final userWorkspaces myWorkspaces;
  final int currentWorkspace;
  final String searchText;
  final Organizedhit organizedHits;
  MediaAssetsSearch({
    Key key,
    @required this.myWorkspaces,
    @required this.currentWorkspace,
    @required this.searchText,
    @required this.organizedHits,
  }) : super(key: key);

  @override
  _MediaAssetsSearchState createState() => _MediaAssetsSearchState();
}

class _MediaAssetsSearchState extends State<MediaAssetsSearch> {
  String searchText = "";
  List<MediaResults> result = new List<MediaResults>();
  List<MediaResults> filteredResult = new List<MediaResults>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int totalPages = 1;
  int currentPage = 1;
  TextEditingController searchController = new TextEditingController();

  void filterContent() async {
    searchText = widget.searchText;
    setState(() {});
    _filterResult();
  }

  @override
  void initState() {
    _getAllImages();
    searchController..text = widget.searchText;
    filterContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c223a),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (BuildContext context, bool value, _) {
          return value
              ? InkWell(
                  enableFeedback: false,
                  onTap: () => print(""),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _searchBar(context),
                        SizedBox(height: 15),
                        _imageView(context),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  _getAllImages() async {
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final MediaAssetModel assetResponse = await EM.getMediaAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
    );
    if (assetResponse != null && assetResponse.response.status == "ok") {
      result = assetResponse.results;
      filteredResult = result;
      setState(() {});
    }
    print(assetResponse);
    isLoading.value = false;
  }

  void resetData() {
    filteredResult = result;
    currentPage = 1;
    totalPages = 1;
    setState(() {});
  }

  _filterResult() async {
    if (searchText.length <= 2) {
      resetData();
    } else {
      totalPages = 1;
      currentPage = 1;
      final EM = Provider.of<EnterMedia>(context, listen: false);
      final myUser = Provider.of<userData>(context, listen: false);
      print(myUser.entermediakey);
      final MediaAssetModel assetSearchResponse = await EM.searchMediaAssets(
        context,
        widget.myWorkspaces.instUrl[widget.currentWorkspace],
        searchText,
        (currentPage).toString(),
      );
      if (assetSearchResponse != null && assetSearchResponse.response.status == "ok") {
        filteredResult = [];
        filteredResult = assetSearchResponse.results;
        currentPage = assetSearchResponse.response.page;
        totalPages = assetSearchResponse.response.pages;
      }
      setState(() {});
      print(assetSearchResponse);
    }
  }

  _loadMoreImages() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final MediaAssetModel assetSearchResponse = await EM.searchMediaAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
      searchText,
      (currentPage + 1).toString(),
    );
    if (assetSearchResponse != null && assetSearchResponse.response.status == "ok") {
      filteredResult.addAll(assetSearchResponse.results);
      currentPage = assetSearchResponse.response.page;
      totalPages = assetSearchResponse.response.pages;
      setState(() {});
    }
    print(assetSearchResponse);
  }

  Widget _searchBar(BuildContext context) {
    return CustomSearchBar(searchController, (val) {
      searchText = val;
      _filterResult();
      setState(() {});
    }, context);
  }

  Widget _imageView(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MasonryGrid(
            staggered: true,
            children: getImages(),
            column: 2,
          ),
          /*Wrap(
            children: getImages(),
          ),*/
          currentPage < totalPages
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: RaisedButton(
                      child: Text("Load more"),
                      onPressed: () => _loadMoreImages(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  List<Widget> getImages() {
    String errorUrl = "https://img.icons8.com/FF0000/error";
    List<Widget> image = [];
    for (int index = 0; index < filteredResult.length; index++) {
      String url = filteredResult[index].downloads.length == 0
          ? errorUrl
          : ("${widget.myWorkspaces.instUrl[widget.currentWorkspace].toString()}${(filteredResult[index].downloads[3].url)}").trim();
      String fullResolutionImageurl = filteredResult[index].downloads.length == 0 ? errorUrl : ("${(filteredResult[index].downloads[2].url)}").trim();
      print(url);
      image.add(
        _singleImageTile(imageUrl: url, fullScreenImageUrl: fullResolutionImageurl),
      );
    }
    if (image.length == 0) {
      image.add(Container());
    }
    return image;
  }

  Widget _singleImageTile({
    @required String imageUrl,
    @required String fullScreenImageUrl,
  }) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black,
      color: Colors.transparent,
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(
                collectionId: null,
                instanceUrl: widget.myWorkspaces.instUrl[widget.currentWorkspace],
                hasDirectLink: true,
                directLink: '$fullScreenImageUrl',
              ),
            ),
          );
        },
      ),
    );
  }
}
