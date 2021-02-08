import 'dart:async';

import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/views/WorkspaceSelect.dart';
import 'package:flutter/services.dart';
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
        Provider<AuthenticationService>(create: (_) => AuthenticationService(FirebaseAuth.instance)),
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
            accentColor: Color(0xff61af56),
            backgroundColor: Colors.white38,
            //Text Colors
            textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(color: Color(0xff92e184))),
            //Button Colors
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xff61af56),
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

  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    initPlatformStateForUriUniLinks();
    if (firebaseUser == null) {
      return LoginPage();
    } else {
      //Attempt relogin with current stored shared preferences key.
      reLoginUser(context);
      return WorkspaceSelect();
    }
  }

  Future<void> initPlatformStateForUriUniLinks() async {
    _stream = getUriLinksStream().listen((Uri uri) {
      if (_initialUri != null) {
        onSignInWithKey(_initialUri?.queryParameters['entermedia.key'], context);
      }
      _newUri = uri;
    }, onError: (Object err) {
      _newUri = null;
    });

    getUriLinksStream().listen((Uri uri) {
      if (uri != null) {
        onSignInWithKey(uri?.queryParameters['entermedia.key'], context);
      }
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (Object err) {
      print('got err: $err');
    });

    try {
      _initialUri = await getInitialUri();
      if (_initialUri != null) {
        onSignInWithKey(_initialUri?.queryParameters['entermedia.key'], context);
      }
    } on PlatformException {
      _initialUri = null;
    }

    _newUri = _initialUri;
    _stream.cancel();
  }
}

reLoginUser(BuildContext context) async {
  final EM = Provider.of<EnterMedia>(context);
  final myUser = Provider.of<userData>(context);
  String emkey = await sharedPref().getEMKey();

  print('Trying to relogin');

  if (emkey != null && myUser.entermediakey == null) {
    final EmUser userInfo = await EM.emAutoLoginWithKey(context, emkey);
    if (userInfo.response.status == "ok") {
      print('RELOGGING IN WITH STORED KEY');
      print(emkey);

      myUser.addUser(userInfo.results.userid, userInfo.results.screenname, userInfo.results.entermediakey, userInfo.results.firstname,
          userInfo.results.lastname, userInfo.results.email, userInfo.results.firebasepassword);
    } else {
      showErrorFlushbar(context, "Unable to log in using saved key! Please try again.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
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
