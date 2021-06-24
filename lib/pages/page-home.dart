import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sahabatjaya/pages/homes/tab_list_barang.dart';
import 'package:sahabatjaya/pages/homes/tab_list_history.dart';
import 'package:sahabatjaya/pages/homes/tab_list_pesanan.dart';
import 'package:sahabatjaya/widgets/basics/basic_widgets.dart';
import 'package:sahabatjaya/widgets/drawers/drawer_main.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.judul}) : super(key: key);
  final String judul;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _tabList = [
    'Daftar Barang',
    'Daftar Pesanan',
    'History Pesanan',
  ];

  int _selectedIndex = 0;

  BottomNavigationBarItem _buildTab(int idx) {
    return BottomNavigationBarItem (
      icon: Icon(Icons.home),
      title: Text(
        _tabList[idx],
      ),
      backgroundColor: Colors.red,
    );
  }

  List<BottomNavigationBarItem> _itemList = [];

  @override
  void initState() {
    _itemList = _tabList.asMap().entries.map((MapEntry map) => _buildTab(map.key)).toList();
    super.initState();
  }

  Widget _getCurrentTab(int idx) {
    switch (idx) {
      case 1: return TabListPesanan();
      case 2: return TabListHistory();
      default: return TabListBarang();
    }
  }

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Creating HOME PAGE");
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: ChangeNotifierProvider<DrawerItemProvider>(
        create: (context) => DrawerItemProvider(),
        child: DrawerMain(
        ),
      ),
      appBar: AppBar(
        title: Text('SAHABAT JAYA'),
        actions: <Widget>[
        ],
        toolbarOpacity: 0.8,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _itemList,
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColorLight,
        onTap: _itemTapped,
      ),
      body: _getCurrentTab(_selectedIndex),
    );
  }
}
