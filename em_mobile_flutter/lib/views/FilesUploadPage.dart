import 'dart:convert';
import 'dart:io';

import 'package:em_mobile_flutter/models/getWorkspacesModel.dart';
import 'package:em_mobile_flutter/models/uploadMediaModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/shared/CircularLoader.dart';
import 'package:em_mobile_flutter/views/AttachEntityPage.dart';
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
  Map<String, List<String>> jsonEncodedData = {};

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
                  border: Border.all(color: Colors.grey, width: 1),
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
    return Scaffold(
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
                      child: Loader.showLoader(context),
                    )
                  : Container();
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          fileList == null
              ? Text("")
              : ElevatedButton(
                  onPressed: () async {
                    jsonEncodedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttachEntityPage(widget.instanceUrl),
                        fullscreenDialog: true,
                      ),
                    );
                    print(jsonEncodedData);
                    setState(() {});
                  },
                  child: Text("Attach Entity Tags"),
                  style: ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
                ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              if (isLoading.value) {
                return null;
              }
              await httpSend(params, context, fileList, myWorkspaces);
            },
            tooltip: 'Upload File',
            child: const Icon(Icons.cloud_upload),
          ),
        ],
      ),
    );
  }

  Widget cancelIcon() {
    return Positioned(
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
    );
  }

  Future pickFiles() async {
    Widget thumbs;
    thumbs = fileListThumb;

    try {
      await FilePicker.platform.pickFiles(type: FileType.any).then((file) {
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
                if (myFile != null) cancelIcon(),
              ],
            );
          } else
            thumbs = Stack(
              children: [
                Card(
                  color: Colors.transparent,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.white,
                          size: 60,
                        ),
                        SizedBox(height: 7),
                        Text(
                          "${basename(myFile.path)}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                if (myFile != null) cancelIcon(),
              ],
            );
          fileList = myFile;
          setState(() {
            fileListThumb = thumbs;
          });
        }
      });
    } catch (e) {
      isLoading.value = false;
      fileListThumb = null;
      fileList = null;
      Fluttertoast.showToast(
        msg: "An error occurred while uploading image to the server. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 20,
        backgroundColor: Colors.red[400],
        fontSize: 16.0,
      );
    }
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
    try {
      final EM = Provider.of<EnterMedia>(context, listen: false);
      print(file.path);
      final UploadMediaModel response = await EM.uploadAsset(
        context,
        widget.instanceUrl,
        file?.path,
        jsonEncodedData,
      );
      if (response.response.status == 'ok') {
        await MainContent(myWorkspaces: null).loadNewWorkspace(context, workspaces.instUrl.indexOf(widget.instanceUrl), false).whenComplete(() {
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
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred while communicating with the server. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 15,
        backgroundColor: Colors.red.withOpacity(0.8),
        fontSize: 16.0,
      );
    }
    isLoading.value = false;
  }
}
