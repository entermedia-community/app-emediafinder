import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EMWebview.dart' as Collection;

Widget emWorkspace(
    String imageVal, String workspaceName, String instanceUrl) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Material(
      elevation: 20.0,
      shadowColor: Color(0x8092e184),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of(). CANNOT USE BuildContext from original scaffolding.-Mando
          child: Builder(builder: (BuildContext context) {

            return emWorkspaceRow(
                imageVal, workspaceName, instanceUrl, context);
          })),
    ),
  );
}

Column emWorkspaceRow(String imageVal, String workspaceName,
    String instanceUrl, BuildContext context) {
  return Column(
    children: [
      //Spacingggggggg for the rows.
      SizedBox(
        height: 3,
      ),
      Material(
        color:  Color(0xff0c223a),
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x8092e184),
        child: Center(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                leftSide(imageVal, workspaceName),
                rightSide(instanceUrl, context),
              ],
            )
          ],
        )),
      ),
    ],
  );
}

Widget leftSide(String imageVal, String workspaceName) {
  return Container(
      child: Row(
    children: <Widget>[
      //TODO Change AssetImage to NetworkImage('URL')
      SizedBox(
        width: 15.0,
      ),
      Container(
        child: Text(
          workspaceName,
          style: TextStyle(
              color: Color(0xff61af56),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 16.0),
        ),
      ),
    ],
  ));
}

Widget rightSide(String instanceUrl, BuildContext context) {
  return Container(
      child: Column(
    children: <Widget>[
      Container(
        child: IconButton(
          icon: Icon(Icons.auto_awesome_mosaic,
          color: Color(0x8092e184),
          ),
          onPressed: () {
            _testOpenHomeMenu(context, instanceUrl);
            //TODO: This button will open to HomeMenu of the correct Workspace, place getEMAssets in this on pressed and pass in correct post URL
//            final snackBar = SnackBar(
//              content: Text('No Webview Attached'),
//              action: SnackBarAction(
//                label: 'Close',
//                onPressed: () {},
//              ),
//            );

            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
//            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    ],
  ));
}

//edit to open correct HomeMenu dynamically
void _openCollectionWV(BuildContext context, String url) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Collection.WebViewContainer(url)));
}

void _testOpenHomeMenu(BuildContext context, String instanceUrl) {
  final EM = Provider.of<EnterMedia>(context,listen: false);
  print(instanceUrl);

  EM.getWorkspaceAssets(instanceUrl);

  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeMenu()));
}
