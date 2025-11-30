# Guía de Migración a Otro PC

Si quieres mover tu instancia de n8n a otra computadora manteniendo tus datos, sigue estos pasos. `git clone` solo descarga la estructura, **no tus datos ni tus contraseñas**.

## 1. En la PC Antigua (Origen)

Necesitas guardar dos cosas importantes que **no** están en GitHub:

1.  **El archivo `.env`**:
    *   Copia el archivo `.env` a un lugar seguro (USB, nube privada, etc.).
    *   **IMPORTANTE**: Este archivo tiene la `N8N_ENCRYPTION_KEY`. Si la pierdes, no podrás usar tus credenciales en la nueva PC.

2.  **Tus Datos (Workflows y Credenciales)**:
    *   Ejecuta estos comandos para exportar tus datos a archivos JSON:
    ```bash
    # Exportar workflows
    sudo docker exec n8n-n8n-1 n8n export:workflow --all --output=/home/node/.n8n/workflows.json
    
    # Exportar credenciales (desencriptadas para poder importarlas con la misma key)
    sudo docker exec n8n-n8n-1 n8n export:credentials --all --output=/home/node/.n8n/credentials.json --decrypted
    
    # Copiar los archivos fuera del contenedor
    sudo docker cp n8n-n8n-1:/home/node/.n8n/workflows.json ./workflows.json
    sudo docker cp n8n-n8n-1:/home/node/.n8n/credentials.json ./credentials.json
    ```
    *   Guarda `workflows.json` y `credentials.json` junto con tu `.env`.

## 2. En la PC Nueva (Destino)

1.  **Clonar el repositorio**:
    ```bash
    git clone https://github.com/osintESP/n8n-secure-setup.git
    cd n8n-secure-setup
    ```

2.  **Restaurar configuración**:
    *   Pega tu archivo `.env` guardado en esta carpeta.

3.  **Iniciar servicios**:
    ```bash
    docker compose up -d
    ```

4.  **Restaurar Datos**:
    *   Copia tus archivos JSON a la carpeta del proyecto en la nueva PC.
    *   Cópialos dentro del contenedor e impórtalos:
    ```bash
    # Copiar archivos al contenedor
    sudo docker cp workflows.json n8n-n8n-1:/home/node/.n8n/workflows.json
    sudo docker cp credentials.json n8n-n8n-1:/home/node/.n8n/credentials.json
    
    # Importar workflows
    sudo docker exec n8n-n8n-1 n8n import:workflow --input=/home/node/.n8n/workflows.json
    
    # Importar credenciales
    sudo docker exec n8n-n8n-1 n8n import:credentials --input=/home/node/.n8n/credentials.json
    ```

## Opción B: Migración Completa (Base de Datos + Historial)

Si quieres conservar **todo** (historial de ejecuciones, usuarios, variables, etiquetas), es mejor hacer un backup de la base de datos PostgreSQL.

### 1. En la PC Antigua (Origen)
```bash
# Crear un backup completo de la base de datos
sudo docker exec n8n-postgres-1 pg_dump -U n8n n8n > n8n_full_backup.sql
```
Guarda el archivo `n8n_full_backup.sql` junto con tu `.env`.

### 2. En la PC Nueva (Destino)
Después de iniciar los servicios (`docker compose up -d`), restaura la base de datos:

```bash
# Copiar el backup al contenedor
sudo docker cp n8n_full_backup.sql n8n-postgres-1:/tmp/n8n_full_backup.sql

# Restaurar la base de datos (borrando la existente primero)
sudo docker exec n8n-postgres-1 psql -U n8n -d n8n -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
sudo docker exec n8n-postgres-1 psql -U n8n -d n8n -f /tmp/n8n_full_backup.sql
```

¡Listo! Tu n8n debería estar funcionando con todos tus datos en la nueva PC.
