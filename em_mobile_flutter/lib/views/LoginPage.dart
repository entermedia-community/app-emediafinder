import 'dart:async';
import 'dart:ui';

import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:uni_links/uni_links.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController entermediakeyController = TextEditingController();

  Uri _initialUri;
  Uri _newUri;

  StreamSubscription _stream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

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
              decoration: InputDecoration(labelText: "EnterMedia Key", focusColor: Color(0xff61af56)),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              onSignInWithKey(entermediakeyController.text.trim());
            },
            child: Text("Sign In With Key"),
          ),
          FlatButton(
              child: Text('E-Mail Me a Key?', style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300, color: Color(0xff61af56))),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          elevation: 16,
                          child: Container(
                            height: 200.0,
                            width: 600.0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
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
                                      //Get User info from entermedia website
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

  void onSignInWithKey(String entermediakey) async {
    print("called");
    final myUser = Provider.of<userData>(context, listen: false);
    final EM = Provider.of<EnterMedia>(context, listen: false);
    //store the entermediakey from this login screent to local storage.
    await sharedPref().saveEMKey(entermediakey);
    print(sharedPref().getEMKey());
    //Get User info from entermedia website
    final EmUser userInfo = await EM.emLoginWithKey(entermediakey);
    print(userInfo.results.screenname);
    // Here we call and update global myUser class with Entermediadb.org user information after logging in.
    myUser.addUser(userInfo.results.userid, userInfo.results.screenname, userInfo.results.entermediakey, userInfo.results.firstname,
        userInfo.results.lastname, userInfo.results.email, userInfo.results.firebasepassword);
    //Firebase Authentication sign in.
    context.read<AuthenticationService>().signIn(email: myUser.email, password: myUser.firebasepassword);
  }

  Future<void> initPlatformState() async {
    await initPlatformStateForUriUniLinks();
  }

  Future<void> initPlatformStateForUriUniLinks() async {
    _stream = getUriLinksStream().listen((Uri uri) {
      if (_initialUri != null) {
        onSignInWithKey(_initialUri?.queryParameters['entermedia.key']);
      }
      _newUri = uri;
    }, onError: (Object err) {
      _newUri = null;
    });

    getUriLinksStream().listen((Uri uri) { if (uri != null) {
      onSignInWithKey(uri?.queryParameters['entermedia.key']);
    }
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (Object err) {
      print('got err: $err');
    });

    try {
      _initialUri = await getInitialUri();
      if (_initialUri != null) {
        onSignInWithKey(_initialUri?.queryParameters['entermedia.key']);
      }
    } on PlatformException {
      _initialUri = null;
    }

    _newUri = _initialUri;
  }
}
