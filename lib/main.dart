import 'package:flutter/material.dart';
import 'package:mapas/src/views/fullscreenmap.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapas',
      home: Scaffold(
        body: FullScreenMap()
      ),
    );
  }
}