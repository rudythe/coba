// import 'dart:js';

import 'dart:convert';

import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:sahabatjaya/engines/bits/bits_view_model.dart';
import 'package:sahabatjaya/engines/bits/bits_filter.dart';
import 'package:sahabatjaya/engines/common_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatelessWidget {
  BitsFilter curFilter;
  final BitsViewModel mainVM;

  UpdatePage(this.mainVM) {
    // mainVM = vm;
    print("creating form update");
    mainVM.setFieldFilterUpdate();
    curFilter = mainVM.filter.cloneFilter();
    curFilter.setAwalFilterUpdate();
    // curFilter.setFilterFromJson(isKey: false, mapFilter: curFilter.datas, map: );
    print(jsonEncode(mainVM.filter));
  }


  _buildWidgetInput({String nField, int pos, BuildContext context}) {
    final jenis = Provider.of<BitsFilter>(context).datas[nField].jenisWidget;
    final item = Provider.of<BitsFilter>(context).datas[nField].data[pos];
    print(nField + ' error text' + item.errorText);
    if (jenis == CJENIS_FILTER_STRING) {
      return Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              enabled: Provider.of<BitsFilter>(context).datas[nField].isEnable,
//              enabled: !(nField == CFIELD_KODE),
              controller: item.controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Masukan $nField',
//                errorText: item.errorText.isEmpty ? null : item.errorText,
                errorText: item.errorText,
              ),
            ),
          ),
        ],
      );
    } else if (jenis == CJENIS_FILTER_INT) {
      return Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: item.controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukan $nField',
                errorText: item.errorText.isEmpty ? null : item.errorText,
              ),
            ),
          ),
        ],
      );
    } else if (jenis == CJENIS_FILTER_TANGGAL) {
      return Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: item.controller,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: 'Masukan $nField',
                errorText: item.errorText.isEmpty ? null : item.errorText,
              ),
              onTap: () => {
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
    print(filter.datas.toString());
    return Expanded(
      child: Container(
        // color: Colors.lime,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: filter.datas.length,
          itemBuilder: (context, index) {
            final mapField = filter.datas.entries.elementAt(index);
            if (mapField.value.isVisible) {
            return Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Card(
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.amber,
                        // margin: EdgeInsets.only(left: ),
                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              mapField.key.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 250),
                          child: _buildListKeyData(mapField: mapField)),
                    ],
                  ),
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
    final filter = Provider.of<BitsFilter>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            onPressed: () => {filter.notifyListeners()},
            child: Text('tesss'),
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          RaisedButton(
            onPressed: () => {
              if (mainVM.validateInputData(sourceFilter: curFilter)) {
                curFilter.getWidgetData(isKey: false),
                mainVM.filter.updateFilterDatas(src: curFilter),
                mainVM.updateDataList(),
                // mainVM.filter.updateDatas(src: curFilter),
                Navigator.pop(context, true),
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('=============================');
    return ChangeNotifierProvider.value(
      value: curFilter,
      child: Consumer<BitsFilter>(builder: (context, filter, child) {
        print('updated');
        return Scaffold(
          appBar: AppBar(title: Text("Ubah ${filter.title}")),
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
                _buildBottomContainer(context: context),

                // _buildListKeyMap(bitsFilter),
              ],
            ),
          ),
        );
      }),
    );
  }
}
