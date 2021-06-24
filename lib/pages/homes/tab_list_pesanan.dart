import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sahabatjaya/models/barang.dart';
import 'package:sahabatjaya/services/srv_login.dart';
import 'package:sahabatjaya/viewmodels/vm_barang.dart';
import 'package:sahabatjaya/widgets/basics/basic_widgets.dart';

class TabListPesanan extends StatelessWidget {
  final double itemHeight = 100;
  final double titleHeight = 18;

  Widget _getDetailBarang(BuildContext context, int idxTipe, int idxBarang) {
    Barang barang = Provider.of<ViewModelBarang>(context, listen: false).listTipe[idxTipe].listBarang[idxBarang];
    return RoundedContainer(
      padding: EdgeInsets.all(1.0),
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              barang.ukuran.toString(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(NumberFormat("#,##0.##").format(barang.jumorder),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(NumberFormat(" x #,##0.##").format(barang.harga),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(NumberFormat(" x #,##0.##").format(barang.harga * barang.jumorder),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDetailTipe(BuildContext context, int idx) {
    ViewModelBarang vm = Provider.of<ViewModelBarang>(context, listen: false);
    return Expanded (
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        height: itemHeight - titleHeight,
        color: Colors.white,
        child: ListView.builder(
          itemCount: vm.listTipe[idx].listBarang.length,
          itemBuilder: (context, i)  {
            return _getDetailBarang(context, idx, i);
          },
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
    print('TAB PESANAN');
    return Container(
      child: ChangeNotifierProvider<ViewModelBarang>(
        create: (context) => ViewModelBarang(Provider.of<UserProvider>(context, listen: false)),
        child: Consumer<ViewModelBarang>(
            builder: (context, barang, child) {
              return ListView.builder(
                  itemCount: barang.listTipe.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            _getTipeBarang(context, i),
                            _getDetailTipe(context, i),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
        ),
      ),
    );
  }
}