from flask import Flask
import os
import psycopg2

app = Flask(__name__)

def db_check():
    try:
        conn = psycopg2.connect(
            dbname=os.environ.get("DB_NAME"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            host=os.environ.get("DB_HOST", "127.0.0.1"),
            port=os.environ.get("DB_PORT", "5432"),
            connect_timeout=3,
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        cur.close()
        conn.close()
        return f"OK - Connected to PostgreSQL: {version}"
    except Exception as e:
        return f"DB connection error: {e}"

@app.route("/")
def index():
    return "Hello from Flask + Gunicorn + NGINX!"

@app.route("/health")
def health():
    return "OK"

@app.route("/db")
def db():
    return db_check()

if __name__ == "__main__":
    app.run()
