// import 'dart:js';

import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:sahabatjaya/engines/bits/bits_view_model.dart';
import 'package:sahabatjaya/engines/bits/bits_filter.dart';
import 'package:sahabatjaya/engines/common_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatelessWidget {
  BitsFilter curFilter;
  final BitsViewModel mainVM;
  // BitsFilter mainFilter;

  FilterPage(this.mainVM) {
    if (mainVM.filter.keys.length == 0) mainVM.setFieldFilterSearch();
    curFilter = mainVM.filter.cloneFilter();
    curFilter.setAwalFilterSearch();
  }

  _iconDelete({String nField, int pos, BuildContext context}) {
    return IconButton(
      icon: Icon(Icons.delete),
      tooltip: 'Hapus',
      onPressed: () {
        Provider.of<BitsFilter>(context, listen: false)
            .deleteMaps(nField: nField, posData: pos, isKey: true);
      },
    );
  }

  _dropDownListInt({DataKey item, Map<String, String> map, BuildContext context}) {
    List<DropdownMenuItem<String>> list = List<DropdownMenuItem<String>>();
    map.forEach((key, value) { 
      list.add(DropdownMenuItem<String>(
            value: key,
            child: Text(value),
          ));
    });
        
    return Container(
      width: 90,
      child: DropdownButton(
        isExpanded: true,
        value: item.data,
        onChanged: (String newValue) {
          // item.data = newValue;
          Provider.of<BitsFilter>(context, listen: false)
              .updateWidgetData(data: item, value: newValue);
        },
        items: list,
//      items: ConditionStr.map<DropdownMenuItem<String>>((String value) {
        // items: list.map<DropdownMenuItem<String>>((String value) {
        //   return DropdownMenuItem<String>(
        //     value: value,
        //     child: Text(value),
        //   );
        // }).toList(),
      ),
    );
  }

  _dropDown({DataKey item, List<String> list, BuildContext context}) {
    return Container(
      width: 90,
      child: DropdownButton(
        isExpanded: true,
        value: item.opr,
        onChanged: (String newValue) {
          item.opr = newValue;
          Provider.of<BitsFilter>(context, listen: false)
              .updateWidgetOpr(data: item, value: newValue);
        },
//      items: ConditionStr.map<DropdownMenuItem<String>>((String value) {
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  _buildWidgetInput({String nField, int pos, BuildContext context}) {
    final jenis = Provider.of<BitsFilter>(context).keys[nField].jenisWidget;
    final item = Provider.of<BitsFilter>(context).keys[nField].data[pos];
    final mapList = Provider.of<BitsFilter>(context).keys[nField].list;
    // List<String> list = List();

    // mapList.forEach((key, value) { list.add(value); });

    if (jenis == CJENIS_FILTER_STRING) {
      return Row(
        children: <Widget>[
          // _dropDown(item: item, list ConditionStr, context, pos),
          _dropDown(context: context, item: item, list: CLIST_CONDITION_STR),
          Expanded(
            child: TextField(
              controller: item.controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                // labelText: 'Masukan $nField yang di cari',
                hintText: "Masukan $nField yang di cari",
                errorText: item.errorText.isEmpty ? null : item.errorText,
                // errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
          // _iconDelete(nField, pos, context),
          _iconDelete(context: context, nField: nField, pos: pos)
        ],
      );
    } else if (jenis == CJENIS_FILTER_INT) {
      return Row(
        children: <Widget>[
          // _dropDown(item, ConditionAngka, context),
          _dropDown(context: context, item: item, list: CLIST_CONDITION_ANGKA),
          Expanded(
            child: TextField(
              controller: item.controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Masukan $nField yang di cari',
                hintText: "Masukan $nField yang di cari",
                errorText: item.errorText.isEmpty ? null : item.errorText,
                // errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
          // _iconDelete(nField, pos, context),
          _iconDelete(context: context, nField: nField, pos: pos)
        ],
      );
    } else if (jenis == CJENIS_FILTER_TANGGAL) {
      return Row(
        children: <Widget>[
          // _dropDown(item, ConditionTgl, context),
          _dropDown(context: context, item: item, list: CLIST_CONDITION_TGL),
          Expanded(
            child: TextField(
              controller: item.controller,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                // labelText: 'Masukan $nField yang di cari',
                hintText: "Masukan $nField yang di cari",
                errorText: item.errorText.isEmpty ? null : item.errorText,
                // errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              onTap: () => {
                // showDatePicker(context: this, initialDate: null, firstDate: null, lastDate: null)
                showDatePicker(
                  context: context,
                  initialDate: strToDate(item.controller.text),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2101),
                ).then((date) => {
                      (date == null)
                          ? item.controller.text
                          : item.controller.text = dateToStr(date),
                      print(item.controller.text),
                    }),
              },
            ),
          ),
          // _iconDelete(nField, pos, context),
          _iconDelete(context: context, nField: nField, pos: pos)
        ],
      );
    } else if (jenis == CJENIS_FILTER_LIST_INT) {
      return Row(
        children: <Widget>[
          // _dropDown(item, ConditionAngka, context),
          _dropDown(context: context, item: item, list: CLIST_CONDITION_LIST_INT),
          Expanded(
            child: _dropDownListInt(context: context, item: item, map: mapList),
          ),
          // _iconDelete(nField, pos, context),
          _iconDelete(context: context, nField: nField, pos: pos)
        ],
      );
    } else {
      return Center(child: Text("Tipe Data yang di masukan Salah"));
    }
  }

  _buildListKeyData({MapEntry<String, ValueKeyFilter> mapField}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mapField.value.data.length,
      itemBuilder: (context, indexItem) {
        return _buildWidgetInput(
          nField: mapField.key,
          pos: indexItem,
          context: context,
        );
      },
    );
  }

  _buildKeyField(BitsFilter filter) {
    return Expanded(
      child: Container(
        // color: Colors.lime,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: filter.keys.length,
          itemBuilder: (context, index) {
            final mapField = filter.keys.entries.elementAt(index);
            if (mapField.value.isVisible) {
              return Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.amber,
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              mapField.key.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            FlatButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () => filter.addDataMap(
                                  nField: mapField.key, isKey: true, jenisWidget: mapField.value.jenisWidget),
                              child: Text("Tambah",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: 250),
                        child: _buildListKeyData(mapField: mapField),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _buildBottomContainer({BuildContext context}) {
    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            onPressed: () => {curFilter.notifyListeners()},
            child: Text('tesss'),
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          RaisedButton(
            onPressed: () => {
              if (mainVM.validateSearchData(sourceFilter: curFilter)) {
                curFilter.getWidgetData(isKey: true),
                mainVM.filter.updateFilterKeys(src: curFilter),
                mainVM.updateSearchList(curFilter),
                Navigator.pop(context, true),
              }
            },
            child: Text('Cari'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('=============================');
    print('Build Filter UI BOOOOSSS');
    return ChangeNotifierProvider.value(
      value: curFilter,
      child: Consumer<BitsFilter>(builder: (context, filter, child) {
        print('updated');
        return Scaffold(
          appBar: AppBar(title: Text("Filter ${filter.title}")),
          // body: Text('data'),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, false);
              print('will POP triggered');
              return false;
            },
            child: Column(
              children: <Widget>[
                // _buildKeyField(context),
                _buildKeyField(curFilter),
                _buildBottomContainer(context: context)
              ],
            ),
          ),
        );
      }),
    );
  }
}
