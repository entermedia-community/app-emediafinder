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

  static Widget showLoaderWithText(BuildContext context, String text) {
    return InkWell(
      enableFeedback: false,
      onTap: () => print(""),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                "$text",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget showLoaderWithTextInPopup(BuildContext context, String text) {
    return InkWell(
      enableFeedback: false,
      onTap: () => print(""),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Theme.of(context).primaryColor,
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 30, 50, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 15),
                      Text(
                        "$text",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
