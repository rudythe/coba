import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sahabatjaya/services/srv_login.dart';

import 'package:sahabatjaya/widgets/basics/basic_widgets.dart';
import 'package:sahabatjaya/viewmodels/vm_barang.dart';

class TabListBarang extends StatelessWidget {
  final double itemHeight = 200;
  final double titleHeight = 30;

  _getOrder(BuildContext context, int idxTipe, int idxBarang) {
    ViewModelBarang vm = Provider.of<ViewModelBarang>(context, listen: false);
    if ((vm.listTipe[idxTipe].listBarang[idxBarang].jumorder==0)) {
      return GestureDetector(
        onTap: () {
          vm.addOrder(vm.listTipe[idxTipe].listBarang[idxBarang]);
        },
        child: RoundedContainer(
//          backgroundColor: Colors.transparent,
          color: Theme.of(context).buttonColor,
          child: Text('Pesan',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (!vm.subOrder(vm.listTipe[idxTipe].listBarang[idxBarang])) {
                final snackBar = SnackBar(
                  content: Text('Barang ini sudah dibuatkan nota, tidak bisa dikurangi'),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            child: RoundedContainer(
              padding: EdgeInsets.all(4),
              radius: 20,
              color: Theme.of(context).buttonColor,
              child: Icon(Icons.remove,
                color: Colors.blue,
                size: 16,
              ),
            ),
          ),
          Text(NumberFormat(" #,##0.## ").format(vm.listTipe[idxTipe].listBarang[idxBarang].jumorder),),
          GestureDetector(
              onTap: () => vm.addOrder(vm.listTipe[idxTipe].listBarang[idxBarang]),
              child: RoundedContainer(
                padding: EdgeInsets.all(4),
                radius: 20,
                color: Theme.of(context).buttonColor,
                child: Icon(Icons.add,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
            ),
          ],
      );
    }
  }

  Widget _getDetailBarang(BuildContext context, int idxTipe, int idxBarang) {
    ViewModelBarang vm = Provider.of<ViewModelBarang>(context, listen: false);
    return RoundedContainer(
      color: (vm.listTipe[idxTipe].listBarang[idxBarang].jumorder > 0) ?
        Theme.of(context).highlightColor : null,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.all(2.0),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>
            [
              Text(
                vm.listTipe[idxTipe].listBarang[idxBarang].ukuran.toString(),
                textAlign: TextAlign.left,
              ),
              Text(NumberFormat("#,##0.##").format(vm.listTipe[idxTipe].listBarang[idxBarang].harga)),
            ],
          ),
          _getOrder(context, idxTipe, idxBarang),
        ],
      ),
    );
  }

  Widget _getDetailTipe(BuildContext context, int idx) {
    ViewModelBarang vm = Provider.of<ViewModelBarang>(context, listen: false);
    return Expanded (
      child: Container(
        height: itemHeight - titleHeight,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ListView.builder(
            itemCount: vm.listTipe[idx].listBarang.length,
            itemBuilder: (context, i)  {
              return _getDetailBarang(context, idx, i);
            },
          ),
        ),
      ),
    );
  }

  Widget _getTipeBarang(BuildContext context, int i) {
    ViewModelBarang vm = Provider.of<ViewModelBarang>(context, listen: false);
    return ItemImage(
      imagePath: 'https://shbjaya.s3.ap-northeast-2.amazonaws.com/Nice+Sunset.jpg',
      imageHeight: itemHeight,
      titleHeight: titleHeight,
      title: vm.listTipe[i].tipe.nama,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('TAB LIST BARANG');
    return Container(
      child: ChangeNotifierProvider<ViewModelBarang>(
        create: (context) => ViewModelBarang(Provider.of<UserProvider>(context, listen: false)),
        child: Consumer<ViewModelBarang>(
          builder: (context, barang, child) {
            print(barang);
            print('create cosnsumer');
            ScrollController _scrollController = ScrollController();
            _scrollController.addListener(() {
              if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
                Provider.of<ViewModelBarang>(context).loadMore();
              }
            });
            return ListView.builder(
              itemCount: barang.listTipe.length,
              itemBuilder: (context, i) {
                return Text('dfadfadsf');
              },
              // controller: _scrollController,
              // itemCount: barang.listTipe.length,
              // itemBuilder: (context, i) {
              //   return Card(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 4.0),
              //         child: Row(
              //           children: <Widget>[
              //             _getTipeBarang(context, i),
              //             _getDetailTipe(context, i),
              //           ],
              //         ),
              //       ),
              //     );
              //   }
            );
          }
        ),
      ),
    );
  }
}