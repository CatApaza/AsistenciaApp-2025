-- Crear la base de datos
CREATE DATABASE asistencia_db;

\c asistencia_db;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    foto_path TEXT NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de asistencias
CREATE TABLE asistencias (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(20) NOT NULL, -- entrada o salida
    estado VARCHAR(20),
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6),
    registrado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

