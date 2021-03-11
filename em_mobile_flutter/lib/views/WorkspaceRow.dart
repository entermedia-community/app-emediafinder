import 'package:em_mobile_flutter/models/userData.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/models/workspaceAssetsModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/services/sharedpreferences.dart';
import 'package:em_mobile_flutter/views/HomeMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*Widget emWorkspace(String imageVal, String workspaceName, String instanceUrl, String colId) {
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
            return emWorkspaceRow(imageVal, workspaceName, instanceUrl, colId, context);
          })),
    ),
  );
}*/

Column emWorkspaceRow(String imageVal, String workspaceName, String instanceUrl, String colId, BuildContext context, int index) {
  return Column(
    children: [
      //Spacingggggggg for the rows.
      SizedBox(
        height: 3,
      ),
      Material(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0xff92e184),
        child: Center(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                leftSide(imageVal, workspaceName),
                rightSide(instanceUrl, colId, context, index),
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
          "${workspaceName}",
          style: TextStyle(color: Color(0xff237C9C), fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: 16.0),
        ),
      ),
    ],
  ));
}

Widget rightSide(String instanceUrl, String colId, BuildContext context, int index) {
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
            Icons.account_tree_rounded,
            color: Color(0xff237C9C),
          ),
          onPressed: () async {
            await EM.createTeamAccount(context, instanceUrl, myUser.entermediakey, colId);

            final WorkspaceAssetsModel searchedData = await EM.getWorkspaceAssets(context, instanceUrl);

            hitTracker.searchedhits = searchedData;

            hitTracker.organizeData();

            //todo; Save this shit
            hitTracker.getAssetSampleUrls(instanceUrl);

            hitTracker.initializeFilters();
            if (index != null) {
              sharedPref().saveRecentWorkspace(index);
            }

            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeMenu()));
          },
        ),
      ),
    ],
  ));
}
