# Guía de instalación: Docker, Kubernetes (kubectl) y Minikube en WSL

Esta guía explica cómo instalar Docker, kubectl y Minikube en un entorno Ubuntu sobre WSL (Windows Subsystem for Linux). También especifica en qué tipo de terminal ejecutar cada comando para evitar errores.

---

## 1. Instalación de Docker en WSL (Ubuntu)
**Terminal recomendada:** WSL (Ubuntu)

1. Actualiza los paquetes:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
2. Instala dependencias:
   ```bash
   sudo apt install -y ca-certificates curl gnupg lsb-release
   ```
3. Agrega la clave GPG de Docker:
   ```bash
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```
4. Agrega el repositorio de Docker:
   ```bash
   echo \ 
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \ 
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```
5. Instala Docker Engine:
   ```bash
   sudo apt update
   sudo apt install -y docker-ce docker-ce-cli containerd.io
   ```
6. (Opcional) Permite usar Docker sin sudo:
   ```bash
   sudo usermod -aG docker $USER
   # Cierra y vuelve a abrir la terminal para aplicar el cambio
   ```
7. Verifica la instalación:
   ```bash
   docker --version
   ```

---

## 2. Instalación de kubectl en WSL (Ubuntu)
**Terminal recomendada:** WSL (Ubuntu)

1. Descarga el binario:
   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   ```
2. Instala kubectl:
   ```bash
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```
3. Verifica la instalación:
   ```bash
   kubectl version --client
   ```

---

## 3. Instalación de Minikube en WSL (Ubuntu)
**Terminal recomendada:** WSL (Ubuntu)

1. Descarga el binario:
   ```bash
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   ```
2. Instala Minikube:
   ```bash
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```
3. Verifica la instalación:
   ```bash
   minikube version
   ```

---

## Notas importantes
- **No ejecutes estos comandos en PowerShell ni CMD de Windows.** Siempre usa la terminal WSL (Ubuntu) para evitar problemas de rutas y permisos.
- Si usas Docker Desktop en Windows, puedes integrarlo con WSL, pero para este flujo se recomienda usar Docker directamente en WSL.
- Si tienes problemas de permisos, reinicia la terminal o tu equipo tras agregar tu usuario al grupo docker.

---

Para más detalles sobre el uso de cada herramienta, revisa la documentación oficial o los archivos en la carpeta `Documentación/`.
