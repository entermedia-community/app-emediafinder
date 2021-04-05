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
import 'package:fluttertoast/fluttertoast.dart';
import 'LoginPage.dart';
import 'WorkspaceRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspaceSelect extends StatefulWidget {
  @override
  _WorkspaceSelectState createState() => _WorkspaceSelectState();
}

class _WorkspaceSelectState extends State<WorkspaceSelect> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  void initState() {
    loadUserWorkspaces();
    super.initState();
  }

  void loadUserWorkspaces() {
    getWorkspaceCount().then((value) {
      if (value != null) {
        if (value > 0) {
          loadWorkspaces(context);
        } else {
          createNewWorkspace().then((value) {
            if (value) {
              loadWorkspaces(context);
            } else {
              isLoading.value = false;
            }
          });
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userWorkspace = Provider.of<userWorkspaces>(context, listen: false);
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
                AuthenticationService.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (BuildContext context, bool value, _) {
          return value
              ? InkWell(
                  enableFeedback: false,
                  onTap: () => print(""),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 15),
                        Text(
                          "Loading workspaces",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Failed to load workspaces.",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          child: Text("Try again"),
                          onPressed: () => loadUserWorkspaces(),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<bool> createNewWorkspace() async {
    bool success = false;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final CreateWorkspaceModel createWorkspaceResponse = await EM.createNewWorkspaces(myUser.entermediakey, context);
    print(createWorkspaceResponse.toJson());
    if (createWorkspaceResponse != null && createWorkspaceResponse.response.status == 'ok') {
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  Future<int> getWorkspaceCount() async {
    int workspaceCount;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    await EM.getEMWorkspaces(context).then((value) {
      if (value != null) {
        workspaceCount = value.results.length;
      }
    });
    return await workspaceCount;
  }

  Future<bool> loadWorkspaces(BuildContext context) async {
    var wkspcs = false;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myWorkspaces2 = Provider.of<userWorkspaces>(context, listen: false);
    final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
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
      if (project.servers.isEmpty == true || project.servers[0].instanceurl == null) {
        myWorkspaces2.instUrl.add("pending");
      } else {
        myWorkspaces2.instUrl.add(project.servers[0].instanceurl);
        print(project.servers[0].instanceurl);
      }
    }
    print("workspace count ${userWorkspaces2.results.length}");

    if (savedColId == null && userWorkspaces2.results.length > 0) {
      int currentIndex = 0;
      if (myWorkspaces2.instUrl[0] == "pending") {
        for (int i = 0; i < myWorkspaces2.instUrl.length; i++) {
          if (myWorkspaces2.instUrl[i] != "pending") {
            currentIndex = i;
            break;
          }
        }
      }
      if (myWorkspaces2.instUrl[currentIndex] == "pending") {
        logOutUser(context);
      } else {
        await EM
            .startMediaFinder(context, myWorkspaces2.instUrl[currentIndex], myUser.entermediakey, myWorkspaces2.colId[currentIndex])
            .whenComplete(() async {
          final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(context, myWorkspaces2.instUrl[currentIndex]);
          hitTracker.searchedhits = await searchedData;
          await hitTracker.organizeData();
          await hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[currentIndex]);
          await hitTracker.initializeFilters();
          await sharedPref().saveRecentWorkspace(currentIndex);
          try {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomeMenu(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeMenu()));
          } catch (e) {
            print("Null Safety : $e");
          }
          return await wkspcs;
        });
      }
    }
    if (savedColId != null && savedColId < userWorkspaces2.results.length) {
      int currentIndex = savedColId;
      if (myWorkspaces2.instUrl[savedColId] == "pending") {
        for (int i = 0; i < myWorkspaces2.instUrl.length; i++) {
          if (myWorkspaces2.instUrl[i] != "pending") {
            currentIndex = i;
            break;
          }
        }
      }
      if (myWorkspaces2.instUrl[currentIndex] == "pending") {
        logOutUser(context);
      } else {
        await EM
            .startMediaFinder(context, myWorkspaces2.instUrl[currentIndex], myUser.entermediakey, myWorkspaces2.colId[currentIndex])
            .whenComplete(() async {
          final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(context, myWorkspaces2.instUrl[currentIndex]);
          hitTracker.searchedhits = await searchedData;
          await hitTracker.organizeData();
          await hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[currentIndex]);
          await hitTracker.initializeFilters();
          try {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomeMenu(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          } catch (e) {
            print("Null Safety : $e");
          }
        });
      }
    }
    return await wkspcs;
  }

  void logOutUser(BuildContext context) async {
    Fluttertoast.showToast(
      msg: "No instance URL found for the Workspaces. Please try again after some time.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 20,
      backgroundColor: Colors.lightBlue,
      fontSize: 16.0,
    );
    final EM = Provider.of<EnterMedia>(context, listen: false);
    await EM.logOutUser();
    sharedPref().resetValues();
    AuthenticationService.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
