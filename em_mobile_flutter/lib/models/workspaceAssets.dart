import 'dart:core';

import 'package:flutter/widgets.dart';
//use this format to create custom classes that need to change.

class workspaceAssets with ChangeNotifier {
  Map searchedhits;
  List imageUrls;
  List workspaceCompanies;
  List workspaceEvents;
  List workspaceLocations;
  List workspacePeople;
  List workspaceProducts;
  List workspaceProjects;

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

//This organizes the response from /finder/mediadb/services/module/modulesearch/sample.json
  //Todo; Add 'if else' statements for all other datatypes
  organizeData() {
    var companies = <String>[];
    var events = <String>[];
    var locations = <String>[];
    var people = <String>[];
    var products = <String>[];
    var projects = <String>[];

    for (final i in searchedhits["organizedhits"]) {
      //Find projects in response object
      if (i["id"] == "entityproject") {

        print("These are workspace PROJECTS");
        print(i["samples"]);

        for (final i in i["samples"]) {
          projects.add(i["name"]);
        }

        workspaceProjects = projects;
        print(workspaceProjects);

        //Find events in response object
      } else if (i["id"] == "entityevent") {

        print("These are workspace EVENTS");
        print(i["samples"]);

        for (final i in i["samples"]) {
          events.add(i["name"]);
        }

        workspaceEvents = events;

      } else if (i["id"] == "entityproduct") {

        print("These are workspace PRODUCTS");
        print(i["samples"]);

        for (final i in i["samples"]) {
          products.add(i["name"]);
        }

        workspaceProducts = products;

      } else if (i["id"] == "entityperson") {

        print("These are workspace PEOPLE");
        print(i["samples"]);

        for (final i in i["samples"]) {
          people.add(i["name"]);
        }

        workspacePeople = people;

      } else if (i["id"] == "entitylocation") {

        print("These are workspace LOCATIONS");
        print(i["samples"]);

        for (final i in i["samples"]) {
          locations.add(i["name"]);
        }

        workspaceLocations = locations;

      } else if (i["id"] == "entitycompany") {

        print("These are workspace COMPANIES");
        print(i["samples"]);

        for (final i in i["samples"]) {
          companies.add(i["name"]);
        }

        workspaceCompanies = companies;

      }
    }
  }
}
