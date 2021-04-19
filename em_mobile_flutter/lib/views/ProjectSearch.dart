import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/projectAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CircularLoader.dart';
import 'package:em_mobile_flutter/shared/CustomSearchBar.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

class ProjectSearch extends StatefulWidget {
  final userWorkspaces myWorkspaces;
  final int currentWorkspace;
  final String searchText;
  ProjectSearch({
    Key key,
    @required this.myWorkspaces,
    @required this.currentWorkspace,
    @required this.searchText,
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
  TextEditingController searchController = new TextEditingController();

  void filterContent() async {
    searchText = widget.searchText;
    setState(() {});
    _filterResult();
  }

  @override
  void initState() {
    searchController..text = widget.searchText;
    _getAllProjects().whenComplete(() => filterContent());
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
                  ? Loader.showLoader(context)
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

  Future _getAllProjects() async {
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
      currentPage = projectResponse.response.page;
      totalPages = projectResponse.response.pages;
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
    isLoading.value = true;
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
    isLoading.value = false;
  }

  _loadMoreProjects() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final ProjectAssetModel assetSearchResponse = await EM.searchProjectsAssets(
      context,
      widget.myWorkspaces.instUrl[widget.currentWorkspace],
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

  Widget _searchBar(BuildContext context) {
    return CustomSearchBar(searchController, (val) {
      searchText = val;
      _filterResult();
      setState(() {});
    }, context);
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
              return filteredResult[index].name.toString().toLowerCase() == 'null'
                  ? Container()
                  : entitiesTiles(
                      title: '${filteredResult[index].name.toString()}',
                      id: '${filteredResult[index].id.toString()}',
                      context: context,
                      myWorkspaces: widget.myWorkspaces,
                      currentWorkspace: widget.currentWorkspace,
                      searchText: "project",
                      instanceUrl: widget.myWorkspaces.instUrl[widget.currentWorkspace],
                      hasThumbnails: false,
                      attachedmedia: null,
                    );
            },
          ),
          currentPage < totalPages
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: RaisedButton(
                      child: Text("Load more"),
                      onPressed: () => _loadMoreProjects(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
