import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:asistencia_app/services/api_service.dart';

class ListaAsistenciasScreen extends StatefulWidget {
  final int usuarioId; // 👈 recibimos el ID del usuario logueado

  const ListaAsistenciasScreen({super.key, required this.usuarioId});

  @override
  State<ListaAsistenciasScreen> createState() => _ListaAsistenciasScreenState();
}

class _ListaAsistenciasScreenState extends State<ListaAsistenciasScreen> {
  List asistencias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarAsistencias();
  }

  Future<void> cargarAsistencias() async {
    try {
      // 👈 usamos el usuarioId que se pasó desde el login
      final response = await ApiService.listarAsistencias(widget.usuarioId);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          asistencias = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception("Error al cargar asistencias: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 Lista de Asistencias"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : asistencias.isEmpty
              ? const Center(child: Text("No hay asistencias registradas"))
              : ListView.builder(
                  itemCount: asistencias.length,
                  itemBuilder: (context, index) {
                    final asistencia = asistencias[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(
                          "${asistencia['usuario']['nombre']} ${asistencia['usuario']['apellido']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("📧 ${asistencia['usuario']['correo']}"),
                            Text("📅 Fecha: ${asistencia['fecha']}"),
                            Text("🕒 Hora: ${asistencia['hora']}"),
                            Text(
                                "📍 Ubicación: (${asistencia['latitud']}, ${asistencia['longitud']})"),
                            Text("✅ Estado: ${asistencia['estado']}"),
                          ],
                        ),
                        trailing: Text(
                          asistencia['tipo'] ?? "",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
