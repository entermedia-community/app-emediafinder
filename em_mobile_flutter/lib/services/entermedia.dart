import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/emWorkspaces.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class EnterMedia {
  final String EM = 'https://entermediadb.org/entermediadb/app';
  final String MEDIADB = 'https://entermediadb.org/entermediadb/mediadb';
  var client = http.Client();
  var emUser;
  
  //Generic post method
  Future<Map> post(String url, Map jsonBody) async {
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

  //This gets the Entermedia user information called when logging in. - Mando Oct 14th 2020
  Future<EmUser> emLogin(String email, String password) async {
    final resMap = await post(
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


    final resMap = await post(
      MEDIADB + '/services/module/librarycollection/viewprojects.json',
      {},
    );
    print("Fetching workspaces...");
    if (resMap != null) {
//      resMap["results"].forEach(() => workSpaces.addName(resMap["results"]["name"]));
//      resMap["results"].forEach((int i) => workSpaces.addColId(resMap["results"][i]["id"]));


//      emWorkspacesFromJson(json.encode(resMap));

      return resMap["results"];
    } else {
      print("Request failed!");
      return null;
    }
  }
}
