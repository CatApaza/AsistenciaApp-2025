import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // cambia IP si usas celular físico

  static Future<http.Response> registrarUsuario(
      String nombre, String apellido, String correo, File foto) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/auth/registro'));
    request.fields['nombre'] = nombre;
    request.fields['apellido'] = apellido;
    request.fields['correo'] = correo;
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> login(
      String correo, String tipo, File foto, double lat, double lng) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/auth/login'));
    request.fields['correo'] = correo;
    request.fields['tipo'] = tipo;
    request.fields['latitud'] = lat.toString();
    request.fields['longitud'] = lng.toString();
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  static Future<http.Response> listarAsistencias(int usuarioId) async {
    return await http.get(Uri.parse('$baseUrl/auth/asistencias/$usuarioId'));
  }
}
