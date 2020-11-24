import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspaceSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myWorkspaces = Provider.of<userWorkspaces>(context);
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        title: Text("Select a Workspace"),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        (ctx, i) => emWorkspaceRow('assets/EM Logo Basic.jpg',
            myWorkspaces.names[i], myWorkspaces.colId[i], context),
        //amount of rows
        childCount: 6,
      )),
    ]);
  }
}
