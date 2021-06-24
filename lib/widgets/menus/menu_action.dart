import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionItem {
  String title;
  GestureTapCallback onSelect;

  ActionItem({@required this.title, @required this.onSelect});

  void callOnSelect() => onSelect();
}

class ViewModelAction extends ChangeNotifier {
  bool opened = false;

  void toggleStatus() async {
    opened = !opened;
    notifyListeners();
    if (opened) {
      await Future.delayed(Duration(seconds: 2));
      if (opened) {
        opened = false;
        notifyListeners();
      }
    }
  }
}

class ActionMenu extends StatelessWidget {
  List<ActionItem> actions = List();
  ActionMenu({this.actions}) {
  }

  List<Widget> _actionList(BuildContext context) {
    List<Widget> list = [];
    ViewModelAction options = Provider.of<ViewModelAction>(context);
    if (options.opened) {
      for (int i = 0; i < actions.length; i++) {
        list.add(
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () {
                actions[i].callOnSelect();
              },
              child: Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Theme.of(context).indicatorColor,
                label: Text(actions[i].title),
              ),
            ),
          ),
        );
      }
    }
    list.add(
      InkWell(
        onTap: () => Provider.of<ViewModelAction>(context, listen: false).toggleStatus(),
        child: Chip(
          backgroundColor: Theme.of(context).indicatorColor,
          label: Icon(
            Icons.more_vert,
            size: 22.0,
          ),
        ),
      ),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewModelAction(),
      child: Consumer<ViewModelAction>(
        builder: (context, act, child) => Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _actionList(context),
          ),
        ),
      ),
    );
  }
}
