import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/views/WorkspaceRow.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
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
    Provider.of<workspaceAssets>(context, listen: false).initializeFilters();

    return Consumer<workspaceAssets>(builder: (context, assets, child) {
      return CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          //appbar title & menu goes here
          title: Container(
            height: 80,
            child: SearchBar(
              icon: Icon(
                Icons.search_rounded,
                color: Color(0xff92e184),
              ),
              hintText: "Search your media...",
              hintStyle: TextStyle(
                color: Colors.deepOrangeAccent,
              ),
              minimumChars: 0,
              onCancelled: () => Provider.of<workspaceAssets>(context, listen: false).initializeFilters(),
              searchBarStyle: SearchBarStyle(
                backgroundColor: Color(0xff384964),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              onSearch: (val) => Provider.of<workspaceAssets>(context, listen: false).filterResult(val),
              onItemFound: null,
            ),
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
                      Text('Media (' + assets.filterUrls.length.toString() + ')'),
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
                    assets.filterUrls[i],
                  ),
              childCount: assets.filterUrls.length),
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
                      Text('Projects (' + assets.filterProjects.length.toString() + ')'),
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
          (ctx, i) => emWorkspaceRow(
            'assets/EM Logo Basic.jpg',
            assets.filterProjects[i],
            i < myWorkspaces.instUrl.length ? myWorkspaces.instUrl[i] : "",
            i < myWorkspaces.colId.length ? myWorkspaces.colId[i] : "",
            context,
            null,
          ),
          //amount of rows
          childCount: assets.filterProjects.length,
        )),
        SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 33,
              maxHeight: 33,
              child: Container(
                  color: Color(0xff384964),
                  child: Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Events (' + assets.filterEvents.length.toString() + ')'),
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
          (ctx, i) => emWorkspaceRow(
            'assets/EM Logo Basic.jpg',
            assets.filterEvents[i],
            i < myWorkspaces.instUrl.length ? myWorkspaces.instUrl[i] : "",
            i < myWorkspaces.colId.length ? myWorkspaces.colId[i] : "",
            context,
            null,
          ),
          //amount of rows
          childCount: assets.filterEvents.length,
        )),
      ]);
    });
  }
}

//required for proper collapsing behavior- mando
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
