import 'package:em_mobile_flutter/models/emUser.dart';
import 'package:em_mobile_flutter/models/userData.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:em_mobile_flutter/services/authentication.dart';
import 'package:provider/provider.dart';

class NavMenu extends StatelessWidget {
  const NavMenu();

  @override
  Widget build(BuildContext context) {
    final myUser = Provider.of<userData>(context, listen: false);
    return Row(
      children: [
        Container(
          child: IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
        ),
      ],
    );
  }
}
