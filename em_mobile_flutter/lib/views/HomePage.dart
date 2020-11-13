import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EntermediaDB'),
      ),
      body: Center(
        child: Column(
          children:[
            Text("La Casa"),
            RaisedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}