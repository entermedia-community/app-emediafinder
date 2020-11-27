import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EMWebview.dart' as Collection;

Widget emWorkspace(String imageVal, String workspaceName, String instanceUrl, String colId) {
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
                imageVal, workspaceName, instanceUrl, colId, context);
          })),
    ),
  );
}

Column emWorkspaceRow(String imageVal, String workspaceName, String instanceUrl, String colId,
    BuildContext context) {
  return Column(
    children: [
      //Spacingggggggg for the rows.
      SizedBox(
        height: 3,
      ),
      Material(
        color: Color(0xff0c223a),
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x8092e184),
        child: Center(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                leftSide(imageVal, workspaceName),
                rightSide(instanceUrl,colId, context),
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

Widget rightSide(String instanceUrl, String colId, BuildContext context) {
  //Instantiate global instances of Entermedia and hitTracker
  final EM = Provider.of<EnterMedia>(context, listen: false);
  final hitTracker = Provider.of<workspaceAssets>(context, listen: false);
  final myUser = Provider.of<userData>(context);

  return Container(
      child: Column(
    children: <Widget>[
      Container(
        child: IconButton(
          icon: Icon(
            Icons.auto_awesome_mosaic,
            color: Color(0x8092e184),
          ),
          onPressed: () async {

            EM.createTeamAccount(instanceUrl, myUser.entermediakey, colId);

//            final Map searchedData = (await EM.getWorkspaceAssets(instanceUrl)) as Map;
//
//            hitTracker.searchedhits = searchedData;
//
//            hitTracker.getAssetSampleUrls(instanceUrl);


//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => HomeMenu()));
          },
        ),
      ),
    ],
  ));
}

