## Crear un panel personalizado en Grafana para métricas de personas-api

Sigue estos pasos para visualizar la métrica personalizada `personas_api_requests_total` en un dashboard de Grafana:

1. Abre Grafana en tu navegador: [http://localhost:3000](http://localhost:3000)
  - Usuario: `admin`
  - Contraseña: la que obtuviste con el comando de la guía

2. En el menú lateral izquierdo, haz clic en el icono de “Dashboards” (cuatro cuadros) y selecciona **New → Dashboard**.

3. Haz clic en **Add a new panel**.

4. En la sección de consultas (Query), selecciona la fuente de datos **Prometheus**.

5. En el campo de consulta, escribe:
  ```
  personas_api_requests_total
  ```
  (Puedes usar el modo “Builder” o “Code”)

6. Verás la gráfica de la métrica. Puedes ajustar el rango de tiempo (arriba a la derecha) para ver los datos recientes.

7. Personaliza el panel:
  - Cambia el título en “Panel title” (por ejemplo: “Total de requests personas-api”).
  - Ajusta el tipo de visualización (línea, barras, etc.) según prefieras.

8. Haz clic en **Apply** (Arriba a la derecha) para guardar el panel en el dashboard.

9. Opcional: Haz clic en **Save dashboard** para guardar el dashboard completo y así reutilizarlo.

Si quieres agregar más métricas personalizadas, repite el proceso agregando nuevos paneles.
# Guía para levantar y detener el sistema completo

Esta guía explica cómo iniciar y detener todos los servicios del sistema usando Docker Compose, y resalta la ventaja de los contenedores respecto a los entornos virtuales de Python.

## Levantar los servicios

1. Abre una terminal y navega al directorio donde está el archivo `docker-compose.yml`:
   
   ```bash
   cd /ruta/a/Microservicios/WSL
   ```
   (Reemplaza la ruta según tu estructura)

2. Ejecuta el siguiente comando para construir e iniciar todos los servicios:
   
   ```bash
   docker compose up --build
   ```
   Esto levantará los contenedores definidos (por ejemplo, personas-api y flask-frontend).

3. Accede al frontend desde tu navegador en:
   
   - http://localhost:8000

4. Para verificar que los servicios están corriendo, puedes usar:
   
   ```bash
   docker ps
   ```

## Detener los servicios

1. En la misma terminal (o en otra, estando en el mismo directorio del archivo `docker-compose.yml`), ejecuta:
   
   ```bash
   docker compose down
   ```
   Esto detendrá y eliminará los contenedores creados por Docker Compose.

## Nota sobre entornos virtuales y Docker

- Cuando usas Docker, no necesitas crear entornos virtuales de Python en tu máquina local, ya que cada contenedor es un entorno aislado con sus propias dependencias.
- Esto simplifica la gestión de dependencias y evita conflictos entre proyectos.

---

## Levantar y detener los servicios con Kubernetes (Minikube)

### Requisitos previos
- Tener instalado y configurado Minikube y kubectl en WSL (ver la guía de instalación correspondiente).
- Haber construido las imágenes Docker locales (`wsl-personas-api:latest` y `wsl-flask-frontend:latest`).

### 1. Iniciar Minikube
Abre una terminal WSL y ejecuta:

```bash
minikube start --driver=docker
```

### 2. Apuntar Docker a Minikube (opcional, solo si necesitas construir imágenes dentro del entorno de Minikube)

```bash
eval $(minikube docker-env)
```

### 3. Aplicar los archivos de despliegue
Navega a la carpeta donde están los archivos YAML de Kubernetes (por ejemplo, `k8s/`):

```bash
cd /ruta/a/Microservicios/WSL/k8s
```

Aplica los despliegues y servicios:

```bash
kubectl apply -f personas-api-deployment.yaml
kubectl apply -f flask-frontend-deployment.yaml
```

### 4. Verifica que los pods estén corriendo

```bash
kubectl get pods
```

### 5. Exponer el frontend en tu navegador
Para acceder al frontend desde tu navegador, ejecuta:

```bash
minikube service flask-frontend
```
> **Nota importante:**
> 
> Antes de ejecutar `minikube service flask-frontend`, asegúrate de que los pods del frontend y personas-api estén desplegados y en estado Running. Si detuviste Minikube, eliminaste los pods o es la primera vez que levantas el entorno, primero ejecuta:
> 
> ```bash
> kubectl apply -f personas-api-deployment.yaml
> kubectl apply -f flask-frontend-deployment.yaml
> kubectl get pods
> ```
> 
> Solo cuando los pods estén en estado Running, usa `minikube service flask-frontend` para exponer el frontend y poder interactuar con la aplicación.
> 
> Si el pod personas-api está en CrashLoopBackOff, revisa los logs con:
> ```bash
> kubectl logs <nombre-del-pod-personas-api>
> ```
> y corrige el error antes de continuar.
Esto abrirá la URL del servicio frontend en tu navegador.

### 6. Detener el clúster de Minikube

```bash
minikube stop
```

### 7. Eliminar el clúster de Minikube (opcional)

```bash
minikube delete
```

---

## Notas importantes sobre directorios y construcción de imágenes en Minikube

- **Iniciar Minikube y apuntar Docker a Minikube** (`minikube start`, `eval $(minikube docker-env)`): puedes ejecutarlos desde cualquier directorio.

- **Construir las imágenes Docker para Kubernetes:**
    1. **Importante:** Debes estar en la raíz del proyecto, donde existen las carpetas `servicios/` y `frontend/`, para que los comandos de build funcionen correctamente. Si ejecutas el build desde otro directorio, verás errores de "path not found".
     
      Ejemplo de ruta correcta:
      ```bash
      cd /mnt/c/Users/sambo/Documents/Programacion/GitHub/MicroServicios/WSL
      eval $(minikube docker-env)
      ```
    2. Construye las imágenes dentro del entorno de Minikube (desde la raíz del proyecto):
      ```bash
      docker build -t wsl-personas-api:latest ./servicios/personas-api
      docker build -t wsl-flask-frontend:latest ./frontend/flask-frontend
      ```
  3. Ahora sí, navega a la carpeta `k8s/` para aplicar los archivos YAML:
     ```bash
     cd k8s #del comando previo o cd /mnt/c/Users/sambo/Documents/Programacion/GitHub/MicroServicios/WSL/k8s
     kubectl apply -f personas-api-deployment.yaml
     kubectl apply -f flask-frontend-deployment.yaml
     #Estos comandos antes de los anteriores en caso de haber realizado cambios y reconstruido
     kubectl delete -f personas-api-deployment.yaml
     kubectl delete -f flask-frontend-deployment.yaml
     ```

- **Resumen de directorios:**
  - Construcción de imágenes: raíz del proyecto (`/WSL`)
  - Aplicar YAML: carpeta `k8s`

- Si ya aplicaste los YAML y los pods fallaron con `ErrImagePull`, elimina los recursos antes de volver a aplicar:
  ```bash
  kubectl delete -f personas-api-deployment.yaml
  kubectl delete -f flask-frontend-deployment.yaml
  ```
  Luego repite el proceso de construcción y aplicación.

---

## Tip importante sobre acceso al frontend en Minikube

- Cuando ejecutes:
  ```bash
  minikube service flask-frontend
  ```
  Minikube intentará abrir la URL del frontend automáticamente en un navegador dentro de WSL. Si ves mensajes de error como `xdg-open: no method available for opening ...`, simplemente copia la URL que te muestra el comando (por ejemplo, `http://127.0.0.1:38863`) y pégala manualmente en tu navegador de Windows.
- No refresques la dirección anterior de Docker Compose (`http://localhost:8000`), ya que la URL y el puerto pueden cambiar en cada ejecución de Minikube.

---

## Monitoreo con Prometheus y Grafana en Minikube

### 1. Instalar Helm (si no lo tienes)
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

### 2. Agregar el repositorio de Prometheus Community y actualizar
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 3. Instalar Prometheus y Grafana en el clúster
```bash
helm install monitoring prometheus-community/kube-prometheus-stack
```

> Si ves advertencias sobre "unrecognized format 'int32'/'int64'" o "SessionAffinity is ignored", puedes ignorarlas si el STATUS es "deployed".

### 4. Espera a que los pods estén en estado Running
```bash
kubectl get pods -l "release=monitoring"
```

### 5. Acceder a Grafana
- Obtén el nombre del pod de Grafana:
  ```bash
  kubectl get pods -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=monitoring"
  ```
- Haz el port-forward (reemplaza <nombre-del-pod> por el nombre real):
  ```bash
  kubectl port-forward <nombre-del-pod> 3000:3000
  ```
- Abre en tu navegador: http://localhost:3000
- Usuario: `admin`
- Contraseña: obténla con:
  ```bash
  kubectl --namespace default get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
  ```

### 6. Tips y notas
- Si el pod de Grafana está en Pending, espera unos minutos y vuelve a intentar.
- Puedes monitorear recursos, pods, servicios y métricas desde los dashboards preconfigurados de Grafana.
- Para eliminar el stack de monitoreo:
  ```bash
  helm uninstall monitoring
  ```

---

## Visualizar métricas de Kubernetes en Grafana

1. Ingresa a Grafana en http://localhost:3000 con usuario `admin` y la contraseña obtenida.
2. En el menú lateral izquierdo, haz clic en el icono de “Dashboards” (cuatro cuadros).
3. Selecciona “Browse” (Explorar).
4. Busca y abre alguno de los dashboards preconfigurados, por ejemplo:
   - Kubernetes / Compute Resources / Namespace
   - Kubernetes / Compute Resources / Pod
   - Kubernetes / Compute Resources / Workload
   - Kubernetes / Networking / Services
   - Kubernetes / Cluster
5. Estos dashboards muestran métricas de CPU, memoria, red, estado de pods, servicios y más.
6. Puedes buscar “Kubernetes” en la barra de búsqueda de dashboards para encontrarlos rápidamente.

> Si quieres crear dashboards personalizados para tus propias métricas de aplicación, puedes agregar paneles nuevos y seleccionar Prometheus como fuente de datos.

---

**Notas:**
- Todos los comandos deben ejecutarse en una terminal WSL (Ubuntu), no en PowerShell ni CMD de Windows.
- Si modificas los archivos YAML, puedes volver a aplicar los cambios usando `kubectl apply -f <archivo>.yaml`.
- Para ver los logs de un pod:
  ```bash
  kubectl logs <nombre-del-pod>
  ```
- Para eliminar los recursos creados:
  ```bash
  kubectl delete -f personas-api-deployment.yaml
  kubectl delete -f flask-frontend-deployment.yaml
  ```

---

Para más detalles sobre la arquitectura o estructura del proyecto, revisa los archivos en la carpeta `Documentación/`.
