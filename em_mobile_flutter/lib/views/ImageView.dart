import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/FilesUploadPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ImageView extends StatefulWidget {
  final String collectionId;
  final String instanceUrl;
  final bool hasDirectLink;
  final String directLink;
  ImageView({@required this.collectionId, @required this.instanceUrl, @required this.hasDirectLink, @required this.directLink});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<MediaResults> result = new List<MediaResults>();
  var myUser;
  String imageUrl = '';

  @override
  void initState() {
    myUser = Provider.of<userData>(context, listen: false);
    if (widget.hasDirectLink) {
      setState(() {
        imageUrl = widget.directLink;
      });
    } else {
      getFullSizeImage();
    }
    super.initState();
  }

  Future<void> getFullSizeImage() async {
    isLoading.value = true;
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final myUser = Provider.of<userData>(context, listen: false);
    print(myUser.entermediakey);
    final MediaAssetModel assetResponse = await EM.getMediaAssets(
      context,
      widget.instanceUrl,
    );
    if (assetResponse != null && assetResponse.response.status == "ok") {
      result = assetResponse.results;
      for (var i in result) {
        if (i.id == widget.collectionId) {
          print("collection id is : ${widget.collectionId}");
          imageUrl = i.downloads[2].url.toString();
          setState(() {});
          isLoading.value = false;
          return;
        }
      }
      setState(() {});
    }
    print(assetResponse);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_download),
        onPressed: _downloadImage,
      ),
      backgroundColor: Color(0xff0c223a),
      body: Stack(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (BuildContext context, bool value, _) {
              return value
                  ? InkWell(
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
                    )
                  : Center(
                      child: CachedNetworkImage(
                        imageUrl: widget.instanceUrl + imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
            },
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          /*SafeArea(
            child: Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.cloud_download,
                  color: Colors.white,
                ),
                onPressed: () => _downloadImage(widget.imageUrls[_controller.page.toInt()]),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  void _downloadImage() async {
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilesUploadPage()));
    Directory imageDir = await getApplicationDocumentsDirectory();
    String imagePath = imageDir.path;
    try {
      final taskId = await FlutterDownloader.enqueue(
        url: widget.instanceUrl + imageUrl,
        savedDir: imagePath,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
      print(taskId);
    } on PlatformException catch (error) {
      print(error);
    }
  }
}
