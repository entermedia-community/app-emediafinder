import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'models/userData.dart';
import 'models/userWorkspaces.dart';
import 'models/workspaceAssets.dart';
import 'services/authentication.dart';
import 'views/LoginPage.dart';
import 'services/sharedpreferences.dart';
import 'services/entermedia.dart';
import 'views/WorkspaceSelect.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //a way to set the glue between the widgets and the Flutter engine before it has been done itself. This happens automatically a bit after the main method is called.
  //but as we want to initialize a class asynchronously then, before that is done we need to say:  "Hey, can we do the initialization now and after that we initialize the class"
  //binding is required before/inorder to call native code. - 10/2/2020
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  //initialize firebase.
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of the application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // todo; <--- this just highlights in the IDE what is typed after. Follow the trail to see a complete setup and usage.
    // todo;   This MultiProvider class is a sub class of Provider. Provider is how we're going to pass around information within the app.
    // todo; Provider basically can provide us with instances of any class we specify here. This has to 'wrap' the beginning of the app UI so that every child widget can access the same instance with the
    // todo; Consumer widget.
    // todo; When you want to display you must instantiate first with 'final name = Provider.of<SOMECLASS>(context) or/then wrap UI component with Consumer Widget.
    // todo; On ln 31 we return the MultiProvider()[] Widget because here we are going to define all classes we need access to globally and this 'wraps' ALL UI components which are in Material App()
    // todo; We create necessary Firebase classes and userData().

    return MultiProvider(
      providers: [
        // todo; Creating an instance of the global class that will store our users information (see userData.dart in lib/models) after logging in.
        ChangeNotifierProvider<userData>(create: (context) => userData()),
        ChangeNotifierProvider<userWorkspaces>(create: (context) => userWorkspaces()),
        ChangeNotifierProvider<workspaceAssets>(create: (context) => workspaceAssets()),
        Provider<EnterMedia>(create: (context) => EnterMedia()),
        Provider<sharedPref>(create: (context) => sharedPref()),
        /*Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),*/
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EntermediaDB Demo',
          //Entermedia Theme Colors
          theme: ThemeData(
            primaryColor: Color(0xff0c223a),
            accentColor: Color(0xff237C9C),
            backgroundColor: Colors.white38,
            //Text Colors
            textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(color: Color(0xff237C9C))),
            //Button Colors
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.white,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: AuthenticationWrapper()),
    );
  }
}

//Requires users to be logged into Firebase
class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  Uri _initialUri;
  Uri _latestUri;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  StreamSubscription _stream;
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: AuthenticationService.instance.authStateChanges,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User user = snapshot.data;
              if (user == null) {
                return LoginPage();
              }
              return FutureBuilder(
                future: reLoginUser(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return WorkspaceSelect();
                  }
                  return Scaffold(
                    backgroundColor: Theme.of(context).primaryColor,
                    body: Container(),
                  );
                },
              );
            } else {
              return Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: InkWell(
                  enableFeedback: false,
                  onTap: () => print(""),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            }
          },
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
    );
  }

  Future<void> initPlatformState() async {
    await initPlatformStateForUriUniLinks();
  }

  Future<void> initPlatformStateForUriUniLinks() async {
    _stream = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _initialUri = uri;
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _initialUri = null;
      });
    });
    getUriLinksStream().listen((Uri uri) async {
      if (uri != null && uri?.queryParameters['entermedia.key'].toString().length > 0) {
        print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
        await logOutUserForDeepLink().whenComplete(() {
          sharedPref().saveEMKey(uri.queryParameters['entermedia.key'].toString());
          reLoginUser().then((value) {
            if (value == true) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WorkspaceSelect()));
            }
          });
        });
      } else {
        setState(() {
          _initialUri = null;
        });
      }
    }, onError: (Object err) {
      print('got err: $err');
    });
    try {
      _initialUri = await getInitialUri();
      if (_initialUri != null && _initialUri.queryParameters['entermedia.key'].toString().length > 0) {
        print('initial uri: ${_initialUri?.path}' ' ${_initialUri?.queryParametersAll}');
        await logOutUserForDeepLink().whenComplete(() async {
          await sharedPref().saveEMKey(_initialUri.queryParameters['entermedia.key'].toString());
          reLoginUser().then((value) {
            if (value == true) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WorkspaceSelect()));
            }
          });
        });
      } else {
        setState(() {
          _initialUri = null;
        });
      }
    } on PlatformException {
      _initialUri = null;
      setState(() {});
    } on FormatException {
      _initialUri = null;
      setState(() {});
    }
    if (!mounted) return;
    setState(() {
      _latestUri = _initialUri;
    });
  }

  Future<bool> logOutUserForDeepLink() async {
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    myUser.removeUser();
    await EM.logOutUser();
    await sharedPref().resetValues();
    await AuthenticationService.instance.signOut();
    isLoading.value = false;
    return true;
  }

  Future<bool> reLoginUser() async {
    if (isLoading.value) {
      return false;
    }
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    String emkey = await sharedPref().getEMKey();
    print('Trying to relogin $emkey');
    print('Trying to relogin22 ${myUser.entermediakey}');
    if (emkey != null && myUser.entermediakey == null) {
      final userInfo = await EM.emAutoLoginWithKey(context, emkey);
      print(userInfo);
      if (userInfo.response.status != 'ok') {
        await EM.logOutUser();
        sharedPref().resetValues();
        AuthenticationService.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        Fluttertoast.showToast(
          msg: "Invalid login. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red.withOpacity(0.8),
          fontSize: 16.0,
        );
        return false;
      }
      print('RELOGGING IN WITH STORED KEY');
      print(emkey);
      myUser.addUser(userInfo.results.userid, userInfo.results.screenname, userInfo.results.entermediakey, userInfo.results.firstname,
          userInfo.results.lastname, userInfo.results.email, userInfo.results.firebasepassword);
      AuthenticationService.instance.signIn(email: userInfo.results.email, password: userInfo.results.firebasepassword, context: context);
      return true;
    }
    isLoading.value = false;
  }
}
