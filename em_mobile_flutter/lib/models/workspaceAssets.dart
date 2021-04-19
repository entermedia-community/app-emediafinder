import 'dart:core';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
//use this format to create custom classes that need to change.

class workspaceAssets with ChangeNotifier {
  WorkspaceAssetsModel searchedhits;
  List imageUrls;
  List workspaceCompanies;
  List<EntityFilters> workspaceEvents;
  List workspaceLocations;
  List workspacePeople;
  List workspaceProducts;
  List<EntityFilters> workspaceProjects;
  List filterUrls;
  List<EntityFilters> filterEvents;
  List<EntityFilters> filterProjects;
  List imageSourcePath;
  List imageName;
  List ids;
  List filterIds;
  int filterPageCount = 1;
  int currentPageNumber = 1;
  int totalMediaCount = 0;
  int totalProjectCount = 0;
  int totalEventCount = 0;

  workspaceAssets({this.searchedhits});

  getAssetSampleUrls<List>(String instanceUrl) {
    var images = <String>[];
    var sources = <String>[];
    var name = <String>[];
    var id = <String>[];
    totalMediaCount = 0;
    imageUrls = [];
    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      if (searchedhits.organizedhits[0].id == "asset") {
        for (final i in searchedhits.organizedhits[0].samples) {
          images.add(instanceUrl.toString() + i.thumbnailimg.toString());
          sources.add(instanceUrl + i.sourcepath);
          name.add(instanceUrl + i.name);
          id.add(i.id);
        }
        totalMediaCount = int.parse(searchedhits.organizedhits[0].sampletotal.toString());
      }
    }
    ids = id;
    imageUrls = images;
    print(images);

    return images;
  }

  //hitsperpage

  getFilteredAssetSampleUrls<List>(String instanceUrl, bool appendResult) {
    var images = <String>[];
    var sources = <String>[];
    var name = <String>[];
    var id = <String>[];

    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      if (searchedhits.organizedhits[0].id == "asset") {
        for (final i in searchedhits.organizedhits[0].samples) {
          images.add(instanceUrl + i.thumbnailimg);
          sources.add(i.sourcepath);
          name.add(instanceUrl + i.name);
          id.add(i.id);
        }
      }
    }
    if (!appendResult) {
      filterUrls = images;
      filterIds = id;
      print(images);
    } else {
      filterUrls.addAll(images);
      filterIds.addAll(id);
      print(images);
    }

    return images;
  }

  initializeFilters() {
    currentPageNumber = 1;
    filterPageCount = 1;
    filterUrls = imageUrls;
    filterEvents = workspaceEvents;
    filterProjects = workspaceProjects;
    filterIds = ids;
    notifyListeners();
  }

  clearFields() {
    workspaceEvents = [];
    workspaceProjects = [];
    notifyListeners();
  }

  increaseCurrentPageCount() {
    currentPageNumber++;
  }

  Future<void> filterResult(String filterText, BuildContext context, userWorkspaces myWorkspace, bool appendResult) async {
    if (filterText.length <= 2) {
      initializeFilters();
    } else {
      final myHitTracker = Provider.of<workspaceAssets>(context, listen: false);
      final EM = Provider.of<EnterMedia>(context, listen: false);
      int index = await sharedPref().getRecentWorkspace();
      String instUrl = myWorkspace.instUrl[index != null ? index : 0];
      final WorkspaceAssetsModel searchedData = await EM.searchWorkspaceAssets(context, instUrl, filterText, currentPageNumber.toString());
      print(searchedData);
      myHitTracker.searchedhits = searchedData;
      filterPageCount = searchedData.response.pages;
      currentPageNumber = searchedData.response.page;
      myHitTracker.organizeFilterData(appendResult);

      myHitTracker.getFilteredAssetSampleUrls(instUrl, appendResult);
    }
    notifyListeners();
  }

//This organizes the response from /finder/mediadb/services/module/modulesearch/sample.json called in entermedia.dart
  //Todo; Add 'if else' statements for all other datatypes

  organizeFilterData(bool appendResult) {
    var projects = <EntityFilters>[];
    var events = <EntityFilters>[];
    if (!appendResult) {
      filterProjects = [];
      filterEvents = [];
    }
    for (final i in searchedhits.organizedhits) {
      //Find projects in response object
      if (i.id == "entityproject") {
        print("These are workspace PROJECTS");
        print(i.samples);

        for (final i in i.samples) {
          projects.add(EntityFilters(id: i.id, name: i.name, attachedMedia: i.attachedmedia));
        }

        projects.forEach((element) {
          filterProjects.add(element);
        });
        print(workspaceProjects);

        //Find events in response object
      } else if (i.id == "entityevent") {
        print("These are workspace EVENTS");
        print(i.samples);

        for (final i in i.samples) {
          events.add(EntityFilters(id: i.id, name: i.name, attachedMedia: i.attachedmedia));
        }
        events.forEach((element) {
          filterEvents.add(element);
        });
      }
    }
  }

  organizeData() {
    var companies = <EntityFilters>[];
    var events = <EntityFilters>[];
    var locations = <EntityFilters>[];
    var people = <EntityFilters>[];
    var products = <EntityFilters>[];
    var projects = <EntityFilters>[];
    totalProjectCount = 0;
    totalEventCount = 0;
    workspaceProjects = [];
    workspaceEvents = [];
    workspaceCompanies = [];
    workspaceLocations = [];
    workspacePeople = [];
    workspaceProducts = [];
    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      for (final i in searchedhits.organizedhits) {
        //Find projects in response object
        if (i.id == "entityproject") {
          print("These are workspace PROJECTS");
          print(i.samples);

          for (final i in i.samples) {
            projects.add(EntityFilters(id: i.id, name: i.name, attachedMedia: i.attachedmedia));
          }

          workspaceProjects = projects;
          totalProjectCount = int.parse(i.sampletotal.toString());
          print(workspaceProjects);

          //Find events in response object
        } else if (i.id == "entityevent") {
          print("These are workspace EVENTS");
          print(i.samples);

          for (final i in i.samples) {
            events.add(EntityFilters(id: i.id, name: i.name, attachedMedia: i.attachedmedia));
          }

          workspaceEvents = events;
          totalEventCount = int.parse(i.sampletotal.toString());
        } else if (i.id == "entityproduct") {
          print("These are workspace PRODUCTS");
          print(i.samples);

          for (final i in i.samples) {
            products.add(EntityFilters(id: i.id, name: i.name));
          }

          workspaceProducts = products;
        } else if (i.id == "entityperson") {
          print("These are workspace PEOPLE");
          print(i.samples);

          for (final i in i.samples) {
            people.add(EntityFilters(id: i.id, name: i.name));
          }

          workspacePeople = people;
        } else if (i.id == "entitylocation") {
          print("These are workspace LOCATIONS");
          print(i.samples);

          for (final i in i.samples) {
            locations.add(EntityFilters(id: i.id, name: i.name));
          }

          workspaceLocations = locations;
        } else if (i.id == "entitycompany") {
          print("These are workspace COMPANIES");
          print(i.samples);

          for (final i in i.samples) {
            companies.add(EntityFilters(id: i.id, name: i.name));
          }

          workspaceCompanies = companies;
        }
      }
    } else {
      clearFields();
    }
  }
}

class EntityFilters {
  final String name;
  final String id;
  final List<Attachedmedia> attachedMedia;
  EntityFilters({@required this.id, @required this.name, this.attachedMedia = const []});
}
