import 'package:em_mobile_flutter/models/moduleAssetModel.dart';
import 'package:em_mobile_flutter/models/moduleListModel.dart';
import 'package:em_mobile_flutter/models/projectAssetModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CustomExpansionTile.dart';
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
  List<ModulesDetails> modulesDetails = <ModulesDetails>[];
  EnterMedia EM;

  List<TextEditingController> nameControllers = <TextEditingController>[];
  List<ValueNotifier<bool>> isContentLoading = List<ValueNotifier<bool>>.filled(0, ValueNotifier(false), growable: true);
  List<ValueNotifier<bool>> isTextFieldActive = List<ValueNotifier<bool>>.filled(0, ValueNotifier(false), growable: true);

  Future<ModuleListModel> fetchModulesData() async {
    isLoading.value = true;
    isContentLoading = List<ValueNotifier<bool>>.filled(0, ValueNotifier(false), growable: true);
    modulesDetails = <ModulesDetails>[];
    EM = Provider.of<EnterMedia>(context, listen: false);
    moduleListData = await EM.getAllModulesList(context, widget.instanceUrl);
    for (int i = 0; i < moduleListData.results.length; i++) {
      modulesDetails.add(new ModulesDetails(moduleListData.results[i].id, moduleListData.results[i].name, []));
      isContentLoading.add(ValueNotifier(false));
      isTextFieldActive.add(ValueNotifier(false));
      nameControllers.add(new TextEditingController());
    }
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
                  modules[index].isentity == 'true' && modules[index].id != 'asset'
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
                ValueListenableBuilder<bool>(
                    valueListenable: isTextFieldActive[index],
                    builder: (BuildContext context, bool value, _) {
                      return value ? textFieldWithButton(index) : Container();
                    }),
                ValueListenableBuilder<bool>(
                  valueListenable: isContentLoading[index],
                  builder: (BuildContext context, bool value, _) {
                    return value
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 25),
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GridView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: modulesDetails[index].entityName.length + 2,
                                itemBuilder: (BuildContext context, int childIndex) {
                                  return childIndex == 0
                                      ? addButton(index)
                                      : childIndex == 1
                                          ? refreshButton(index)
                                          : Card(
                                              elevation: 3,
                                              shadowColor: Colors.black,
                                              color: Color(0xFF2680A0).withOpacity(0.9),
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${modulesDetails[index].entityName[childIndex - 2]}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.fade,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                },
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                              ),
                              /*  Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      child: Text("Add ${modulesDetails[index].name}"),
                                      onPressed: () {
                                        print("");
                                      },
                                    ),
                                  ],
                                ),
                              ),*/
                            ],
                          );
                  },
                ),
              ],
              onExpansionChanged: (state) {
                if (state && modulesDetails[index].entityName.length < 1) {
                  fetchEntityData(modulesDetails[index].id, index);
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget textFieldWithButton(int index) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(fontSize: 17, color: Colors.white),
            controller: nameControllers[index],
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff384964),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                errorBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(width: 1, color: Colors.black)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.drive_file_rename_outline,
                  color: Color(0xff92e184),
                ),
                contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5)),
            keyboardType: TextInputType.emailAddress,
            onChanged: (text) => print(text),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  isTextFieldActive[index].value = false;
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300],
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                child: Text("Create"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[300],
                ),
                onPressed: () async {
                  if (nameControllers[index].text.trim().length > 0) {
                    bool response = await EM.createModulesData(context, widget.instanceUrl, modulesDetails[index].id, nameControllers[index].text);
                    if (response) {
                      Fluttertoast.showToast(
                        msg: "${modulesDetails[index].name} created successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Color(0xff61af56),
                        fontSize: 16.0,
                      );
                      nameControllers[index]..text = "";
                      isTextFieldActive[index].value = false;
                      fetchEntityData(modulesDetails[index].id, index);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Failed to create ${modulesDetails[index].name}!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.red.withOpacity(0.7),
                        fontSize: 16.0,
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "${modulesDetails[index].name} name can't be empty.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 10,
                      backgroundColor: Colors.red.withOpacity(0.7),
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addButton(int index) {
    return InkWell(
      child: Card(
        color: Colors.blue.withOpacity(0.5),
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        setState(() {
          isTextFieldActive[index].value = true;
        });
      },
    );
  }

  Widget refreshButton(int index) {
    return InkWell(
      child: Card(
        color: Colors.white.withOpacity(0.3),
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 45,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () => fetchEntityData(modulesDetails[index].id, index),
    );
  }

  Future fetchEntityData(String entityId, int index) async {
    isContentLoading[index].value = true;
    List<String> names = <String>[];
    final ModuleAssetModel moduleAssetModel = await EM.getModulesData(context, widget.instanceUrl, entityId.trim());
    if (moduleAssetModel.response.status == 'ok') {
      moduleAssetModel.results.forEach((element) {
        names.add(element.name);
      });
      modulesDetails[index].entityName = names;
    }
    setState(() {});
    isContentLoading[index].value = false;
  }
}

class ModulesDetails {
  String id;
  String name;
  List<String> entityName = <String>[];
  ModulesDetails(this.id, this.name, this.entityName);
}
