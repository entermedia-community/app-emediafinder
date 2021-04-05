import 'package:flutter/material.dart';

class Loader {
  static Widget showLoader(BuildContext context) {
    return InkWell(
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
    );
  }
}
