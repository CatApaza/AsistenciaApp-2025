from fastapi import APIRouter, Form, UploadFile
import shutil, os
from deepface import DeepFace
from database import get_connection

router = APIRouter(prefix="/auth", tags=["Autenticación"])

TEMP_DIR = "backend/temp"
os.makedirs(TEMP_DIR, exist_ok=True)

# Registro de usuario
@router.post("/registro")
async def registro(
    nombre: str = Form(...),
    apellido: str = Form(...),
    correo: str = Form(...),
    foto: UploadFile = None
):
    if not foto:
        return {"error": "Se requiere una foto"}

    save_path = os.path.join(TEMP_DIR, f"{correo}_registro.jpg")
    with open(save_path, "wb") as buffer:
        shutil.copyfileobj(foto.file, buffer)

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO usuarios (nombre, apellido, correo, foto_path) VALUES (%s, %s, %s, %s) RETURNING id;",
        (nombre, apellido, correo, save_path)
    )
    user_id = cursor.fetchone()["id"]
    conn.commit()
    cursor.close()
    conn.close()

    return {"msg": "Usuario registrado ✅", "id": user_id, "correo": correo}


# Login y marcar asistencia
@router.post("/login")
async def login(
    correo: str = Form(...),
    tipo: str = Form(...),  # entrada o salida
    foto: UploadFile = None,
    latitud: float = Form(...),
    longitud: float = Form(...)
):
    if not foto:
        return {"error": "Se requiere una foto"}

    temp_path = os.path.join(TEMP_DIR, f"{correo}_login.jpg")
    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(foto.file, buffer)

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, foto_path FROM usuarios WHERE correo=%s;", (correo,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if not user:
        return {"error": "Usuario no encontrado"}

    result = DeepFace.verify(img1_path=temp_path, img2_path=user["foto_path"])

    if result["verified"]:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO asistencias (usuario_id, tipo, estado, latitud, longitud) VALUES (%s, %s, %s, %s, %s) RETURNING id;",
            (user["id"], tipo, "presente", latitud, longitud)
        )
        asistencia_id = cursor.fetchone()["id"]
        conn.commit()
        cursor.close()
        conn.close()
        return {"msg": "Asistencia registrada ✅", "usuario_id": user["id"], "asistencia_id": asistencia_id}
    else:
        return {"error": "Rostro no coincide 🚫"}


# Listar asistencias por usuario
@router.get("/asistencias/{usuario_id}")
async def listar_asistencias(usuario_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM asistencias WHERE usuario_id = %s ORDER BY hora DESC;", (usuario_id,))
    asistencias = cursor.fetchall()
    cursor.close()
    conn.close()
    return asistencias
