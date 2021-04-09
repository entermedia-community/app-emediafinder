import 'package:em_mobile_flutter/views/AttachEntityPage.dart';
import 'package:em_mobile_flutter/views/FilesUploadPage.dart';
import 'package:flutter/material.dart';

class MyPageView extends StatefulWidget {
  final String instanceUrl;
  MyPageView(this.instanceUrl);
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> with SingleTickerProviderStateMixin {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: _pageController,
        // physics: NeverScrollableScrollPhysics(), // so the user cannot scroll, only animating when they select an option
        children: <Widget>[
          FilesUploadPage(widget.instanceUrl),
          AttachEntityPage(widget.instanceUrl),
        ],
      ),
    );
  }
}
