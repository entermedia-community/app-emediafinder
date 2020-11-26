import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnterMedia {
  final String EM = 'https://entermediadb.org/entermediadb/app';
  final String MEDIADB = 'https://entermediadb.org/entermediadb/mediadb';
  final String Localhost = '';
  var client = http.Client();
  var emUser;
  
  //Generic post method to entermedias server
  Future<Map> postEntermedia(String url, Map jsonBody) async {
    //Set headers
    var headers = <String,String>{};
    if (emUser != null) {
      print("Setting Headers.");
      //Important must specify types! Dart defaults to dynamic and http.post requires definitive types.
      headers = <String,String>{
        "X-token": emUser.results.entermediakey,
        "X-tokentype": "entermedia"
      };
    }

    //make API post
    final response = await client.post(
      url,
      body: jsonBody,
      headers: headers,
    );
    print("Post started response is below!");
    print("Response code: ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Success user info is:" + response.body);
      final String responseString = response.body;

      //returns map!
      return json.decode(responseString);
    } else {
      return null;
    }
  }
//Generic post to client specific 'EMFinder' server.
  Future<Map> postFinder(String url, Map jsonBody) async {
    //Set headers
    var headers = <String,String>{};
    if (emUser != null) {
      print("Setting Headers.");
      //Important must specify types! Dart defaults to dynamic and http.post requires definitive types.
      headers = <String,String>{
        "X-token": "em" + emUser.results.entermediakey,
        "X-tokentype": "entermedia"
      };
    }

    //make API post
    final response = await client.post(
      url,
      body: jsonBody,
      headers: headers,
    );
    print("Post started response is below!");
    print("Response code: ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Success workspace data is:" + response.body);
      final String responseString = response.body;

      //returns map!
      return json.decode(responseString);
    } else {
      return null;
    }
  }

  //This gets the Entermedia user information called when logging in. - Mando Oct 14th 2020
  Future<EmUser> emLogin(String email, String password) async {
    final resMap = await postEntermedia(
        MEDIADB + '/services/authentication/firebaselogin.json',
        {"email": email, "password": password});

    print("Logging in");

    if (resMap != null) {

      //save local emUser from response object
      emUser = emUserFromJson(json.encode(resMap));
      return emUser;
    } else {
      return null;
    }
  }

//This function retrieves list of workspaces the user is apart of. - Mando Oct 23rd
  Future<List> getEMWorkspaces() async {


    final resMap = await postEntermedia(
      MEDIADB + '/services/module/librarycollection/viewprojects.json',
      {},
    );
    print("Fetching workspaces...");
    if (resMap != null) {
      print(resMap);

//      emWorkspacesFromJson(json.encode(resMap));

      return resMap["results"];
    } else {
      print("Request failed!");
      return null;
    }
  }

  Future<Map> getWorkspaceAssets(String url) async {

    final resMap = await postFinder(
      url + '/finder/mediadb/services/module/modulesearch/sample.json',
      {},
    );
    print("Fetching workspace assets from " + url + "/finder/mediadb/services/module/modulesearch/sample.json");
    if (resMap != null) {
      print(resMap);

      return resMap;
    } else {
      print("Request failed!");
      return null;
    }
  }
}
