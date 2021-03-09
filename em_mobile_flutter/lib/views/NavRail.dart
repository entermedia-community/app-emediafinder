import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/AddTeamMember.dart';
import 'package:em_mobile_flutter/views/FilesUploadPage.dart';
import 'package:em_mobile_flutter/views/ModuleListingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavRail extends StatefulWidget {
  @override
  _NavRailState createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  int _selectedIndex = 0;
  String instanceUrl = "";

  @override
  void initState() {
    getInstanceUrl();
    super.initState();
  }

  Future getInstanceUrl() async {
    final int currentWorkspace = await sharedPref().getRecentWorkspace();
    final userWorkspace = Provider.of<userWorkspaces>(context, listen: false);
    instanceUrl = userWorkspace.instUrl[currentWorkspace];
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: false,
      minWidth: 56,
      groupAlignment: -1,
      backgroundColor: Color(0xff2228),
      unselectedIconTheme: IconThemeData(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Colors.white70),
      elevation: 10,
      destinations: [
        NavigationRailDestination(
          icon: emLogoIcon(),
          label: Text('Account Options'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.filter_alt_rounded,
            color: Colors.blueGrey,
          ),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.folder_rounded,
            color: Colors.yellow,
          ),
          label: Text('Show Categories'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.photo_library_outlined,
            color: Colors.orange,
          ),
          label: Text('Albums'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.cloud,
            color: Colors.red,
          ),
          label: Text('AI Facial Recognition'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.replay,
            color: Color(0xff61af56),
          ),
          label: Text('Recent'),
        ),

//        NavigationRailDestination(
//            icon: Icon(Icons.add_box_outlined), label: Text('Add New')),
      ],
      trailing: IconButton(
        icon: Icon(Icons.add_box_outlined),
        color: Colors.white70,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMember()));
        },
      ),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          print("NavRail index is: ");
          print(_selectedIndex);
        });
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleListingPage(instanceUrl),
            ),
          );
        } else if (index == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilesUploadPage(instanceUrl),
            ),
          );
        }
      },
    );
  }
}
