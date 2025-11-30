#!/bin/bash
# Script para crear y preparar entornos virtuales en los microservicios

set -e

# Crear y preparar entorno para personas-api
cd ../servicios/personas-api
if [ ! -d "venv" ]; then
    echo "Creando entorno virtual para personas-api..."
    python3 -m venv venv
else
    echo "Entorno virtual para personas-api ya existe."
fi
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
 deactivate

# Crear y preparar entorno para flask-frontend
cd ../../frontend/flask-frontend
if [ ! -d "venv" ]; then
    echo "Creando entorno virtual para flask-frontend..."
    python3 -m venv venv
else
    echo "Entorno virtual para flask-frontend ya existe."
fi
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
 deactivate

cd ../../scripts

echo "Entornos virtuales preparados."
