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
  List workspaceEvents;
  List workspaceLocations;
  List workspacePeople;
  List workspaceProducts;
  List workspaceProjects;
  List filterUrls;
  List filterEvents;
  List filterProjects;
  List imageSourcePath;
  List imageName;
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

    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      if (searchedhits.organizedhits[0].id == "asset") {
        for (final i in searchedhits.organizedhits[0].samples) {
          images.add(instanceUrl + i.thumbnailimg);
          sources.add(instanceUrl + i.sourcepath);
          name.add(instanceUrl + i.name);
        }
        totalMediaCount = int.parse(searchedhits.organizedhits[0].sampletotal.toString());
      }
    }
    imageUrls = images;
    print(images);

    return images;
  }

  //hitsperpage

  getFilteredAssetSampleUrls<List>(String instanceUrl, bool appendResult) {
    var images = <String>[];
    var sources = <String>[];
    var name = <String>[];

    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      if (searchedhits.organizedhits[0].id == "asset") {
        for (final i in searchedhits.organizedhits[0].samples) {
          images.add(instanceUrl + i.thumbnailimg);
          sources.add(i.sourcepath);
          name.add(instanceUrl + i.name);
        }
      }
    }
    if (!appendResult) {
      filterUrls = images;
      print(images);
    } else {
      filterUrls.addAll(images);
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
    var projects = <String>[];
    var events = <String>[];
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
          projects.add(i.name);
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
          events.add(i.name);
        }
        events.forEach((element) {
          filterEvents.add(element);
        });
      }
    }
  }

  organizeData() {
    var companies = <String>[];
    var events = <String>[];
    var locations = <String>[];
    var people = <String>[];
    var products = <String>[];
    var projects = <String>[];
    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      for (final i in searchedhits.organizedhits) {
        //Find projects in response object
        if (i.id == "entityproject") {
          print("These are workspace PROJECTS");
          print(i.samples);

          for (final i in i.samples) {
            projects.add(i.name);
          }

          workspaceProjects = projects;
          totalProjectCount = int.parse(i.sampletotal.toString());
          print(workspaceProjects);

          //Find events in response object
        } else if (i.id == "entityevent") {
          print("These are workspace EVENTS");
          print(i.samples);

          for (final i in i.samples) {
            events.add(i.name);
          }

          workspaceEvents = events;
          totalEventCount = int.parse(i.sampletotal.toString());
        } else if (i.id == "entityproduct") {
          print("These are workspace PRODUCTS");
          print(i.samples);

          for (final i in i.samples) {
            products.add(i.name);
          }

          workspaceProducts = products;
        } else if (i.id == "entityperson") {
          print("These are workspace PEOPLE");
          print(i.samples);

          for (final i in i.samples) {
            people.add(i.name);
          }

          workspacePeople = people;
        } else if (i.id == "entitylocation") {
          print("These are workspace LOCATIONS");
          print(i.samples);

          for (final i in i.samples) {
            locations.add(i.name);
          }

          workspaceLocations = locations;
        } else if (i.id == "entitycompany") {
          print("These are workspace COMPANIES");
          print(i.samples);

          for (final i in i.samples) {
            companies.add(i.name);
          }

          workspaceCompanies = companies;
        }
      }
    } else {
      clearFields();
    }
  }
}
