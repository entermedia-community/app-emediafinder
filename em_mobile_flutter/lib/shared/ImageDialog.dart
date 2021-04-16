import 'dart:io';

import 'package:flutter/material.dart';

class ImageDialog extends StatefulWidget {
  final File imageFile;
  final bool isPreviewAvailable;
  final String filename;
  ImageDialog({
    @required this.imageFile,
    @required this.isPreviewAvailable,
    @required this.filename,
  });

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return !widget.isPreviewAvailable
        ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "${widget.filename}",
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              cancelIcon(context),
            ],
          )
        : Stack(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(widget.imageFile),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: cancelIcon(context),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.filename}",
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}

Widget cancelIcon(BuildContext context) {
  return Positioned(
    top: 0,
    right: 0,
    child: Card(
      shape: CircleBorder(),
      color: Colors.transparent,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 4),
          child: Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    ),
  );
}
