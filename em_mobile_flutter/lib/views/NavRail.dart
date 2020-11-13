import 'package:em_mobile_flutter/models/emWorkspaces.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceIcon.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NavRail extends StatefulWidget {
  @override
  _NavRailState createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final EM = Provider.of<EnterMedia>(context);
    final myWorkspaces = Provider.of<userWorkspaces>(context);
    return NavigationRail(
      extended: false,
      minWidth: 56,
      groupAlignment: -1,
      backgroundColor: Color(0xff384964),
      unselectedIconTheme: IconThemeData(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Color(0xff61af56)),
      elevation: 10,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home_rounded),
          label: Text('Home'),
        ),
        NavigationRailDestination(
            icon: Icon(Icons.chat_bubble_rounded), label: Text('Chat')),
        NavigationRailDestination(
            icon: Icon(Icons.filter_alt_rounded), label: Text('Search')),
        NavigationRailDestination(
            icon: workspaceIcon(), label: Text('Workspaces')),
      ],
      trailing: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
      ),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          print("NavRail index is: ");
          print(_selectedIndex);
          if (index == 3) {
//            //Perform API call
//            final userWorkspaces = await EM.getEMWorkspaces();
//            //Initialize blank Lists
//            myWorkspaces.names = [];
//            myWorkspaces.colId = [];
//            //Loop thru API 'results'
//            for (final project in userWorkspaces) {
//
//              myWorkspaces.names.add(project["name"]);
//              myWorkspaces.colId.add(project["id"]);
//            }

          }
        });
      },
    );
  }
}
