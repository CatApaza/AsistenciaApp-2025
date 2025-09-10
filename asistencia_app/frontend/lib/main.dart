import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(AsistenciaApp());
}

class AsistenciaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistencia App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}
