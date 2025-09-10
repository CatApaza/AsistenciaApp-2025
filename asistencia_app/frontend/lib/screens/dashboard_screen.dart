import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  final Map usuario;
  DashboardScreen({required this.usuario});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  File? foto;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) setState(() => foto = File(pickedFile.path));
  }

  void marcarAsistencia() async {
    if (foto == null) return;
    String ubicacion = "Ubicación prueba"; // Aquí se puede integrar geolocalización
    final response = await ApiService.marcarAsistencia(foto!, ubicacion);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Asistencia marcada correctamente")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al marcar asistencia")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard - ${widget.usuario['nombre']}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(onPressed: pickImage, child: Text("Tomar Foto")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: marcarAsistencia, child: Text("Marcar Asistencia")),
          ],
        ),
      ),
    );
  }
}
