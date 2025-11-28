# Iniciar un Repositorio en GitHub desde PowerShell

Sigue estos pasos para subir tu proyecto a GitHub usando PowerShell:

1. **Crea el repositorio en GitHub:**
   - Ve a https://github.com y haz clic en “New repository”.
   - Ponle nombre, elige si es público o privado, y créalo (sin README, .gitignore ni licencia).

2. **Abre PowerShell y navega a la carpeta raíz de tu proyecto:**
   ```powershell
   cd "c:\Users\sambo\Documents\Programacion\GitHub\MicroServicios"
   ```

3. **Inicializa git (si no lo has hecho):**
   ```powershell
   git init
   ```

4. **Agrega los archivos y haz el primer commit:**
   ```powershell
   git add .
   git commit -m "Primer commit"
   ```

5. **Conecta tu repositorio local con el de GitHub** (reemplaza TU_USUARIO y TU_REPO):
   ```powershell
   git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
   ```

6. **Sube tu código:**
   ```powershell
   git branch -M main
   git push -u origin main
   ```

¡Listo! Tu proyecto estará en GitHub.
