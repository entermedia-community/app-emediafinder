import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/projectAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

class ProjectSearch extends StatefulWidget {
  final userWorkspaces myWorkspaces;
  final int currentWorkspace;
  ProjectSearch({
    Key key,
    @required this.myWorkspaces,
    @required this.currentWorkspace,
  }) : super(key: key);

  @override
  _ProjectSearchState createState() => _ProjectSearchState();
}

class _ProjectSearchState extends State<ProjectSearch> {
  String searchText = "";
  List<ProjectResults> result = new List<ProjectResults>();
  List<ProjectResults> filteredResult = new List<ProjectResults>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int totalPages = 1;
  int currentPage = 1;

  @override
  void initState() {
    _getAllProjects();

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
                            _projectView(context),
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

  _getAllProjects() async {
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final ProjectAssetModel projectResponse = await EM.getProjectsAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
    );
    if (projectResponse != null && projectResponse.response.status == "ok") {
      result = projectResponse.results;
      filteredResult = result;
      setState(() {});
    }
    print(projectResponse);
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
      final ProjectAssetModel assetSearchResponse = await EM.searchProjectsAssets(
        context,
        widget.myWorkspaces.instUrl[widget.currentWorkspace],
        searchText,
        currentPage.toString(),
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

  _loadMoreProjects() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final ProjectAssetModel assetSearchResponse = await EM.searchProjectsAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
      searchText,
      (currentPage + 1).toString(),
    );
    if (assetSearchResponse != null && assetSearchResponse.response.status == "ok") {
      filteredResult = [];
      filteredResult = assetSearchResponse.results;
      setState(() {});
    }
    print(assetSearchResponse);
  }

  Widget _searchBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 80,
            child: SearchBar(
              icon: Icon(Icons.search_rounded, color: Color(0xff92e184)),
              hintText: "Search your project...",
              hintStyle: TextStyle(color: Colors.grey),
              minimumChars: 0,
              cancellationWidget: Icon(Icons.clear),
              onCancelled: resetData,
              searchBarStyle: SearchBarStyle(
                backgroundColor: Color(0xff384964),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              onSearch: (val) async {
                searchText = val;
                setState(() {});
                _filterResult();
                return null;
              },
              loader: CircularProgressIndicator(),
              onItemFound: null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _projectView(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: filteredResult?.length,
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return emWorkspaceRow('assets/EM Logo Basic.jpg', filteredResult[index].name.toString(), null, null, context, index);
            },
          ),
        ],
      ),
    );
  }
}
