import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lennyfacekeyboard/screens/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //force portrait view only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //debugPaintSizeEnabled=true;

    return MaterialApp(
      title: 'Lenny Face Keyboard',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.white
      ),
      home: HomePage(),
    );
  }
}