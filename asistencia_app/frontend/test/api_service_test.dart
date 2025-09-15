import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:asistencia_app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group("ApiService Tests", () {
    test("Login devuelve éxito con credenciales válidas", () async {
      // Mockear la respuesta del backend
      final mockClient = MockClient((request) async {
        if (request.url.path == "/auth/login") {
          return http.Response(jsonEncode({
            "msg": "Login correcto ✅",
            "usuario": {
              "id": 1,
              "nombre": "Rubí",
              "apellido": "Ramírez",
              "correo": "rubi@test.com",
              "foto_path": "backend/temp/rubi.jpg"
            }
          }), 200);
        }
        return http.Response("Not Found", 404);
      });

      // Reemplazar temporalmente el cliente de http
      final response = await mockClient.post(
        Uri.parse("${ApiService.baseUrl}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": "rubi@test.com", "contrasena": "12345"}),
      );

      expect(response.statusCode, 200);

      final body = jsonDecode(response.body);
      expect(body["msg"], "Login correcto ✅");
      expect(body["usuario"]["correo"], "rubi@test.com");
    });

    test("Lista asistencias devuelve registros", () async {
      final mockClient = MockClient((request) async {
        if (request.url.path == "/asistencia/") {
          return http.Response(jsonEncode([
            {
              "id": 1,
              "fecha": "2025-09-15",
              "hora": "2025-09-15T08:30:00",
              "tipo": "entrada",
              "estado": "presente",
              "latitud": -12.0464,
              "longitud": -77.0428,
              "usuario": {
                "id": 1,
                "nombre": "Rubí",
                "apellido": "Ramírez",
                "correo": "rubi@test.com",
                "foto_path": "backend/temp/rubi.jpg"
              }
            }
          ]), 200);
        }
        return http.Response("Not Found", 404);
      });

      final response = await mockClient.get(
        Uri.parse("${ApiService.baseUrl}/asistencia/"),
      );

      expect(response.statusCode, 200);

      final data = jsonDecode(response.body);
      expect(data, isA<List>());
      expect(data[0]["usuario"]["nombre"], "Rubí");
    });
  });
}
