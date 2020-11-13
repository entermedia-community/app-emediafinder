import 'dart:convert';
import 'package:em_mobile_flutter/models/emWorkspaces.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceIcon.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/EMWebview.dart';
import 'package:em_mobile_flutter/views/NavRail.dart';
import 'package:em_mobile_flutter/models/emLogo.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EMWebview.dart' as Col;
import 'package:webview_flutter/webview_flutter.dart';

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
            _navigateToNextScreen(context);
//            //This button is to make sure workspaces were loading correctly.
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
////              print(myWorkspaces.names);

          },
          child: Icon(Icons.refresh),
        ),
      body: Row(
        children: <Widget>[
          //From NavRail.dart
          NavRail(),
          //todo; main landing page content displayed here in the Expanded. Can make it's own view and return Expanded()
          Expanded(
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                  //appbar title & menu goes here
                  title: SizedBox(
                    height: 80,
                    child: SearchBar(onSearch: null, onItemFound: null),
                  ),
                  pinned: true,
                  expandedHeight: 200.0,
                  //logo goes here?
                  flexibleSpace: FlexibleSpaceBar(
                    background: EmLogo(),
                  )),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                //todo; This is where images are loaded
                delegate: SliverChildBuilderDelegate(
                    (ctx, i) => Image.asset(
                          example[i],
                        ),
                    childCount: example.length),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewContainer('https://google.com')));
}

// todo; Load image url into list dynamically from entermedia.
final List<String> images = [
  "https://images.unsplash.com/photo-1524758631624-e2822e304c36?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
  "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
  "https://images.unsplash.com/photo-1538688525198-9b88f6f53126?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80",
  "https://images.unsplash.com/photo-1513161455079-7dc1de15ef3e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
  "https://images.unsplash.com/photo-1544457070-4cd773b4d71e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=843&q=80",
  "https://images.unsplash.com/photo-1532323544230-7191fd51bc1b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
  "https://images.unsplash.com/photo-1549488344-cbb6c34cf08b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
];
// Be specific in '.yaml' file when using local assets. Might also have to push first: https://stackoverflow.com/questions/52644621/flutter-assets-error-exception-caught-by-image-resource-service
final List<String> example = [
  'assets/images/one.jpg',
  'assets/images/two.jpg',
  'assets/images/three.jpg',
  'assets/images/four.jpg',
  'assets/images/five.jpg',
  'assets/images/six.jpg',
  'assets/images/seven.jpg',
  'assets/images/eight.jpg',
  'assets/images/nine.jpg',
  'assets/images/ten.jpg',
];

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
