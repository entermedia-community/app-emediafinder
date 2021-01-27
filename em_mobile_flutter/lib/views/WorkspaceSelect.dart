import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'WorkspaceRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspaceSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myWorkspaces2 = Provider.of<userWorkspaces>(context);

    return FutureBuilder(
        future: loadWorkspaces(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select a Workspace",
                      style: TextStyle(color: Color(0xff61af56)),
                    ),
                    emLogoIcon(),
                  ],
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
                pinned: true,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (ctx, i) => emWorkspaceRow(
                  'assets/EM Logo Basic.jpg',
                  myWorkspaces2.names[i],
                  myWorkspaces2.instUrl[i],
                  myWorkspaces2.colId[i],
                  context,
                  i,
                ),
                //amount of rows
                childCount: myWorkspaces2.colId.length,
              )),
            ]);
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select a Workspace",
                      style: TextStyle(color: Color(0xff61af56)),
                    ),
                    emLogoIcon(),
                  ],
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: Container(color: Colors.black, child: Center(child: CircularProgressIndicator())),
            );
          }
        });
  }
}

Future<bool> loadWorkspaces(BuildContext context) async {
  var wkspcs = false;
  final EM = Provider.of<EnterMedia>(context);
  final myWorkspaces2 = Provider.of<userWorkspaces>(context);
  final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
  final myUser = Provider.of<userData>(context);
  //Perform API call
  final List userWorkspaces2 = await EM.getEMWorkspaces(context);
  wkspcs = true;
  int savedColId = await sharedPref().getRecentWorkspace();
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
  print("workspace count ${userWorkspaces2.length}");
  if (userWorkspaces2.length == 1) {
    await EM.createTeamAccount(context, myWorkspaces2.instUrl[0], myUser.entermediakey, myWorkspaces2.colId[0]);
    final Map searchedData = await EM.getWorkspaceAssets(context, myWorkspaces2.instUrl[0]);
    hitTracker.searchedhits = searchedData;
    hitTracker.organizeData();
    hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[0]);
    hitTracker.initializeFilters();
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeMenu()));
  }
  if (savedColId != null && savedColId < userWorkspaces2.length) {
    await EM.createTeamAccount(context, myWorkspaces2.instUrl[savedColId], myUser.entermediakey, myWorkspaces2.colId[savedColId]);
    final Map searchedData = await EM.getWorkspaceAssets(context, myWorkspaces2.instUrl[savedColId]);
    hitTracker.searchedhits = searchedData;
    hitTracker.organizeData();
    hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[savedColId]);
    hitTracker.initializeFilters();
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeMenu()));
  }
  return wkspcs;
}
