import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'asistencias_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  File? _foto;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _foto = File(picked.path));
  }

  Future<void> _login() async {
    if (_foto == null) return;
    var response = await ApiService.login(
        _correoController.text, "entrada", _foto!, -12.04318, -77.02824);
    print(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
    // si login OK, navegar a asistencias
    Navigator.push(context, MaterialPageRoute(builder: (_) => AsistenciasScreen(usuarioId: 1))); // reemplaza con id real del response
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _correoController, decoration: InputDecoration(labelText: "Correo")),
          ElevatedButton(onPressed: _pickImage, child: Text("Tomar Foto")),
          if (_foto != null) Image.file(_foto!, height: 100),
          ElevatedButton(onPressed: _login, child: Text("Iniciar Sesión"))
        ]),
      ),
    );
  }
}
