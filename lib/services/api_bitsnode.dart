import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sahabatjaya/constanta/constanta.dart';
import 'package:sahabatjaya/engines/bits/bits_filter.dart';
import 'package:sahabatjaya/services/srv_login.dart';

class APIBitsNode {
  UserProvider user;

  APIBitsNode(this.user);

  Future<Map> postRequest(BitsFilter filter, String path) async {
    final url = '$CHOST_ADDR' + path;
    Map<String, dynamic> reqBody = filter.toJsonAPI();
//    reqBody.putIfAbsent("posDB", () => 1);
    print(url + " body: " + jsonEncode(reqBody));
    final response = await http.post(Uri.http(CHOST_ADDR, '/bits/BasicQuery/show'), body:jsonEncode(filter.toJsonAPI()), headers: {"Content-type": "application/json", "token":user.token});
    // final response = await http.post(url, body:jsonEncode(reqBody), headers: {"Content-type": "application/json", "token":user.token});
//    print(response.body['isidata'].length);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<Map> basicQueryShow(BitsFilter filter) async {
    final url = '$CHOST_ADDR/bits/BasicQuery/show';
    Map<String, dynamic> reqBody = filter.toJsonAPI();
//    reqBody.putIfAbsent("posDB", () => 1);
    print(url + " body: " + jsonEncode(reqBody));
    final response = await http.post(Uri.http(CHOST_ADDR, '/bits/BasicQuery/show'), body:jsonEncode(filter.toJsonAPI()), headers: {"Content-type": "application/json", "token":user.token});
    // final response = await http.post(url, body:jsonEncode(reqBody), headers: {"Content-type": "application/json", "token":user.token});
//    print(response.body['isidata'].length);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<Map> basicQueryRaw(String sqlText, List<dynamic> data) async {
    final url = '$CHOST_ADDR/bits/BasicQuery/raw';
    Map<String, dynamic> reqBody = {"text": sqlText, "values": data};
    // final response = await http.post(url, body:jsonEncode(reqBody), headers: {"Content-type": "application/json", "token":user.token});
    final response = await http.post(Uri.http(CHOST_ADDR, '/bits/BasicQuery/raw'), body:jsonEncode(reqBody), headers: {"Content-type": "application/json", "token":user.token});
    print(response.body);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['isidata']);
      return jsonDecode(response.body);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

}