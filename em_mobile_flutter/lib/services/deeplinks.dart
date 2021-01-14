import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinks {
  DeepLinks._();
  static final DeepLinks instance = DeepLinks._();

  Future handleDynamicLinks() async {
    Future.delayed(
      Duration(seconds: 3),
      () async {
        final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
        print(data);
        // print(data?.key);
        _handleDeepLink(data);
        FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            _handleDeepLink(data);
          },
          onError: (OnLinkErrorException e) async {
            print('Link Failed: ${e.message}');
          },
        );
      },
    );
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    print(deepLink);
    if (deepLink != null) {
      print(deepLink.queryParameters);
      if (deepLink.queryParameters.containsKey('key')) {
        String token = deepLink.queryParameters['key'];
        sharedPref().saveEMKey(token);
        print(token);
      }
      print('_handleDeepLink | deeplink: $deepLink');
    }
  }
}
