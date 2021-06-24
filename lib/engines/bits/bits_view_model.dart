import 'package:flutter/material.dart';
import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:sahabatjaya/engines/bits/bits_filter.dart';

abstract class BitsViewModel<E> extends ChangeNotifier {
  Map<String, ValueKeyFilter> searchFieldList = {};
  Map<String, ValueKeyFilter> entryFieldList = {};
  Map<String, String> validatingField = {};
  BitsFilter filter = BitsFilter();
//  BitsFilter filterSearch = BitsFilter();

  List<E> listData = List<E>();
  SnackBar snackBar = SnackBar(content: Text("message"));
  bool isLoading;
  String resultMessage;
  bool isError;
  int index;

  // Untuk mengambil data dari Model ke Filter
//    void _updateFilterData(BitsFilter curFilter, bool isKey, bool updateData) {
  void _updateFilterData(bool updateData) {
    filter.datas.forEach((key, value) {
      value.updateData(0, curData: (updateData) ? getDataField(key) : null, curOpr: CLIST_CONDITION_STR[2]);
    });
  }

  bool _isEmptyDatakey(
      {@required String nField,
        String errorText = "Data Kosong",
        bool isSearch = false,
        BitsFilter outSource}) {
    bool hasil = false;

    BitsFilter tmpFilter = (outSource == null) ? this.filter : outSource;
    hasil = tmpFilter.isEmptyController(nField, errorText);
    return hasil;
  }

  // == FUNCTION YANG DIGUNAKAN DI DETAIL, UNTUK NAVIGASI DATA == //
  bool nextDetail() {
    if (this.index < this.listData.length - 1) {
      this.index++;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  bool prevDetail() {
    if (this.index > 0) {
      this.index--;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  bool resetIndex() {
    bool hasil = true;
    if (this.listData.length == 1) {
      return false;
    } else if (this.index >= listData.length - 1) {
      index = listData.length - 2;
      // vmDet.prevDetail();
    }
    return hasil;
  }

  // == FUNCTION YANG DIGUNAKAN DI BITS WIDGET UNTUK MANIPULASI DATA (SEARCH, ADD, EDIT, DELETE) == //
  void setFieldFilterSearch() {
    filter.copyFieldList(filter.keys, searchFieldList);
  }

  void setFieldFilterInput() {
    filter.copyFieldList(filter.datas, entryFieldList);
    _updateFilterData(false);
  }

  void setFieldFilterUpdate() {
    entryFieldList["kode"].isEnable = false;
    filter.copyFieldList(filter.datas, entryFieldList);
    _updateFilterData(true);
  }

  Future addDataList() async {
    await addItem();
    if (!isError) getList();
  }

  Future updateDataList() async {
    filter.datas.forEach((key, value) {
      setDataField(key, value.data[0].data);
    });
    notifyListeners();
    await updateItem();
    if (isError) getList();
  }

  Future deleteDataList() async {
    listData.removeAt(index);
    notifyListeners();
    await deleteItem();
    if (isError) getList();
  }

  Future updateSearchList(BitsFilter sourceFilter) async {
    filter.copyFieldList(searchFieldList, sourceFilter.keys);
    getList();
  }

  // Digunakan BITS Widget untuk validasi data input (must have item)
  bool validateInputData({BitsFilter sourceFilter}) {
    bool res = true;
    setDefFilterAngka(isSearch: false, outSource: sourceFilter);
    validatingField.forEach((key, value) {
      res = res && !_isEmptyDatakey(nField: key, errorText: value, isSearch: false, outSource: sourceFilter);
    });
    if (!res) sourceFilter.notifyListeners();
    return res;
  }

  bool validateSearchData({BitsFilter sourceFilter}) {
    setDefFilterAngka(isSearch: false, outSource: sourceFilter);
    return true;
  }
//  void setAwalMainDataFilter(
//      {@required String title,
//      @required String nTable,
//      int limit = 100,
//      int offset = 0,
//      String orderBy = ""}) {
//    filter.title = title;
//    filter.ntabel = nTable;
//    filter.limit = limit;
//    filter.offset = offset;
//    filter.orderby = orderBy;
//
//    filterSearch.title = filter.title;
//    filterSearch.ntabel = filter.ntabel;
//    filterSearch.limit = filter.limit;
//    filterSearch.offset = filter.offset;
//    filterSearch.orderby = filter.orderby;
//  }
//

  //FUNCTION YANG DIGUNAKAN DI TURUNAN DLL
  void setSnackBar(String message) async {
    snackBar = SnackBar(content: Text(message));
  }

  //Untuk membuat daftar field yang digunakan untuk filter search dan data
  void addFieldList(String nField, int jenisWidget, dynamic defValue, bool isKey, bool isData) {
    searchFieldList.putIfAbsent(nField, () => ValueKeyFilter(
      jenisWidget: jenisWidget,
      isVisible: isKey,
      data: [
        DataKey(
          data: defValue.toString(),
          opr: ((jenisWidget == CJENIS_FILTER_INT) || (jenisWidget == CJENIS_FILTER_DOUBLE)) ? CLIST_CONDITION_ANGKA[0] : CLIST_CONDITION_STR[0],
          operand: "AND",
        ),
      ],
    ),);
//    if (isData) entryFieldList.putIfAbsent(nField, () => ValueKeyFilter(
    entryFieldList.putIfAbsent(nField, () => ValueKeyFilter(
      jenisWidget: jenisWidget,
      isVisible: isData,
      data: [
        DataKey(
          data: defValue.toString(),
          opr: ((jenisWidget == CJENIS_FILTER_INT) || (jenisWidget == CJENIS_FILTER_DOUBLE)) ? CLIST_CONDITION_ANGKA[0] : CLIST_CONDITION_STR[0],
          operand: "AND",
        ),
      ],
    ),);
  }

  // Set List Field dan data yang akan digunakan untuk Input ke API
  void setKeyFilterInput(List<String> fields) {
    filter.keys.clear();
    fields.forEach((nField) {
      filter.addDataMap(nField: nField, isKey: true, data: filter.datas[nField].data[0].data, opr: "=");
    });
  }

  // Set List Field dan data yang akan digunakan untuk Update ke API
  void setKeyFilterUpdate(List<String> fields) {
    filter.keys.clear();
    fields.forEach((nField) {
      filter.addDataMap(nField: nField, isKey: true, data: getDataField(nField), opr: "=");
    });
  }

  // Set List Field dan data yang akan digunakan untuk Delete ke API
  void setKeyFilterDelete(List<String> fields) {
    filter.keys.clear();
    fields.forEach((nField) {
      filter.addDataMap(nField: nField, isKey: true, data: getDataField(nField), opr: "=");
    });
  }

  setDefFilterAngka({bool isSearch = false, BitsFilter outSource}) {
    BitsFilter tmpFilter = (outSource == null) ? this.filter : outSource;

    if (isSearch) {
      tmpFilter.keys.forEach((key, value) {
        value.setDefFilterAngka();
      });
    } else {
      tmpFilter.datas.forEach((key, value) {
        value.setDefFilterAngka();
      });
    }
  }

  // Untuk mendapatkan data dari Model
  dynamic getDataField(String nField);

  // Untuk set data ke Model
  void setDataField(String nField, dynamic data);

  // Akses API untuk ambil data
  Future<void> getList();

  // Akses API untuk tambah data
  Future addItem();

  // Akses API untuk ubah data
  Future updateItem();

  // Akses API untuk hapus data
  Future deleteItem();
}
