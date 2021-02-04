import 'package:flutter/material.dart';

class Loader {
  static Future<void> showLoader(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
