import 'dart:convert';
import 'dart:io';

import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  File fileList;
  Future pickFiles() async {
    Widget thumbs;
    thumbs = fileListThumb;

    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'pdf', 'doc', 'docx'],
    ).then((file) {
      File myFile = File(file.files.single.path);
      print(myFile.absolute.path);
      if (myFile != null) {
        List<String> picExt = ['.jpg', '.jpeg', '.bmp'];
        if (picExt.contains(extension(myFile.path))) {
          thumbs = Padding(padding: EdgeInsets.all(1), child: new Image.file(myFile));
        } else
          thumbs = Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.insert_drive_file), Text(extension(myFile.path))]));
        fileList = myFile;
        setState(() {
          fileListThumb = thumbs;
        });
      }
    });

/*    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'pdf', 'doc', 'docx'],
    ).then((selectedFiles) {
      List<File> files = selectedFiles.paths.map((path) => File(path)).toList();
      if (files != null && files.length > 0) {
        files.forEach((element) {
          List<String> picExt = ['.jpg', '.jpeg', '.bmp'];

          if (picExt.contains(extension(element.path))) {
            thumbs.add(Padding(padding: EdgeInsets.all(1), child: new Image.file(element)));
          } else
            thumbs.add(Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.insert_drive_file), Text(extension(element.path))])));
          fileList.add(element);
        });
        setState(() {
          fileListThumb = thumbs;
        });
      }
    });*/
  }

  Future httpSend(Map params, BuildContext context, File file) async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    print(file.path);
    final response = await EM.uploadAsset(
      context,
      widget.instanceUrl,
      file?.path,
    );
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    if (fileListThumb == null)
      fileListThumb = InkWell(
        onTap: pickFiles,
        child: Container(child: Icon(Icons.add)),
      );
    final Map params = new Map();
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Media"),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(5),
        child: fileListThumb,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await httpSend(params, context, fileList);
        },
        tooltip: 'Upload File',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
