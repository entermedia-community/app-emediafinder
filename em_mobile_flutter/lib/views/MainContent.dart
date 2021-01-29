import 'dart:convert';

import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
    Provider.of<workspaceAssets>(context, listen: false).initializeFilters();

    return Consumer<workspaceAssets>(builder: (context, assets, child) {
      return CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          //appbar title & menu goes here
          leading: Container(),
          titleSpacing: 0,
          leadingWidth: 6,
          actions: [
            SizedBox(width: 10),
            PopupMenuButton(
              child: Icon(Icons.menu),
              color: Color(0xff0c223a),
              itemBuilder: (BuildContext popupContext) {
                return [
                  PopupMenuItem(
                    child: Text(
                      "Create Workspace",
                      style: TextStyle(
                        color: Color(0xff92e184),
                      ),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Change Workspace",
                      style: TextStyle(
                        color: Color(0xff92e184),
                      ),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Log out",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    value: 3,
                  ),
                ];
              },
              onSelected: (value) {
                value == 1
                    ? createWorkspace(context, newWorkspaceController)
                    : value == 2
                        ? switchWorkspace(context)
                        : logOutUser(context);
              },
              offset: Offset(0, 50),
            ),
            SizedBox(width: 8),
          ],

          title: Container(
            height: 80,
            child: SearchBar(
              icon: Icon(
                Icons.search_rounded,
                color: Color(0xff92e184),
              ),
              hintText: "Search your media...",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              minimumChars: 0,
              cancellationWidget: Icon(Icons.clear),
              onCancelled: () => Provider.of<workspaceAssets>(context, listen: false).initializeFilters(),
              searchBarStyle: SearchBarStyle(
                backgroundColor: Color(0xff384964),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              onSearch: (val) => Provider.of<workspaceAssets>(context, listen: false).filterResult(
                val,
                context,
                hitTracker,
                myWorkspaces,
              ),
              onItemFound: null,
            ),
//                 todo; IF YOU WANT TO ADD ICON NEXT TO SEARCHBAR -> Row(children: [ Expanded(child: SearchBar(onSearch: null, onItemFound: null)),IconButton(icon: Icon(Icons.list,color: Colors.white,), onPressed: null)]),
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
                  color: Color(0xff384964),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Media (' + assets.filterUrls?.length.toString() + ')'),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 19,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: null)
                    ],
                  ))),
            )),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 3,
          ),
          //todo; This is where images are loaded
          delegate: SliverChildBuilderDelegate(
              (ctx, i) => Image.network(
                    assets.filterUrls[i],
                  ),
              childCount: assets.filterUrls?.length),
        ),
        SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 33,
              maxHeight: 33,
              child: Container(
                  color: Color(0xff384964),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Projects (' + assets.filterProjects?.length.toString() + ')'),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 19,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: null)
                    ],
                  ))),
            )),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          //just an example will build from api call
          (ctx, i) => emWorkspaceRow(
            'assets/EM Logo Basic.jpg',
            assets.filterProjects[i],
            i < myWorkspaces.instUrl?.length ? myWorkspaces.instUrl[i] : "",
            i < myWorkspaces.colId?.length ? myWorkspaces.colId[i] : "",
            context,
            null,
          ),
          //amount of rows
          childCount: assets.filterProjects.length,
        )),
        SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 33,
              maxHeight: 33,
              child: Container(
                  color: Color(0xff384964),
                  child: Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Events (' + assets.filterEvents?.length.toString() + ')'),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 19,
                          color: Colors.deepOrangeAccent,
                        ),
                        onPressed: null)
                  ]))),
            )),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          //just an example will build from api call
          (ctx, i) => emWorkspaceRow(
            'assets/EM Logo Basic.jpg',
            assets.filterEvents[i],
            i < myWorkspaces.instUrl?.length ? myWorkspaces.instUrl[i] : "",
            i < myWorkspaces.colId?.length ? myWorkspaces.colId[i] : "",
            context,
            null,
          ),
          //amount of rows
          childCount: assets.filterEvents?.length,
        )),
      ]);
    });
  }
}

void logOutUser(BuildContext context) {
  sharedPref().resetValues();
  context.read<AuthenticationService>().signOut();
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

switchWorkspace(BuildContext context) {
  final myWorkspaces2 = Provider.of<userWorkspaces>(context, listen: false);
  print(myWorkspaces2.names);
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 16,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff0c223a),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
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
                                loadNewWorkspace(context, index);
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
          ),
        ),
      );
    },
  );
}

createWorkspace(BuildContext context, TextEditingController newWorkspaceController) {
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
                controller: newWorkspaceController,
                decoration: InputDecoration(
                  labelText: "Workspace name",
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      final EM = Provider.of<EnterMedia>(context, listen: false);
                      final myUser = Provider.of<userData>(context, listen: false);
                      print(myUser.entermediakey);
                      final Map createWorkspaceResponse = await EM.createNewWorkspaces(myUser.entermediakey, context);
                      print(createWorkspaceResponse);
                      if (json.encode(createWorkspaceResponse).contains("ok")) {}
                      Fluttertoast.showToast(
                        msg: "Workspace created successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Color(0xff61af56),
                        fontSize: 16.0,
                      );
                      reloadWorkspaces(context);
                    },
                    child: Text("Create Workspace"),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                child: Text(
                  "Leave the textfield empty to generate randomly named workspace.",
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

void reloadWorkspaces(BuildContext context) async {
  final EM = Provider.of<EnterMedia>(context, listen: false);
  final myWorkspaces2 = Provider.of<userWorkspaces>(context, listen: false);
  final List userWorkspaces2 = await EM.getEMWorkspaces(context);
  //Initialize blank Lists
  myWorkspaces2.names = [];
  myWorkspaces2.colId = [];
  myWorkspaces2.instUrl = [];
  //Loop thru API 'results'
  for (final project in userWorkspaces2) {
    myWorkspaces2.names.add(project["name"]);
    myWorkspaces2.colId.add(project["id"]);

    //Loop through response, add urls and check if blank.
    if (project["servers"].isEmpty == true) {
      myWorkspaces2.instUrl.add("no instance url");
    } else {
      myWorkspaces2.instUrl.add(project["servers"][0]["instanceurl"]);
      print(project["servers"][0]["instanceurl"]);
    }
  }
  Provider.of<userWorkspaces>(context, listen: false).notify();
}

Future<void> loadNewWorkspace(BuildContext parentContext, int index) async {
  final EM = Provider.of<EnterMedia>(parentContext, listen: false);
  final myWorkspaces2 = Provider.of<userWorkspaces>(parentContext, listen: false);
  final hitTracker = Provider.of<workspaceAssets>(parentContext, listen: false);
  final myUser = Provider.of<userData>(parentContext, listen: false);
  //Perform API call
  final List userWorkspaces2 = await EM.getEMWorkspaces(parentContext);
  myWorkspaces2.names = [];
  myWorkspaces2.colId = [];
  myWorkspaces2.instUrl = [];
  //Loop thru API 'results'
  for (final project in userWorkspaces2) {
    myWorkspaces2.names.add(project["name"]);
    myWorkspaces2.colId.add(project["id"]);
    //Loop through response, add urls and check if blank.
    if (project["servers"].isEmpty == true) {
      myWorkspaces2.instUrl.add("no instance url");
    } else {
      myWorkspaces2.instUrl.add(project["servers"][0]["instanceurl"]);
      print(project["servers"][0]["instanceurl"]);
    }
  }
  print("CHeck here");
  print(myWorkspaces2.instUrl[index]);
  print(myUser.entermediakey);
  print(myWorkspaces2.colId[index]);
  await EM.createTeamAccount(parentContext, myWorkspaces2.instUrl[index], myUser.entermediakey, myWorkspaces2.colId[index]);
  final Map searchedData = await EM.getWorkspaceAssets(parentContext, myWorkspaces2.instUrl[index]);
  hitTracker.searchedhits = searchedData;
  if (searchedData != null && searchedData.length > 0) {
    hitTracker.organizeData();
  }
  hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[index]);
  hitTracker.initializeFilters();
  if (index != null) {
    sharedPref().saveRecentWorkspace(index);
  }
  Fluttertoast.showToast(
    msg: "Workspace changed",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 10,
    backgroundColor: Color(0xff61af56),
    fontSize: 16.0,
  );
  Navigator.pushReplacement(parentContext, MaterialPageRoute(builder: (BuildContext ctx) => HomeMenu()));
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
