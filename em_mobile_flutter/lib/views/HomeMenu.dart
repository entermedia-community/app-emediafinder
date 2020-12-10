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

    return Scaffold(
      backgroundColor: Color(0xff0c223a),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final testWorkspaces = await EM.getEMWorkspaces();
          print(testWorkspaces);
        },
        child: Icon(Icons.refresh),
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

