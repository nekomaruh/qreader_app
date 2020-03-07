import 'package:flutter/material.dart';
import 'package:qreader_app/src/pages/home_page.dart';
import 'package:qreader_app/src/pages/address_page.dart';
import 'package:qreader_app/src/pages/maps_page.dart';

import 'src/pages/map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QReader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.deepPurple
      ),
      initialRoute: 'home',
      routes: {
        'home' : (_) => HomePage(),
        'maps' : (_) => MapsPage(),
        'map' : (_) => MapPage(),
        'address' : (_) => AddressPage()
      },
    );
  }
}
