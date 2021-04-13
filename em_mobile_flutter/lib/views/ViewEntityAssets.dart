import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CustomSearchBar.dart';
import 'package:em_mobile_flutter/views/ImageView.dart';
import 'package:flutter/material.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';

class ViewEntityAssets extends StatefulWidget {
  final userWorkspaces myWorkspaces;
  final int currentWorkspace;
  final String searchText;
  final String entityId;
  final String instanceUrl;
  ViewEntityAssets({
    Key key,
    @required this.myWorkspaces,
    @required this.currentWorkspace,
    @required this.searchText,
    @required this.entityId,
    @required this.instanceUrl,
  }) : super(key: key);
  @override
  _ViewEntityAssetsState createState() => _ViewEntityAssetsState();
}

class _ViewEntityAssetsState extends State<ViewEntityAssets> {
  String searchText = "";
  List<MediaResults> result = new List<MediaResults>();
  List<MediaResults> filteredResult = new List<MediaResults>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int totalPages = 1;
  int currentPage = 1;
  TextEditingController searchController = new TextEditingController();

/*  void filterContent() async {
    searchText = widget.searchText;
    setState(() {});
    _filterResult();
  }*/

  @override
  void initState() {
    searchText = widget.searchText;
    searchController..text = widget.searchText;
    _getAllImages();

    // filterContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c223a),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          ValueListenableBuilder<bool>(
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
                            // _searchBar(context),
                            _imageView(context),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  _getAllImages() async {
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    List<MediaResults> mediaResult = [];
    final MediaAssetModel assetResponse = await EM.searchMediaAssets(
      context,
      widget.instanceUrl,
      searchText,
      currentPage.toString(),
    );
    if (assetResponse != null && assetResponse.response.status == "ok") {
      if (widget.searchText.toLowerCase().trim() == 'event') {
        mediaResult = assetResponse.results.where((element) => element.entityevent.id.contains(widget.entityId)).toList();
      } else if (widget.searchText.toLowerCase().trim() == 'project') {
        mediaResult = assetResponse.results.where((element) => element.entityproject.id.contains(widget.entityId)).toList();
      }

      result = mediaResult;
      filteredResult = result;
      currentPage = assetResponse.response.page;
      totalPages = assetResponse.response.pages;
      setState(() {});
    }
    print(assetResponse);
    await print("LOGLOG");
    await print(widget.entityId);
    await print(widget.searchText);
    isLoading.value = false;
  }

  void resetData() {
    filteredResult = result;
    currentPage = 1;
    totalPages = 1;
    setState(() {});
  }

/*  _filterResult() async {
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
        widget.instanceUrl,
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
  }*/

  _loadMoreImages() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final MediaAssetModel assetSearchResponse = await EM.searchMediaAssets(
      context,
      widget.instanceUrl,
      searchText == null || searchText.length < 3 ? '*' : searchText,
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

  /* Widget _searchBar(BuildContext context) {
    return CustomSearchBar(searchController, (val) {
      searchText = val;
      _filterResult();
      setState(() {});
    }, context);
  }*/

  Widget _imageView(BuildContext context) {
    return Container(
      child: filteredResult.length < 1
          ? Container(
              height: MediaQuery.of(context).size.height * 0.75,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Center(
                child: Text(
                  "No media file with ${widget.searchText} tag is found.",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MasonryGrid(
                  staggered: true,
                  children: getImages(),
                  column: 3,
                ),
                currentPage < totalPages
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: TextButton(
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
          child: CachedNetworkImage(
            imageUrl: "$imageUrl",
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.contain,
          ) /*Image.network(
            imageUrl,
            fit: BoxFit.contain,
          )*/
          ,
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

String getEntityId(String entity) {
  ///TODO: IF THERE ARE MORE ENTITIES IN FUTURE THEN MAKE SURE TO ADD IT HERE
  Map<String, String> entityToId = {
    'project': 'entityproject',
    'event': 'entityevent',
  };
  return entityToId[entity].toLowerCase();
}
