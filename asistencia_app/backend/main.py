from fastapi import FastAPI
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor

app = FastAPI(title="Asistencia con Reconocimiento Facial")

# Configuración de la conexión a PostgreSQL
def get_connection():
    return psycopg2.connect(
        dbname="asistencia_db",
        user="postgres",
        password="tu_password",
        host="localhost",
        port="5432",
        cursor_factory=RealDictCursor
    )

# Modelo para usuarios
class Usuario(BaseModel):
    nombre: str
    apellido: str
    correo: str

# Ruta de prueba
@app.get("/")
def home():
    return {"msg": "API de Asistencia corriendo 🚀"}

# Crear usuario
@app.post("/usuarios")
def crear_usuario(usuario: Usuario):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO usuarios (nombre, apellido, correo) VALUES (%s, %s, %s) RETURNING id;",
        (usuario.nombre, usuario.apellido, usuario.correo)
    )
    nuevo_id = cursor.fetchone()["id"]
    conn.commit()
    cursor.close()
    conn.close()
    return {"msg": "Usuario creado", "id": nuevo_id}
