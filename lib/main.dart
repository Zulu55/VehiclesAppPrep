import 'package:flutter/material.dart';
import 'package:vehicles_prep/screens/login_screen.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicles App',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}