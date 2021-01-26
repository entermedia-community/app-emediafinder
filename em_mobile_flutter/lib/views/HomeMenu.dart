import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:em_mobile_flutter/views/NavRail.dart';
import 'package:flutter/material.dart';
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "1",
            onPressed: () async {
              final testWorkspaces = await EM.getEMWorkspaces();
              print(testWorkspaces);
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "2",
            onPressed: () => showDialog(
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
            child: Icon(Icons.add),
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
