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
  int filterPageCount = 1;
  int currentPageNumber = 1;

  workspaceAssets({this.searchedhits});

  getAssetSampleUrls<List>(String instanceUrl) {
    var images = <String>[];

    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      if (searchedhits.organizedhits[0].id == "asset") {
        for (final i in searchedhits.organizedhits[0].samples) {
          images.add(instanceUrl + i.thumbnailimg);
        }
      }
    }
    imageUrls = images;
    print(images);

    return images;
  }

  //hitsperpage

  getFilteredAssetSampleUrls<List>(String instanceUrl) {
    var images = <String>[];

    if (searchedhits != null && searchedhits.organizedhits.length > 0) {
      if (searchedhits.organizedhits[0].id == "asset") {
        for (final i in searchedhits.organizedhits[0].samples) {
          images.add(instanceUrl + i.thumbnailimg);
        }
      }
    }
    filterUrls = images;
    print(images);

    return images;
  }

  initializeFilters() {
    currentPageNumber = 1;
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

  filterResult(String filterText, BuildContext context, userWorkspaces myWorkspace) async {
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
      myHitTracker.organizeFilterData();

      myHitTracker.getFilteredAssetSampleUrls(instUrl);
    }
    notifyListeners();
  }

//This organizes the response from /finder/mediadb/services/module/modulesearch/sample.json called in entermedia.dart
  //Todo; Add 'if else' statements for all other datatypes

  organizeFilterData() {
    var projects = <String>[];
    var events = <String>[];

    filterProjects = [];
    filterEvents = [];
    for (final i in searchedhits.organizedhits) {
      //Find projects in response object
      if (i.id == "entityproject") {
        print("These are workspace PROJECTS");
        print(i.samples);

        for (final i in i.samples) {
          projects.add(i.name);
        }

        filterProjects = projects;
        print(workspaceProjects);

        //Find events in response object
      } else if (i.id == "entityevent") {
        print("These are workspace EVENTS");
        print(i.samples);

        for (final i in i.samples) {
          events.add(i.name);
        }

        filterEvents = events;
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
    if (searchedhits.organizedhits.length > 0) {
      for (final i in searchedhits.organizedhits) {
        //Find projects in response object
        if (i.id == "entityproject") {
          print("These are workspace PROJECTS");
          print(i.samples);

          for (final i in i.samples) {
            projects.add(i.name);
          }

          workspaceProjects = projects;
          print(workspaceProjects);

          //Find events in response object
        } else if (i.id == "entityevent") {
          print("These are workspace EVENTS");
          print(i.samples);

          for (final i in i.samples) {
            events.add(i.name);
          }

          workspaceEvents = events;
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
