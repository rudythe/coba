import 'dart:convert';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sahabatjaya/constanta/constanta.dart';

enum Status{statLogged, statLogout, statLogin, statNone}

class UserProvider with ChangeNotifier{
  String nama;
  String custID;
  String pesan;
  String token;
  Status statLogin = Status.statNone;

  initUser() async {
    print('initUser');
    List<String> userData = await getUserData();
    print(userData);
    nama = userData[0];
    custID = userData[1];
    token = userData[2];
    statLogin = (token != null) ? Status.statLogged : Status.statLogout;
    print('Status Login: ' + statLogin.toString());
    notifyListeners();
  }

  Future<List<String>> getUserData() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    return data.getStringList('userdata');
  }

  void logIn(String uName, String custID, String token) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    this.nama = uName;
    this.custID = custID;
    this.token = token;
    data.setStringList('userdata', [nama, this.custID, token]);
    statLogin = Status.statLogged;
    notifyListeners();
  }

  void logOut([bool isExpired = false]) async {
    if (isExpired == true) {
      pesan = 'Season berakhir, login kembali';
    }
    statLogin = Status.statLogout;
    notifyListeners();
    SharedPreferences data = await SharedPreferences.getInstance();
    data.remove('userdata');
  }
}

class ServiceLogin with ChangeNotifier {
  String pesan = '';
  UserProvider userLogin;

  ServiceLogin(this.userLogin) {
    userLogin.initUser();
  }

  Future<bool> loginAPI(BuildContext context, String uname, String passwd) async {
    final url = '$CHOST_ADDR/bits/user/login';
    String body = '{"uname": "$uname", "pass": "$passwd"}';
    print(Uri.http(CHOST_ADDR, '/bits/user/login').toString() + 'API BODY: $body');
    final response = await http.post(Uri.http(CHOST_ADDR, '/bits/user/login'), body:body, headers: {"Content-type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      if (data["Code"] == 1) {
        Map<String, dynamic> custData = jsonDecode(response.body)['isidata'][0];
        userLogin.logIn(uname, custData['custid'].toString(), custData['token'].toString());
        return true;
      }
      else {
        pesan = data["message"];
        notifyListeners();
        return false;
      }
    } else {
      notifyListeners();
      throw Exception("Unable to perform request!");
    }
  }

}