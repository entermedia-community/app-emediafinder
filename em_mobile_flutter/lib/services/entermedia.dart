import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnterMedia {
  final String EM = 'https://entermediadb.org/entermediadb/app';
  final String MEDIADB = 'https://entermediadb.org/entermediadb/mediadb';
//  final String MEDIADB = 'http://cburkey.entermediadb.org:8080/entermediadb/mediadb';
  var client = http.Client();
  var emUser;
  var tempKey;



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
        "X-token": tempKey,
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
//Entermedia Login with key pasted in
  Future<EmUser> emLoginWithKey(String entermediakey) async {
    final resMap = await postEntermedia(
        MEDIADB + '/services/authentication/firebaselogin.json',
        {"entermediakey": entermediakey});

    print("Logging in with key...");

    if (resMap != null) {

      //save local emUser from response object
      emUser = emUserFromJson(json.encode(resMap));
      return emUser;
    } else {
      return null;
    }
  }

  //Entermedia Login with key pasted in
  Future<EmUser> emAutoLoginWithKey(emkey) async {

    final resMap = await postEntermedia(
        MEDIADB + '/services/authentication/firebaselogin.json',
        {"entermediakey": emkey});

    print("Logging in with key...");

    if (resMap != null) {

      //save local emUser from response object
      emUser = emUserFromJson(json.encode(resMap));
      return emUser;
    } else {
      return null;
    }
  }

  //Entermedia Login with key pasted in
  Future<bool>emEmailKey(String email) async {
    final resMap = await postEntermedia(
        MEDIADB + '/services/authentication/sendmagiclink.json',
        {"to": email});

    print("Sending email...");

    if (resMap != null) {
      var loggedin = true;
      print(resMap);

      return loggedin;
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

  Future<Map> createTeamAccount(String url, String entermediakey, String colId) async {

    final resMap = await postFinder(
      url + '/finder/mediadb/services/authentication/createteamaccount.json',
      {
        "entermediacloudkey": entermediakey,
        "collectionid": colId

      },
    );
    if (resMap != null) {
//    && resMap.response["status"] == "ok"

      print(resMap);

      print('Your temporary server key is: ' + resMap["results"]["entermediakey"]);

      tempKey = resMap["results"]["entermediakey"];

      return resMap;
    } else {
      print("Request failed!" );
      return null;
    }
  }
}
