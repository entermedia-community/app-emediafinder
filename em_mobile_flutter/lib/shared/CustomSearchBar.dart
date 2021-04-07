import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final BuildContext context;
  CustomSearchBar(this.controller, this.onChanged, this.context);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: 80,
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    hintText: "Search your media...",
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
      ],
    );
  }
}
