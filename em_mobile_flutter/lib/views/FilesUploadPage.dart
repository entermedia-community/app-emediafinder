import 'dart:convert';
import 'dart:io';

import 'package:em_mobile_flutter/models/uploadMediaModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FilesUploadPage extends StatefulWidget {
  final String instanceUrl;
  FilesUploadPage(this.instanceUrl);
  @override
  FilesUploadPageState createState() => FilesUploadPageState();
}

class FilesUploadPageState extends State<FilesUploadPage> {
  // variable section
  Widget fileListThumb;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  File fileList;
  Future pickFiles() async {
    Widget thumbs;
    thumbs = fileListThumb;

    await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'heic', 'pdf', 'doc', 'docx'],
    )
        .then((file) {
      File myFile = File(file.files.single.path);
      print(myFile.absolute.path);
      if (myFile != null) {
        List<String> picExt = ['.jpg', '.jpeg', '.bmp', '.heic'];
        if (picExt.contains(extension(myFile.path).toLowerCase())) {
          thumbs = Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(1),
                child: Card(
                  color: Colors.transparent,
                  child: ClipRRect(
                    child: new Image.file(myFile),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (myFile != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Card(
                    shape: CircleBorder(),
                    color: Colors.transparent,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          fileList = null;
                          fileListThumb = null;
                        });
                      },
                    ),
                  ),
                ),
            ],
          );
        } else
          thumbs = Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.white,
                ),
                Text(
                  extension(myFile.path),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        fileList = myFile;
        setState(() {
          fileListThumb = thumbs;
        });
      }
    });
  }

  Future httpSend(Map params, BuildContext context, File file, userWorkspaces workspaces) async {
    if (file == null) {
      Fluttertoast.showToast(
        msg: "  Select a file first  ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red[400],
        fontSize: 16.0,
      );
      return;
    }
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    print(file.path);
    final UploadMediaModel response = await EM.uploadAsset(
      context,
      widget.instanceUrl,
      file?.path,
    );
    if (response.response.status == 'ok') {
      await MainContent(
        myWorkspaces: null,
      ).loadNewWorkspace(context, workspaces.instUrl.indexOf(widget.instanceUrl), false).whenComplete(() {
        Fluttertoast.showToast(
          msg: "Media Uploaded successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Color(0xff61af56),
          fontSize: 16.0,
        );
        fileListThumb = null;
        fileList = null;
        setState(() {});
      });
    } else {
      Fluttertoast.showToast(
        msg: "Failed to upload media.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red.withOpacity(0.8),
        fontSize: 16.0,
      );
    }
    print(response);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final myWorkspaces = Provider.of<userWorkspaces>(context, listen: false);
    if (fileListThumb == null)
      fileListThumb = InkWell(
        onTap: pickFiles,
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            Card(
              color: Colors.transparent,
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    final Map params = new Map();
    return WillPopScope(
      onWillPop: () async {
        if (isLoading.value) {
          Fluttertoast.showToast(
            msg: "Please wait until file upload is complete.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.red.withOpacity(0.8),
            fontSize: 16.0,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text("Upload Media"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: fileListThumb,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (BuildContext context, bool value, _) {
                return value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (isLoading.value) {
              return null;
            }
            await httpSend(params, context, fileList, myWorkspaces);
          },
          tooltip: 'Upload File',
          child: const Icon(Icons.cloud_upload),
        ),
      ),
    );
  }
}
