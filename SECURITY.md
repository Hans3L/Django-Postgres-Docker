# Política de Seguridad
 
## Alcance del proyecto
 
Este es un proyecto educativo (réplica de un sistema monolítico con Django, PostgreSQL y Docker). No está pensado para producción tal cual, pero se documenta esta política para dejar claro cómo reportar problemas y qué advertencias de seguridad ya se conocen.
 
## Versiones soportadas
 
Al ser un repositorio educativo con una sola rama activa, solo se dan mantenimiento a los reportes sobre la última versión de `master`.
 
| Rama / Versión | Soportada |
| --------------- | --------- |
| `master` (última) | V |
| Cualquier fork/tag anterior | X |
 
## Cómo reportar una vulnerabilidad
 
Si encuentras un problema de seguridad:
 
1. **No abras un issue público** para vulnerabilidades sensibles (credenciales expuestas, RCE, etc.).
2. Usa la pestaña **"Security" → "Report a vulnerability"** de GitHub (Private Vulnerability Reporting) si está habilitada en este repositorio.
3. Alternativamente, escribe a **hansel.hir@gmail.com** describiendo:
   - Pasos para reproducir el problema.
   - Impacto potencial.
   - Versión/commit afectado.
Recibirás una respuesta en un plazo razonable dado que este es un proyecto de mantenimiento personal, no un producto con SLA formal. Los problemas no sensibles (mejoras de configuración, dependencias desactualizadas) sí pueden reportarse como issues normales.
 
## Advertencias de seguridad conocidas
 
Estas son limitaciones **ya identificadas** en el estado actual del código. Si vas a usar este proyecto más allá de fines educativos, corrígelas antes de exponerlo:
 
- **`SECRET_KEY` hardcodeada en `settings.py`**: la clave está en el historial de git y por tanto ya debe considerarse comprometida. Debe moverse a una variable de entorno (`os.environ.get("DJANGO_SECRET_KEY")`) y **regenerarse**, no solo removerse del archivo.
- **`DEBUG = True`**: expone tracebacks completos y variables internas ante cualquier error. Debe ser `False` en cualquier entorno accesible públicamente, controlado también por variable de entorno.
- **`ALLOWED_HOSTS = []`**: solo funciona porque `DEBUG=True`; en producción, con `DEBUG=False`, la app rechazará todas las peticiones hasta que se configure explícitamente.
- **Credenciales de base de datos hardcodeadas**: usuario, host y puerto de PostgreSQL están escritos directamente en `settings.py`. El proyecto ya incluye `python-dotenv` en `requirements.txt` pero no se usa; se recomienda cargar estos valores desde un archivo `.env` (no versionado) o desde secretos del entorno.
- **`Django==2.2.28` está fuera de soporte** (fin de vida desde abril de 2021) y no recibe parches de seguridad. Se recomienda actualizar a una versión con soporte activo (ver [Django Roadmap](https://www.djangoproject.com/download/#supported-versions)) y revisar los cambios necesarios en el código.
- **Imagen base `centos:centos7`** en el `Dockerfile`: CentOS 7 ya no recibe actualizaciones de seguridad. Se recomienda migrar a una imagen mantenida (por ejemplo, `python:3.x-slim`).
- **El contenedor corre como root**: el `Dockerfile` no define un `USER` distinto de root. Se recomienda crear un usuario sin privilegios y usarlo para ejecutar la aplicación.
## Buenas prácticas recomendadas para quien despliegue este proyecto
 
- Usar variables de entorno o un gestor de secretos para `SECRET_KEY` y credenciales de base de datos.
- No commitear archivos `.env` (ya está cubierto en `.dockerignore`/`.gitignore`, verifícalo antes de cada commit).
- Fijar `DEBUG=False` y configurar `ALLOWED_HOSTS` en cualquier entorno expuesto a internet.
- Ejecutar `pip list --outdated` / herramientas como `pip-audit` o Dependabot periódicamente.
- Ejecutar el contenedor con un usuario no root.
