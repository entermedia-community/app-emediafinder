import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:em_mobile_flutter/views/NavRail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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
          EM.getEMWorkspaces();
        },
        child: Icon(Icons.refresh),
      ),
      body: Row(
        children: <Widget>[
          //From NavRail.dart
          NavRail(),
          //todo; main content displayed below in the Expanded. Make it's own view and return Expanded() - done Mando
          Expanded(
            child: MainContent(myWorkspaces: myWorkspaces),
          )
        ],
      ),
    );
  }
}

//testing with card idea.
class ImageCard extends StatelessWidget {
  final loc;

  @override
  Widget build(BuildContext context) {
    return Card(
//      margin: const EdgeInsets.fromLTRB(0, 0, 24, 24),
      child: Image.asset(loc),
//      clipBehavior: Clip.antiAlias,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  const ImageCard(this.loc);
}
