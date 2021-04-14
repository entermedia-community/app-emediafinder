import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String collectionId;
  final String instanceUrl;
  final bool hasDirectLink;
  final String directLink;
  final String filename;
  ImageView({
    @required this.collectionId,
    @required this.instanceUrl,
    @required this.hasDirectLink,
    @required this.directLink,
    this.filename,
  });

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<MediaResults> result = new List<MediaResults>();
  var myUser;
  String imageUrl = '';
  final Dio _dio = Dio();
  String fileName = DateTime.now().toString() + '.jpg';
  String _progress = "-";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    myUser = Provider.of<userData>(context, listen: false);
    if (widget.hasDirectLink) {
      setState(() {
        imageUrl = widget.directLink;
        fileName = widget.filename;
      });
    } else {
      getFullSizeImage();
    }
    initializeLocalNotification();
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
          fileName = i.name.toString();
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
        onPressed: _download,
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
        ],
      ),
    );
  }

  void initializeLocalNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android =
        AndroidNotificationDetails('channel id', 'channel name', 'channel description', priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<Directory> _getDownloadDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      permission = await Permission.storage.status;
    }

    return permission == PermissionStatus.granted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(widget.instanceUrl + imageUrl, savePath, onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }

  Future<void> _download() async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    String path = dir.path + '/' + fileName;
    if (isPermissionStatusGranted) {
      final savePath = path;
      await _startDownload(savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
  }

/*  void _downloadImage() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewAndFileDownloadPage(
                  title: "Title",
                )));
    */ /* Directory imageDir = await getApplicationDocumentsDirectory();
    String imagePath = imageDir.path;
    try {
      final taskId = await FlutterDownloader.enqueue(
        url: widget.instanceUrl + imageUrl,
        savedDir: imagePath,
        showNotification: true,
        openFileFromNotification: true,
      );
      print(taskId);
    } on PlatformException catch (error) {
      print(error);
    }*/ /*
  }*/
}
