---

## Sistema de monitoreo y gestión listo

¡Listo! Ahora cuentas con un sistema funcional para monitorear y gestionar tus microservicios en Docker usando Portainer y cAdvisor:

- Puedes acceder a Portainer en `http://IP_RASPBERRY_PI:9000/` y gestionar todos tus contenedores, imágenes, volúmenes y redes de forma visual.
- Desde el dashboard de Portainer (tras hacer clic en “Live Connect” en el entorno local), puedes ver el estado de cada microservicio, iniciar/detener contenedores, ver logs y estadísticas, y administrar recursos fácilmente.
- cAdvisor sigue disponible en `http://IP_RASPBERRY_PI:8080/` para monitoreo detallado de recursos de cada contenedor.

Este entorno es ideal para pruebas, aprendizaje y demostraciones de microservicios en Raspberry Pi.

> **Recomendación:** Para producción, usa contraseñas fuertes, restringe el acceso a los puertos de administración y realiza respaldos periódicos de tus datos y configuraciones.

Puedes seguir agregando microservicios, monitorearlos y gestionarlos desde la misma interfaz, facilitando el desarrollo y la operación.
---

## Configuración inicial de Portainer

Después de acceder a Portainer por primera vez en `http://IP_RASPBERRY_PI:9000/` y crear el usuario administrador:

1. Inicia sesión con el usuario y clave definidos (por ejemplo, rodrigo / Mn@10).
2. En la pantalla "Select your environment", elige **Docker local** (Local) para gestionar los contenedores de la propia Raspberry Pi.
3. Haz clic en **Connect**.
4. Ahora verás el dashboard principal de Portainer, donde puedes:
	- Ver todos los contenedores, imágenes, volúmenes y redes.
	- Crear, detener, eliminar y modificar contenedores desde la web.
	- Ver logs y estadísticas de uso de cada contenedor.
	- Gestionar stacks (docker-compose), usuarios y control de acceso (en versiones avanzadas).

> **Recomendación:** No expongas el puerto 9000 a Internet sin protección. Usa Portainer solo en redes de confianza o configura autenticación fuerte y firewall si lo necesitas remotamente.

Con esto, Portainer quedará listo para gestionar y monitorear tus microservicios en Docker.
---

## Instalación y acceso a Portainer (gestión visual de Docker)

Portainer es una interfaz web ligera para gestionar y monitorear contenedores Docker. Puedes agregarlo fácilmente a tu `docker-compose.yml` junto a tus otros servicios:

```yaml
	portainer:
		image: portainer/portainer-ce:latest
		container_name: portainer
		restart: always
		ports:
			- "9000:9000"
		volumes:
			- /var/run/docker.sock:/var/run/docker.sock
			- portainer_data:/data

volumes:
	portainer_data:
```

Luego ejecuta:
```sh
docker compose up -d
```

Accede a Portainer desde tu navegador en:
`http://IP_RASPBERRY_PI:9000/`

En la primera pantalla, crea el usuario administrador. Para esta prueba de concepto, puedes usar:
- **Usuario:** rodrigo
- **Clave:** Mn@10

> **Nota:** Esta contraseña es solo para pruebas y demostraciones. Usa una contraseña fuerte y única en entornos reales.

Con Portainer podrás gestionar, monitorear, crear y eliminar contenedores de forma visual y sencilla.
---

---
---

## Verificación del estado de Kubernetes en WSL

Antes de instalar Linkerd, es importante asegurarse de que el clúster Kubernetes esté activo y funcional. Puedes verificarlo con los siguientes comandos desde la terminal WSL:

```sh
# Verifica la versión de kubectl y la conexión al clúster
kubectl version --short

# Muestra los nodos del clúster
kubectl get nodes

# Muestra los pods en todos los namespaces
kubectl get pods --all-namespaces
```

Si ves al menos un nodo en estado "Ready" y los pods del sistema en estado "Running" o "Completed", tu clúster está listo para instalar Linkerd.

---
---

## Instalación y configuración de Linkerd en WSL

Linkerd es un service mesh ligero ideal para pruebas y entornos con recursos limitados. A continuación, los pasos para instalarlo y configurarlo en WSL con Kubernetes:

### 1. Prerrequisitos
- Tener un clúster Kubernetes corriendo en WSL (por ejemplo, k3s, kind o minikube).
- Tener `kubectl` configurado y funcionando.

### 2. Instalar la CLI de Linkerd
Descarga y agrega Linkerd al PATH:

```sh
curl -sL https://run.linkerd.io/install | sh
export PATH=$PATH:$HOME/.linkerd2/bin
```

Puedes agregar la línea del `export` a tu `~/.bashrc` o `~/.zshrc` para que sea permanente.

Verifica la instalación:
```sh
linkerd version
```

### 3. Prechequeo del clúster
Comprueba que tu clúster cumple los requisitos:
```sh
linkerd check --pre
```


### 4. Instalar Linkerd en el clúster

Antes de instalar Linkerd, primero debes instalar los CRDs (Custom Resource Definitions):

```sh
linkerd install --crds | kubectl apply -f -
```

Luego instala Linkerd normalmente:

```sh
linkerd install | kubectl apply -f -
```

Verifica la instalación:
```sh
linkerd check
```

### 5. Dashboard de Linkerd
Puedes abrir el dashboard web de Linkerd con:
```sh
linkerd viz install | kubectl apply -f -
linkerd viz dashboard
```
Esto abrirá una página web local con métricas y monitoreo de tus servicios meshados.

### 6. Inyectar Linkerd a tus servicios
Para agregar Linkerd a un deployment existente (namespace = default de ejemplo):
```sh
kubectl get deploy -n <namespace>
kubectl -n <namespace> get deploy <nombre> -o yaml | linkerd inject - | kubectl apply -f -
```
O al crear un deployment nuevo, agrega la anotación:
```yaml
metadata:
	annotations:
		linkerd.io/inject: enabled
```

---

> **Nota:** Linkerd es mucho más ligero que Istio y suficiente para la mayoría de pruebas y monitoreo de microservicios en entornos de laboratorio o educativos.
---

## Ejemplo de Docker Compose con monitoreo básico

Puedes levantar tu microservicio y monitorearlo fácilmente usando Docker Compose y cAdvisor:

1. Crea un archivo `docker-compose.yml` en la carpeta de tu microservicio con el siguiente contenido:

```yaml
version: "3.8"
services:
	microservicio-ejemplo:
		build: .
		container_name: microservicio-ejemplo
		ports:
			- "5000:5000"
		restart: always

	cadvisor:
		image: gcr.io/cadvisor/cadvisor:latest
		container_name: cadvisor
		ports:
			- "8080:8080"
		volumes:
			- /:/rootfs:ro
			- /var/run:/var/run:ro
			- /sys:/sys:ro
			- /var/lib/docker/:/var/lib/docker:ro
		restart: always
```

2. Levanta los servicios:
```sh
docker compose up -d
```

3. Accede a los servicios desde tu máquina remota:
- Microservicio Flask:  
	`http://IP_RASPBERRY_PI:5000/`
- cAdvisor (monitoreo de contenedores):  
	`http://IP_RASPBERRY_PI:8080/`

Así podrás ver el estado y métricas de tus contenedores desde cualquier navegador en la red local.

> **Nota:** Para monitoreo avanzado puedes agregar Prometheus y Grafana, o integrar Istio cuando escales a Kubernetes en una máquina más potente.
---

## Verificar e instalar Docker Compose

Para usar Docker Compose y levantar varios microservicios fácilmente, asegúrate de tenerlo instalado:

1. Verifica la versión de Docker Compose (plugin moderno):
	```sh
	docker compose version
	```
	o para la versión clásica:
	```sh
	docker-compose --version
	```
	Si ves la versión, ya está instalado.

2. Si no está instalado, puedes instalarlo con:
	```sh
	sudo apt install docker-compose
	```
	o para el plugin moderno (recomendado):
	```sh
	sudo apt install docker-compose-plugin
	```

Después de esto, podrás usar Docker Compose para definir y levantar tus microservicios fácilmente.
---

## Liberar recursos: detener Kubernetes (k3s) en la Raspberry Pi

Si quieres liberar recursos y no usar Kubernetes temporalmente, puedes detener el servicio k3s:

1. Verifica el estado de k3s:
	```sh
	sudo systemctl status k3s
	```
	Si ves “active (running)”, k3s está usando recursos.

2. Detén k3s para liberar memoria y CPU:
	```sh
	sudo systemctl stop k3s
	```

3. (Opcional) Deshabilita k3s para que no inicie automáticamente al arrancar:
	```sh
	sudo systemctl disable k3s
	```

Puedes volver a activarlo cuando lo necesites con:
```sh
sudo systemctl start k3s
```
o habilitarlo de nuevo:
```sh
sudo systemctl enable k3s
```
---

# Solución de problemas comunes en el despliegue de microservicios

## 1. Error ImagePullBackOff (imagen local no encontrada)

Esto ocurre cuando Kubernetes no puede encontrar la imagen Docker local. Soluciones:

- Asegúrate de construir la imagen localmente:
	```sh
	docker build -t microservicio-ejemplo:latest .
	```
- En el manifiesto de tu deployment, agrega:
	```yaml
	imagePullPolicy: Never
	```
	Ejemplo:
	```yaml
	containers:
	- name: microservicio-ejemplo
		image: microservicio-ejemplo:latest
		imagePullPolicy: Never
		ports:
		- containerPort: 5000
	```
- Aplica el manifiesto de nuevo:
	```sh
	kubectl apply -f deployment.yaml
	```

## 2. Eliminar recursos antiguos o con errores

Si necesitas limpiar pods o servicios con errores:
```sh
kubectl delete -f deployment.yaml
```

Si ves errores de red o lentitud, reinicia k3s:
```sh
sudo systemctl restart k3s
```

## 3. Problemas de permisos con kubectl

Si kubectl muestra errores de permisos o busca el archivo de configuración en `/etc/rancher/k3s/k3s.yaml`, asegúrate de:
```sh
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
```
Puedes agregar la línea del export a tu `~/.bashrc` para que sea permanente.

## 4. Verifica el estado de k3s

Si kubectl no responde o hay errores de conexión:
```sh
sudo systemctl status k3s
sudo systemctl restart k3s
```

---
## Instalación y configuración de Docker en Raspberry Pi

Si al intentar usar Docker ves el error `docker: command not found`, sigue estos pasos:

1. Verifica si Docker está instalado:
	```sh
	which docker
	```
	Si no devuelve nada, instala Docker:

2. Instala Docker:
	```sh
	curl -sSL https://get.docker.com | sh
	```

3. Agrega tu usuario al grupo docker (para evitar usar sudo):
	```sh
	sudo usermod -aG docker $USER
	```
	Luego cierra la sesión y vuelve a entrar, o ejecuta:
	```sh
	newgrp docker
	```

4. Verifica la instalación:
	```sh
	docker --version
	```

Después de esto, podrás usar Docker normalmente, incluso desde tu ambiente virtual.
# Despliegue de un Microservicio de Ejemplo en Kubernetes (k3s)

## 1. Crear un microservicio de ejemplo (Python Flask)

1. Crea una carpeta para el microservicio:
	 ```sh
	 mkdir ~/microservicio-ejemplo
	 cd ~/microservicio-ejemplo
	 ```

2. Crea un archivo `app.py` con este contenido:
	 ```python
	 from flask import Flask
	 app = Flask(__name__)

	 @app.route("/")
	 def hello():
			 return "¡Microservicio Python en Kubernetes!"

	 if __name__ == "__main__":
			 app.run(host="0.0.0.0", port=5000)
	 ```

3. Crea un archivo `requirements.txt`:
	 ```
	 flask
	 ```

---

## 2. Crear un Dockerfile

En la misma carpeta, crea un archivo llamado `Dockerfile`:
```Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```

---

## 3. Construir la imagen Docker

Si tienes Docker en la Raspberry Pi:
```sh
docker build -t microservicio-ejemplo:latest .
```

---

## 4. Crear el manifiesto de despliegue para Kubernetes

Crea un archivo `deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
	name: microservicio-ejemplo
spec:
	replicas: 1
	selector:
		matchLabels:
			app: microservicio-ejemplo
	template:
		metadata:
			labels:
				app: microservicio-ejemplo
		spec:
			containers:
			- name: microservicio-ejemplo
				image: microservicio-ejemplo:latest
				ports:
				- containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
	name: microservicio-ejemplo
spec:
	type: NodePort
	selector:
		app: microservicio-ejemplo
	ports:
		- protocol: TCP
			port: 5000
			targetPort: 5000
			nodePort: 30500
```

---

## 5. Desplegar en Kubernetes

Desde la carpeta donde está `deployment.yaml`:
```sh
kubectl apply -f deployment.yaml
```

---

## 6. Verificar el despliegue

```sh
kubectl get pods
kubectl get svc
```

Accede a tu microservicio desde tu navegador o con curl usando la IP de tu Raspberry Pi y el puerto 30500:
```
http://IP_RASPBERRY_PI:30500/
```

---

Si necesitas adaptar algún paso o agregar detalles para otros lenguajes o frameworks, puedes hacerlo aquí.
