import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  File? foto;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) setState(() => foto = File(pickedFile.path));
  }

  void registrar() async {
    if (foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Seleccione una foto")));
      return;
    }
    final response = await ApiService.registrarUsuario(
      nombreController.text,
      correoController.text,
      contrasenaController.text,
      foto!,
    );
    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al registrar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreController, decoration: InputDecoration(labelText: "Nombre")),
            TextField(controller: correoController, decoration: InputDecoration(labelText: "Correo")),
            TextField(controller: contrasenaController, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
            SizedBox(height: 10),
            ElevatedButton(onPressed: pickImage, child: Text("Tomar Foto")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: registrar, child: Text("Registrar")),
          ],
        ),
      ),
    );
  }
}
