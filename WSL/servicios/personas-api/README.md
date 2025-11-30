# personas-api

Microservicio de ejemplo para gestión de personas (agenda) usando Flask y MariaDB.

## Endpoints

- `POST /personas`  
  Agrega una persona.  
  JSON de entrada: `{ "nombre": "Juan", "telefono": "123456789" }`

- `GET /personas`  
  Lista todas las personas registradas.

## Configuración de la base de datos

El microservicio espera conectarse a una base de datos MariaDB accesible por red. Por defecto, usa:
- Host: `169.254.218.17` (IP de ejemplo de la Raspberry Pi)
- Usuario: `root`
- Contraseña: `example`
- Base de datos: `agenda`

Puedes cambiar estos valores usando variables de entorno:
- `DB_HOST`
- `DB_USER`
- `DB_PASS`
- `DB_NAME`


## Ejemplo de ejecución local

> **Nota:** Ejecuta estos comandos en una terminal WSL (no en PowerShell) para asegurar compatibilidad con dependencias y red.

```sh
# Instala dependencias
pip install -r requirements.txt

# Ejecuta el microservicio
python app.py
```

## Docker

```sh
# Construye la imagen
docker build -t personas-api .

# Ejecuta el contenedor
# (ajusta la IP de la base de datos si es necesario)
docker run -e DB_HOST=169.254.218.17 -p 5000:5000 personas-api
```
