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
  @override
  Widget build(BuildContext context) {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myWorkspaces = Provider.of<userWorkspaces>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff0c223a),
        resizeToAvoidBottomInset: false,
        body: Row(
          children: <Widget>[
            //From NavRail.dart
            NavRail(),
            Expanded(
              child: MainContent(myWorkspaces: myWorkspaces),
            )
          ],
        ),
      ),
    );
  }
}
