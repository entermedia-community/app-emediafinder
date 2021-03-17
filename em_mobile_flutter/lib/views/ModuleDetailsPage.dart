import 'package:em_mobile_flutter/models/moduleAssetModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CustomSearchBar.dart';
import 'package:em_mobile_flutter/shared/SearchBarWithoutArrow.dart';
import 'package:em_mobile_flutter/views/ModuleListingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ModuleDetailsPage extends StatefulWidget {
  final ModulesDetails modulesDetails;
  final String instanceUrl;
  ModuleDetailsPage(this.modulesDetails, this.instanceUrl);
  @override
  _ModuleDetailsPageState createState() => _ModuleDetailsPageState();
}

class _ModuleDetailsPageState extends State<ModuleDetailsPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isListModeEnabled = ValueNotifier(false);
  ValueNotifier<bool> enableEdit = ValueNotifier(false);
  List<EntitiesDetails> entitiesDetails = <EntitiesDetails>[];
  List<EntitiesDetails> filteredEntitiesDetails = <EntitiesDetails>[];
  TextEditingController searchBarController = new TextEditingController();
  TextEditingController createEntityController = new TextEditingController();
  TextEditingController nameEditController = new TextEditingController();
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    fetchEntityData();
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    createEntityController.dispose();
    nameEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("${widget.modulesDetails.name}"),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: fetchEntityData,
            ),
          ],
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
                                  SearchBarWithoutArrow(
                                    controller: searchBarController,
                                    onChanged: (value) => filterResult(value),
                                    context: context,
                                    entity: widget.modulesDetails.name,
                                    trailingWidget: IconButton(
                                      icon: ValueListenableBuilder<bool>(
                                          valueListenable: isListModeEnabled,
                                          builder: (BuildContext context, bool state, _) {
                                            return state
                                                ? Icon(
                                                    Icons.grid_view,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )
                                                : Icon(
                                                    Icons.format_list_bulleted,
                                                    color: Colors.white,
                                                    size: 30,
                                                  );
                                          }),
                                      onPressed: () {
                                        isListModeEnabled.value = !isListModeEnabled.value;
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: isListModeEnabled,
                                    builder: (BuildContext context, bool state, _) {
                                      return state ? listViewEntity() : gridViewEntity();
                                    },
                                  ),
                                  currentPage <= totalPages
                                      ? Container(
                                          margin: EdgeInsets.only(top: 15, bottom: 5, left: 5, right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              currentPage > 1 && currentPage <= totalPages
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xff237C9C),
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.navigate_before_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            currentPage++;
                                                          });
                                                          filterResult(searchBarController.text);
                                                        },
                                                        color: Color(0xff237C9C),
                                                      ),
                                                    )
                                                  : Container(),
                                              currentPage < totalPages
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xff237C9C),
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.navigate_next_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            currentPage--;
                                                          });
                                                          filterResult(searchBarController.text);
                                                        },
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        )
                                      : Container(),
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

  Future fetchEntityData() async {
    isLoading.value = true;

    entitiesDetails = <EntitiesDetails>[];
    filteredEntitiesDetails = <EntitiesDetails>[];
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final ModuleAssetModel moduleAssetModel = await EM.getModulesData(context, widget.instanceUrl, widget.modulesDetails.id.trim());
    if (moduleAssetModel.response.status == 'ok') {
      moduleAssetModel.results.forEach((element) {
        entitiesDetails.add(EntitiesDetails(element.id, element.name));
        filteredEntitiesDetails.add(EntitiesDetails(element.id, element.name));
      });
    }
    setState(() {});
    isLoading.value = false;
  }

  void resetSearchFilter() {
    setState(() {
      filteredEntitiesDetails = [];
      filteredEntitiesDetails = entitiesDetails;
    });
  }

  void filterResult(String searchText) async {
    if (searchText.length <= 2) {
      resetSearchFilter();
    } else {
      final EM = Provider.of<EnterMedia>(context, listen: false);
      final ModuleAssetModel filteredModules = await EM.searchFromModulesData(
        context,
        widget.instanceUrl,
        widget.modulesDetails.id,
        searchText,
        currentPage.toString(),
      );
      if (filteredModules.response.status == 'ok') {
        List<EntitiesDetails> tempDetails = <EntitiesDetails>[];
        filteredModules.results.forEach((element) {
          tempDetails.add(EntitiesDetails(element.id, element.name));
        });
        filteredEntitiesDetails = tempDetails;
        currentPage = filteredModules.response.page;
        totalPages = filteredModules.response.pages;
      }
/*
      ///TODO: USE THIS CODE IF YOU WANT TO ADD SEARCH FILTER LOCALLY
      List<EntitiesDetails> tempDetails = <EntitiesDetails>[];
      filteredEntitiesDetails.forEach((element) {
        print("element");
        print(element.name);
        if (element.name.toString().toLowerCase().contains(searchText.toLowerCase())) {
          tempDetails.add(element);
        }
      });
      filteredEntitiesDetails = tempDetails;*/
    }
    setState(() {});
  }

  Widget listViewEntity() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: filteredEntitiesDetails.length + 1,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext myContext, int index) {
            return index == 0
                ? customListTile(
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),

                      title: Text(
                        "Add new",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      // tileColor: Color(0xFF2680A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: showBottomSheetTextField,
                    ),
                    Color(0xff237C9C),
                  )
                : customListTile(
                    ListTile(
                      dense: true,
                      title: Text(
                        "${filteredEntitiesDetails[index - 1].name}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      // tileColor: Color(0xFF2680A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () => viewAndEditEntity(
                        EntitiesDetails(filteredEntitiesDetails[index - 1].id, filteredEntitiesDetails[index - 1].name),
                      ),
                    ),
                    Color(0xff0c223a),
                  );
          },
        ),
      ],
    );
  }

  void viewAndEditEntity(EntitiesDetails entity) {
    modalSheet(
      Container(
        color: Color(0xff0c223a),
        padding: EdgeInsets.fromLTRB(15, 30, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                "${widget.modulesDetails.name}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: enableEdit,
              builder: (BuildContext context, bool isEnabled, _) {
                return !isEnabled
                    ? Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "${entity.name}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                      )
                    : Container(
                        height: 45,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(fontSize: 15),
                                controller: nameEditController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xff384964),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    hintText: "${entity.name}",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    alignLabelWithHint: true,
                                    contentPadding: EdgeInsets.fromLTRB(12, 5, 5, 5)),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (v) => print(v),
                              ),
                            ),
                            SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                child: Icon(Icons.check),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green[400],
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[400],
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 5),
                  ValueListenableBuilder<bool>(
                    valueListenable: enableEdit,
                    builder: (BuildContext context, bool isActive, _) {
                      return !isActive
                          ? ElevatedButton(
                              child: Text("Edit"),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff237C9C),
                              ),
                              onPressed: () {
                                enableEdit.value = !enableEdit.value;
                              },
                            )
                          : ElevatedButton(
                              child: Text("View"),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff237C9C),
                              ),
                              onPressed: () {
                                enableEdit.value = !enableEdit.value;
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customListTile(Widget listTile, Color boxColor) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: listTile,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget gridViewEntity() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GridView.builder(
          padding: EdgeInsets.all(0),
          itemCount: filteredEntitiesDetails.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext myContext, int index) {
            return index == 0
                ? InkWell(
                    child: Card(
                      color: Colors.transparent,
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff237C9C),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                          boxShadow: [
                            new BoxShadow(
                              offset: Offset(2, 2),
                              color: Colors.black12,
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                    onTap: showBottomSheetTextField,
                  )
                : Container(
                    child: InkWell(
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
                          alignment: Alignment.center,
                          child: ListTile(
                            title: Text(
                              "${filteredEntitiesDetails[index - 1].name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // tileColor: Color(0xFF2680A0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        viewAndEditEntity(filteredEntitiesDetails[index - 1]);
                      },
                    ),
                  );
          },
        ),
      ],
    );
  }

  void showBottomSheetTextField() {
    modalSheet(textFieldWithButton());
  }

  Widget textFieldWithButton() {
    return Container(
      color: Color(0xff0c223a),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 8),
            child: Text(
              "Create new",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            style: TextStyle(fontSize: 17, color: Colors.white),
            controller: createEntityController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff384964),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.drive_file_rename_outline,
                  color: Color(0xff237C9C),
                ),
                contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5)),
            keyboardType: TextInputType.emailAddress,
            onChanged: (text) => print(text),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                ),
                onPressed: () {
                  createEntityController..text = '';
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 5),
              ElevatedButton(
                child: Text("Create"),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff237C9C),
                ),
                onPressed: createEntity,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void modalSheet(Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      elevation: 8,
      builder: (BuildContext popupContext) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Color(0xff237C9C), // Color(0xff0c223a),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FractionallySizedBox(
                widthFactor: 0.25,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 18.0,
                  ),
                  child: Container(
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.9),
                      borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        );
      },
    );
  }

  Future createEntity() async {
    Navigator.of(context).pop();
    final EM = Provider.of<EnterMedia>(context, listen: false);
    if (createEntityController.text.trim().length > 0) {
      bool response = await EM.createModulesData(
        context,
        widget.instanceUrl,
        widget.modulesDetails.id,
        createEntityController.text,
      );
      if (response) {
        Fluttertoast.showToast(
          msg: "${widget.modulesDetails.name} created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Color(0xff61af56),
          fontSize: 16.0,
        );
        createEntityController..text = "";
        fetchEntityData();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to create ${widget.modulesDetails.name}!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red.withOpacity(0.7),
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "${widget.modulesDetails.name} name can't be empty.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red.withOpacity(0.7),
        fontSize: 16.0,
      );
    }
  }

/*  Widget addButton(int index) {
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
  }*/
}

class EntitiesDetails {
  String name;
  String id;
  EntitiesDetails(this.id, this.name);
}
