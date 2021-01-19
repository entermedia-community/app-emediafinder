import 'dart:ui';

import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';

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
    final myUser = Provider.of<userData>(context);
    final EM = Provider.of<EnterMedia>(context);

    return Scaffold(
      appBar: AppBar(
        title: emLogoIcon(),
        centerTitle: true,
      ),
//      backgroundColor: Colors.white38,
      body: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 130.0),
          //margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 130.0),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text("Login:", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0, color: Colors.indigo)),
          Container(
            width: 250,
            child: TextField(
              autofocus: true,
              cursorColor: Color(0xff61af56),
              controller: entermediakeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "EnterMedia Key",
                  focusColor: Color(0xff61af56)
              ),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              String entermediakey = entermediakeyController.text.trim();
              //store the entermediakey from this login screent to local storage.
              await sharedPref().saveEMKey(entermediakey);

              print(sharedPref().getEMKey());

              //Get User info from entermedia website
              final EmUser userInfo = await EM.emLoginWithKey(entermediakey);
              print(userInfo.results.screenname);
              // Here we call and update global myUser class with Entermediadb.org user information after logging in.
              myUser.addUser(
                  userInfo.results.userid,
                  userInfo.results.screenname,
                  userInfo.results.entermediakey,
                  userInfo.results.firstname,
                  userInfo.results.lastname,
                  userInfo.results.email,
                  userInfo.results.firebasepassword);

              //Firebase Authentication sign in.
              context.read<AuthenticationService>().signIn(
                  email: myUser.email, password: myUser.firebasepassword);
            },
            child: Text("Sign In With Key"),
          ),
          FlatButton(
              child: Text('E-Mail Me a Key?',
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.w300,color: Color(0xff61af56))),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          elevation: 16,
                          child: Container(
                            height: 200.0,
                            width: 600.0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10,50,10,0),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: "E- mail",
                                    ),
                                  ),
                                   RaisedButton(
                                    onPressed: () async {
                                      String email = emailController.text.trim();
                                      //Send email entermedia website and send key in email if email exists.
                                      EM.emEmailKey(email);
                                      Navigator.of(context).pop();

                                    },
                                    child: Text("E-mail Key"),
                                  ),
                                ],
                              ),
                            ),

                          ));
                    });
              }),

          SizedBox(
            height: 66,
            child: Center(
                child: Text(
              " ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            )),
          ),
        ],
      )),
    );
  }
}
