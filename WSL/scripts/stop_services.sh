#!/bin/bash
# Script para detener personas-api y flask-frontend en WSL

PERSONAS_API="../servicios/personas-api/app.py"
FRONTEND_API="../frontend/flask-frontend/app.py"

# Función para verificar si un proceso está corriendo y matarlo
PERSONAS_API_DIR="../servicios/personas-api"
FRONTEND_API_DIR="../frontend/flask-frontend"

# Función para buscar y detener procesos python app.py en la ruta dada
stop_service() {
    local DIR="$1"
    local PIDS=$(ps aux | grep "python app.py" | grep "$DIR" | grep -v grep | awk '{print $2}')
    if [ -n "$PIDS" ]; then
        echo "Deteniendo procesos en $DIR: $PIDS"
        kill $PIDS
    else
        echo "No hay procesos activos en $DIR."
    fi
}

stop_service "$PERSONAS_API_DIR"
stop_service "$FRONTEND_API_DIR"

echo "Servicios verificados/detenidos."
