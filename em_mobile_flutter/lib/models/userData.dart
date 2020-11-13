import 'package:flutter/widgets.dart';
//use this format to create custom classes that need to change.

class userData with ChangeNotifier{
  String userid;
  String screenname;
  String entermediakey;
  String firstname;
  String lastname;
  String email;
  String firebasepassword;
//This function is what we use to create and update the 'myUser' userData() class in the login page.
  void addUser(String id, String sname, String key, String fname,String lname,String mail,String fbpw){
    userid = id;
    screenname = sname;
    entermediakey = key;
    firstname = fname;
    lastname = lname;
    email = mail;
    firebasepassword = fbpw;
    notifyListeners();

  }

}