# flask-frontend

Frontend en Flask para consumir el microservicio personas-api.

## Uso


1. (Recomendado) Crea y activa un entorno virtual:
   ```sh
   python3 -m venv venv
   source venv/bin/activate  # En Linux/WSL
   venv\Scripts\activate    # En Windows
   ```
2. Instala dependencias:
   ```sh
   pip install -r requirements.txt
   ```
3. Ejecuta la app:
   ```sh
   python app.py
   ```
4. Accede a [http://localhost:8000](http://localhost:8000)

## Docker

Para construir y correr el contenedor:

```sh
docker build -t flask-frontend .
docker run -p 8000:8000 flask-frontend
```

## Estructura
- `app.py`: Lógica principal Flask
- `templates/index.html`: Página principal
- `requirements.txt`: Dependencias
- `Dockerfile`: Imagen para Docker
