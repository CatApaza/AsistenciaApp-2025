from fastapi import APIRouter, Form, UploadFile
import shutil, os
from database import get_connection

router = APIRouter(prefix="/usuarios", tags=["Usuarios"])

UPLOAD_DIR = "backend/fotos_usuarios"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/registro")
async def registrar_usuario(
    nombre: str = Form(...),
    apellido: str = Form(...),
    correo: str = Form(...),
    foto: UploadFile = None
):
    foto_path = None
    if foto:
        foto_path = os.path.join(UPLOAD_DIR, f"{correo}.jpg")
        with open(foto_path, "wb") as buffer:
            shutil.copyfileobj(foto.file, buffer)

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO usuarios (nombre, apellido, correo, foto_path) VALUES (%s, %s, %s, %s) RETURNING id;",
        (nombre, apellido, correo, foto_path)
    )
    nuevo_id = cursor.fetchone()["id"]
    conn.commit()
    cursor.close()
    conn.close()

    return {"msg": "Usuario registrado ✅", "id": nuevo_id}
