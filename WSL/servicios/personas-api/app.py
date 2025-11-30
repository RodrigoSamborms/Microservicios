
from flask import Flask, request, jsonify, Response
import mysql.connector
import os
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST


app = Flask(__name__)

# Métricas Prometheus
REQUEST_COUNT = Counter('personas_api_requests_total', 'Total de peticiones HTTP', ['method', 'endpoint', 'http_status'])
REQUEST_LATENCY = Histogram('personas_api_request_latency_seconds', 'Latencia de las peticiones HTTP', ['endpoint'])


# Configuración de la base de datos usando variables de entorno
DB_CONFIG = {
    'user': os.environ.get('DB_USER', 'agendaAdmin'),
    'password': os.environ.get('DB_PASSWORD', '1234'),
    'host': os.environ.get('DB_HOST', '169.254.218.17'),
    'database': os.environ.get('DB_NAME', 'agenda'),
    'port': int(os.environ.get('DB_PORT', 3306))
}

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/personas', methods=['POST'])
def agregar_persona():
    with REQUEST_LATENCY.labels(endpoint='/personas').time():
        data = request.get_json()
        nombre = data.get('nombre')
        telefono = data.get('telefono')
        if not nombre or not telefono:
            REQUEST_COUNT.labels(method='POST', endpoint='/personas', http_status=400).inc()
            return jsonify({'error': 'Faltan datos'}), 400
        db = get_db()
        cursor = db.cursor()
        cursor.execute('INSERT INTO personas (nombre, telefono) VALUES (%s, %s)', (nombre, telefono))
        db.commit()
        cursor.close()
        db.close()
        REQUEST_COUNT.labels(method='POST', endpoint='/personas', http_status=201).inc()
        return jsonify({'mensaje': 'Persona agregada'}), 201

@app.route('/personas', methods=['GET'])
def listar_personas():
    with REQUEST_LATENCY.labels(endpoint='/personas').time():
        db = get_db()
        cursor = db.cursor()
        cursor.execute('SELECT id, nombre, telefono FROM personas')
        personas = [{'id': row[0], 'nombre': row[1], 'telefono': row[2]} for row in cursor.fetchall()]
        cursor.close()
        db.close()
        REQUEST_COUNT.labels(method='GET', endpoint='/personas', http_status=200).inc()
        return jsonify(personas)
@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
