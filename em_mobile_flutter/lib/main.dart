import 'dart:async';

import 'package:em_mobile_flutter/models/getWorkspacesModel.dart';
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
import 'views/LoginPage.dart';
import 'services/sharedpreferences.dart';
import 'services/authentication.dart';
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
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
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
  Uri _newUri;

  StreamSubscription _stream;
  @override
  void initState() {
    sharedPref().setDeepLinkHandler(false);

    super.initState();
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    initPlatformState();
    if (firebaseUser == null) {
      return LoginPage();
    } else {
      //Attempt relogin with current stored shared preferences key.
      reLoginUser();

      return WorkspaceSelect();
    }
  }

  Future<void> initPlatformState() async {
    await initPlatformStateForUriUniLinks();
  }

  Future<void> initPlatformStateForUriUniLinks() async {
    try {
      _stream = getUriLinksStream().listen((Uri uri) {
        if (_initialUri != null) {
          sharedPref().setDeepLinkHandler(true);
          sharedPref().saveEMKey(_initialUri?.queryParameters['entermedia.key'].toString());
          reLoginUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkspaceSelect()));
          });
        }
        _newUri = uri;
      }, onError: (Object err) {
        _newUri = null;
      });

      getUriLinksStream().listen((Uri uri) {
        if (uri != null) {
          sharedPref().setDeepLinkHandler(true);

          sharedPref().saveEMKey(uri?.queryParameters['entermedia.key'].toString());
          reLoginUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkspaceSelect()));
          });
        }
        print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
      }, onError: (Object err) {
        print('got err: $err');
      });

      try {
        _initialUri = await getInitialUri();
        if (_initialUri != null) {
          sharedPref().setDeepLinkHandler(true);

          sharedPref().saveEMKey(_initialUri?.queryParameters['entermedia.key'].toString());
          reLoginUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkspaceSelect()));
          });
        }
      } on PlatformException {
        _initialUri = null;
      }

      _newUri = _initialUri;
    } catch (e) {
      print("Error");
    }
  }

  Future<void> reLoginUser() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    String emkey = await sharedPref().getEMKey();

    print('Trying to relogin');

    if (emkey != null && myUser.entermediakey == null) {
      final userInfo = await EM.emAutoLoginWithKey(context, emkey);
      if (userInfo.response.status != 'ok') {
        sharedPref().resetValues();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        Fluttertoast.showToast(
          msg: "Invalid login. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red.withOpacity(0.8),
          fontSize: 16.0,
        );
        return;
      }
      print('RELOGGING IN WITH STORED KEY');
      print(emkey);

      myUser.addUser(userInfo.results.userid, userInfo.results.screenname, userInfo.results.entermediakey, userInfo.results.firstname,
          userInfo.results.lastname, userInfo.results.email, userInfo.results.firebasepassword);
    }
    print("called again");
  }
}
