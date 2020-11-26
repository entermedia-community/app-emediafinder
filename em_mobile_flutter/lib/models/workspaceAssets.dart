import 'dart:core';

import 'package:flutter/widgets.dart';
//use this format to create custom classes that need to change.

class workspaceAssets with ChangeNotifier {
  Map searchedhits;
  List imageUrls;


  workspaceAssets({this.searchedhits});

  getAssetSampleUrls<List>(String instanceUrl) {

    var images = <String>[];

    if (searchedhits != null) {
      if (searchedhits["organizedhits"][0]["id"] == "asset") {
        for (final i in searchedhits["organizedhits"][0]["samples"]) {
          images.add(instanceUrl + i["thumbnailimg"]);
        }
      }
    }
    imageUrls = images;
    print(images);

    return images;
  }
}
