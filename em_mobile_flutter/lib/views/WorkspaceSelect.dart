import 'dart:convert';

import 'package:em_mobile_flutter/models/createWorkspaceModel.dart';
import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/getWorkspacesModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'WorkspaceRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspaceSelect extends StatelessWidget {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  TextEditingController workspaceController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final myWorkspaces2 = Provider.of<userWorkspaces>(context);
    return Scaffold(
      body: FutureBuilder(
        future: loadWorkspaces(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ValueListenableBuilder<bool>(
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
                  : Center(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                "You don't seem to have a workspace. Get started by creating a new workspace.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              autofocus: true,
                              cursorColor: Color(0xff237C9C),
                              controller: workspaceController,
                              decoration: InputDecoration(
                                labelText: "Workspace Name",
                                focusColor: Color(0xff237C9C),
                              ),
                            ),
                            SizedBox(height: 19),
                            RaisedButton(
                              child: Text("Create Workspace"),
                              onPressed: () async {
                                isLoading.value = true;
                                final EM = Provider.of<EnterMedia>(context, listen: false);
                                final myUser = Provider.of<userData>(context, listen: false);
                                print(myUser.entermediakey);
                                final CreateWorkspaceModel createWorkspaceResponse = await EM.createNewWorkspaces(myUser.entermediakey, context);
                                print(createWorkspaceResponse);
                                if (createWorkspaceResponse != null && createWorkspaceResponse.response.status == 'ok') {
                                  loadWorkspaces(context);
                                }
                                isLoading.value = false;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }

  Future<bool> loadWorkspaces(BuildContext context) async {
    var wkspcs = false;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myWorkspaces2 = Provider.of<userWorkspaces>(context);
    final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
    final myUser = Provider.of<userData>(context);
    //Perform API call
    final GetWorkspaceModel userWorkspaces2 = await EM.getEMWorkspaces(context);
    wkspcs = true;
    int savedColId = await sharedPref().getRecentWorkspace();
    //Initialize blank Lists
    myWorkspaces2.names = [];
    myWorkspaces2.colId = [];
    myWorkspaces2.instUrl = [];
    //Loop thru API 'results'
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
    print("workspace count ${userWorkspaces2.results.length}");

    if (userWorkspaces2.results.length == 0) {
      isLoading.value = false;
    }

    if (savedColId == null && userWorkspaces2.results.length > 0) {
      await EM.createTeamAccount(context, myWorkspaces2.instUrl[0], myUser.entermediakey, myWorkspaces2.colId[0]);
      final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(context, myWorkspaces2.instUrl[0]);
      hitTracker.searchedhits = searchedData;
      hitTracker.organizeData();
      hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[0]);
      hitTracker.initializeFilters();
      sharedPref().saveRecentWorkspace(0);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeMenu()));

      return wkspcs;
    }
    if (savedColId != null && savedColId < userWorkspaces2.results.length) {
      await EM.createTeamAccount(context, myWorkspaces2.instUrl[savedColId], myUser.entermediakey, myWorkspaces2.colId[savedColId]);
      final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(context, myWorkspaces2.instUrl[savedColId]);
      hitTracker.searchedhits = searchedData;
      hitTracker.organizeData();
      hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[savedColId]);
      hitTracker.initializeFilters();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeMenu()));
    }
    return wkspcs;
  }
}
