from fastapi import FastAPI
from routers import usuarios, asistencias, auth

app = FastAPI(title="Asistencia con Reconocimiento Facial")

# Incluir módulos (routers)
app.include_router(usuarios.router)
app.include_router(asistencias.router)
app.include_router(auth.router)

@app.get("/")
def home():
    return {"msg": "API de Asistencia corriendo 🚀"}
