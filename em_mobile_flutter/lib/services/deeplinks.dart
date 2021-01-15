import 'package:em_mobile_flutter/main.dart';
import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DeepLinks {
  DeepLinks._();
  static final DeepLinks instance = DeepLinks._();

  Future handleDynamicLinks(BuildContext context) async {
    Future.delayed(
      Duration(seconds: 3),
      () async {
        final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
        print(data);
        // print(data?.key);
        _handleDeepLink(data, context);
        FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            _handleDeepLink(data, context);
          },
          onError: (OnLinkErrorException e) async {
            print('Link Failed: ${e.message}');
          },
        );
      },
    );
  }

  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) async {
    final Uri deepLink = data?.link;
    print(deepLink);
    if (deepLink != null) {
      print(deepLink.queryParameters);
      if (deepLink.queryParameters.containsKey('key')) {
        String token = deepLink.queryParameters['key'];
        token = token.replaceAll(" ", "+");
        await sharedPref().saveEMKey(token);
        final myUser = Provider.of<userData>(context);
        final EM = Provider.of<EnterMedia>(context);
        final EmUser userInfo = await EM.emLoginWithKey(token);
        print(userInfo.results.screenname);
        // Here we call and update global myUser class with Entermediadb.org user information after logging in.
        myUser.addUser(userInfo.results.userid, userInfo.results.screenname, userInfo.results.entermediakey, userInfo.results.firstname,
            userInfo.results.lastname, userInfo.results.email, userInfo.results.firebasepassword);
        //Firebase Authentication sign in.
        context.read<AuthenticationService>().signIn(email: myUser.email, password: myUser.firebasepassword);
      }
      print('_handleDeepLink | deeplink: $deepLink');
    }
  }
}
