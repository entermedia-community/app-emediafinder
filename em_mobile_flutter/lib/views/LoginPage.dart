import 'dart:async';
import 'dart:ui';

import 'package:em_mobile_flutter/models/emLogoIcon.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/views/WorkspaceSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:uni_links/uni_links.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController entermediakeyController = TextEditingController();

  @override
  initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    entermediakeyController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool hasDeeplinkPassed = await sharedPref().getDeepLinkHandler();
      if (hasDeeplinkPassed == true) {
        try {
          final _initialUri = await getInitialUri();
          if (_initialUri != null) {
            await logOutUserForDeepLink().whenComplete(() {
              sharedPref().saveEMKey(_initialUri?.queryParameters['entermedia.key'].toString());
              onSignInWithKey(_initialUri?.queryParameters['entermedia.key'].toString(), context);
              sharedPref().setDeepLinkHandler(false);
            });
          }
        } on PlatformException {
          print("Error");
        }
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final myUser = Provider.of<userData>(context);
    final EM = Provider.of<EnterMedia>(context);

    return WillPopScope(
      onWillPop: () {
        print("Disabled back button");
        return null;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: emLogoIcon(),
          centerTitle: true,
          leading: Text(""),
        ),
//      backgroundColor: Colors.white38,
        body: Stack(
          children: [
            InkWell(
              onTap: () => FocusScope.of(context).unfocus(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Text("Login:", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0, color: Colors.indigo)),
                  Container(
                    width: 250,
                    child: Theme(
                      data: ThemeData(
                        brightness: Brightness.dark,
                        accentColor: Theme.of(context).accentColor,
                      ),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Color(0xff237C9C),
                        controller: emailController, // if needed change back to entermediakeyController
                        decoration: InputDecoration(labelText: "E-mail", focusColor: Color(0xff237C9C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      RegExp regEx = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (emailController.text.trim().length == 0) {
                        Fluttertoast.showToast(
                          msg: "E-mail field can't be empty.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          fontSize: 16.0,
                        );
                      } else if (!regEx.hasMatch(emailController.text.trim())) {
                        Fluttertoast.showToast(
                          msg: "Invalid Email. Please try again.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          fontSize: 16.0,
                        );
                      } else if (emailController.text.trim().length > 0) {
                        String email = emailController.text.trim();
                        //Send email entermedia website and send key in email if email exists.
                        final bool emailResp = await EM.emEmailKey(context, email);

                        if (emailResp == true) {
                          Fluttertoast.showToast(
                            msg: "E-mail Sent! Please check your e-mail.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Color(0xff61af56),
                            fontSize: 16.0,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Error. E-mail not sent!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Colors.deepOrangeAccent,
                            fontSize: 16.0,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
                    child: Text("Send Key"),
                  ),
//              RaisedButton(
//                onPressed: () async {
//                  if (entermediakeyController.text.trim().length > 0) {
//                    onSignInWithKey(entermediakeyController.text.trim(), context);
//                  }
//                },
//                child: Text("Sign In With Key"),
//              ),
                  TextButton(
                      child: Text(
                        'Paste key here',
                        style: new TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff237C9C),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 16,
                                  child: Container(
                                    height: 200.0,
                                    width: 600.0,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
                                      child: Column(
                                        children: [
                                          TextField(
                                            autofocus: true,
                                            controller: entermediakeyController,
                                            decoration: InputDecoration(
                                              labelText: "eMedia Key",
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          RaisedButton(
                                            onPressed: () async {
                                              String emkey = entermediakeyController.text.trim();
                                              //Send email entermedia website and send key in email if email exists.
                                              if (entermediakeyController.text.trim().length > 0) {
                                                Navigator.of(dialogContext).pop();
                                                FocusScope.of(context).unfocus();
                                                onSignInWithKey(emkey, context);
                                              }
//                                          EM.emEmailKey(context, email);
//                                          Navigator.of(context).pop();
                                            },
                                            child: Text("Sign-in"),
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
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (BuildContext context, bool value, _) {
                return value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logOutUserForDeepLink() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    await EM.logOutUser();
    sharedPref().resetValues();
    AuthenticationService.instance.signOut();
  }

  void onSignInWithKey(String entermediakey, BuildContext context) async {
    isLoading.value = true;
    print("called");
    final myUser = Provider.of<userData>(context, listen: false);
    final EM = Provider.of<EnterMedia>(context, listen: false);
    //store the entermediakey from this login screent to local storage.
    await sharedPref().saveEMKey(entermediakey);
    print(sharedPref().getEMKey());
    //Get User info from entermedia website
    final EmUser userInfo = await EM.emLoginWithKey(context, entermediakey);
    if (userInfo.response.status == 'ok')
    // Here we call and update global myUser class with Entermediadb.org user information after logging in.
    {
      await myUser.addUser(userInfo.results.userid, userInfo.results.screenname, userInfo.results.entermediakey, userInfo.results.firstname,
          userInfo.results.lastname, userInfo.results.email, userInfo.results.firebasepassword);
      //Firebase Authentication sign in.
      await AuthenticationService.instance.signIn(email: myUser.email, password: myUser.firebasepassword, context: context);
    } else {
      Fluttertoast.showToast(
        msg: "Invalid Key. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red.withOpacity(0.8),
        fontSize: 16.0,
      );
    }
    isLoading.value = false;
  }
}
