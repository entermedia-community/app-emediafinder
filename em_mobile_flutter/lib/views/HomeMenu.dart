import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:em_mobile_flutter/views/NavRail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,
        closeManually: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Color(0xff61af56),
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.refresh),
            backgroundColor: Color(0xff61af56).withOpacity(0.8),
            label: 'Refresh page',
            labelStyle: TextStyle(color: Colors.blue, fontSize: 15),
            onTap: () async {
              final testWorkspaces = await EM.getEMWorkspaces();
              print(testWorkspaces);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Color(0xff61af56).withOpacity(0.6),
            label: 'Add workspace',
            labelStyle: TextStyle(color: Colors.blue, fontSize: 15),
            onTap: () => showDialog(
                context: context,
                builder: (context) {
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
                                    Navigator.of(context).pop();
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
                      ));
                }),
          ),
          SpeedDialChild(
            child: Icon(Icons.list_alt),
            backgroundColor: Color(0xff61af56).withOpacity(0.4),
            label: 'Change workspace',
            labelStyle: TextStyle(color: Colors.blue, fontSize: 15),
            onTap: () => print('Change workspace'),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          //From NavRail.dart
          NavRail(),
          Expanded(
            child: MainContent(myWorkspaces: myWorkspaces),
          )
        ],
      ),
    );
  }
}
