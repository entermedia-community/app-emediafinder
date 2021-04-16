import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/createTeamModel.dart';
import 'package:em_mobile_flutter/models/createWorkspaceModel.dart';
import 'package:em_mobile_flutter/models/getWorkspacesModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/shared/CircularLoader.dart';
import 'package:em_mobile_flutter/shared/ConfirmationDialog.dart';
import 'package:em_mobile_flutter/views/EventSearch.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:em_mobile_flutter/views/ImageView.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
import 'package:em_mobile_flutter/views/MediaAssetsSearch.dart';
import 'package:em_mobile_flutter/views/ProjectSearch.dart';
import 'package:em_mobile_flutter/views/ViewEntityAssets.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class MainContent extends StatelessWidget {
  MainContent({
    Key key,
    @required this.myWorkspaces,
  }) : super(key: key);

  final userWorkspaces myWorkspaces;
  final TextEditingController newWorkspaceController = new TextEditingController();
  TextEditingController renameController;
  String searchText = "";
  int currentWorkspace = 0;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isSearching = ValueNotifier(false);

  Future<int> getWorkspace() async {
    currentWorkspace = await sharedPref().getRecentWorkspace();
    return await currentWorkspace;
  }

  @override
  Widget build(BuildContext context) {
    final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
    Provider.of<workspaceAssets>(context, listen: false).initializeFilters();
    getWorkspace();
    return FutureBuilder(
        future: getWorkspace(),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.hasData && snapshot.data != null) {
            return Stack(
              children: [
                Consumer<workspaceAssets>(
                  builder: (context, assets, child) {
                    return myWorkspaces.instUrl.length > 0
                        ? CustomScrollView(
                            slivers: <Widget>[
                              SliverAppBar(
                                //appbar title & menu goes here
                                leading: Container(),
                                titleSpacing: 0,
                                leadingWidth: 0,
                                actions: [
                                  SizedBox(width: 10),
                                  PopupMenuButton(
                                    child: Icon(Icons.menu),
                                    color: Colors.white,
                                    itemBuilder: (BuildContext popupContext) {
                                      return [
                                        PopupMenuItem(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Theme(
                                                data: ThemeData(
                                                  dividerColor: Colors.transparent,
                                                  accentColor: Color(0xff237C9C),
                                                  unselectedWidgetColor: Color(0xff237C9C),
                                                ),
                                                child: ListTileTheme(
                                                  contentPadding: EdgeInsets.all(0),
                                                  child: ExpansionTile(
                                                    title: Text(
                                                      "Workspaces",
                                                      style: TextStyle(color: Color(0xff237C9C)),
                                                    ),
                                                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      if (currentWorkspace != null)
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            customPopupWithTrailingIconMenuItem(
                                                              context,
                                                              Icons.album_outlined,
                                                              popupContext,
                                                              "${myWorkspaces.names[currentWorkspace]}",
                                                              null,
                                                            ),
                                                            customPopupWithIconMenuItem(
                                                              context,
                                                              Icons.edit,
                                                              popupContext,
                                                              "Rename",
                                                              () => renameWorkspace(context, renameController),
                                                            ),
                                                            customPopupWithIconMenuItem(
                                                              context,
                                                              Icons.delete,
                                                              popupContext,
                                                              "Delete",
                                                              () => renameWorkspace(context, renameController),
                                                            ),
                                                            customPopupMenuItem(context, popupContext, "Create New Workspace",
                                                                () => createWorkspace(context, newWorkspaceController), 0),
                                                            myWorkspaces.names.length > 1
                                                                ? ExpansionTile(
                                                                    ///TODO REMOVE TILE WHEN THERE IN ONLY ONE WORKSPACE
                                                                    title: Text(
                                                                      "Change Workspace",
                                                                      style: TextStyle(color: Color(0xff237C9C)),
                                                                    ),
                                                                    children: getWorkspaces(context, popupContext, myWorkspaces.names),
                                                                    tilePadding: EdgeInsets.all(0),
                                                                    childrenPadding: EdgeInsets.all(0),
                                                                    initiallyExpanded: false,
                                                                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                    ],
                                                    tilePadding: EdgeInsets.all(0),
                                                    // childrenPadding: EdgeInsets.only(left: 8),
                                                    initiallyExpanded: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: null,
                                        ),
                                        PopupMenuItem(
                                          child: customPopupMenuItem(
                                            context,
                                            popupContext,
                                            "Log out",
                                            () => ConfirmationDialog(
                                              context: context,
                                              title: "Log out?",
                                              alertMessage: "Are you sure you want to log out?",
                                              hasSecondActionButton: true,
                                              actionButtonLabel: "Yes",
                                              actionButtonCallback: () => logOutUser(context),
                                              secondActionButtonLabel: "No",
                                            ).showPopUpDialog(),
                                            0,
                                          ),
                                          value: 1,
                                        ),
                                      ];
                                    },
                                    offset: Offset(0, 20),
                                    onSelected: (value) {
                                      if (value == 1) {
                                        ConfirmationDialog(
                                          context: context,
                                          title: "Log out?",
                                          alertMessage: "Are you sure you want to log out?",
                                          hasSecondActionButton: true,
                                          actionButtonLabel: "Yes",
                                          actionButtonCallback: () => logOutUser(context),
                                          secondActionButtonLabel: "No",
                                        ).showPopUpDialog();
                                      }
                                    },
                                  ),
                                  SizedBox(width: 8),
                                ],
                                title: Container(
                                  height: 80,
                                  child: SearchBar(
                                    icon: Icon(Icons.search_rounded, color: Color(0xff237C9C)),
                                    hintText: "Search your media...",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    minimumChars: 0,
                                    cancellationWidget: Icon(Icons.clear),
                                    onCancelled: () {
                                      searchText = '';
                                      Provider.of<workspaceAssets>(context, listen: false).initializeFilters();
                                      isSearching.value = false;
                                      FocusScope.of(context).unfocus();
                                    },
                                    searchBarStyle: SearchBarStyle(
                                      backgroundColor: Color(0xff384964),
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    ),
                                    onSearch: (val) async {
                                      isLoading.value = true;
                                      searchText = val;
                                      // Provider.of<workspaceAssets>(context, listen: false).initializeFilters();
                                      isSearching.value = false;
                                      await Provider.of<workspaceAssets>(context, listen: false)
                                          .filterResult(val, context, myWorkspaces, false)
                                          .then((value) {
                                        isSearching.value = true;
                                      });
                                      isLoading.value = false;
                                      return null;
                                    },
                                    loader: CircularProgressIndicator(),
                                    onItemFound: null,
                                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                pinned: true,
                                expandedHeight: 55.0,
                              ),
                              SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverAppBarDelegate(
                                    minHeight: 33,
                                    maxHeight: 33,
                                    child: Container(
                                        // color: Colors.white70,
                                        //changes color of sliver bar header
                                        decoration: BoxDecoration(
                                            // color: Color(0xff384964),
                                            borderRadius: BorderRadius.circular(5),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff384964),
                                                Theme.of(context).primaryColor,
                                                Color(0xff384964),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ValueListenableBuilder<bool>(
                                              valueListenable: isSearching,
                                              builder: (BuildContext context, bool value, _) {
                                                return value
                                                    ? Text(
                                                        'Media (' +
                                                            (searchText.length <= 2
                                                                ? "${hitTracker?.totalMediaCount.toString()}"
                                                                : "${assets.filterUrls.length.toString()}") +
                                                            ')',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w900,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors.black,
                                                              blurRadius: 1,
                                                              offset: Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Text(
                                                        'Media (' + "${hitTracker?.totalMediaCount.toString()}" + ')',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w900,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors.black,
                                                              blurRadius: 1,
                                                              offset: Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                              },
                                            ),
                                            // Text('Media (' + hitTracker?.sampleMediaCount.toString() + ')'),
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 19,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MediaAssetsSearch(
                                                    myWorkspaces: myWorkspaces,
                                                    currentWorkspace: currentWorkspace,
                                                    searchText: searchText,
                                                    organizedHits: assets.searchedhits == null || assets.searchedhits.organizedhits.isEmpty
                                                        ? null
                                                        : assets.searchedhits.organizedhits[0],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))),
                                  )),
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder<bool>(
                                    valueListenable: isSearching,
                                    builder: (BuildContext context, bool value, _) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                StaggeredGridView.countBuilder(
                                                  shrinkWrap: true,
                                                  crossAxisCount: 9,
                                                  padding: EdgeInsets.all(0),
                                                  physics: ClampingScrollPhysics(),
                                                  itemCount: assets.filterUrls?.length,
                                                  itemBuilder: (BuildContext context, int i) {
                                                    return buildImageTile(context, assets, i);
                                                  },
                                                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(3),
                                                  mainAxisSpacing: 2.0,
                                                  crossAxisSpacing: 2.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverAppBarDelegate(
                                    minHeight: 33,
                                    maxHeight: 33,
                                    child: Container(
                                        //changes color of sliver bar header
                                        margin: EdgeInsets.only(top: 3),
                                        // color: Colors.white70,
                                        decoration: BoxDecoration(
                                            // color: Color(0xff384964),
                                            borderRadius: BorderRadius.circular(5),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff384964),
                                                Theme.of(context).primaryColor,
                                                Color(0xff384964),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ValueListenableBuilder<bool>(
                                              valueListenable: isSearching,
                                              builder: (BuildContext context, bool value, _) {
                                                return value
                                                    ? Text(
                                                        'Projects (' +
                                                            (searchText.length <= 2
                                                                ? "${hitTracker?.totalProjectCount.toString()}"
                                                                : "${assets.filterProjects.length.toString()}") +
                                                            ')',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w900,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors.black,
                                                              blurRadius: 1,
                                                              offset: Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Text(
                                                        'Projects (' + "${hitTracker?.totalProjectCount.toString()}" + ')',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w900,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors.black,
                                                              blurRadius: 1,
                                                              offset: Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 19,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProjectSearch(
                                                    myWorkspaces: myWorkspaces,
                                                    currentWorkspace: currentWorkspace,
                                                    searchText: searchText,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))),
                                  )),
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: isSearching,
                                  builder: (BuildContext context, bool value, _) {
                                    return Column(
                                      children: List.generate(
                                        assets.filterProjects.length,
                                        (i) => assets.filterProjects[i].name.toString().toLowerCase() == 'null'
                                            ? Container()
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  entitiesTiles(
                                                    title: "${assets.filterProjects[i].name}",
                                                    id: "${assets.filterProjects[i].id}",
                                                    context: context,
                                                    myWorkspaces: myWorkspaces,
                                                    currentWorkspace: currentWorkspace,
                                                    searchText: "project",
                                                    instanceUrl: myWorkspaces.instUrl[currentWorkspace],
                                                    hasThumbnails: true,
                                                    attachedmedia: assets.filterProjects[i].attachedMedia,
                                                  ),
                                                ],
                                              ),
                                      ),
                                      //just an example will build from api call
                                    );
                                  },
                                ),
                              ),
                              SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverAppBarDelegate(
                                    minHeight: 33,
                                    maxHeight: 33,
                                    child: Container(
                                        margin: EdgeInsets.only(top: 3),
                                        //changes color of sliver bar header
                                        // color: Colors.white70,
                                        decoration: BoxDecoration(
                                            // color: Color(0xff384964),
                                            borderRadius: BorderRadius.circular(5),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff384964),
                                                Theme.of(context).primaryColor,
                                                Color(0xff384964),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )),
                                        child: Center(
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          ValueListenableBuilder<bool>(
                                            valueListenable: isSearching,
                                            builder: (BuildContext context, bool value, _) {
                                              return value
                                                  ? Text(
                                                      'Events (' +
                                                          (searchText.length <= 2
                                                              ? "${hitTracker?.totalEventCount.toString()}"
                                                              : "${assets.filterEvents.length.toString()}") +
                                                          ')',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            offset: Offset(0.5, 0.5),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Text(
                                                      'Events (' + "${hitTracker?.totalEventCount.toString()}" + ')',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            offset: Offset(0.5, 0.5),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 19,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EventSearch(
                                                  myWorkspaces: myWorkspaces,
                                                  currentWorkspace: currentWorkspace,
                                                  searchText: searchText,
                                                ),
                                              ),
                                            ),
                                          )
                                        ]))),
                                  )),
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: isSearching,
                                  builder: (BuildContext context, bool value, _) {
                                    return Column(
                                      children: List.generate(
                                        assets.filterEvents.length,
                                        (i) => assets.filterEvents[i].name.toString().toLowerCase() == 'null'
                                            ? Container()
                                            : entitiesTiles(
                                                title: "${assets.filterEvents[i].name}",
                                                id: "${assets.filterEvents[i].id}",
                                                context: context,
                                                myWorkspaces: myWorkspaces,
                                                currentWorkspace: currentWorkspace,
                                                searchText: "event",
                                                instanceUrl: myWorkspaces.instUrl[currentWorkspace],
                                                hasThumbnails: true,
                                                attachedmedia: assets.filterEvents[i].attachedMedia,
                                              ),
                                      ),
                                      //just an example will build from api call
                                    );
                                  },
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: hitTracker.filterPageCount > 1 && hitTracker.currentPageNumber < hitTracker.filterPageCount
                                    ? Padding(
                                        padding: const EdgeInsets.only(right: 10.0, top: 15, bottom: 10),
                                        child: InkWell(
                                          child: Text(
                                            'Show more...',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onTap: () {
                                            print(searchText);
                                            Provider.of<workspaceAssets>(context, listen: false).increaseCurrentPageCount();
                                            Provider.of<workspaceAssets>(context, listen: false).filterResult(
                                              searchText,
                                              context,
                                              myWorkspaces,
                                              true,
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                              ),
                            ],
                          )
                        : Text("Create new Workspace");
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () => loadNewWorkspace(context, currentWorkspace, false),
                    child: Icon(Icons.refresh),
                  ),
                ),
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
                        : Container();
                  },
                ),
              ],
            );
          }
          return Loader.showLoaderWithText(context, "Fetching Assets");
        });
  }

  Widget buildImageTile(BuildContext context, workspaceAssets assets, int i) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: Colors.black,
      color: Colors.transparent,
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: "${assets.filterUrls[i]}",
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => FutureBuilder(
              future: reloadCachedImage(context),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return CachedNetworkImage(
                    imageUrl: "${assets.filterUrls[i]}",
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Icon(Icons.error),
                    ),
                    fit: BoxFit.contain,
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
            fit: BoxFit.contain,
          ),
        ),
        onTap: () {
          print(assets.filterIds[i]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(
                collectionId: assets.filterIds[i],
                instanceUrl: myWorkspaces.instUrl[currentWorkspace],
                hasDirectLink: false,
                directLink: '',
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getWorkspaces(BuildContext context, BuildContext popupContext, List workspaces) {
    List<Widget> _widget = [];
    if (workspaces.length < 2) {
      _widget.add(Container());
      return _widget;
    }
    for (int i = 0; i < workspaces.length; i++) {
      if (i != currentWorkspace) {
        _widget.add(
          Container(
            alignment: Alignment.centerLeft,
            child: customPopupMenuItem(
              context,
              popupContext,
              workspaces[i].toString(),
              () => loadNewWorkspace(context, i, true),
              12,
            ),
          ),
        );
      }
    }
    return _widget;
  }

  Future<bool> reloadCachedImage(BuildContext context) async {
    bool status = false;
    Future.delayed(Duration(seconds: 5), () async {
      final EM = Provider.of<EnterMedia>(context, listen: false);
      final myWorkspaces2 = Provider.of<userWorkspaces>(context, listen: false);
      final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
      final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(context, myWorkspaces.instUrl[currentWorkspace]);
      if (searchedData.response.status == 'ok') {
        hitTracker.searchedhits = await searchedData;
        await hitTracker.organizeData();
        await hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[currentWorkspace]);
        await hitTracker.initializeFilters();
        status = true;
      }
    });
    return await status;
  }

  Widget customPopupWithTrailingIconMenuItem(BuildContext context, IconData icon, BuildContext popupContext, String title, Function onTap) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 0, top: 4, bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "$title",
                style: TextStyle(
                  color: Color(0xff237C9C),
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              icon,
              color: Color(0xff237C9C),
              size: 18,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(popupContext).pop();
        onTap();
      },
    );
  }

  Widget customPopupWithIconMenuItem(BuildContext context, IconData icon, BuildContext popupContext, String title, Function onTap) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 4, bottom: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xff237C9C),
              size: 18,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "$title",
                style: TextStyle(
                  color: Color(0xff237C9C),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(popupContext).pop();
        onTap();
      },
    );
  }

  Widget customPopupMenuItem(BuildContext context, BuildContext popupContext, String title, Function onTap, double leftPadding) {
    return InkWell(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(leftPadding, 5, 5, 5),
              child: Text(
                "$title",
                style: TextStyle(
                  color: Color(0xff237C9C),
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(popupContext).pop();
        onTap();
      },
    );
  }

  void logOutUser(BuildContext context) async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    await EM.logOutUser();
    sharedPref().resetValues();
    AuthenticationService.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  switchWorkspace(BuildContext context) {
    final myWorkspaces2 = Provider.of<userWorkspaces>(context, listen: false);
    print(myWorkspaces2.names);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<userWorkspaces>(builder: (context, myWorkspace, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  itemCount: myWorkspace.names?.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: InkWell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(child: Text("${myWorkspace.names[index]}")),
                          ],
                        ),
                        onTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          loadNewWorkspace(context, index, true);
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  deleteWorkspace(BuildContext context) {
    print(myWorkspaces.colId[currentWorkspace]);
    if (myWorkspaces.instUrl.length > 0) {
      ConfirmationDialog(
        context: context,
        title: "Delete Workspace",
        alertMessage: "Are you sure you want to delete ${myWorkspaces.names[currentWorkspace]}?",
        hasSecondActionButton: true,
        actionButtonLabel: "Yes",
        actionButtonCallback: () async {
          isLoading.value = true;
          final EM = Provider.of<EnterMedia>(context, listen: false);
          final myUser = Provider.of<userData>(context, listen: false);
          print(myUser.entermediakey);
          final Map createWorkspaceResponse = await EM.deleteWorkspaces("${myWorkspaces.colId[currentWorkspace]}", context);
          int newIndex;
          for (int i = 0; i < myWorkspaces.names.length; i++) {
            if (i != currentWorkspace) {
              newIndex = i;
              break;
            }
          }
          sharedPref().saveRecentWorkspace(newIndex);
          reloadWorkspaces(context, myWorkspaces.instUrl[newIndex], true);
          print(createWorkspaceResponse);
          if (json.encode(createWorkspaceResponse).contains("complete")) {
            Fluttertoast.showToast(
              msg: "Deletion initiated. Workspace will be deleted within 30 days.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 10,
              backgroundColor: Color(0xff61af56),
              fontSize: 16.0,
            );
          }
          //TODO:Reload workspace after getting instUrl
          // if (createWorkspaceResponse != null) {
          //   reloadWorkspaces(context, createWorkspaceResponse.data.instanceurl);
          // }
          isLoading.value = false;
        },
        secondActionButtonLabel: "No",
      ).showPopUpDialog();
    } else {
      ConfirmationDialog(
        context: context,
        title: "Operation not allowed!",
        alertMessage: "You have only one workspace. Create new one before you delete \"${myWorkspaces.names[currentWorkspace]}\".",
        hasSecondActionButton: false,
        actionButtonLabel: "Cancel",
        actionButtonCallback: null,
        secondActionButtonLabel: "",
      ).showPopUpDialog();
    }
  }

  renameWorkspace(BuildContext context, TextEditingController renameController) async {
    renameController = new TextEditingController()..text = myWorkspaces.names[currentWorkspace];
    print(myWorkspaces.colId[currentWorkspace]);
    popupWithTextInput(
        context: context,
        controller: renameController,
        textFieldHint: "Rename Workspace",
        buttonLabel: "Rename Workspace",
        footerText: "",
        onTap: () async {
          isLoading.value = true;
          final EM = Provider.of<EnterMedia>(context, listen: false);
          final myUser = Provider.of<userData>(context, listen: false);
          print(myUser.entermediakey);
          final Map createWorkspaceResponse =
              await EM.renameWorkspaces("${renameController.text}", "${myWorkspaces.colId[currentWorkspace]}", context);
          if (createWorkspaceResponse != null) {
            await reloadWorkspaces(context, myWorkspaces.instUrl[currentWorkspace], false).whenComplete(() {
              print(createWorkspaceResponse);
              if (json.encode(createWorkspaceResponse).contains("complete")) {
                Fluttertoast.showToast(
                  msg: "Workspace renamed successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 10,
                  backgroundColor: Color(0xff61af56),
                  fontSize: 16.0,
                );
              }
            });
          }
          isLoading.value = false;
        });
  }

  createWorkspace(BuildContext context, TextEditingController newWorkspaceController) {
    popupWithTextInput(
      context: context,
      controller: newWorkspaceController,
      textFieldHint: "Workspace name",
      buttonLabel: "Create Workspace",
      footerText: "Leave the textfield empty to generate randomly named workspace.",
      onTap: () async {
        isLoading.value = true;

        final EM = Provider.of<EnterMedia>(context, listen: false);
        final myUser = Provider.of<userData>(context, listen: false);
        print(myUser.entermediakey);
        final CreateWorkspaceModel createWorkspaceResponse = await EM.createNewWorkspaces(myUser.entermediakey, context);
        print(createWorkspaceResponse);
        if (createWorkspaceResponse != null) {
          reloadWorkspaces(context, createWorkspaceResponse.data.instanceurl, true);
        }
        isLoading.value = false;
      },
    );
  }

  popupWithTextInput(
      {BuildContext context, TextEditingController controller, Function onTap, String footerText, String buttonLabel, String textFieldHint}) async {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "$textFieldHint",
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        onTap();
                      },
                      child: Text("$buttonLabel"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  child: Text(
                    "$footerText",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> reloadWorkspaces(BuildContext context, String instanceUrl, bool switchWorkspace) async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myWorkspaces2 = Provider.of<userWorkspaces>(context, listen: false);
    final GetWorkspaceModel userWorkspaces2 = await EM.getEMWorkspaces(context);
    //Initialize blank Lists
    myWorkspaces2.names = [];
    myWorkspaces2.colId = [];
    myWorkspaces2.instUrl = [];
    //Loop thru API 'results'
    if (userWorkspaces2 != null) {
      for (final project in userWorkspaces2.results) {
        myWorkspaces2.names.add(project.name);
        myWorkspaces2.colId.add(project.id);

        //Loop through response, add urls and check if blank.
        if (project.servers.isEmpty == true) {
          myWorkspaces2.instUrl.add("no instance url");
        } else {
          myWorkspaces2.instUrl.add(project.servers[0].instanceurl);
          print(project.servers[0].instanceurl);
        }
      }
    }
    Provider.of<userWorkspaces>(context, listen: false).notify();
    for (int i = 0; i < myWorkspaces2.instUrl.length; i++) {
      if (myWorkspaces2.instUrl[i] == instanceUrl) {
        loadNewWorkspace(context, i, switchWorkspace);
        break;
      }
    }
  }

  Future<void> loadNewWorkspace(BuildContext parentContext, int index, bool switchWorkspace) async {
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(parentContext, listen: false);
    final myWorkspaces2 = Provider.of<userWorkspaces>(parentContext, listen: false);
    final hitTracker = Provider.of<workspaceAssets>(parentContext, listen: false);
    final myUser = Provider.of<userData>(parentContext, listen: false);
    //Perform API call
    final GetWorkspaceModel userWorkspaces2 = await EM.getEMWorkspaces(parentContext);
    myWorkspaces2.names = [];
    myWorkspaces2.colId = [];
    myWorkspaces2.instUrl = [];
    //Loop thru API 'results'
    if (userWorkspaces2 != null) {
      for (final project in userWorkspaces2?.results) {
        myWorkspaces2.names.add(project.name);
        myWorkspaces2.colId.add(project.id);
        //Loop through response, add urls and check if blank.
        if (project.servers.isEmpty == true) {
          myWorkspaces2.instUrl.add("no instance url");
        } else {
          myWorkspaces2.instUrl.add(project.servers[0].instanceurl);
          print(project.servers[0].instanceurl);
        }
      }
    }
    print("CHeck here");
    print(myWorkspaces2.instUrl[index]);
    print(myUser.entermediakey);
    print(myWorkspaces2.colId[index]);
    await EM.startMediaFinder(parentContext, myWorkspaces2.instUrl[index], myUser.entermediakey, myWorkspaces2.colId[index]).whenComplete(() async {
      final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(parentContext, myWorkspaces2.instUrl[index]);
      hitTracker.searchedhits = searchedData;
      hitTracker.organizeData();
      hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[index]);
      hitTracker.initializeFilters();
      if (index != null) {
        sharedPref().saveRecentWorkspace(index);
      }
      if (switchWorkspace) {
        Fluttertoast.showToast(
          msg: "Workspace changed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Color(0xff61af56),
          fontSize: 16.0,
        );
      }
      isLoading.value = false;
      if (switchWorkspace) {
        Navigator.pushReplacement(parentContext, MaterialPageRoute(builder: (BuildContext ctx) => HomeMenu()));
      }
    });
  }
}

Widget entitiesTiles({
  @required String title,
  @required String id,
  @required BuildContext context,
  @required userWorkspaces myWorkspaces,
  @required int currentWorkspace,
  @required String searchText,
  @required String instanceUrl,
  @required bool hasThumbnails,
  @required List<Attachedmedia> attachedmedia,
}) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff0c223a),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Text(
                        "$title",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  !hasThumbnails
                      ? Container()
                      : Row(
                          children: List.generate(attachedmedia.length, (index) {
                            return Container(
                              margin: EdgeInsets.only(right: 3),
                              height: 30,
                              child: Image.network(
                                instanceUrl + attachedmedia[index].thumbnailimg,
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          }),
                        ),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEntityAssets(
                myWorkspaces: myWorkspaces,
                currentWorkspace: currentWorkspace,
                searchText: searchText,
                entityId: id,
                instanceUrl: instanceUrl,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

//required for proper collapsing behavior- mando
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
