import 'dart:convert';

import 'package:em_mobile_flutter/models/createTeamModel.dart';
import 'package:em_mobile_flutter/models/createWorkspaceModel.dart';
import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/getWorkspacesModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
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
      backgroundColor: Color(0xff0c223a),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Text(""),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                final EM = Provider.of<EnterMedia>(context, listen: false);
                await EM.logOutUser();
                sharedPref().resetValues();
                sharedPref().setDeepLinkHandler(false);
                context.read<AuthenticationService>().signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
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
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              style: TextStyle(fontSize: 17, color: Colors.white),
                              controller: workspaceController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xff384964),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                  ),
                                  hintText: "Workspace name",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Color(0xff237C9C),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5)),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (text) => print(text),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: Text("Create"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff237C9C),
                                  ),
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
      /*CreateTeamModel data =*/ await EM.createTeamAccount(context, myWorkspaces2.instUrl[0], myUser.entermediakey, myWorkspaces2.colId[0]);
      /* if (data.response.status != 'ok') {
        print("Error creating team account");
      }*/
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
      /*CreateTeamModel data =*/
      await EM.createTeamAccount(context, myWorkspaces2.instUrl[savedColId], myUser.entermediakey, myWorkspaces2.colId[savedColId]);
      /* if (data.response.status != 'ok') {
        print("Error creating team account");
      }*/
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
