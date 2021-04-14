import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
  bool isLoading = false;
  bool isDownloading = false;
  List<MediaResults> result = new List<MediaResults>();
  var myUser;
  String imageUrl = '';
  final Dio _dio = Dio();
  String fileName = DateTime.now().toString() + '.jpg';
  ValueNotifier<double> progress = ValueNotifier(0.0);

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

  List<String> imageFileFormat = ['jpg', 'jpeg', 'png', 'svg'];

  Future<void> getFullSizeImage() async {
    setState(() {
      isLoading = true;
    });
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
          if (imageFileFormat.contains(i.detectedfileformat.toLowerCase())) {
            imageUrl = i.downloads[2].url.toString();
          } else {
            imageUrl = i.downloads[0].url.toString();
          }

          fileName = i.name.toString();
          setState(() {
            isLoading = false;
          });
          return;
        }
      }
      setState(() {});
    }
    print(assetResponse);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: isLoading ? Colors.grey : Theme.of(context).accentColor,
        child: Icon(Icons.file_download),
        onPressed: isLoading ? null : _download,
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff0c223a),
      body: isLoading
          ? Loader.showLoader(context)
          : Stack(
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.instanceUrl + imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                !isDownloading
                    ? Container()
                    : Positioned(
                        bottom: 90,
                        child: ValueListenableBuilder<double>(
                          valueListenable: progress,
                          builder: (BuildContext context, double value, _) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Center(
                                    child: LinearPercentIndicator(
                                      width: 200.0,
                                      lineHeight: 20.0,
                                      percent: value / 100,
                                      center: Text(
                                        "${value.toStringAsFixed(0)}%",
                                        style: new TextStyle(fontSize: 16.0, color: Colors.white, fontStyle: FontStyle.italic),
                                      ),
                                      alignment: MainAxisAlignment.center,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      backgroundColor: Colors.grey,
                                      progressColor: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    value == 100 ? "Download complete!" : "Downloading...",
                                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            );
                          },
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
      progress.value = (received / total * 100);
      print(progress.value);
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
    setState(() {
      isDownloading = true;
    });
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    String path = dir.path + '/' + fileName;
    if (isPermissionStatusGranted) {
      final savePath = path;
      await _startDownload(savePath);
    } else {
      print("User has not given the permission");
    }
    setState(() {
      isDownloading = false;
      progress.value = 0.0;
    });
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
