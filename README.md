### Acceso y credenciales de Grafana

Cuando accedas a http://localhost:3000, Grafana te pedirá usuario y contraseña:

- **Usuario:** `admin`
- **Contraseña:** Para obtener la contraseña por defecto, ejecuta:
	```bash
	kubectl --namespace default get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
	```
	Copia y pega la contraseña resultante en el login de Grafana.

Una vez dentro, podrás crear dashboards y visualizar métricas personalizadas.
## Acceso rápido a Grafana

Para facilitar el acceso a la interfaz de Grafana, puedes usar el script `gestionar_grafana.sh` desde la carpeta raíz:

### 1. Dar permisos de ejecución (solo la primera vez)
```bash
chmod +x gestionar_grafana.sh
```

### 2. Iniciar el port-forward de Grafana
```bash
./gestionar_grafana.sh -iniciar
```
Esto abrirá el puerto 3000 localmente para que puedas acceder a Grafana en:
http://localhost:3000

### 3. Detener el port-forward de Grafana
```bash
./gestionar_grafana.sh -detener
```
Esto detiene el port-forward de Grafana.

---
# Gestión rápida de servicios Kubernetes para Microservicios

Este proyecto incluye un script para facilitar el arranque y detención de los servicios en Kubernetes usando Minikube.

## Uso del script `gestionar_k8s.sh`

Desde la carpeta raíz del proyecto (`/Microservicios`):

### 1. Dar permisos de ejecución (solo la primera vez)
```bash
chmod +x gestionar_k8s.sh
```

### 2. Iniciar los servicios
```bash
./gestionar_k8s.sh -iniciar
```
Esto:
- Inicia Minikube (si no está iniciado)
- Aplica los despliegues de personas-api y flask-frontend
- Aplica el ServiceMonitor para Prometheus
- Muestra el estado de los pods
- Te recuerda cómo exponer el frontend

### 3. Exponer el frontend
En una terminal aparte:
```bash
minikube service flask-frontend
```
Esto abrirá la URL del frontend en tu navegador.

### 4. Detener los servicios
```bash
./gestionar_k8s.sh -detener
```
Esto detiene el clúster de Minikube.

---

## Requisitos previos
- Tener Minikube y kubectl instalados y configurados en WSL
- Haber construido las imágenes Docker locales (`wsl-personas-api:latest` y `wsl-flask-frontend:latest`)

---

Para más detalles, consulta la guía completa en `WSL/Documentación/GuiaLevantamientoSistema.md`.
