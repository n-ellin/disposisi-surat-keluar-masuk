import 'package:flutter/material.dart';
import 'pages/TU/menu/menuTu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuTuPage(),
    );
  }
}
 