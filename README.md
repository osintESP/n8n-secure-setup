# N8N Secure Setup with PostgreSQL

This repository contains a production-ready Docker Compose setup for [n8n](https://n8n.io/).

## Features

- **Persistence**: Uses PostgreSQL 16 instead of the default SQLite for robust data storage.
- **Security**:
  - Secrets management via `.env` file (not committed).
  - Non-root user execution.
  - Resource limits configured.
- **Stability**: Version pinning for n8n and database images.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/osintESP/n8n-secure-setup.git
   cd n8n-secure-setup
   ```

2. Create a `.env` file based on your needs (see `docker-compose.yml` for required variables):
   ```bash
   # Example .env
   POSTGRES_USER=n8n
   POSTGRES_PASSWORD=secure_password
   POSTGRES_DB=n8n
   N8N_ENCRYPTION_KEY=your_encryption_key
   N8N_HOST=localhost
   N8N_PORT=5678
   N8N_PROTOCOL=http
   GENERIC_TIMEZONE=Europe/Rome
   ```

3. Start the services:
   ```bash
   docker compose up -d
   ```

4. Access n8n at `http://localhost:5678`.
