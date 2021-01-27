import 'dart:async';
import 'dart:io';

import 'package:em_mobile_flutter/Helper/customException.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnterMedia {
  final String EM = 'https://entermediadb.org/entermediadb/app';
  final String MEDIADB = 'https://entermediadb.org/entermediadb/mediadb';
  final String EMFinder = 'https://emediafinder.com/entermediadb/mediadb';

//  final String MEDIADB = 'http://cburkey.entermediadb.org:8080/entermediadb/mediadb';
  var client = http.Client();
  var emUser;
  var tempKey;

  //Generic post method to entermedias server
  Future<Map> postEntermedia(String url, Map jsonBody, BuildContext context, {String customError}) async {
    //Set headers
    Map<String, String> headers = <String, String>{};
    headers.addAll({"X-tokentype": "entermedia"});
    if (emUser != null) {
      print("Setting Headers.");
      // todo: Important must specify types! Dart defaults to dynamic and http.post requires definitive types. - mando
      headers.addAll({"X-token": emUser.results.entermediakey});
    }
    //make API post
    final response = await httpRequest(
      requestUrl: url,
      context: context,
      body: jsonBody,
      headers: headers,
      customError: customError,
    );
    print("Post started response is below!");

    // print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("Success user info is:" + response.body);
      final String responseString = response.body;
      //returns map!
      return json.decode(responseString);
    } else {
      return null;
    }
  }

//Generic post to client specific 'EMFinder' server.
  Future<Map> postFinder(String url, Map jsonBody, BuildContext context, {String customError}) async {
    //Set headers
    var headers = <String, String>{};
    if (emUser != null) {
      print("Setting Headers.");
      //Important must specify types! Dart defaults to dynamic and http.post requires definitive types.
      headers = <String, String>{"X-token": tempKey, "X-tokentype": "entermedia"};
    }

    //make API post
    final response = await httpRequest(requestUrl: url, context: context, body: jsonBody, headers: headers, customError: customError);
    print("Post started response is below!");
    print("Response code: ");
    // print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("Success workspace data is:" + response.body);
      final String responseString = response.body;

      //returns map!
      return json.decode(responseString);
    } else {
      return null;
    }
  }

  //This gets the Entermedia user information called when logging in. - Mando Oct 14th 2020
  Future<EmUser> emLogin(BuildContext context, String email, String password) async {
    final resMap = await postEntermedia(MEDIADB + '/services/authentication/firebaselogin.json', {"email": email, "password": password}, context,
        customError: "Invalid credentials. Please try again!");

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
  Future<EmUser> emLoginWithKey(BuildContext context, String entermediakey) async {
    final resMap = await postEntermedia(EMFinder + '/services/authentication/firebaselogin.json', {"entermediakey": entermediakey}, context,
        customError: "Invalid credentials. Please try again!");

    print("Logging in with key...");

    if (resMap != null) {
      //save local emUser from response object
      emUser = emUserFromJson(json.encode(resMap));
      return emUser;
    } else {
      return null;
    }
  }

  //Entermedia Login with sharedPreferences key used in reLoginWithKey
  Future<EmUser> emAutoLoginWithKey(BuildContext context, emkey) async {
    final resMap = await postEntermedia(EMFinder + '/services/authentication/firebaselogin.json', {"entermediakey": emkey}, context,
        customError: "Invalid credentials. Please try again!");

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
  Future<bool> emEmailKey(BuildContext context, String email) async {
    final resMap = await postEntermedia(EMFinder + '/services/authentication/sendmagiclink.json', {"to": email}, context);

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
  Future<List> getEMWorkspaces(
    BuildContext context,
  ) async {
    final resMap = await postEntermedia(
      EMFinder + '/services/module/librarycollection/viewprojects.json',
      {},
      context,
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

  Future<Map> getWorkspaceAssets(BuildContext context, String url) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/module/modulesearch/sample.json',
      null,
      context,
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

  Future<Map> searchWorkspaceAssets(BuildContext context, String url, String searchtext) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/module/modulesearch/sample.json',
      {
        "query": {
          "terms": [
            {"field": "description", "operation": "freeform", "value": searchtext}
          ]
        }
      },
      context,
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

  Future<Map> createTeamAccount(BuildContext context, String url, String entermediakey, String colId) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/authentication/createteamaccount.json',
      {"entermediacloudkey": entermediakey, "collectionid": colId},
      context,
    );
    if (resMap != null) {
      print(resMap);

      print('Your temporary server key is: ' + resMap["results"]["entermediakey"]);

      tempKey = resMap["results"]["entermediakey"];

      return resMap;
    } else {
      print("Request failed!");
      return null;
    }
  }

  Future<http.Response> httpRequest({
    @required String requestUrl,
    @required context,
    @required Map<dynamic, dynamic> body,
    @required Map<String, String> headers,
    String customError,
  }) async {
    String url = requestUrl;
    print(url);
    http.Response response;
    try {
      final responseJson = await client.post(
        url,
        body: body,
        headers: headers,
      );
      response = await handleException(responseJson);
    } on BadRequestException catch (error) {
      showErrorFlushbar(context, "Bad request! Please try again later.");
    } on UnauthorisedException catch (error) {
      showErrorFlushbar(context, "Unauthorized user. Please try again.");
    } on TimeoutException catch (error) {
      showErrorFlushbar(context, "Request timed out. Please try again!");
    } on SocketException catch (error) {
      showErrorFlushbar(context, "Unable to connect to server. Please try again!");
    } on Exception catch (error) {
      showErrorFlushbar(
          context, customError != null ? customError : "Error occurred while communication with server. Please try again after some time.");
    } catch (error) {
      print("errorPrince $error");
      showErrorFlushbar(context, "Error occurred while communication with server. Please try again after some time.");
    }
    return response;
  }

  dynamic handleException(http.Response response) {
    print("Response code: " + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        final http.Response responseJson = response;
        return responseJson;
        break;
      case 201:
        final http.Response responseJson = response;
        return responseJson;
        break;
      case 302:
        break;
      case 400:
        throw BadRequestException(response.body.toString());
        break;

      case 403:
        throw UnauthorisedException(response.body.toString());
        break;

      case 408:
        throw TimeoutException(response.body.toString());
        break;

      case 500:
        throw Exception(response.body.toString());
        break;

      default:
        throw FetchDataException('Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
        break;
    }
  }

  void showErrorFlushbar(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.orange.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
