import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTeamMember extends StatefulWidget {
  @override
  _AddTeamMemberState createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  String _selectedIndex;
  List<String> workspaces = [];
  userWorkspaces hitTracker;

  @override
  void initState() {
    hitTracker = Provider.of<userWorkspaces>(context, listen: false);
    hitTracker.names.forEach((element) {
      workspaces.add(element);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: new AppBar(
          title: new Text("Add User to Workspace"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        backgroundColor: Color(0xff0c223a),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25),
                _workspaceInDropdown(hitTracker),
                SizedBox(height: 10),
                _memberNameTextField(),
                SizedBox(height: 5),
                addUserButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addUserButton() {
    return Container(
      margin: EdgeInsets.only(right: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: Text("Add User"),
            onPressed: () => print(""),
          ),
        ],
      ),
    );
  }

  Widget _workspaceInDropdown(userWorkspaces hitTracker) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
        color: Color(0xff384964),
      ),
      margin: EdgeInsets.symmetric(horizontal: 3),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton(
        hint: Text(
          "Select workspace",
          style: TextStyle(color: Colors.grey, fontSize: 16),
          softWrap: true,
        ),
        dropdownColor: Color(0xff384964),
        items: workspaces.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        value: _selectedIndex,
        underline: Container(),
        isExpanded: true,
      ),
    );
  }

  Widget _memberNameTextField() {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
      ),
      child: Theme(
        data: ThemeData(
          primaryColor: Color(0xff0c223a),
          primaryColorDark: Color(0xff0c223a),
          accentColor: Color(0xff0c223a),
        ),
        child: TextField(
          style: TextStyle(fontSize: 16, color: Colors.black),
          keyboardType: TextInputType.text,
          cursorColor: Color(0xff237C9C),
          decoration: InputDecoration(
            hintText: 'Name',
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white),
            ),
            filled: true,
            fillColor: Color(0xff384964),
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }
}
