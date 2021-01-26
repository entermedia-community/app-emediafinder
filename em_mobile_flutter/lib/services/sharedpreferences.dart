import 'package:shared_preferences/shared_preferences.dart';

class sharedPref {
  saveEMKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('entermediakey', key);
  }

  getEMKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('entermediakey');
    return stringValue;
  }

  saveWorkspaceKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('workspacekey', key);
  }

  getWorkspaceKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('workspacekey');
    return stringValue;
  }

  saveRecentWorkspace(int colId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('recent', colId);
  }

  getRecentWorkspace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return index of workspace
    int intValue = prefs.getInt('recent');
    return intValue;
  }

  //todo; EX:Handle null int intValue= await prefs.getInt('intValue') ?? 0;
  //todo; EX: Check value SharedPreferences prefs = await SharedPreferences.getInstance();
  //todo; bool CheckValue = prefs.containsKey('value');
  //todo; containsKey will return true if persistent storage contains the given key and false if not.

  resetValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove entermediakey
    prefs.remove("entermediakey");
    //Remove workspacekey
    prefs.remove("workspacekey");
    //Remove most recent workspace ID
    prefs.remove("recent");
  }
}
