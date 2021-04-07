import 'package:em_mobile_flutter/models/createUserResponseModel.dart';
import 'package:em_mobile_flutter/models/userWorkspaces.dart';
import 'package:em_mobile_flutter/models/workspaceAssets.dart';
import 'package:em_mobile_flutter/services/entermedia.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddTeamMember extends StatefulWidget {
  final String instanceUrl;
  AddTeamMember(this.instanceUrl);

  @override
  _AddTeamMemberState createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  String _selectedIndex;
  List<String> workspaces = [];
  userWorkspaces hitTracker;
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 25),
                  // _workspaceInDropdown(hitTracker),
                  _memberTextField(
                    hintText: 'Name',
                    controller: nameController,
                    validatorIndex: 1,
                    isObscure: false,
                  ),
                  SizedBox(height: 10),
                  _memberTextField(
                    hintText: 'Email',
                    controller: emailController,
                    validatorIndex: 4,
                    isObscure: false,
                  ),
                  SizedBox(height: 10),
                  _memberTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    validatorIndex: 2,
                    isObscure: true,
                  ),
                  SizedBox(height: 10),
                  _memberTextField(
                    hintText: 'Confirm Password',
                    controller: confirmPasswordController,
                    validatorIndex: 3,
                    isObscure: true,
                  ),
                  SizedBox(height: 5),
                  addUserButton(),
                ],
              ),
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
            child: Text(
              "Add User",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff237C9C),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                FocusScope.of(context).unfocus();
                final EM = Provider.of<EnterMedia>(context, listen: false);
                CreateUserResponseModel data = await EM.createNewUser(
                  context,
                  widget.instanceUrl,
                  nameController.text,
                  passwordController.text,
                  emailController.text,
                );
                if (data.response.status == 'ok') {
                  Fluttertoast.showToast(
                    msg: "User created successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 10,
                    backgroundColor: Color(0xff61af56),
                    fontSize: 16.0,
                  );
                  nameController..text = '';
                  passwordController..text = '';
                  confirmPasswordController..text = '';
                  emailController..text = '';
                } else {
                  Fluttertoast.showToast(
                    msg: "Failed to create user. \nError: ${data.response.status}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 10,
                    backgroundColor: Color(0xff61af56),
                    fontSize: 16.0,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  //Validator index as : 1 - Name, 2 - password, 3 - Confirm Password
  Widget _memberTextField({String hintText, TextEditingController controller, int validatorIndex, bool isObscure}) {
    return TextFormField(
      obscureText: isObscure,
      controller: controller,
      style: TextStyle(fontSize: 16, color: Colors.white),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      cursorColor: Color(0xff237C9C),
      decoration: InputDecoration(
        labelText: '$hintText',
        labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 2,
            )
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white),
        ),
        filled: true,
        fillColor: Color(0xff384964),
        contentPadding: EdgeInsets.all(16),
      ),
      validator: validatorIndex == 1
          ? nameValidator
          : validatorIndex == 2
              ? passwordValidator
              : validatorIndex == 3
                  ? confirmPasswordValidator
                  : emailValidator,
    );
  }

  String nameValidator(String value) {
    if (value.isEmpty) {
      return "Name field can't be empty.";
    }
    return null;
  }

  String passwordValidator(value) {
    if (value.isEmpty) {
      return "Password field can't be empty.";
    }
    if (value.length < 8) {
      return "Password must be 8 characters long";
    }
    return null;
  }

  String confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return "Confirm Password field can't be empty.";
    }
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      return "Passwords do not match";
    }
    return null;
  }

  String emailValidator(value) {
    if (value.isEmpty) {
      return "Email field can't be empty.";
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return "Invalid email address.";
    }
    return null;
  }
}
