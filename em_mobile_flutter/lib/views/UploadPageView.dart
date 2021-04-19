import 'dart:convert';

import 'package:em_mobile_flutter/services/sharedpreferences.dart';
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
  List<SelectedModulesWithTitle> selectedModulesWithTitle = <SelectedModulesWithTitle>[];
  RemoveItem removedId = new RemoveItem(null, null);
  // Map<String, List<String>> jsonEncodedData = {};

  void onDataChanged(List<SelectedModulesWithTitle> newData) async {
    setState(() => selectedModulesWithTitle = newData);
    // await sharedPref().setRecentEntity(sharedPreferencesUsingModelToJson(selectedModulesWithTitle));
  }

  List<SelectedModulesWithTitle> getEncodedJson() {
    return selectedModulesWithTitle;
  }

  void removeEntityAtIndex(String moduleId, int index, String itemId) {
    setState(() {
      removedId = RemoveItem(moduleId, itemId);
      selectedModulesWithTitle.where((element) => element.moduleId == moduleId).first.selectedModules.removeAt(index);
    });
  }

  void fetchRecentEntities() {}

  void resetRemoveId() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        removedId = new RemoveItem(null, null);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
    fetchRecentEntities();
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
          FilesUploadPage(
            instanceUrl: widget.instanceUrl,
            controller: _pageController,
            getEncodedJson: getEncodedJson,
            removeEntityAtIndex: removeEntityAtIndex,
          ),
          AttachEntityPage(
              instanceUrl: widget.instanceUrl,
              onDataChanged: onDataChanged,
              controller: _pageController,
              removedItems: removedId,
              resetVariable: resetRemoveId),
        ],
      ),
    );
  }
}

class RemoveItem {
  final String moduleId;
  final String item;
  RemoveItem(this.moduleId, this.item);
}

class RecentEntity {
  String moduleId;
  String title;
  List<SelectedModules> selectedModules;

  RecentEntity({this.moduleId, this.title, this.selectedModules});

  RecentEntity.fromJson(Map<String, dynamic> json) {
    moduleId = json['moduleId'];
    title = json['title'];
    if (json['selectedModules'] != null) {
      selectedModules = new List<SelectedModules>();
      json['selectedModules'].forEach((v) {
        selectedModules.add(new SelectedModules.fromJson(v));
      });
    }
  }

  static Map<String, dynamic> toMap(RecentEntity recentEntity) =>
      {'moduleId': recentEntity.moduleId, 'title': recentEntity.title, 'selectedModules': recentEntity.selectedModules};

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moduleId'] = this.moduleId;
    data['title'] = this.title;
    if (this.selectedModules != null) {
      data['selectedModules'] = this.selectedModules.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static String encode(List<RecentEntity> musics) => json.encode(
        musics.map<Map<String, dynamic>>((music) => RecentEntity.toMap(music)).toList(),
      );

  static List<RecentEntity> decode(String musics) =>
      (json.decode(musics) as List<dynamic>).map<RecentEntity>((item) => RecentEntity.fromJson(item)).toList();
}

class SelectedModules {
  String id;
  String name;

  SelectedModules({this.id, this.name});

  SelectedModules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
