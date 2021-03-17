import 'package:em_mobile_flutter/models/moduleAssetModel.dart';
import 'package:em_mobile_flutter/models/moduleListModel.dart';
import 'package:em_mobile_flutter/models/projectAssetModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CustomExpansionTile.dart';
import 'package:em_mobile_flutter/views/AddTeamMember.dart';
import 'package:em_mobile_flutter/views/ModuleDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ModuleListingPage extends StatefulWidget {
  final String instanceUrl;
  ModuleListingPage(this.instanceUrl);
  @override
  _ModuleListingPageState createState() => _ModuleListingPageState();
}

class _ModuleListingPageState extends State<ModuleListingPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ModuleListModel moduleListData = new ModuleListModel();
  EnterMedia EM;

  Future<ModuleListModel> fetchModulesData() async {
    isLoading.value = true;
    EM = Provider.of<EnterMedia>(context, listen: false);
    moduleListData = await EM.getAllModulesList(context, widget.instanceUrl);
    isLoading.value = false;
    return moduleListData;
  }

  @override
  void initState() {
    fetchModulesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Database Manager"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        backgroundColor: Color(0xff0c223a),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            child: Column(
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
                              height: MediaQuery.of(context).size.height * 0.85,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  modulesListing(moduleListData.results),
                                  SizedBox(height: 80),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BottomSheet(
          builder: (BuildContext context) {
            return ListTile(
              tileColor: Color(0xff384964),
              title: Text(
                'Add a user to Workspace',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTeamMember(),
                ),
              ),
            );
          },
          onClosing: () => print(""),
        ),
      ),
    );
  }

  Widget modulesListing(List<ModuleListResults> modules) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: modules.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Row(
                children: [
                  modules[index].isentity == 'true' && modules[index].id != 'asset'
                      ? Expanded(
                          child: Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff0c223a),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${modules[index].name}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                                // tileColor: Color(0xFF2680A0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModuleDetailsPage(
                                      ModulesDetails(modules[index].id, modules[index].name),
                                      widget.instanceUrl,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class ModulesDetails {
  String id;
  String name;
  ModulesDetails(this.id, this.name);
}
