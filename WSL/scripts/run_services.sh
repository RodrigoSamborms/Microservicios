#!/bin/bash
# Script para lanzar personas-api y flask-frontend en WSL

# Rutas relativas a este script
PERSONAS_API="../servicios/personas-api/app.py"
FRONTEND_API="../frontend/flask-frontend/app.py"

# Función para verificar si un proceso está corriendo
is_running() {
    pgrep -f "$1" > /dev/null
}

# Lanzar personas-api si no está corriendo
if is_running "$PERSONAS_API"; then
    echo "personas-api ya está en ejecución."
else
    echo "Lanzando personas-api..."
     (cd ../servicios/personas-api && source venv/bin/activate && nohup python app.py > personas-api.log 2>&1 &)
fi

# Lanzar flask-frontend si no está corriendo
if is_running "$FRONTEND_API"; then
    echo "flask-frontend ya está en ejecución."
else
    echo "Lanzando flask-frontend..."
     (cd ../frontend/flask-frontend && source venv/bin/activate && nohup python app.py > flask-frontend.log 2>&1 &)
fi

sleep 1
echo "Servicios verificados/lanzados."
