import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AsistenciasScreen extends StatefulWidget {
  final int usuarioId;
  AsistenciasScreen({required this.usuarioId});

  @override
  _AsistenciasScreenState createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends State<AsistenciasScreen> {
  List asistencias = [];

  Future<void> _cargarAsistencias() async {
    var response = await ApiService.listarAsistencias(widget.usuarioId);
    setState(() => asistencias = jsonDecode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _cargarAsistencias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Asistencias")),
      body: ListView.builder(
        itemCount: asistencias.length,
        itemBuilder: (context, index) {
          final a = asistencias[index];
          return ListTile(
            title: Text("${a['tipo']} - ${a['estado']}"),
            subtitle: Text("${a['fecha']} ${a['hora']}"),
          );
        },
      ),
    );
  }
}
