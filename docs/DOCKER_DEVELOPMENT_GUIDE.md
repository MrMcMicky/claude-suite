# 🐳 Docker Development Guide - VS Code Projekte

## ⚡ Docker-First Policy

**WICHTIG**: Alle Projekte in diesem Repository MÜSSEN mit Docker entwickelt und ausgeführt werden!

## 📋 Warum Docker?

1. **Konsistenz**: Gleiche Umgebung für alle Entwickler
2. **Isolation**: Keine Konflikte zwischen Projekten
3. **Portabilität**: Läuft überall gleich
4. **Einfachheit**: Ein Befehl zum Starten
5. **Skalierbarkeit**: Leicht erweiterbar

## 🚀 Standard Docker-Setup für neue Projekte

### 1. Minimale docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "${PORT:-3000}:3000"
    volumes:
      - .:/app
      - /app/node_modules  # Für Node.js Projekte
    environment:
      - NODE_ENV=development
    command: npm run dev
```

### 2. Standard Dockerfile

#### Für Node.js Projekte:
```dockerfile
FROM node:18-alpine

WORKDIR /app

# Dependencies zuerst (für besseres Caching)
COPY package*.json ./
RUN npm ci

# Dann der Rest
COPY . .

EXPOSE 3000
CMD ["npm", "start"]
```

#### Für Python/Django Projekte:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

#### Für PHP/Laravel Projekte:
```dockerfile
FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install

EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
```

## 🎯 Best Practices

### 1. Multi-Stage Builds für Production
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### 2. Environment Variables
```yaml
# docker-compose.yml
services:
  app:
    env_file:
      - .env
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/dbname
      - REDIS_URL=redis://redis:6379
```

### 3. Volumes für Entwicklung
```yaml
volumes:
  - .:/app                    # Code live reloading
  - /app/node_modules         # Verhindert Überschreibung
  - ./data:/app/data         # Persistente Daten
```

### 4. Netzwerke für Multi-Service Apps
```yaml
version: '3.8'

services:
  frontend:
    networks:
      - app-network
  
  backend:
    networks:
      - app-network
      - db-network
  
  database:
    networks:
      - db-network

networks:
  app-network:
  db-network:
```

## 🔧 Nützliche Docker-Befehle

```bash
# Container starten
docker-compose up -d

# Logs anzeigen
docker-compose logs -f

# In Container einsteigen
docker-compose exec app bash

# Container neu bauen
docker-compose build --no-cache

# Aufräumen
docker-compose down -v
docker system prune -a

# Status prüfen
docker-compose ps
docker stats
```

## 📊 Projekt-Status

### ✅ Bereits mit Docker:
- StepUpFundraiser
- XTTS Voice Cloning

### 🚧 Migration erforderlich:
- Out of the Loop
- BLDB-Webapp
- Anlass-System
- Gebetsstandorte
- ChurchTools Integration

## 🆘 Troubleshooting

### Port bereits belegt
```bash
# Prozess auf Port finden
lsof -i :3000
# Oder alle Docker-Container stoppen
docker stop $(docker ps -q)
```

### Permission Errors
```dockerfile
# Im Dockerfile
RUN chown -R node:node /app
USER node
```

### Langsame Performance (Windows/Mac)
- Verwende named volumes statt bind mounts für node_modules
- Aktiviere Docker Desktop's "Use the WSL 2 based engine"

## 📚 Weiterführende Ressourcen

- [Docker Compose Dokumentation](https://docs.docker.com/compose/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker für VS Code](https://code.visualstudio.com/docs/containers/overview)

---

**Remember**: No local installations! Everything runs in Docker! 🐳