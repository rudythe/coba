import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahabatjaya/services/srv_login.dart';

class TabListHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Center(
        child: RaisedButton(
          onPressed: () {
            Provider.of<UserProvider>(context).logOut(false);
          },
          child: Text('Log Out'),
        ),
      ),  
    );
  }
}