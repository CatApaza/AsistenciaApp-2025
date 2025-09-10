from fastapi import APIRouter, Form, UploadFile
import shutil, os
from deepface import DeepFace
from database import get_connection

router = APIRouter(prefix="/auth", tags=["Autenticación"])

TEMP_DIR = "backend/temp"
os.makedirs(TEMP_DIR, exist_ok=True)

@router.post("/login")
async def login(
    correo: str = Form(...),
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
            "INSERT INTO asistencias (usuario_id, tipo, estado, latitud, longitud) VALUES (%s, %s, %s, %s, %s);",
            (user["id"], "entrada", "presente", latitud, longitud)
        )
        conn.commit()
        cursor.close()
        conn.close()
        return {"msg": "Asistencia registrada ✅", "usuario_id": user["id"], "ubicacion": {"lat": latitud, "lng": longitud}}
    else:
        return {"error": "Rostro no coincide 🚫"}
