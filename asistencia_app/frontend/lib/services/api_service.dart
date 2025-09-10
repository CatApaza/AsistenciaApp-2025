import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<http.Response> registrarUsuario(String nombre, String correo, String contrasena, File foto) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/auth/registro'));
    request.fields['nombre'] = nombre;
    request.fields['correo'] = correo;
    request.fields['contrasena'] = contrasena;
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> login(String correo, String contrasena) async {
    var body = jsonEncode({'correo': correo, 'contrasena': contrasena});
    var response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    return response;
  }

  static Future<http.Response> marcarAsistencia(File foto, String ubicacion) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/asistencia/marcar'));
    request.fields['ubicacion'] = ubicacion;
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> listarAsistencias() async {
    return await http.get(Uri.parse('$baseUrl/asistencia/'));
  }
}
