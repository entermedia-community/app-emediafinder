import 'package:cached_network_image/cached_network_image.dart';
import 'package:em_mobile_flutter/models/mediaAssetModel.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';

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

  Widget _arrow(IconData icon, Function onTap) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
        size: 40,
      ),
      onPressed: onTap,
    );
  }

  void _downloadImage(imageUrl) async {}
}
