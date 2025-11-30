from mcp import ModelContext, Model, Field
from flask import Flask, request, jsonify
import mysql.connector

# Configuración de la base de datos
DB_CONFIG = {
    'host': 'mariadb',
    'user': 'root',
    'password': 'example',
    'database': 'registrodb'
}

app = Flask(__name__)

class Nombre(Model):
    id = Field(int, primary_key=True)
    nombre = Field(str)

ctx = ModelContext()
ctx.register(Nombre)

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/nombres', methods=['POST'])
def agregar_nombre():
    data = request.get_json()
    nombre = data.get('nombre')
    if not nombre:
        return jsonify({'error': 'Falta el nombre'}), 400
    db = get_db()
    cursor = db.cursor()
    cursor.execute('INSERT INTO nombres (nombre) VALUES (%s)', (nombre,))
    db.commit()
    cursor.close()
    db.close()
    return jsonify({'mensaje': 'Nombre agregado'}), 201

@app.route('/nombres', methods=['GET'])
def listar_nombres():
    db = get_db()
    cursor = db.cursor()
    cursor.execute('SELECT id, nombre FROM nombres')
    nombres = [{'id': row[0], 'nombre': row[1]} for row in cursor.fetchall()]
    cursor.close()
    db.close()
    return jsonify(nombres)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
