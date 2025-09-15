import 'package:flutter/material.dart';
import 'screens/registro_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Asistencia App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegistroScreen(), // o LoginScreen()
    );
  }
}
