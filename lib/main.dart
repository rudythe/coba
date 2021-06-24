import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahabatjaya/pages/login/page_login.dart';

import 'package:sahabatjaya/pages/page-home.dart';
import 'package:sahabatjaya/services/srv_login.dart';

void main() {
  print('Running APP');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("CREATING APP");
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
//      return MaterialApp(
        title: 'Sahabat Jaya',
        theme: ThemeData(
          // primarySwatch: Colors.lightBlue,
          primaryColor: Color(0xFFD81159),
          highlightColor: Color(0xFFCCF5FC),
          // primaryColor: Colors.white,
          // backgroundColor: Color(0xFFD81159),
          primaryColorLight: Colors.white,
          primaryColorDark: Colors.black,
          canvasColor: Color(0xFFEDF5FC),
          cardColor: Color(0xFF5D737E),
          buttonColor: Color(0xFFB3DEB1),
          accentColor: Color(0xFF04E762),
          indicatorColor: Color(0xFFFFCAB1),
        ),
        initialRoute: '/',
        routes: {
          // '/': (context) => MyHomePage(),
          '/': (context) => MainRoute(),
          '/login': (context) => PageLogin(),
//            '/register': (context) => PageLogin(),
//          '/resetpass': (context) => PageLogin(),
        },
      ),
    );
  }
}

class MainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Provider.of<UserProvider>(context).initUser();
    return Consumer<UserProvider> (
      builder: (context, user, child) {
        print("CONSUME USER PROVIDER " + user.statLogin.toString());
        switch (user.statLogin) {
          case Status.statLogout: return PageLogin(); break;
          case Status.statLogged: return MyHomePage(judul: 'SAHABAT JAYA');
          default: return PageLogin(); break;
        }
      },
    );
  }
}
