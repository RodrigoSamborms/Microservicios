# Arquitectura y Flujo de Trabajo del Proyecto de Microservicios

## 1. Objetivo

Desarrollar un sistema de ejemplo basado en microservicios, orquestado y monitoreado desde WSL (Windows Subsystem for Linux), con la base de datos y páginas web estáticas alojadas en una Raspberry Pi. Todo el desarrollo, despliegue y monitoreo se realiza desde una sola ventana de VS Code, usando terminales WSL, PowerShell y SSH.

---

## 2. Distribución de Componentes

- **WSL (PC local):**
  - Carpeta principal del proyecto: `/microservicios/WSL`
  - Desarrollo de microservicios (API, lógica de negocio, etc.)
  - Orquestación con Docker Compose o Kubernetes (minikube/kind/k3s)
  - Monitoreo y observabilidad (Istio, Grafana, Prometheus, cAdvisor, Portainer)
  - Terminal WSL para manipular y configurar el entorno

- **Raspberry Pi:**
  - Base de datos MariaDB
  - Servidor Apache para páginas web estáticas del proyecto 
    (accesibles en la red local, por ejemplo,   en http://169.254.218.17/)
  - Carpeta dedicada para las páginas del proyecto (por ejemplo, /var/www/html/proyecto)
  - Configuración y administración vía terminal SSH desde PowerShell

---

## 3. Flujo de Trabajo Sugerido

1. **Desarrollo:**
   - Todo el código fuente y archivos de configuración se crean y versionan en `/microservicios/WSL`.
   - Se pueden crear subcarpetas para cada microservicio, scripts, documentación, etc.

2. **Orquestación y pruebas:**
   - Se ejecutan y orquestan los microservicios en WSL usando Docker Compose o Kubernetes.
   - Los microservicios se configuran para conectarse a la base de datos MariaDB en la Raspberry Pi (usando la IP local de la Pi).

3. **Transferencia de archivos:**
   - Las páginas web y archivos del proyecto se crean en la máquina local y se transfieren a la Raspberry Pi usando scp desde PowerShell.
   
   - Ejemplo: (La IP 169.254.218.17 es de ejemplo, usa la IP real de tu Raspberry Pi en tu red local.)
     En una terminal conectada al Servidor PI, ejecuta:

```sh
scp ruta/local/index.html rodrigo@169.254.218.17:/var/www/html/proyecto/

```


4. **Administración de la Raspberry Pi:**
   - Se accede a la Pi mediante SSH desde PowerShell para instalar, configurar y administrar MariaDB y Apache.

5. **Monitoreo y gestión:**
   - Se monitorean los microservicios y la infraestructura desde WSL usando herramientas como Portainer, cAdvisor, Istio, Grafana, etc.
   - Se puede acceder a los dashboards de monitoreo desde el navegador local.

---

## 4. Ventajas de este enfoque

- Máximo aprovechamiento de los recursos del PC local para la lógica y orquestación.
- Raspberry Pi dedicada solo a la base de datos y/o páginas web estáticas, reduciendo su carga.
- Todo el flujo de trabajo centralizado en VS Code, usando terminales WSL, PowerShell y SSH.
- Facilidad para transferir archivos y administrar ambos entornos desde una sola interfaz.
- Flexibilidad para escalar, monitorear y experimentar con tecnologías modernas de microservicios.

---

## 5. Diagrama de arquitectura (descripción)

```
+-------------------+         +---------------------+
|    WSL (PC)       | <-----> |   Raspberry Pi      |
|-------------------|         |---------------------|
| - Microservicios  |         | - MariaDB           |
| - Orquestador     |         | - Apache (proyecto) |
| - Monitoreo       |         | - /var/www/html/    |
+-------------------+         +---------------------+

```

- Comunicación entre microservicios y base de datos por red local.
- Administración y transferencia de archivos vía SSH/SCP.

---

## 6. Recomendaciones

- Mantén la documentación y scripts en `/microservicios/WSL/Documentación`.
- Usa variables de entorno y archivos de configuración para facilitar el cambio de IP/host de la base de datos.
- Realiza pruebas de conectividad entre WSL y la Raspberry Pi antes de desplegar los servicios.
- Versiona todo el código y la configuración en Git para facilitar el control de cambios.
- Usa variables de entorno y archivos de configuración para facilitar el cambio de IP/host de la base  
de datos y del servidor web.
- Recuerda que la IP 169.254.218.17 es solo de ejemplo; usa la IP real de tu Raspberry Pi según tu red local.
---

Este documento sirve como referencia para el flujo de trabajo y la arquitectura del proyecto. Puedes ampliarlo según evolucione tu solución.
