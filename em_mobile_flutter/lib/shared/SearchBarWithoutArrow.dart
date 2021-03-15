import 'package:flutter/material.dart';

class SearchBarWithoutArrow extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final BuildContext context;
  final String entity;
  final Widget trailingWidget;
  SearchBarWithoutArrow({
    @required this.controller,
    @required this.onChanged,
    @required this.context,
    @required this.entity,
    @required this.trailingWidget,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 0, left: 2, right: 2),
            height: 80,
            child: Theme(
              data: ThemeData(
                primaryColor: Color(0xff0c223a),
                primaryColorDark: Color(0xff0c223a),
                accentColor: Color(0xff0c223a),
              ),
              child: TextFormField(
                style: TextStyle(fontSize: 17),
                controller: controller,
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
                    hintText: "Search $entity...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff92e184),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5)),
                keyboardType: TextInputType.emailAddress,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        Center(
          child: trailingWidget,
        ),
      ],
    );
  }
}
