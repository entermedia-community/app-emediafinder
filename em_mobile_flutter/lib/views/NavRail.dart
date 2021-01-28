import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:flutter/material.dart';

class NavRail extends StatefulWidget {
  final BuildContext parentContext;
  final TextEditingController createWorkspaceController;
  NavRail({@required this.parentContext, @required this.createWorkspaceController});

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
      backgroundColor: Color(0xff384964),
      unselectedIconTheme: IconThemeData(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Color(0xff61af56)),
      elevation: 10,
      destinations: [
        NavigationRailDestination(
          icon: emLogoIcon(),
          label: Text('Account Options'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.filter_alt_rounded),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.account_tree_rounded),
          label: Text('Linked Folders'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.face_retouching_natural),
          label: Text('Facial Recognition'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bookmark_rounded),
          label: Text('Favorites'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.photo_library_outlined),
          label: Text('Albums'),
        ),
//        NavigationRailDestination(
//            icon: Icon(Icons.add_box_outlined), label: Text('Add New')),
      ],
      trailing: Column(
        children: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            color: Color(0xff61af56),
            onPressed: () {
              print('Create Upload Function');
            },
          ),
          Divider(),
          IconButton(
            icon: Icon(Icons.create),
            color: Color(0xff61af56),
            onPressed: () {
              createWorkspace(widget.parentContext, widget.createWorkspaceController);
            },
          ),
          SizedBox(height: 3),
          IconButton(
            icon: Icon(Icons.swap_vert),
            color: Color(0xff61af56),
            onPressed: () {
              switchWorkspace(widget.parentContext);
            },
          ),
        ],
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
