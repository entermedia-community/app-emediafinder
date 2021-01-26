import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:em_mobile_flutter/models/emLogo.dart';

class emLogoIcon extends StatefulWidget {
  @override
  _emLogoIconState createState() => _emLogoIconState();
}

class _emLogoIconState extends State<emLogoIcon> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: EmLogo(),
      elevation: 10,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Logout"),
        ),
      ],
      onSelected: (value) => {
        if (value == 1)
          {
            //clear out stored entermediakey value
            sharedPref().resetValues(),
            //firebase signout which should auto redirect to LoginPage()
            context.read<AuthenticationService>().signOut(),
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
          }
      },
    );
  }
}
