import 'dart:convert';

import 'package:em_mobile_flutter/models/moduleAssetModel.dart';
import 'package:em_mobile_flutter/models/moduleListModel.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:em_mobile_flutter/shared/CircularLoader.dart';
import 'package:em_mobile_flutter/views/ModuleDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttachEntityPage extends StatefulWidget {
  final String instanceUrl;
  AttachEntityPage(this.instanceUrl);
  @override
  _AttachEntityPageState createState() => _AttachEntityPageState();
}

class _AttachEntityPageState extends State<AttachEntityPage> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  ModuleListModel moduleList = new ModuleListModel();
  List<ModuleAssetModel> moduleAssets = <ModuleAssetModel>[];
  List<List<SelectedModule>> selectedModule = <List<SelectedModule>>[];
  TabController _tabController;

  Future<void> fetchAllModules() async {
    moduleList = new ModuleListModel();
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final ModuleListModel model = await EM.getAllModulesList(context, widget.instanceUrl);
    if (model != null && model.response.status == "ok") {
      for (int i = 0; i < model.results.length; i++) {
        if (model.results[i].isentity != "true" || model.results[i].id == "asset") {
          await model.results.removeAt(i);
        }
      }

      moduleList = await model;
      _tabController = new TabController(vsync: this, length: moduleList.results.length + 1);
      moduleAssets = new List<ModuleAssetModel>(moduleList.results.length);
      selectedModule = List.generate(moduleList.results.length, (index) => new List.filled(0, SelectedModule(null, null), growable: true));
      // selectedModule = new List<List<SelectedModule>>(moduleList.results.length);

      return await moduleList;
    }
  }

  Future<void> fetchEntities() async {
    for (int i = 0; i < moduleList.results.length; i++) {
      await fetchEntityData(moduleList.results[i].id.trim(), i);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    fetchAllModules().whenComplete(() => fetchEntities());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        length: isLoading ? 0 : (moduleList.results.length) + 1,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          extendBodyBehindAppBar: isLoading ? true : false,
          appBar: AppBar(
            title: Text("Attach Entity Tags"),
            leading: Text(""),
            actions: [
              SizedBox(width: 10),
              Center(
                child: InkWell(
                  child: Text(
                    "View Selected",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    _tabController.animateTo(0, duration: Duration(milliseconds: 150));
                  },
                ),
              ),
              SizedBox(width: 8),
            ],
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: List.generate(
                isLoading ? 0 : (moduleList.results.length) + 1,
                (index) {
                  if (index == 0) {
                    return Tab(
                      child: Text(
                        "Selected Entity",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  return Tab(
                    child: Text(
                      "${moduleList.results[index - 1].name}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              isScrollable: true,
              physics: AlwaysScrollableScrollPhysics(),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: isLoading ? Colors.grey : Theme.of(context).accentColor,
                child: Icon(Icons.done),
                onPressed: isLoading
                    ? null
                    : () {
                        createEncodedJson();
                      },
              ),
            ],
          ),
          body: isLoading
              ? Loader.showLoaderWithText(context, "Fetching Entities")
              : TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    (moduleList.results.length) + 1,
                    (index) {
                      if (index == 0) {
                        return buildSelectedEntity();
                      }
                      return buildTabContent(moduleList.results[index - 1].id, index - 1);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> createEncodedJson() async {
    Map<String, List<String>> jsonMap = {};
    for (int i = 0; i < moduleList.results.length; i++) {
      if (getEntityList(i).length > 0) {
        jsonMap.addAll({'${moduleList.results[i].id}': getEntityList(i)});
      }
    }
    Map<String, List<String>> jsonEncodedData = jsonMap;
    Navigator.pop(context, jsonEncodedData);
  }

  List<String> getEntityList(int index) {
    List<String> entityId = [];
    for (int i = 0; i < selectedModule[index].length; i++) {
      entityId.add(selectedModule[index][i].id);
    }
    return entityId;
  }

  Widget buildSelectedEntity() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: buildEntitySections(),
      ),
    );
  }

  Widget buildEntitySections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(moduleList.results.length, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${moduleList.results[index].name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            getSelectedEntity(moduleList.results[index].id, index),
          ],
        );
      }),
    );
  }

  Widget getSelectedEntity(String id, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 25),
      child: Wrap(
        children: List.generate(selectedModule[index] == null ? 0 : selectedModule[index].length, (i) {
          return buildSelectedTile(selectedModule[index][i].id, selectedModule[index][i].name, index, i);
        }),
      ),
    );
  }

  Widget buildTabContent(String entityId, int index) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Wrap(
          children: List.generate(moduleAssets[index].results.length, (i) {
            return buildEntityTile(moduleAssets[index].results[i].id, moduleAssets[index].results[i].name, index);
          }),
        ),
      ),
    );
  }

  Widget buildEntityTile(String id, String name, int index) {
    return name.toString() == 'null' || doesExist(id, name, index)
        ? Container()
        : GestureDetector(
            child: Card(
              color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                child: Text(
                  "$name",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            onTap: () async {
              bool status = await doesExist(id, name, index);
              if (!status) {
                selectedModule[index].add(SelectedModule(id, name));
                setState(() {});
              }
            },
          );
  }

  bool doesExist(String id, String name, int index) {
    bool status = false;
    for (int i = 0; i < selectedModule[index].length; i++) {
      if (selectedModule[index][i].id == id) {
        status = true;
      }
    }
    return status;
  }

  Widget buildSelectedTile(String id, String name, int moduleIndex, int tileIndex) {
    return Container(
      child: Card(
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
              child: Text(
                "$name",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5),
              child: GestureDetector(
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onTap: () {
                  selectedModule[moduleIndex].removeAt(tileIndex);
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchEntityData(String entityId, int index) async {
    final EM = Provider.of<EnterMedia>(context, listen: false);
    final ModuleAssetModel moduleAssetModel = await EM.getModulesData(context, widget.instanceUrl, entityId.trim());
    if (moduleAssetModel.response.status == 'ok') {
      moduleAssets[index] = await moduleAssetModel;
    }
    return await true;
  }
}

class SelectedModule {
  final String id;
  final String name;
  SelectedModule(this.id, this.name);
}
