# Scripts de gestión de servicios

En esta carpeta encontrarás scripts útiles para lanzar y detener los microservicios principales del proyecto en WSL.

## Scripts disponibles

- `run_services.sh`: Lanza los servicios `personas-api` y `flask-frontend` solo si no están ya en ejecución.
- `stop_services.sh`: Detiene ambos servicios solo si están en ejecución.


## Uso

### 1. Preparar entornos virtuales (solo la primera vez o tras clonar el proyecto)
Ejecuta el siguiente script para crear y preparar los entornos virtuales de ambos microservicios:
```sh
chmod +x setup_venvs.sh
./setup_venvs.sh
```

### 2. Dar permisos de ejecución a los scripts de gestión (solo la primera vez):
```sh
chmod +x run_services.sh stop_services.sh
```


### 3. Para lanzar ambos servicios (en segundo plano):
```sh
./run_services.sh
```
Los servicios se ejecutarán en segundo plano y los logs se guardarán en los archivos `personas-api.log` y `flask-frontend.log` en las carpetas correspondientes de cada microservicio.

### 4. Para detener ambos servicios:
```sh
./stop_services.sh
```

> El script `setup_venvs.sh` automatiza la creación y preparación de los entornos virtuales y la instalación de dependencias. Úsalo siempre que restaures el proyecto en un entorno nuevo o tras actualizar dependencias.

## Notas
- Los scripts buscan los procesos por la ruta de los archivos `app.py`.
- Si modificas la estructura de carpetas o los nombres de los archivos principales, actualiza los scripts en consecuencia.
