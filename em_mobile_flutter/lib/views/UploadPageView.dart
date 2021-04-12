import 'package:em_mobile_flutter/views/AttachEntityPage.dart';
import 'package:em_mobile_flutter/views/FilesUploadPage.dart';
import 'package:flutter/material.dart';

class UploadPageView extends StatefulWidget {
  final String instanceUrl;
  UploadPageView(this.instanceUrl);
  @override
  _UploadPageViewState createState() => _UploadPageViewState();
}

class _UploadPageViewState extends State<UploadPageView> {
  PageController _pageController;
  Map<String, List<String>> jsonEncodedData = {};

  void onDataChanged(Map<String, List<String>> newData) {
    setState(() => jsonEncodedData = newData);
    print(newData);
  }

  Map<String, List<String>> getEncodedJson() {
    return jsonEncodedData;
  }

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
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          FilesUploadPage(instanceUrl: widget.instanceUrl, controller: _pageController, getEncodedJson: getEncodedJson),
          AttachEntityPage(
            instanceUrl: widget.instanceUrl,
            onDataChanged: onDataChanged,
            controller: _pageController,
          ),
        ],
      ),
    );
  }
}
