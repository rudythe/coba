import 'package:flutter/material.dart';

Widget drawerHeader() {
  return UserAccountsDrawerHeader(
    accountName: Text(
      'Rudy',
      style: TextStyle(color: Colors.white, fontSize: 30),
    ),
    accountEmail: Text(
      'Rudy_the@yahoo.com',
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    currentAccountPicture: CircleAvatar(
      backgroundImage: NetworkImage(
        'https://media.suara.com/pictures/653x366/2019/11/17/27817-frozen-ii.jpg',
      ),
    ),
    decoration: BoxDecoration(
      // image: NetworkImage('https://pngimage.net/wp-content/uploads/2018/05/background-keren-png-5.png')
      image: DecorationImage(
        image: NetworkImage(
          'https://shbjaya.s3.ap-northeast-2.amazonaws.com/Nice+Sunset.jpg',
        ),
        fit: BoxFit.cover,
      ),
    ),
    otherAccountsPictures: <Widget>[
      CircleAvatar(
        backgroundImage: NetworkImage(
          'https://merahputih.com/media/93/47/6c/93476c53acf6fc4657ecaa06f7141ee6.jpg',
        ),
      )
    ],
  );
}
