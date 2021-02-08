import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';

class ImageView extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int currentIndex;
  final List<dynamic> name;
  final String instanceUrl;
  ImageView({@required this.imageUrls, @required this.currentIndex, @required this.instanceUrl, @required this.name});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  PageController _controller;
  var myUser;
  @override
  void initState() {
    _controller = new PageController(initialPage: widget.currentIndex);
    myUser = Provider.of<userData>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c223a),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls?.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              String url =
                  ("${widget.instanceUrl.toString()}/finder/mediadb/services/module/asset/downloads/originals/${widget.imageUrls[index].replaceAll(" ", "%20")}/${widget.name[index]}")
                      .trim();
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url, headers: {"X-tokentype": "entermedia", 'X-token': '${myUser.entermediakey}'}),
                      fit: BoxFit.cover,
                    ),
                  ),
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
          Positioned(
            bottom: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _arrow(Icons.arrow_back_ios, () {
                      _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                    }),
                    _arrow(Icons.arrow_forward_ios, () {
                      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                    }),
                  ],
                ),
              ),
            ),
          ),
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
