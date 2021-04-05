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
    return IconButton(
      icon: EmLogo(),
      onPressed: null,
    );
  }
}
