import 'package:flutter/material.dart';

class PageTest extends StatefulWidget {
  @override
  _PageTestState createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: <Widget>[
            Text('Test'),
            RaisedButton(
              child: Text('Load Item'),
              onPressed: () {
                print('keyPress');
              },
            ),
            ListView (
              children: <Widget>[
                Text('Line 1'),
                Text('Line 2'),
                Text('Line 3'),
              ],
            )
          ]
      ),
    );
  }
}
