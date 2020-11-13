import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //a way to set the glue between the widgets and the Flutter engine before it has been done itself. This happens automatically a bit after the main method is called.
  //but as we want to initialize a class asynchronously then, before that is done we need to say:  "Hey, can we do the initialization now and after that we initialize the class"
  //binding is required before/inorder to call native code. - 10/2/2020
  await Firebase.initializeApp();
  //initialize firebase.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // todo; <--- this just highlights on the IDE what is typed after. Follow the trail to see a complete setup and usage.
    // todo;   This MultiProvider class is a sub class of Provider. Provider is how we're going to pass around information within the app.
    // todo; Provider basically can provide us with instances of any class we specify here. This has to 'wrap' the beginning of the app UI so that every child widget can access the same instance with the
    // todo; Consumer widget (i.e. NavMenu.dart ln 31).
    // todo; When you want to display you must instantiate first with 'final name = Provider.of<SOMECLASS>(context); then wrap UI component with Consumer Widget.
    // todo; On ln 31 we return the MultiProvider()[] Widget because here we are going to define all classes we need access to globally and this 'wraps' ALL UI components which are in Material App()
    // todo; We create necessary Firebase classes and userData(). -> ln 33, below
    return MultiProvider(
        providers: [
          // todo; Creating an instance of the global class that will store our users information (see userData.dart in lib/models) after logging in. -> LoginPage.dart ln 22
          ChangeNotifierProvider<userData>(create: (context) => userData()),
          ChangeNotifierProvider<userWorkspaces>(create: (context) => userWorkspaces()),
          Provider<EnterMedia>(create: (context) => EnterMedia()),
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
          accentColor: Color(0xff61af56),
          backgroundColor: Colors.white38,
          //Text Colors
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white),
              bodyText2: TextStyle(color: Color(0xff92e184))
          ),
          //Button Colors
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xff61af56),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

//Requires users to be logged into Firebase
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final firebaseUser = context.watch<User>();
    final EM = Provider.of<EnterMedia>(context);

    if(firebaseUser != null){
      return HomeMenu();
    }

    return LoginPage();
  }
}


