import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class MainContent extends StatelessWidget {
  const MainContent({
    Key key,
    @required this.myWorkspaces,
  }) : super(key: key);

  final userWorkspaces myWorkspaces;

  @override
  Widget build(BuildContext context) {
    final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
    return CustomScrollView(slivers: <Widget>[
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
            maxHeight: 33,
            child: Container(
                color: Color(0xff384964),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Media' + ' (#)'),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 19,
                          color: Colors.deepOrangeAccent,
                        ),
                        onPressed: null)
                  ],
                ))),
          )),
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          crossAxisCount: 3,
        ),
        //todo; This is where images are loaded
        delegate: SliverChildBuilderDelegate(
            (ctx, i) => Image.network(
                  hitTracker.imageUrls[i],
                ),
            childCount: hitTracker.imageUrls.length),
      ),
      SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            minHeight: 33,
            maxHeight: 33,
            child: Container(
                color: Color(0xff384964),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Projects' + ' (#)'),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 19,
                          color: Colors.deepOrangeAccent,
                        ),
                        onPressed: null)
                  ],
                ))),
          )),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        //just an example will build from api call
        (ctx, i) => emWorkspaceRow('assets/EM Logo Basic.jpg',
            myWorkspaces.names[i], myWorkspaces.colId[i], context),
        //amount of rows
        childCount: 4,
      )),
      SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            minHeight: 33,
            maxHeight: 33,
            child: Container(
                color: Color(0xff384964),
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text('Events' + ' (#)'),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 19,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: null)
                    ]))),
          )),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        //just an example will build from api call
        (ctx, i) => emWorkspaceRow('assets/EM Logo Basic.jpg',
            myWorkspaces.names[i], myWorkspaces.colId[i], context),
        //amount of rows
        childCount: 4,
      )),
    ]);
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

// todo; Load image url into list dynamically from entermedia. below is just example data.
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
