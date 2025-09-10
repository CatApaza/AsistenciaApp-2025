import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    return psycopg2.connect(
        dbname="asistencia_db",
        user="postgres",
        password="71500100",  # 👈 cambia aquí
        host="localhost",
        port="5432",
        cursor_factory=RealDictCursor
    )

