FROM python:3.10-slim
RUN apt-get update && apt-get install -y curl
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip
# Usar mayor timeout y mirror alternativo de PyPI para evitar errores de red
RUN pip install --default-timeout=200 --no-cache-dir -i https://pypi.org/simple -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
