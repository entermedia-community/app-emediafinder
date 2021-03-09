import 'package:em_mobile_flutter/models/moduleListModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CustomExpansionTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleListingPage extends StatefulWidget {
  final String instanceUrl;
  ModuleListingPage(this.instanceUrl);
  @override
  _ModuleListingPageState createState() => _ModuleListingPageState();
}

class _ModuleListingPageState extends State<ModuleListingPage> {
  ModuleListModel moduleListData = new ModuleListModel();

  Future<ModuleListModel> fetchModulesData() async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    moduleListData = await EM.getAllModulesList(context, widget.instanceUrl);
    return moduleListData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
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
                FutureBuilder(
                  future: fetchModulesData(),
                  builder: (BuildContext ctx, AsyncSnapshot<ModuleListModel> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.response.status == 'ok' && snapshot.data.results.length > 0) {
                        return modulesListing(snapshot.data.results);
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Center(
                            child: Text(
                              "No Data available.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  int selectedStep = 0;

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
            return CustomExpansionTile(
              header: Row(
                children: [
                  modules[index].isentity == 'true'
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 13, 10, 13),
                            margin: EdgeInsets.only(bottom: 3),
                            color: Color(0xFF2680A0),
                            child: Text(
                              "${modules[index].name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              children: [
                Container(
                  height: 300,
                  color: Colors.red,
                  child: Text(""),
                ),
              ],
            ) /*Row(
              children: [
                modules[index].isentity == 'true'
                    ? Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 13, 10, 13),
                          margin: EdgeInsets.only(bottom: 3),
                          color: Color(0xFF2680A0),
                          child: Text(
                            "${modules[index].name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            )*/
                ;
          },
        ),
      ],
    );
  }

  List<Step> getSteps(List<ModuleListResults> modules) {
    List<Step> steps = <Step>[];
    for (int i = 0; i < modules.length; i++) {
      steps.add(
        Step(
          title: Text('${modules[i].name}'),
          content: Text("${modules[i].id}"),
        ),
      );
    }
    return steps;
  }
}

class ModulesDetails {
  int id;
  String name;
  String apiSuffix;
  List<String> entityName;
  ModulesDetails(this.id, this.name, this.apiSuffix, this.entityName);
}
