import 'dart:convert';

import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:em_mobile_flutter/views/NavRail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

//todo; LAYOUT starts here
class _HomeMenuState extends State<HomeMenu> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final EM = Provider.of<EnterMedia>(context);
    final myWorkspaces = Provider.of<userWorkspaces>(context);
    final TextEditingController newWorkspaceController = new TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xff0c223a),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          final testWorkspaces = await EM.getEMWorkspaces(context);
          print(testWorkspaces);
        },
      ),
      body: Row(
        children: <Widget>[
          //From NavRail.dart
          NavRail(
            parentContext: context,
            createWorkspaceController: newWorkspaceController,
          ),
          Expanded(
            child: MainContent(myWorkspaces: myWorkspaces),
          )
        ],
      ),
    );
  }
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
          child: Consumer<userWorkspaces>(builder: (context, myWorkspace, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: myWorkspace.names.length,
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
                        onTap: () {
                          loadNewWorkspace(context, dialogContext, index);
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          }),
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

Future<void> loadNewWorkspace(BuildContext parentContext, BuildContext dialogContext, int index) async {
  Navigator.pop(dialogContext);
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
  await EM.createTeamAccount(parentContext, myWorkspaces2.instUrl[index], myUser.entermediakey, myWorkspaces2.colId[index]);
  final Map searchedData = await EM.getWorkspaceAssets(parentContext, myWorkspaces2.instUrl[index]);
  hitTracker.searchedhits = searchedData;
  hitTracker.organizeData();
  hitTracker.getAssetSampleUrls(myWorkspaces2.instUrl[index]);
  hitTracker.initializeFilters();
  if (index != null) {
    sharedPref().saveRecentWorkspace(index);
  }

  Navigator.pop(parentContext);
  Navigator.push(parentContext, MaterialPageRoute(builder: (BuildContext ctx) => HomeMenu()));
}
