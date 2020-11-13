import 'package:flutter/material.dart';
import 'EMWebview.dart' as Collection;

Widget emWorkspace(
    String imageVal, String workspaceName, String collectionURL) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x8092e184),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of(). CANNOT USE BuildContext from original scaffolding.-Mando
          child: Builder(builder: (BuildContext context) {
            return emWorkspaceRow(
                imageVal, workspaceName, collectionURL, context);
          })),
    ),
  );
}

Center emWorkspaceRow(String imageVal, String workspaceName,
    String collectionURL, BuildContext context) {
  return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              leftSide(imageVal, workspaceName),
              rightSide(collectionURL, context),
            ],
          )
        ],
      ));
}

Widget leftSide(String imageVal, String workspaceName) {
  return Container(
      child: Row(
        children: <Widget>[
          //TODO Change AssetImage to NetworkImage('URL')
          Container(
            child: Image(
              height: 50.0,
              image: AssetImage(imageVal),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            child: Text(
              workspaceName,
              style: TextStyle(
                  color: Color(0xff000015),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  fontSize: 16.0),
            ),
          ),
        ],
      ));
}

Widget rightSide(String collectionURL, BuildContext context) {
  return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.web),
              onPressed: () {
                _openCollectionWV(context, collectionURL);
                //TODO: This button will open to collection Webview
                final snackBar = SnackBar(
                  content: Text('No Webview Attached'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {},
                  ),
                );

                // Find the Scaffold in the widget tree and use
                // it to show a SnackBar.
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ));
}

void _openCollectionWV(BuildContext context, String url) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => Collection.WebViewContainer(url)));
}