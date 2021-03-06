import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:em_mobile_flutter/Helper/customException.dart';
import 'package:em_mobile_flutter/models/createTeamModel.dart';
import 'package:em_mobile_flutter/models/createUserResponseModel.dart';
import 'package:em_mobile_flutter/models/eventAssetModel.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/createWorkspaceModel.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/getWorkspacesModel.dart';
import 'package:em_mobile_flutter/models/moduleAssetModel.dart';
import 'package:em_mobile_flutter/models/moduleListModel.dart';
import 'package:em_mobile_flutter/models/projectAssetModel.dart';
import 'package:em_mobile_flutter/models/updateDataModulesModel.dart';
import 'package:em_mobile_flutter/models/uploadMediaModel.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'dart:convert';

class EnterMedia {
  final String EM = 'https://entermediadb.org/entermediadb/app';
  final String MEDIADB = 'https://entermediadb.org/entermediadb/mediadb';
  final String EMFinder = 'https://emediafinder.com/entermediadb/mediadb';
  final String EMImage = "/finder/mediadb/services/module/asset/downloads/originals/";

//  final String MEDIADB = 'http://cburkey.entermediadb.org:8080/entermediadb/mediadb';
  var client = http.Client();
  var emUser;
  var tempKey;

  //Generic post method to entermedias server
  Future<Map> postEntermedia(String url, dynamic jsonBody, BuildContext context, {String customError}) async {
    //Set headers
    Map<String, String> headers = <String, String>{};
    headers.addAll({"X-tokentype": "entermedia"});
    headers.addAll({"Content-type": "application/json"});
    if (this.emUser != null) {
      String tokenKey = handleTokenKey(this.emUser.results.entermediakey);
      headers.addAll({"X-token": tokenKey});
    }
    //make API post
    final response = await httpRequest(
      requestUrl: url,
      context: context,
      body: json.encode(jsonBody),
      headers: headers,
      customError: customError,
    );
    if (response != null && response.statusCode == 200) {
      log("Success user info is:" + response.body);
      final String responseString = response.body;
      return json.decode(responseString);
    } else {
      return null;
    }
  }

//Generic post to client specific 'EMFinder' server.
  Future<Map> postFinder(String url, dynamic jsonBody, BuildContext context, {String customError, bool isPutMethod}) async {
    var headers = <String, String>{};
    headers.addAll({"X-tokentype": "entermedia"});
    if (this.emUser != null) {
      String tokenKey = handleTokenKey(tempKey);
      print("Setting Headers.");
      //Important must specify types! Dart defaults to dynamic and http.post requires definitive types.
      headers.addAll({"X-token": tokenKey});
    }
    //make API post
    final response = await httpRequest(
      requestUrl: url,
      context: context,
      body: json.encode(jsonBody),
      headers: headers,
      customError: customError,
      isPutMethod: isPutMethod,
    );
    if (response != null && response.statusCode == 200) {
      log("Success workspace data is:" + response.body);
      final String responseString = response.body;
      return json.decode(responseString);
    } else {
      return null;
    }
  }

  //TODO: Add prefix before the token
  String handleTokenKey(String token) {
    final String newToken = /*"em" + */ "$token";
    return newToken;
  }

  //This gets the Entermedia user information called when logging in. - Mando Oct 14th 2020
  Future<EmUser> emLogin(BuildContext context, String email, String password) async {
    final resMap = await postEntermedia(MEDIADB + '/services/authentication/firebaselogin.json', {"email": email, "password": password}, context,
        customError: "Invalid credentials. Please try again!");
    print("Logging in");
    if (resMap != null) {
      //save local emUser from response object
      this.emUser = emUserFromJson(json.encode(resMap));
      return this.emUser;
    } else {
      return null;
    }
  }

//Entermedia Login with key pasted in
  Future<EmUser> emLoginWithKey(BuildContext context, String entermediakey) async {
    tempKey = entermediakey;
    this.emUser = null;
    final resMap = await postEntermedia(EMFinder + '/services/authentication/firebaselogin.json', {"entermedia.key": entermediakey}, context,
        customError: "Invalid credentials. Please try again!");
    print("Logging in with key...");
    print(entermediakey);
    if (resMap != null) {
      //save local emUser from response object
      this.emUser = emUserFromJson(json.encode(resMap));
      return this.emUser;
    } else {
      return null;
    }
  }

  //Entermedia Login with sharedPreferences key used in reLoginWithKey
  Future<EmUser> emAutoLoginWithKey(BuildContext context, emkey) async {
    tempKey = emkey;
    this.emUser = null;
    final resMap = await postEntermedia(EMFinder + '/services/authentication/firebaselogin.json', {"entermedia.key": emkey}, context,
        customError: "Invalid credentials. Please try again!");
    print("Logging in with key...");
    if (resMap != null) {
      //save local emUser from response object
      this.emUser = emUserFromJson(json.encode(resMap));
      return this.emUser;
    } else {
      return null;
    }
  }

  //Entermedia Login with key pasted in
  Future<bool> emEmailKey(BuildContext context, String email) async {
    this.emUser = null;
    tempKey = null;
    // final resMap = await postEntermedia(EMFinder + '/services/authentication/sendmagiclink.json', {"to": email}, context);
    final resMap = await postEntermedia(EMFinder + '/services/authentication/emailonlysendmagiclinkfinish.json', {"to": email}, context);
    print("Sending email...");
    if (resMap != null) {
      var loggedin = true;
      return loggedin;
    } else {
      return null;
    }
  }

//This function retrieves list of workspaces the user is apart of. - Mando Oct 23rd

  Future<GetWorkspaceModel> getEMWorkspaces(
    BuildContext context,
  ) async {
    final resMap = await postEntermedia(
      EMFinder + '/services/module/librarycollection/viewprojects.json',
      {},
      context,
    );
    print("Fetching workspaces...");
    if (resMap != null) {
      String response = json.encode(resMap);
      return GetWorkspaceModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<CreateTeamModel> startMediaFinder(BuildContext context, String url, String entermediakey, String colId) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/authentication/startmediafinder.json',
      {"entermediacloudkey": entermediakey, "collectionid": colId},
      context,
    );
    if (resMap != null) {
      print('Your temporary server key is: ' + resMap["results"]["entermediakey"]);
      this.tempKey = resMap["results"]["entermediakey"];
      String response = json.encode(resMap);
      return CreateTeamModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  // this creates a new workspace for people who have an account already
  Future<CreateWorkspaceModel> createNewWorkspaces(String emkey, BuildContext context) async {
    final resMap = await postEntermedia(
      'https://emediafinder.com/entermediadb/app/services/createworkspace.json?',
      {"entermediakey": "$emkey"},
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return CreateWorkspaceModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<Map> renameWorkspaces(String newname, String colId, BuildContext context) async {
    final resMap = await postEntermedia(
      'https://emediafinder.com/entermediadb/app/services/relabelworkspace.json?newname=$newname&collectionid=$colId',
      null,
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return (json.decode(response));
    } else {
      return null;
    }
  }

  Future<Map> deleteWorkspaces(String colId, BuildContext context) async {
    final resMap = await postEntermedia('https://emediafinder.com/entermediadb/app/services/removeworkspace.json?collectionid=$colId', null, context);
    if (resMap != null) {
      String response = json.encode(resMap);
      return (json.decode(response));
    } else {
      return null;
    }
  }

  Future<WorkspaceAssetsModel> getWorkspaceAssets(BuildContext context, String url) async {
    final resMap = await postFinder(url + '/finder/mediadb/services/module/modulesearch/sample.json', null, context);
    if (resMap != null) {
      String response = json.encode(resMap);
      return WorkspaceAssetsModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<WorkspaceAssetsModel> searchWorkspaceAssets(BuildContext context, String url, String searchtext, String page) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/module/modulesearch/sample.json',
      {
        "query": {
          "terms": [
            {"field": "description", "operation": "freeform", "value": searchtext}
          ]
        },
        "hitsperpage": "20",
        "page": page,
      },
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return WorkspaceAssetsModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<MediaAssetModel> getMediaAssets(BuildContext context, String url) async {
    final resMap = await postFinder(url + '/finder/mediadb/services/module/asset/search', null, context);
    if (resMap != null) {
      String response = json.encode(resMap);
      return MediaAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<MediaAssetModel> searchMediaAssets(BuildContext context, String url, String searchtext, String page) async {
    print(searchtext);
    print(page);
    final resMap = await postFinder(
      url + '/finder/mediadb/services/module/asset/search',
      {
        "query": {
          "terms": [
            {"field": "description", "operation": "freeform", "value": searchtext}
          ]
        },
        "hitsperpage": "20",
        "page": page,
      },
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return MediaAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<ProjectAssetModel> getProjectsAssets(BuildContext context, String url) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/search/entityproject',
      null,
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return ProjectAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<ProjectAssetModel> searchProjectsAssets(BuildContext context, String url, String searchtext, String page) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/search/entityproject',
      {
        "query": {
          "terms": [
            {"field": "description", "operation": "freeform", "value": searchtext}
          ]
        },
        "hitsperpage": "20",
        "page": page,
      },
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return ProjectAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<EventAssetModel> getEventsAssets(BuildContext context, String url) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/search/entityevent',
      null,
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return EventAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<EventAssetModel> searchEventsAssets(BuildContext context, String url, String searchtext, String page) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/search/entityevent',
      {
        "query": {
          "terms": [
            {"field": "description", "operation": "freeform", "value": searchtext}
          ]
        },
        "hitsperpage": "20",
        "page": page,
      },
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return EventAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<ModuleAssetModel> getModulesData(BuildContext context, String url, String entity) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/search/$entity',
      null,
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return ModuleAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<bool> createModulesData(BuildContext context, String url, String entity, String name) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/create/$entity',
      {"name": "$name"},
      context,
    );
    if (resMap != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<UpdateDataModulesModel> updateModulesData(BuildContext context, String url, String entity, String moduleId, Map<String, String> body) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/data/$entity/$moduleId',
      body,
      context,
      isPutMethod: true,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return UpdateDataModulesModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<ModuleAssetModel> searchFromModulesData(BuildContext context, String url, String entity, String searchText, String currentPage) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/lists/search/$entity',
      {
        "page": "$currentPage",
        "hitsperpage": "20",
        "query": {
          "terms": [
            {"field": "name", "operation": "matches", "value": "$searchText*"}
          ]
        }
      },
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return ModuleAssetModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<CreateUserResponseModel> createNewUser(BuildContext context, String url, String username, String password, String email) async {
    final resMap = await postFinder(
      url + '/finder/mediadb/services/settings/users/create',
      {"name": "$username", "password": "$password", "email": "$email"},
      context,
    );
    if (resMap != null) {
      String response = json.encode(resMap);
      return CreateUserResponseModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<UploadMediaModel> uploadAsset(BuildContext context, String baseUrl, List<String> filePath, Map<String, List<String>> jsonEncodedData) async {
    Uri url = Uri.parse(baseUrl + "/finder/mediadb/services/module/asset/create");
    print(url);
    var request = new http.MultipartRequest("POST", url);
    Map<String, String> headers = {
      "X-tokentype": "entermedia",
      "Accept": "text/plain",
      "Content-Type": "image/jpeg",
    };
    if (this.emUser != null) {
      headers.addAll({"X-token": "em" + this.emUser.results.entermediakey.toString()});
    }
    request.headers.addAll(headers);
    for (int i = 0; i < filePath.length; i++) {
      request.files.add(
        new http.MultipartFile.fromBytes(
          'file',
          await File.fromUri(Uri.parse("${filePath[i]}")).readAsBytes(),
          contentType: parser.MediaType('application', 'x-tar'),
          filename: filePath[i].split('/').last,
        ),
      );
    }

    ///TODO GET THE PARAMETER _ JSON ENCODED STRING FROM FILE UPLOAD PAGE
    request.fields.addAll({'jsonrequest': json.encode(jsonEncodedData)});
    http.Response response = await http.Response.fromStream(await request.send());
    print("LogLog: ${response.body}");
    return UploadMediaModel.fromJson(json.decode(response.body));
  }

  Future<ModuleListModel> getAllModulesList(BuildContext context, String url) async {
    final resMap = await postFinder(url + '/finder/mediadb/services/settings/modules/list', null, context);
    if (resMap != null) {
      String response = json.encode(resMap);
      return ModuleListModel.fromJson(json.decode(response));
    } else {
      return null;
    }
  }

  Future<void> logOutUser() async {
    tempKey = null;
    this.emUser = null;
  }

  Future<http.Response> httpRequest({
    @required String requestUrl,
    @required context,
    @required dynamic body,
    @required Map<String, String> headers,
    bool isPutMethod,
    String customError,
  }) async {
    String url = requestUrl;
    print(url);
    http.Response response;
    try {
      var responseJson;
      print("isPutMethod: $isPutMethod");
      if (isPutMethod != null && isPutMethod == true) {
        print("isPutMethod: $isPutMethod");
        responseJson = await client.put(
          Uri.parse(url),
          body: body,
          headers: headers,
        );
      } else {
        responseJson = await client.post(
          Uri.parse(url),
          body: body,
          headers: headers,
        );
      }
      print(responseJson.statusCode);
      response = await handleException(responseJson);
    } on BadRequestException catch (error) {
      showErrorFlushbar(context, "Bad request! Please try again later.");
    } on UnauthorisedException catch (error) {
      showErrorFlushbar(context, "Unauthorized user. Please try again.");
    } on TimeoutException catch (error) {
      showErrorFlushbar(context, "Request timed out. Please try again!");
    } on SocketException catch (error) {
      showErrorFlushbar(context, "Unable to connect to server. Please try again!");
    } on HttpException catch (error) {
      showErrorFlushbar(
          context, customError != null ? customError : "Error occurred while communication with server. Please try again after some time.");
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
        throw HttpException(response.body.toString());
        break;
      default:
        // throw FetchDataException('Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
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
