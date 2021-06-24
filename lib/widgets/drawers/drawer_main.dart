import 'package:provider/provider.dart';
import "package:flutter/material.dart";

import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:sahabatjaya/pages/page-home.dart';
import 'package:sahabatjaya/widgets/drawers/drawer_head.dart';

class DrawerItem {
  String title;
  IconData icon;
  IconData iconTrailing;
  bool divider;
  GestureTapCallback onSelect;

  DrawerItem({this.onSelect, this.title = 'Display Title', this.icon, this.iconTrailing, this.divider = false});
}

class DrawerItemProvider extends ChangeNotifier {
  final drawerItems = [
    DrawerItem(title: "Dashboard", icon: Icons.pageview, onSelect: () {}),
    DrawerItem(divider: true),
//    DrawerItem(title: MasterItemID,icon: Icons.info, widget: FrameBarang()),
//    DrawerItem(title: MasterCustomerID,icon: Icons.info, widget: FrameCustomer()),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
    DrawerItem(divider: true),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
    DrawerItem(title: "Contaier Fragment",icon: Icons.info),
  ];
  int selectedItem = 0;

//  getWidget() {
//    print('Get Widget ' + selectedItem.toString());
//    return (drawerItems[selectedItem].onSelect == null)?
//      Text(drawerItems[selectedItem].title): drawerItems[selectedItem].widget;
//  }

  String getTitle() => drawerItems[selectedItem].title;

  void updateIndex(int index) {
    this.selectedItem = index;
    print('Select Item ' + drawerItems[index].title);
    notifyListeners();
  }
}

class DrawerMain extends StatelessWidget {
  _drawerOptions (BuildContext context, DrawerItemProvider drawerItem) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItem.drawerItems.length; i++) {
      var d = drawerItem.drawerItems[i];
      // String name = d.name;
      if (d.divider == false) {
        drawerOptions.add(
            ListTile(
              leading: Icon(d.icon),
              title: Text(d.title),
              trailing: Icon(d.iconTrailing),
              selected: i == drawerItem.selectedItem,
              onTap: () {
                drawerItem.updateIndex(i);
                Navigator.of(context).pop();
//                Navigator.of(context).
              },
            )
        );
      } else {
        drawerOptions.add(
            Divider(color: Colors.red, thickness: 5.2)
        );
      }
    }
    return drawerOptions;
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<DrawerItemProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        children: <Widget>[
          drawerHeader(),
          Column(children: _drawerOptions(context, items)),
        ],
      ),
    );
  }
}