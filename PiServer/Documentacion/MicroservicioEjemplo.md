A continuación se detallan los archivos y pasos para implementar el microservicio.

---

## 2. Código del microservicio (app.py)

Ejemplo básico usando MCP y MariaDB:

```python
from mcp import ModelContext, Model, Field
from flask import Flask, request, jsonify
import mysql.connector

# Configuración de la base de datos
DB_CONFIG = {
      'host': 'mariadb',
      'user': 'root',
      'password': 'example',
      'database': 'registrodb'
}

app = Flask(__name__)

class Nombre(Model):
      id = Field(int, primary_key=True)
      nombre = Field(str)

ctx = ModelContext()
ctx.register(Nombre)

def get_db():
      return mysql.connector.connect(**DB_CONFIG)

@app.route('/nombres', methods=['POST'])
def agregar_nombre():
      data = request.get_json()
      nombre = data.get('nombre')
      if not nombre:
            return jsonify({'error': 'Falta el nombre'}), 400
      db = get_db()
      cursor = db.cursor()
      cursor.execute('INSERT INTO nombres (nombre) VALUES (%s)', (nombre,))
      db.commit()
      cursor.close()
      db.close()
      return jsonify({'mensaje': 'Nombre agregado'}), 201

@app.route('/nombres', methods=['GET'])
def listar_nombres():
      db = get_db()
      cursor = db.cursor()
      cursor.execute('SELECT id, nombre FROM nombres')
      nombres = [{'id': row[0], 'nombre': row[1]} for row in cursor.fetchall()]
      cursor.close()
      db.close()
      return jsonify(nombres)

if __name__ == '__main__':
      app.run(host='0.0.0.0', port=5000)
```

---

## 3. requirements.txt

```
flask
mcp
mysql-connector-python
```

---

## 4. Dockerfile

```
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```

---

## 5. docker-compose.yml

```
version: "3.8"
services:
   registro:
      build: .
      container_name: microservicio-registro
      ports:
         - "5001:5000"
      depends_on:
         - mariadb
      restart: always

   mariadb:
      image: mariadb:10.7
      container_name: mariadb
      environment:
         MYSQL_ROOT_PASSWORD: example
         MYSQL_DATABASE: registrodb
      ports:
         - "3306:3306"
      volumes:
         - mariadb_data:/var/lib/mysql
      restart: always

volumes:
   mariadb_data:
```

---

## 6. Inicializar la base de datos

Al iniciar por primera vez, crea la tabla en MariaDB (puedes hacerlo desde un cliente MySQL o agregando un script de inicialización):

```sql
CREATE TABLE nombres (
   id INT AUTO_INCREMENT PRIMARY KEY,
   nombre VARCHAR(100) NOT NULL
);
```

Puedes conectarte al contenedor MariaDB con:
```sh
docker exec -it mariadb mysql -u root -p
# Contraseña: example
USE registrodb;
# Pega el comando SQL anterior
```

---

## 7. Gestión y monitoreo

- Usa Portainer (`http://IP_RASPBERRY_PI:9000/`) para gestionar y monitorear los servicios.
- Puedes probar el microservicio con:
   - `POST http://IP_RASPBERRY_PI:5001/nombres` con JSON `{ "nombre": "Juan" }`
   - `GET http://IP_RASPBERRY_PI:5001/nombres` para listar los nombres registrados.
# Microservicio de Registro de Nombres con MCP, Docker y MariaDB

Este ejemplo muestra cómo crear un microservicio usando MCP (Model Context Protocol), Docker y MariaDB, gestionado y monitoreado con Portainer.

## Estructura del proyecto

```
microservicio-registro/
├── app.py                # Microservicio MCP
├── requirements.txt      # Dependencias Python
├── Dockerfile            # Imagen del microservicio
├── docker-compose.yml    # Orquestación de servicios
```

## 1. Crear el entorno y archivos base

1. En el servidor, crea la carpeta del microservicio:
   ```sh
   mkdir -p ~/mcp_project/microservicio-registro
   cd ~/mcp_project/microservicio-registro
   ```
2. (Opcional) Activa tu ambiente virtual de Python:
   ```sh
   source ../.venv/bin/activate
   ```

## 2. Código del microservicio (app.py)

El microservicio expone endpoints para agregar y listar nombres en la base de datos MariaDB usando MCP.

## 3. requirements.txt

Incluye MCP y dependencias necesarias.

## 4. Dockerfile

Define la imagen para el microservicio MCP.

## 5. docker-compose.yml

Orquesta el microservicio, MariaDB y expone los puertos necesarios.

## 6. Gestión y monitoreo

- Usa Portainer para gestionar y monitorear los servicios desde la web.
- Accede a Portainer en `http://IP_RASPBERRY_PI:9000/`.

---

A continuación se detallan los archivos y pasos para implementar el microservicio.

---

# Microservicio de Registro de Nombres con MCP, Docker y MariaDB

Este ejemplo muestra cómo crear un microservicio usando MCP (Model Context Protocol), Docker y MariaDB, gestionado y monitoreado con Portainer.

## Estructura del proyecto

```
microservicio-registro/
├── app.py                # Microservicio MCP
├── requirements.txt      # Dependencias Python
├── Dockerfile            # Imagen del microservicio
├── docker-compose.yml    # Orquestación de servicios
```

## 1. Crear el entorno y archivos base

1. En el servidor, crea la carpeta del microservicio:
   ```sh
   mkdir -p ~/mcp_project/microservicio-registro
   cd ~/mcp_project/microservicio-registro
   ```
2. (Opcional) Activa tu ambiente virtual de Python:
   ```sh
   source ../.venv/bin/activate
   ```

---

## 2. Código del microservicio (app.py)

El microservicio expone endpoints para agregar y listar nombres en la base de datos MariaDB usando MCP.

```python
from mcp import ModelContext, Model, Field
from flask import Flask, request, jsonify
import mysql.connector

# Configuración de la base de datos
DB_CONFIG = {
      'host': 'mariadb',
      'user': 'root',
      'password': 'example',
      'database': 'registrodb'
}

app = Flask(__name__)

class Nombre(Model):
      id = Field(int, primary_key=True)
      nombre = Field(str)

ctx = ModelContext()
ctx.register(Nombre)

def get_db():
      return mysql.connector.connect(**DB_CONFIG)

@app.route('/nombres', methods=['POST'])
def agregar_nombre():
      data = request.get_json()
      nombre = data.get('nombre')
      if not nombre:
            return jsonify({'error': 'Falta el nombre'}), 400
      db = get_db()
      cursor = db.cursor()
      cursor.execute('INSERT INTO nombres (nombre) VALUES (%s)', (nombre,))
      db.commit()
      cursor.close()
      db.close()
      return jsonify({'mensaje': 'Nombre agregado'}), 201

@app.route('/nombres', methods=['GET'])
def listar_nombres():
      db = get_db()
      cursor = db.cursor()
      cursor.execute('SELECT id, nombre FROM nombres')
      nombres = [{'id': row[0], 'nombre': row[1]} for row in cursor.fetchall()]
      cursor.close()
      db.close()
      return jsonify(nombres)

if __name__ == '__main__':
      app.run(host='0.0.0.0', port=5000)
```

---

## 3. requirements.txt

```
flask
mcp
mysql-connector-python
```

---

## 4. Dockerfile

```
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```

---

## 5. docker-compose.yml

```
version: "3.8"
services:
   registro:
      build: .
      container_name: microservicio-registro
      ports:
         - "5001:5000"
      depends_on:
         - mariadb
      restart: always

   mariadb:
      image: mariadb:10.7
      container_name: mariadb
      environment:
         MYSQL_ROOT_PASSWORD: example
         MYSQL_DATABASE: registrodb
      ports:
         - "3306:3306"
      volumes:
         - mariadb_data:/var/lib/mysql
      restart: always

volumes:
   mariadb_data:
```

---

## 6. Inicializar la base de datos

Al iniciar por primera vez, crea la tabla en MariaDB (puedes hacerlo desde un cliente MySQL o agregando un script de inicialización):

```sql
CREATE TABLE nombres (
   id INT AUTO_INCREMENT PRIMARY KEY,
   nombre VARCHAR(100) NOT NULL
);
```

Puedes conectarte al contenedor MariaDB con:
```sh
docker exec -it mariadb mysql -u root -p
# Contraseña: example
USE registrodb;
# Pega el comando SQL anterior
```

---

## 7. Gestión y monitoreo

- Usa Portainer (`http://IP_RASPBERRY_PI:9000/`) para gestionar y monitorear los servicios.
- Puedes probar el microservicio con:
  - `POST http://IP_RASPBERRY_PI:5001/nombres` con JSON `{ "nombre": "Juan" }`
  - `GET http://IP_RASPBERRY_PI:5001/nombres` para listar los nombres registrados.