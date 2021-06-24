import 'dart:convert';

import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:flutter/material.dart';
import 'package:sahabatjaya/engines/common_function.dart';

// import 'common_function.dart';

enum JenisFilter { tanggal, angka, string }

class DataKey {
  String data = "";
  String opr = "=";
  String operand = 'AND';
  String errorText = "";
  TextEditingController controller = TextEditingController();

  DataKey({this.data, this.opr, this.operand});

  factory DataKey.fromJson(Map<String, dynamic> json) {
    return DataKey(
        data: json["data"], opr: json["opr"], operand: json["operand"]);
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        "opr": opr,
        "operand": operand,
      };

  Map<String, dynamic> toJsonAPI(int jenisWidget) {
    Map<String, dynamic> hasil = Map<String, dynamic>();
    String tmpOpr = opr;
    String tmpData = data;

    // bool isAddList = true;

    if (jenisWidget == CJENIS_FILTER_STRING) {
      if (opr == CLIST_CONDITION_STR[0]) {
        tmpOpr = 'like';
        tmpData = data + '%';
      } else if (opr == CLIST_CONDITION_STR[1]) {
        tmpOpr = 'like';
        tmpData = '%' + data + '%';
      } else if (opr == CLIST_CONDITION_STR[2]) {
        tmpOpr = '=';
        tmpData = data;
      } else {
        tmpOpr = '=';
        tmpData = data;
      }
    }
    // else if (jenisWidget == CJENIS_FILTER_LIST_INT) {
    //   if (data == "-1") {
    //     isAddList = false;
    //   }
    // }

    // if (isAddList) {
    hasil.addAll({
      "data": tmpData,
      "opr": tmpOpr,
      "operand": operand,
    });
    // } else {
    //   hasil = null;
    // }

    return hasil;
  }

//  bool isEmptyController(String errorText) {
//    bool res = false;
//    if (this.controller.text.isEmpty) {
//      res = true;
//      print('empty');
//      this.errorText = errorText;
//    }
//    return res;
//  }
}

class ValueKeyFilter {
  List<DataKey> data;
  int jenisWidget;
  String titleWidget;
  String hintWidget;
  bool isVisible;
  bool isEnable;
  Map<String, String> list = Map<String, String>();

  ValueKeyFilter({
    this.jenisWidget,
    this.titleWidget,
    this.hintWidget,
    this.data,
    this.isVisible = true,
    this.isEnable = true,
    // this.list = const{}
  });

  factory ValueKeyFilter.fromJson(Map<String, dynamic> json) {
    List<DataKey> fromJSON(Iterable json) =>
        json.map((dataKey) => DataKey.fromJson(dataKey)).toList();

    ValueKeyFilter valueKeyFilter = ValueKeyFilter(
        jenisWidget: json["jenisWidget"],
        titleWidget: json["titleWidget"],
        hintWidget: json["hintWidget"],
        isVisible: json["isVisible"],
        isEnable: json["isEnable"],
        // list: tmplits,
        data: fromJSON(json["data"]));

    json["list"].forEach((k, v) {
      valueKeyFilter.list.addAll({k: v});
    });

    return valueKeyFilter;
  }

  Map<String, dynamic> toJson() => {
        "list": list,
        "data": data,
        "jenisWidget": jenisWidget,
        "titleWidget": titleWidget,
        "hintWidget": hintWidget,
        "isVisible": isVisible,
        "isEnable": isEnable,
      };

  Map<String, dynamic> toJsonAPI() {
    Map<String, dynamic> hasil = Map<String, dynamic>();
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>();
    data.forEach((element) {
      if (!((element.data == "-1") &&
          (jenisWidget == CJENIS_FILTER_LIST_INT))) {
        list.add(element.toJsonAPI(jenisWidget));
      }
    });

    hasil.addAll({"data": list});
    return hasil;
  }

  void setDefFilterAngka() {
    if (this.jenisWidget == CJENIS_FILTER_INT) {
      this.data.forEach((element) {
        if (element.controller.text.isEmpty) {
          element.controller.text = "0";
        }
      });
    } else if (this.jenisWidget == CJENIS_FILTER_DOUBLE) {
      this.data.forEach((element) {
        if (element.controller.text.isEmpty) {
          element.controller.text = "0.0";
        }
      });
    }
  }

  void delData(int posData) => data.removeAt(posData);

  void updateData(int posData,
      {dynamic curData, String curOperand, String curOpr}) {
    print('update data: ' +
        data[posData].data.toString() +
        ' ke ' +
        curData.toString());
    data[posData].data =
        (curData != null) ? curData.toString() : data[posData].data;
    data[posData].operand =
        (curOperand != null) ? curOperand : data[posData].operand;
    data[posData].opr = (curOpr != null) ? curOpr : data[posData].opr;
  }

  void addData(String curData, String curOperand, String curOpr) {
    data.add(DataKey(data: curData, opr: curOpr, operand: curOperand));
  }
}

class BitsFilter extends ChangeNotifier {
  String title;
  String ntabel;
  String orderby;
  String groupby;
  List<String> showField;
  int limit;
  int offset;

  Map<String, ValueKeyFilter> keys = Map<String, ValueKeyFilter>();
  Map<String, ValueKeyFilter> datas = Map<String, ValueKeyFilter>();

  BitsFilter({
    this.title = "",
    this.ntabel = "",
    this.orderby = "",
    this.groupby = "",
    this.showField,
    this.limit = 100,
    this.offset = 0,
  });

  factory BitsFilter.fromJson(Map<String, dynamic> json) {
    BitsFilter hasil = BitsFilter(
      title: json["title"],
      ntabel: json["LNamaTabel"],
      orderby: json["LOrderBy"],
      groupby: json["LGroupBy"],
      limit: json["LLimit"],
      offset: json["LOffset"],
      showField: json["LShowField"],
      //     ntabel; json["ntabel"],
    );

    json["LKey"].forEach((k, v) {
      hasil.keys.addAll({k: ValueKeyFilter.fromJson(v)});
    });

    json["LData"].forEach((k, v) {
      hasil.datas.addAll({k: ValueKeyFilter.fromJson(v)});
    });

    return hasil;
  }

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "LNamaTabel": ntabel,
        "LLimit": limit,
        "LOffset": offset,
        "LOrderBy": orderby,
        "LGroupBy": groupby,
        "LShowField": showField,
        "LKey": keys,
        "LData": datas,
      };

  Map<String, dynamic> toJsonAPI() =>
      {
        "title": title,
        "LNamaTabel": ntabel,
        "LLimit": limit,
        "LOffset": offset,
        "LOrder": orderby,
        "LGroup": groupby,
        "LNamaField": showField,
        "LKey": _toJsonAPIFilter(keys),
        "LData": _toJsonAPIFilter(datas),
      };

  BitsFilter cloneFilter() {
    BitsFilter newFilter = BitsFilter(
        title: this.title,
        ntabel: this.ntabel,
        orderby: this.orderby,
        groupby: this.groupby,
        limit: this.limit,
        offset: this.offset);
    jsonDecode(jsonEncode(this.keys)).forEach((k, v) {
      newFilter.keys.addAll({k: ValueKeyFilter.fromJson(v)});
    });
    newFilter.datas.clear();
    jsonDecode(jsonEncode(this.datas)).forEach((k, v) {
      newFilter.datas.addAll({k: ValueKeyFilter.fromJson(v)});
    });
    return newFilter;
  }

  void copyFieldList(Map<String, ValueKeyFilter> destField,
      Map<String, ValueKeyFilter> sourceField) {
    destField.clear();
    jsonDecode(jsonEncode(sourceField)).forEach((k, v) {
      destField.addAll({k: ValueKeyFilter.fromJson(v)});
    });
  }

  updateWidget(
      {@required String nField,
      String hint = "",
      String title = "",
      int jenisWidget = -1}) {
    // int posMap = getPosMap(key: nField);
    if (hint.isNotEmpty) this.keys[nField].hintWidget = hint;
    if (title.isNotEmpty) this.keys[nField].titleWidget = hint;
    if (jenisWidget != -1) this.keys[nField].jenisWidget = jenisWidget;

    notifyListeners();
  }

  deleteMaps(
      {@required String nField, @required int posData, @required bool isKey}) {
    (isKey)
        ? this.keys[nField].delData(posData)
        : this.datas[nField].delData(posData);
    notifyListeners();
  }

  updateDataMaps(
      {@required String nField,
      String data = "",
      String opr = "=",
      String operand = "AND",
      @required int posData,
      @required bool isKey}) {
    (isKey)
        ? this.keys[nField].updateData(posData,
            curData: data, curOperand: operand, curOpr: opr)
        : this.datas[nField].updateData(posData,
            curData: data, curOperand: operand, curOpr: opr);
    notifyListeners();
  }

  addDataMap(
      {@required String nField,
      int jenisWidget = CJENIS_FILTER_STRING,
      String titleWidget = "Title",
      String hintWidget = "Masukan title",
      String data = "",
      String opr = "=",
      String operand = "AND",
      Map<String, String> list,
      // Map<String, String> list = finalMap<String, String>(),
      @required bool isKey}) {
    Map<String, ValueKeyFilter> map = (isKey) ? this.keys : this.datas;

    if (list == null) {
      list = Map<String, String>();
    }

    // if (isKey) {
    if (data.isEmpty) {
      if (jenisWidget == CJENIS_FILTER_TANGGAL) {
        data = dateToStr(DateTime.now());
      } else if (jenisWidget == CJENIS_FILTER_INT) {
        data = "0";
      } else if (jenisWidget == CJENIS_FILTER_LIST_INT) {
        data = "-1";
        operand = "OR";
      }
    }
    // }

    if (!isKey) {
      operand = "";
      opr = "";
    }

    map.putIfAbsent(nField, () {
      return ValueKeyFilter(
          data: [],
          hintWidget: hintWidget,
          titleWidget: titleWidget,
          jenisWidget: jenisWidget);
    }).addData(data, operand, opr);

    notifyListeners();
  }

//  void setFilterFromJson({Map<String, dynamic> mapData, bool isKey = true}) {
//    Map<String, ValueKeyFilter> mapSource = isKey ? keys : datas;
//    mapSource.clear();
//    // bool isKey = true;
//    mapData.forEach((key, value) {
//      ValueKeyFilter tmpVal = ValueKeyFilter(
//        jenisWidget: value["jenisWidget"],
//        isVisible: isKey ? value["visKey"] : value["visData"],
//        data: [
//          DataKey(
//            data: _getDataValue(
//                data: value["data"], jenisWidget: value["jenisWidget"]),
//            opr: isKey ? value["opr"] : "",
//            operand: value["operand"],
//          ),
//        ],
//      );
//      tmpVal.list = value["list"] as Map<String, String>;
//      mapSource.putIfAbsent(
//        key,
//        () => tmpVal,
//      );
//      // addKeysFilter(nField: key, data: value["data"], jenisWidget: value["jenis"]);
//    });
//  }

  getWidgetData({@required bool isKey}) {
    Map<String, ValueKeyFilter> map = (isKey) ? this.keys : this.datas;
    map.forEach((key, value) {
      value.data.forEach((element) {
        element.data = element.controller.text;
      });
    });
  }

  updateWidgetOpr({@required DataKey data, @required String value}) {
    data.opr = value;
    notifyListeners();
  }

  updateWidgetData({@required DataKey data, @required String value}) {
    data.data = value;
    data.controller.text = value;
    notifyListeners();
  }

  updateFilter({@required BitsFilter src}) {
    updateFilterDatas(src: src);
    updateFilterKeys(src: src);
  }

  updateFilterKeys({@required BitsFilter src}) {
    this.keys.clear();
    jsonDecode(jsonEncode(src.keys)).forEach((k, v) {
      this.keys.addAll({k: ValueKeyFilter.fromJson(v)});
    });
  }

  updateFilterDatas({@required BitsFilter src}) {
    this.datas.clear();
    jsonDecode(jsonEncode(src.datas)).forEach((k, v) {
      this.datas.addAll({k: ValueKeyFilter.fromJson(v)});
    });
  }

  setAwalFilterSearch() {
    this.keys.forEach((key, value) {
      value.data.forEach((element) {
        element.controller.text = element.data;
      });
    });
  }

  setAwalFilterInput() {
    // this.datas.clear();
    this.datas.forEach((key, value) {
      value.data.forEach((element) {
        element.controller.text = "";
        element.data = "";
      });
    });
  }

  setAwalFilterUpdate() {
    this.datas.forEach((key, value) {
      value.data.forEach((element) {
        element.controller.text = element.data;
      });
    });
  }

  bool isEmptyController(String nField, String errorText) {
    bool res = false;
    this.datas[nField].data[0].errorText = "";
    if (this.datas[nField].data[0].controller.text.isEmpty) {
      res = true;
      this.datas[nField].data[0].errorText = errorText;
    }
    return res;
  }

  Map<String, dynamic> _toJsonAPIFilter(Map<String, ValueKeyFilter> map) {
    Map<String, dynamic> hasil = Map<String, dynamic>();
    map.forEach((key, value) {
      hasil.addAll({key: value.toJsonAPI()});
    });

    return hasil;
  }
//  void setKeyFilterInput(List<String> fields) {
//    this.keys.clear();
//    fields.forEach((nField) {
//      this.addDataMap(nField: nField, isKey: true, data: this.datas[nField].data[0].data, opr: "=");
//    });
//  }
//
//  void setKeyFilterUpdate(List<String> fields) {
//    setKeyFilterInput(fields);
//  }
//
//  void setKeyFilterDelete(List<String> fields, List<String> datas) {
//    this.keys.clear();
//    for (int i = 0; i < fields.length - 1; i++) {
//      this.addDataMap(nField: fields[i], isKey: true, data: datas[i], opr: "=");
//    }
////    this.addDataMap(nField: nField, data: data, opr: "=", isKey: true);
//  }

//  String _getDataValue({var data, int jenisWidget}) {
//    String hasil;
//    if (jenisWidget == CJENIS_FILTER_INT) {
//      hasil = data.toString();
//    } else if (jenisWidget == CJENIS_FILTER_DOUBLE) {
//      hasil = toDoubel(data);
//    } else {
//      hasil = data;
//    }
//    return hasil;
//  }

}
