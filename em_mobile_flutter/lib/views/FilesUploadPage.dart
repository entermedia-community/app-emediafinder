import 'dart:convert';
import 'dart:io';

import 'package:em_mobile_flutter/models/uploadMediaModel.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CircularLoader.dart';
import 'package:em_mobile_flutter/shared/ImageDialog.dart';
import 'package:em_mobile_flutter/views/AttachEntityPage.dart';
import 'package:em_mobile_flutter/views/MainContent.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class FilesUploadPage extends StatefulWidget {
  final String instanceUrl;
  final PageController controller;
  final Function getEncodedJson;
  final Function removeEntityAtIndex;
  FilesUploadPage({this.instanceUrl, this.controller, this.getEncodedJson, this.removeEntityAtIndex, Key key}) : super(key: key);
  @override
  FilesUploadPageState createState() => FilesUploadPageState();
}

class FilesUploadPageState extends State<FilesUploadPage> with AutomaticKeepAliveClientMixin {
  List<Widget> fileListThumb = new List<Widget>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<File> fileList = new List<File>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pickFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myWorkspaces = Provider.of<userWorkspaces>(context, listen: false);
    super.build(context);

    final Map params = new Map();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Upload Media"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  GridView.builder(
                    itemCount: fileListThumb.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return InkWell(
                          onTap: pickFiles,
                          child: Center(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 8,
                              child: Container(
                                alignment: Alignment.center,
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
                          ),
                        );
                      }
                      return Stack(
                        children: [
                          fileListThumb[index - 1],
                          if (fileListThumb[index - 1] != null) cancelIcon(index - 1),
                        ],
                      );
                    },
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                  ),
                  fileList == null
                      ? Text("")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () async {
                                widget.controller.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.linear,
                                );
                              },
                              child: Text("+ Entity Tags"),
                              style: ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                  SizedBox(height: 25),
                  showSelectedEntity(),
                ],
              ),
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
    );
  }

  Widget cancelIcon(int index) {
    return Positioned(
      top: 0,
      right: 0,
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
              fileList.removeAt(index);
              fileListThumb.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  Widget showSelectedEntity() {
    List<SelectedModulesWithTitle> modulesWithTitle = widget.getEncodedJson();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          modulesWithTitle.length,
          (index) {
            return modulesWithTitle[index].selectedModules.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(3, 20, 5, 10),
                        child: Text(
                          "${modulesWithTitle[index].title}",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Wrap(
                        children: List.generate(
                          modulesWithTitle[index].selectedModules.length,
                          (i) => buildSelectedTile(
                            modulesWithTitle[index].selectedModules[i].id,
                            modulesWithTitle[index].selectedModules[i].name,
                            modulesWithTitle[index].moduleId,
                            i,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container();
          },
        ),
      ),
    );
  }

  Widget buildSelectedTile(String id, String name, String moduleId, int index) {
    return Container(
      child: Card(
        color: Theme.of(context).accentColor.withOpacity(0.2),
        elevation: 5,
        borderOnForeground: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
              child: Text(
                "$name",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5),
              child: GestureDetector(
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() => widget.removeEntityAtIndex(moduleId, index, id));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickFiles() async {
    List<Widget> thumbs = List<Widget>();
    List<File> myFile = List<File>();
    try {
      await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true).then((file) {
        file.files.forEach((file) {
          myFile.add(File(file.path));
          setState(() {});
        });

        print(myFile.first.absolute.path);
        if (myFile != null) {
          List<String> picExt = ['.jpg', '.jpeg', '.png', '.bmp', '.heic'];
          for (int index = 0; index < myFile.length; index++) {
            if (picExt.contains(p.extension(myFile[index].path, 1))) {
              thumbs.add(GestureDetector(
                child: Card(
                  color: Colors.transparent,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.withOpacity(0.2),
                          image: DecorationImage(
                            image: FileImage(myFile[index]),
                            fit: BoxFit.cover,
                          )),
                      child: Container(),
                    ),
                  ),
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageDialog(
                        imageFile: myFile[index],
                        isPreviewAvailable: true,
                        filename: p.basename(myFile[index].path),
                      );
                    }),
              ));
              setState(() {});
            } else {
              thumbs.add(GestureDetector(
                child: Card(
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
                          size: 40,
                        ),
                        SizedBox(height: 7),
                        Text(
                          "${p.basename(myFile[index].path)}",
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageDialog(
                        imageFile: myFile[index],
                        isPreviewAvailable: false,
                        filename: p.basename(myFile[index].path),
                      );
                    }),
              ));
              setState(() {});
            }
          }
          setState(() {
            fileList.addAll(myFile);
            fileListThumb.addAll(thumbs);
          });
        }
      });
    } on NoSuchMethodError {
      print("No file selected");
    } catch (e) {
      isLoading.value = false;
      fileListThumb = null;
      fileList = null;
      print("error text: $e");
      Fluttertoast.showToast(
        msg: "Failed to pick a file. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 20,
        backgroundColor: Colors.red[400],
        fontSize: 16.0,
      );
    }
  }

  Future httpSend(Map params, BuildContext context, List<File> file, userWorkspaces workspaces) async {
    print(widget.getEncodedJson());
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
      List<String> filePaths = <String>[];
      file.forEach(
        (element) {
          filePaths.add(element.path);
        },
      );
      final EM = Provider.of<EnterMedia>(context, listen: false);
      print(file.first.path);
      final UploadMediaModel response = await EM.uploadAsset(
        context,
        widget.instanceUrl,
        filePaths,
        widget.getEncodedJson(),
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
          fileListThumb = new List<Widget>();
          fileList = new List<File>();
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
