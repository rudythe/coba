import 'package:intl/intl.dart';

toUpperCaseMap(Map<String, dynamic> data) {
  return data.map((k, v) {
        return MapEntry(k.toUpperCase(), v);
      });
  }

  toDoubel(data) {
    var dobel;
      
    if(data is String) {
      dobel = double.parse(data);
    } else if(data is int) {
      dobel = data.toDouble();
    } else if(data is double) {
      dobel = data;
    }

    return dobel;
  }

  toInt(data) {
    var hasil;
      
    if(data is String) {
      hasil = double.parse(data).toInt();
    } else if(data is int) {
      // hasil = data.int();
      hasil = data;
    } else if(data is double) {
      hasil = data.toInt();
    }

    return hasil;
  }

  String dateToStr(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);    
  }

  DateTime strToDate(String date) {
    print(date); 
    return DateFormat('dd/M/yyyy').parse(date);
    // return DateFormat().parse(date);
  }