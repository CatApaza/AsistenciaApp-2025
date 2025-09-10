import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'registro_screen.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();

  void login() async {
    final response = await ApiService.login(correoController.text, contrasenaController.text);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(usuario: data)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Correo o contraseña incorrectos")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: correoController, decoration: InputDecoration(labelText: "Correo")),
            TextField(controller: contrasenaController, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Login")),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegistroScreen()));
            }, child: Text("Registrarse"))
          ],
        ),
      ),
    );
  }
}
