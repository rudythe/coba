import 'package:flutter/material.dart';

class OptionItem {
  String title;
  GestureTapCallback onSelect;

  OptionItem({@required this.title, @required this.onSelect});

  void callOnSelect() => onSelect();
}

showOptionMenu({BuildContext context, String title = "OPTIONS", List<OptionItem> options = const []}) {
  _optionItem(BuildContext context, i) {
    return OutlineButton(
      onPressed: () {
        options[i].callOnSelect();
        Navigator.pop(context);
      },
      child: Text(options[i].title),
    );
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 180,
        child: Column(
          children: <Widget>[
            Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Card (
                child: ListView.builder (
                  itemCount: options.length,
                  itemBuilder: (context, i) => _optionItem(context, i),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

