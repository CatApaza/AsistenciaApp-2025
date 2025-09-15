import psycopg2
import psycopg2.extras

def get_connection():
    return psycopg2.connect(
        host="localhost",
        database="asistencia_db",
        user="postgres",       # <-- cambia según tu usuario
        password="71500100", # <-- cambia según tu password
        cursor_factory=psycopg2.extras.RealDictCursor
    )
