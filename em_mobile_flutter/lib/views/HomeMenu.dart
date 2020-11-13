import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/EMWebview.dart';
import 'package:em_mobile_flutter/views/NavRail.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
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
//                 todo; IF YOU WANT TO ADD ICON NEXT TO SEARCHBAR -> Row(children: [ Expanded(child: SearchBar(onSearch: null, onItemFound: null)),IconButton(icon: Icon(Icons.list,color: Colors.white,), onPressed: null)]),
                ),
                pinned: true,
                expandedHeight: 55.0,
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 33,
                    maxHeight: 66,
                    child: Container(
                        color: Color(0xff384964),
                        child: Center(child: Text('Media'))),
                  )),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 3,
                ),
                //todo; This is where images are loaded
                delegate: SliverChildBuilderDelegate(
                    (ctx, i) => Image.asset(
                          example[i],
                        ),
                    childCount: example.length),
              ),
//                todo; workspace list below use as a template to add another sliver
//              SliverPadding(
//                padding: EdgeInsets.all(9),
//                sliver: SliverList(
//                    delegate: SliverChildBuilderDelegate(
//                  (ctx, i) => emWorkspaceRow('assets/EM Logo Basic.jpg',
//                      myWorkspaces.names[i], myWorkspaces.colId[i], context),
//                  childCount: 15,
//                )),
//              ),
            ]),
          )
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WebViewContainer('https://google.com')));
}

// todo; Load image url into list dynamically from entermedia.
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
  'assets/images/eleven.jpg',
  'assets/images/twelve.jpg',
  'assets/images/thirteen.jpg',
  'assets/images/fourteen.jpg',
  'assets/images/fifteen.jpg',
  'assets/images/sixteen.jpg',
  'assets/images/seventeen.jpg',
  'assets/images/eighteen.jpg',
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
