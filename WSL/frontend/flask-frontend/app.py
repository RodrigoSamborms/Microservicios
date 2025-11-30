
from flask import Flask, render_template, request, redirect, url_for
import requests
import os

app = Flask(__name__)

API_URL = os.environ.get("API_URL", "http://localhost:5000/personas")

@app.route('/')
def index():
    response = requests.get(API_URL)
    personas = response.json() if response.status_code == 200 else []
    return render_template('index.html', personas=personas)

@app.route('/agregar', methods=['POST'])
def agregar():
    nombre = request.form.get('nombre')
    telefono = request.form.get('telefono')
    if nombre and telefono:
        requests.post(API_URL, json={"nombre": nombre, "telefono": telefono})
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
