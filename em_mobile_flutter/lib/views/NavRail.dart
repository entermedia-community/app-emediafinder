import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:flutter/material.dart';

class NavRail extends StatefulWidget {
  @override
  _NavRailState createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  int _selectedIndex = 0;

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
          icon: Icon(Icons.filter_alt_rounded,
          color: Colors.blueGrey,
          ),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.folder_rounded,
            color: Colors.yellow,
          ),
          label: Text('Show Categories'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.photo_library_outlined,
            color: Colors.orange,
          ),
          label: Text('Albums'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.cloud,
            color: Colors.red,
          ),
          label: Text('AI Facial Recognition'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.replay,
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
          print('Create Upload Function');
        },
      ),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          print("NavRail index is: ");
          print(_selectedIndex);
        });
      },
    );
  }
}
