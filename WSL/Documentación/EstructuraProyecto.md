# Estructura de Carpetas y Servicios del Proyecto

Esta es una propuesta de estructura para tu proyecto de microservicios, considerando desarrollo en WSL, despliegue de páginas web y base de datos en Raspberry Pi, y documentación centralizada.

## Estructura de carpetas sugerida

```
/microservicios/WSL/
├── Documentación/
│   ├── ArquitecturaProyecto.md
│   ├── MicroservicioEjemplo.md
│   └── ...
├── servicios/
│   ├── personas-api/           # Microservicio API de personas (Flask/FastAPI/MCP)
│   │   ├── app.py
│   │   ├── requirements.txt
│   │   ├── Dockerfile
│   │   └── ...
│   ├── autenticacion-api/      # (Opcional) Microservicio de autenticación
│   └── ...
├── frontend/
│   ├── flask-frontend/         # Frontend en Flask (opcional)
│   ├── react-frontend/         # Frontend en React (opcional)
│   └── ...
├── docker-compose.yml          # Orquestación local de microservicios
├── k8s/                        # Manifiestos Kubernetes (si usas k8s)
│   ├── personas-api-deploy.yaml
│   └── ...
└── scripts/                    # Scripts útiles (deploy, backup, etc.)

# En la Raspberry Pi (vía SSH):
/var/www/html/proyecto/         # Páginas web estáticas del proyecto
/var/lib/mysql/                 # Datos de MariaDB
```

## Servicios sugeridos

- **personas-api:** Microservicio CRUD de personas (Flask/FastAPI/MCP), conecta a MariaDB en la Raspberry Pi.
- **autenticacion-api:** (Opcional) Microservicio de autenticación y usuarios.
- **frontend:** Web en Flask, React o HTML estático (puede alojarse en la Pi o como microservicio).
- **mariadb:** Base de datos en la Raspberry Pi.
- **apache:** Servidor web en la Raspberry Pi para páginas estáticas.
- **orquestador:** Docker Compose (desarrollo) y/o Kubernetes (para pruebas de Istio, monitoreo, etc.).
- **monitoreo:** Portainer, cAdvisor, Istio, Grafana, Prometheus (según el entorno).

## Notas
- Puedes agregar/quitar microservicios según tus necesidades.
- Mantén la documentación y scripts en la carpeta Documentación.
- Usa variables de entorno para las IPs y credenciales.
- Versiona todo el proyecto con Git.

Esta estructura te permitirá escalar, mantener y documentar tu proyecto de forma clara y profesional.