#!/bin/bash
# Script para gestionar el port-forward de Grafana
# Uso:
#   ./gestionar_grafana.sh -iniciar   # Inicia el port-forward de Grafana
#   ./gestionar_grafana.sh -detener   # Detiene el port-forward de Grafana

set -e

PORT_FORWARD_PID_FILE="grafana_port_forward.pid"

function iniciar() {
    POD=$(kubectl get pods -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=monitoring" -o jsonpath="{.items[0].metadata.name}")
    if [ -z "$POD" ]; then
        echo "[ERROR] No se encontró el pod de Grafana. ¿Está desplegado el stack de monitoreo?"
        exit 1
    fi
    echo "[INFO] Iniciando port-forward de Grafana en segundo plano..."
    kubectl port-forward "$POD" 3000:3000 &
    echo $! > "$PORT_FORWARD_PID_FILE"
    echo "[INFO] Accede a Grafana en: http://localhost:3000"
}

function detener() {
    if [ -f "$PORT_FORWARD_PID_FILE" ]; then
        PID=$(cat "$PORT_FORWARD_PID_FILE")
        echo "[INFO] Deteniendo port-forward de Grafana (PID $PID)..."
        kill $PID || true
        rm "$PORT_FORWARD_PID_FILE"
        echo "[INFO] Port-forward detenido."
    else
        echo "[WARN] No se encontró un port-forward activo registrado."
    fi
}

case "$1" in
    -iniciar)
        iniciar
        ;;
    -detener)
        detener
        ;;
    *)
        echo "Uso: $0 -iniciar | -detener"
        exit 1
        ;;
esac
