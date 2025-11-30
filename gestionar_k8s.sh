#!/bin/bash
# Script de gestión de servicios Kubernetes para Microservicios
# Uso:
#   ./gestionar_k8s.sh -iniciar   # Para levantar servicios
#   ./gestionar_k8s.sh -detener   # Para detener servicios

set -e

K8S_DIR="$(dirname "$0")/WSL/k8s"

function iniciar() {
    echo "[INFO] Iniciando servicios en Kubernetes..."
    minikube start --driver=docker
    echo "[INFO] Aplicando despliegues personas-api y flask-frontend..."
    kubectl apply -f "$K8S_DIR/personas-api-deployment.yaml"
    kubectl apply -f "$K8S_DIR/flask-frontend-deployment.yaml"
    kubectl apply -f "$K8S_DIR/personas-api-servicemonitor.yaml"
    echo "[INFO] Esperando a que los pods estén en estado Running..."
    kubectl get pods
    echo "[INFO] Para exponer el frontend ejecuta: minikube service flask-frontend"
}

function detener() {
    echo "[INFO] Deteniendo clúster de Minikube..."
    minikube stop
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
