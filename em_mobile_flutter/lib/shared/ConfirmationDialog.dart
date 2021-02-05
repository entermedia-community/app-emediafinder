import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog {
  final BuildContext context;
  final String title;
  final String alertMessage;
  final bool hasSecondActionButton;
  final String actionButtonLabel;
  String secondActionButtonLabel;
  final Function actionButtonCallback;
  ConfirmationDialog({
    @required this.context,
    @required this.title,
    @required this.alertMessage,
    @required this.hasSecondActionButton,
    @required this.actionButtonLabel,
    @required this.actionButtonCallback,
    @required this.secondActionButtonLabel,
  });
  showPopUpDialog() {
    return Platform.isIOS ? iosNativeDesignDialog() : androidNativeDesignDialog();
  }

  void iosNativeDesignDialog() async {
    return showCupertinoDialog(
      context: context,
      builder: (popupContext) => Theme(
        data: Theme.of(context).copyWith(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: title == null ? null : Text("$title", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$alertMessage",
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: <Widget>[
            if (hasSecondActionButton)
              FlatButton(
                child: Text(
                  "$secondActionButtonLabel",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            FlatButton(
              child: Text(
                "$actionButtonLabel",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: actionButtonCallback != null ? () => popPage(actionButtonCallback) : () => Navigator.of(popupContext).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void androidNativeDesignDialog() async {
    return showDialog(
      context: context,
      builder: (popupContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: title == null ? null : Text("$title", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text(
          "$alertMessage",
          style: TextStyle(color: Colors.black),
        ),
        titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        actionsPadding: EdgeInsets.only(right: 15),
        actions: <Widget>[
          if (hasSecondActionButton)
            FlatButton(
              child: Text(
                "$secondActionButtonLabel",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          FlatButton(
            child: Text(
              "$actionButtonLabel",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: actionButtonCallback != null ? () => popPage(actionButtonCallback) : () => Navigator.of(popupContext).pop(),
          ),
        ],
      ),
    );
  }

  popPage(Function callback) {
    Navigator.of(context).pop();
    callback();
  }
}
