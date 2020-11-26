import 'dart:ui';

import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController entermediakeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // todo; Calling the global class of userData() and naming it myUser for all widgets nested in it. this will pretty much always happen at under 'Widget build(BuildContext context) {...' -> ln 58, of this file.
    final myUser = Provider.of<userData>(context);
    final EM = Provider.of<EnterMedia>(context);
    final myWorkspaces = Provider.of<userWorkspaces>(context);

    return Scaffold(
      appBar: AppBar(
        title: emLogoIcon(),
        centerTitle: true,
      ),
      body: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 130.0),
          //margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 130.0),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text("Login:", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0, color: Colors.indigo)),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "E- mail",
            ),
          ),
          RaisedButton(
            onPressed: () async {
              String email = emailController.text.trim();

              //Get User info from entermedia website
              EM.emEmailKey(email);



            },
            child: Text("E-mail Key"),
          ),
          SizedBox(
            height: 66,
            child: Center(
                child: Text(
              "Or",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            )),
          ),
          TextField(
            controller: entermediakeyController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Entermediakey",
            ),
          ),
          RaisedButton(
            onPressed: () async {
              String entermediakey = entermediakeyController.text.trim();

              //Get User info from entermedia website
              final EmUser userInfo = await EM.emLoginWithKey(entermediakey);
              print(userInfo.results.screenname);
              // Here we call and update global myUser class with Entermedia user information after logging in.
              myUser.addUser(
                  userInfo.results.userid,
                  userInfo.results.screenname,
                  userInfo.results.entermediakey,
                  userInfo.results.firstname,
                  userInfo.results.lastname,
                  userInfo.results.email,
                  userInfo.results.firebasepassword);

              //Perform API call
              final userWorkspaces = await EM.getEMWorkspaces();
              //Initialize blank Lists
              myWorkspaces.names = [];
              myWorkspaces.colId = [];
              myWorkspaces.instUrl = [];
              //Loop thru API 'results'
              for (final project in userWorkspaces) {
                myWorkspaces.names.add(project["name"]);
                myWorkspaces.colId.add(project["id"]);

                //Loop through response, add urls and check if blank.
                if (project["servers"].isEmpty == true) {
                  myWorkspaces.instUrl.add("no instance url");
                } else {
                  myWorkspaces.instUrl
                      .add(project["servers"][0]["instanceurl"]);
                  print(project["servers"][0]["instanceurl"]);
                }
              }
              //Firebase Authentication
              context.read<AuthenticationService>().signIn(
                  email: myUser.email,
                  password: myUser.firebasepassword);
            },
            child: Text("Sign In With Key"),
          )
        ],
      )),
    );
  }
}
