import 'package:flutter/foundation.dart';
import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:sahabatjaya/engines/bits/bits_filter.dart';
import 'package:sahabatjaya/engines/bits/bits_view_model.dart';
import 'package:sahabatjaya/models/barang.dart';
import 'package:sahabatjaya/services/api_bitsnode.dart';
import 'package:sahabatjaya/services/srv_login.dart';

class ViewModelBarang extends ChangeNotifier{
//  class ViewModelBarang extends BitsViewModel<Barang> {
  UserProvider user;
  List<GroupBarangDetail> listTipe = [];
  List<Barang> listData = [];
  String userMessage;
  int loaded = 0;
  // Map<String, Tipe> listTipe = Map();

  ViewModelBarang(UserProvider this.user) {
//    filter.ntabel = "m_item";
//    addFieldList("tableid", CJENIS_FILTER_STRING, "", true, true);
//    addFieldList("sjid", CJENIS_FILTER_STRING, "", true, true);
//    addFieldList("tipe", CJENIS_FILTER_STRING, "", true, true);
//    addFieldList("ukuran", CJENIS_FILTER_STRING, "", true, true);
//    addFieldList("kode", CJENIS_FILTER_STRING, "", true, true);
//    addFieldList("image", CJENIS_FILTER_STRING, "", true, true);
//    addFieldList("seri", CJENIS_FILTER_DOUBLE, "", true, true);
//    addFieldList("jumlah", CJENIS_FILTER_DOUBLE, "", true, true);
//    addFieldList("jumorder", CJENIS_FILTER_DOUBLE, "", true, true);
//    addFieldList("harga", CJENIS_FILTER_DOUBLE, "", true, true);
//    addFieldList("status", CJENIS_FILTER_INT, "", false, false);
    print("USERID: " + user.custID);
    getList();
  }

  getListBarang(List<GroupBarangDetail> curData) async {
//    this.filter.showField = ['i.*, ci.pesan, ci.jumlah as jumnota'];
//    this.filter.ntabel = 'm_item i left join m_customeritem ci on i.tableid = ci.itemid';
//    this.filter.orderby = "i.harga";
//    await Future.forEach(curData, (GroupBarangDetail group) async {
//      print('Get Detail' + group.tipe.nama);
//      this.filter.keys.clear();
//      this.filter.addDataMap(nField: "tipe", isKey: true, data: group.tipe.nama);
//      Map<String, dynamic> res = await APIBitsNode().getPost(this.filter);
    BitsFilter filter = BitsFilter (
      showField: ['i.*, coalesce(ci.pesan, 0) as pesan, coalesce(ci.jumlah, 0) as jumnota'],
      ntabel: "m_item i left join m_customeritem ci on i.tableid = ci.itemid and ci.custid = '" + user.custID + "'",
      orderby: "i.harga"
    );
    await Future.forEach(curData, (GroupBarangDetail group) async {
      filter.keys.clear();
      print('Get Detail' + group.tipe.nama);
      filter.addDataMap(nField: "tipe", isKey: true, data: group.tipe.nama);
//      filter.addDataMap(nField: "ci.custid", isKey: true, data: user.custID);
      Map<String, dynamic> res = await APIBitsNode(this.user).basicQueryShow(filter);
      print("Jum data Detail: " + res['jumlahData'].toString());
      group.addListBarang(barangFromJSON(res['isidata'], true));
      notifyListeners();
    });
  }

  loadMore() async {
    print('load more');
    BitsFilter filterGroup = BitsFilter(
      ntabel: 'm_item',
      showField: ["tipe"],
      groupby: "tipe",
      orderby: "Max(edittime) desc",
      limit: 5,
      offset: loaded,
    );

    Map res = await APIBitsNode(this.user).basicQueryShow(filterGroup);
    List<GroupBarangDetail> curData = groupBarangFromJSON(res['isidata']);
    listTipe.addAll(curData);
    print('DONE load barang: ' + res['jumlahData'].toString());
    this.loaded += res['jumlahData'];
//    listTipe.forEach((group) {
    getListBarang(curData);
  }

  updatePesanan(Barang barang) async {
    print('update Pesanan');
    BitsFilter tmpFilter = BitsFilter(
      ntabel: 'm_customeritem',
      showField: ["*"],
    );
    tmpFilter.addDataMap(nField: "custid", isKey: true, data: user.custID);
    tmpFilter.addDataMap(nField: "itemid", isKey: true, data: barang.tableid);
    tmpFilter.addDataMap(nField: "custid", isKey: false, data: user.custID);
    tmpFilter.addDataMap(nField: "itemid", isKey: false, data: barang.tableid);
    tmpFilter.addDataMap(nField: "pesan", isKey: false, data: barang.jumorder.toString());

    Map res = await APIBitsNode(this.user).postRequest(tmpFilter, '/bits/customer/pesan');
//    List<GroupBarangDetail> curData = groupBarangFromJSON(res['isidata']);
//    listTipe.addAll(curData);
    print('DONE update Pesanan: ');
//    this.loaded += res['jumlahData'];
//    listTipe.forEach((group) {
  }

  addOrder(Barang barang) {
//    print(barang.seri)
    barang.jumorder += barang.seri;
    notifyListeners();
    updatePesanan(barang);
  }

  bool subOrder(Barang barang) {
    if (barang.jumlah <= barang.jumorder - barang.seri) {
      barang.jumorder -= barang.seri;
      updatePesanan(barang);
      notifyListeners();
      return true;
    } else {
      userMessage = "Barang ini sudah dibuatkan nota, tidak bisa dikurangi";
      return false;
    }
  }
  @override
  Future<void> getList() async {
    print('load barang');
    this.loaded = 0;
    this.listTipe.clear();
    loadMore();

    notifyListeners();
  }

  Future<void> generateGroupTipe() async {
    Map<String, GroupBarangDetail> list = Map();
    for (var barang in listData) {
      var x = list.putIfAbsent(barang.tipe, () => GroupBarangDetail(GroupBarang(barang.tipe, barang.image)));
      x.addBarang(barang);      
    }
  }
}