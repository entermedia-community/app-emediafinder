import 'package:flutter/widgets.dart';
//use this format to create custom classes that need to change.

class userWorkspaces with ChangeNotifier {
  List<String> names = [];
  List<String> colId = [];
  List<String> instUrl = [];

  userWorkspaces({this.names, this.colId, this.instUrl});

  void notify() {
    notifyListeners();
  }
}
