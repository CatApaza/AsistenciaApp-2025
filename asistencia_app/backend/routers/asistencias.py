from fastapi import APIRouter, Form
from database import get_connection

router = APIRouter(prefix="/asistencias", tags=["Asistencias"])

@router.post("/registrar")
def registrar_asistencia(
    usuario_id: int = Form(...),
    tipo: str = Form(...),
    estado: str = Form(...),
    latitud: float = Form(...),
    longitud: float = Form(...)
):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO asistencias (usuario_id, tipo, estado, latitud, longitud) VALUES (%s, %s, %s, %s, %s) RETURNING id;",
        (usuario_id, tipo, estado, latitud, longitud)
    )
    nuevo_id = cursor.fetchone()["id"]
    conn.commit()
    cursor.close()
    conn.close()

    return {"msg": "Asistencia registrada ✅", "id": nuevo_id}
