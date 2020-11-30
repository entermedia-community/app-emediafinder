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
      if (searchedhits["organizedhits"][i]["id"] == "entityproject") {

        print("These are workspace PROJECTS");
        print(searchedhits["organizedhits"][i]["samples"]);

        for (final i in searchedhits["organizedhits"][i]["samples"]) {
          projects.add(i["name"]);
        }

        workspaceProjects = projects;

        //Find events in response object
      } else if (searchedhits["organizedhits"][i]["id"] == "entityevent") {

        print("These are workspace EVENTS");
        print(searchedhits["organizedhits"][i]["samples"]);

        for (final i in searchedhits["organizedhits"][i]["samples"]) {
          events.add(i["name"]);
        }

        workspaceEvents = events;

      } else if (searchedhits["organizedhits"][i]["id"] == "entityproduct") {

        print("These are workspace PRODUCTS");
        print(searchedhits["organizedhits"][i]["samples"]);

        for (final i in searchedhits["organizedhits"][i]["samples"]) {
          products.add(i["name"]);
        }

        workspaceProducts = products;

      } else if (searchedhits["organizedhits"][i]["id"] == "entityperson") {

        print("These are workspace PEOPLE");
        print(searchedhits["organizedhits"][i]["samples"]);

        for (final i in searchedhits["organizedhits"][i]["samples"]) {
          people.add(i["name"]);
        }

        workspacePeople = people;

      } else if (searchedhits["organizedhits"][i]["id"] == "entitylocation") {

        print("These are workspace LOCATIONS");
        print(searchedhits["organizedhits"][i]["samples"]);

        for (final i in searchedhits["organizedhits"][i]["samples"]) {
          locations.add(i["name"]);
        }

        workspaceLocations = locations;

      } else if (searchedhits["organizedhits"][i]["id"] == "entitycompany") {

        print("These are workspace COMPANIES");
        print(searchedhits["organizedhits"][i]["samples"]);

        for (final i in searchedhits["organizedhits"][i]["samples"]) {
          companies.add(i["name"]);
        }

        workspaceCompanies = companies;

      }
    }
  }
}
