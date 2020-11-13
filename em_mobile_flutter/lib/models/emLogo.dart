import 'package:flutter/material.dart';
import 'dart:math';
//Mando - Oct 14th 2020
class EmLogo extends StatelessWidget {
  const EmLogo();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.table_rows_rounded,
            color: Color(0xff61af56),
            size: 66.0,
          ),
          Transform.rotate(
            angle: 90 * pi / 180,
            child: Icon(
              Icons.table_rows_rounded,
              color: Color(0xff61af56),
              size: 66.0,
            ),
          )
        ],
      ),
    );
  }
}
