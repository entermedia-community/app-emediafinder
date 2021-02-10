import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

class MediaAssetsSearch extends StatefulWidget {
  final userWorkspaces myWorkspaces;
  final int currentWorkspace;
  MediaAssetsSearch({
    Key key,
    @required this.myWorkspaces,
    @required this.currentWorkspace,
  }) : super(key: key);

  @override
  _MediaAssetsSearchState createState() => _MediaAssetsSearchState();
}

class _MediaAssetsSearchState extends State<MediaAssetsSearch> {
  String searchText = "";
  List<MediaResults> result = new List<MediaResults>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int totalPages = 1;
  int currentPage = 1;

  @override
  void initState() {
    _getAllImages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c223a),
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
                            _searchBar(context),
                            SizedBox(height: 15),
                            _imageView(context),
                          ],
                        ),
                      ),
                    );
            },
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
    final MediaAssetModel assetResponse = await EM.getMediaAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
    );
    if (assetResponse != null && assetResponse.response.status == "ok") {
      result = assetResponse.results;
      setState(() {});
    }
    print(assetResponse);
    isLoading.value = false;
  }

  _filterResult() async {
    totalPages = 1;
    currentPage = 1;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final MediaAssetModel assetSearchResponse = await EM.getMediaAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
    );
    if (assetSearchResponse != null && assetSearchResponse.response.status == "ok") {
      result = [];
      result = assetSearchResponse.results;
      currentPage = assetSearchResponse.response.page;
      totalPages = assetSearchResponse.response.pages;
    }
    setState(() {});
    print(assetSearchResponse);
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
      result = [];
      result = assetSearchResponse.results;
      setState(() {});
    }
    print(assetSearchResponse);
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35),
      height: 80,
      child: SearchBar(
        icon: Icon(Icons.search_rounded, color: Color(0xff92e184)),
        hintText: "Search your media...",
        hintStyle: TextStyle(color: Colors.grey),
        minimumChars: 0,
        cancellationWidget: Icon(Icons.clear),
        onCancelled: () => Provider.of<workspaceAssets>(context, listen: false).initializeFilters(),
        searchBarStyle: SearchBarStyle(
          backgroundColor: Color(0xff384964),
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        ),
        onSearch: (val) async {
          _filterResult();
          return null;
        },
        loader: CircularProgressIndicator(),
        onItemFound: null,
      ),
    );
  }

  Widget _imageView(BuildContext context) {
    final myUser = Provider.of<userData>(context, listen: false);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            itemCount: result?.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              String url =
                  ("${widget.myWorkspaces.instUrl[widget.currentWorkspace].toString()}/finder/mediadb/services/module/asset/downloads/originals/${Uri.encodeFull(result[index].sourcepath)}/${result[index].name}")
                      .trim();
              print(url);
              Map<String, String> headers = {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                "Authorization": '${myUser.entermediakey}',
                "X-tokentype": 'entermedia',
              };
              return CachedNetworkImage(
                imageUrl: "$url",
                httpHeaders: headers,
                imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.red,
                        BlendMode.colorBurn,
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Text(error.toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}
