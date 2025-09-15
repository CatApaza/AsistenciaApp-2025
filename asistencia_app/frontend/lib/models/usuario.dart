class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String fotoPath;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.fotoPath,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      fotoPath: json['foto_path'], // 👈 ojo: debe coincidir con lo que envía FastAPI
    );
  }
}
