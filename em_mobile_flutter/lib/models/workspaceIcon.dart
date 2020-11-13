import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/views/EMWebview.dart';

class workspaceIcon extends StatefulWidget {
  @override
  _workspaceIconState createState() => _workspaceIconState();
}

class _workspaceIconState extends State<workspaceIcon> {
  //example List
  @override
  Widget build(BuildContext context) {
    return Consumer<userWorkspaces>(
      builder: (BuildContext context, myWorkspaces, child) => PopupMenuButton(
        icon: Icon(Icons.account_tree_rounded),
        elevation: 15,
        itemBuilder: (BuildContext context) {
          return myWorkspaces.names.map((name) {
            return PopupMenuItem(value: name, child: Text(name));
          }).toList();
        },
        onSelected: (name) => {
          _navigateToNextScreen(context, myWorkspaces.colId[myWorkspaces.names.indexOf(name)])
          //Grab the Index of Unique Values
          //You can access the index of a specific value by searching for it with List.indexOf, which returns the index of the first match. This approach is most predictable when all values are unique. A Set can ensure uniqueness throughout the list.-stackoverflow
        },
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context, String colId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewContainer(colId)));
  }
}
