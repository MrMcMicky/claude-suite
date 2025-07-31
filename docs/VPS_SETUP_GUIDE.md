# 🌐 VPS Setup Guide - Organisierte Struktur

## 🎯 Ziel-Struktur auf VPS (69.62.119.90)

```
/var/www/
├── _ACTIVE_PROJECTS/      # 🚀 Produktive Projekte
│   ├── church.assistent.my.id/
│   ├── faith.assistent.my.id/
│   ├── stepup.assistent.my.id/
│   ├── xtts.assistent.my.id/
│   ├── mpm.assistent.my.id/
│   ├── eabw.assistent.my.id/
│   └── studysource.assistent.my.id/
│
├── _CLAUDE_FLOW/          # 🐝 Hive Mind Installation
│   ├── claude-flow-docs/
│   └── production-hub/
│
├── _DOCS/                 # 📚 Dokumentation
│   ├── NGINX_CONFIGS.md
│   ├── DOCKER_PROD.md
│   └── SSL_SETUP.md
│
├── _BACKUP/               # 📦 Backups
└── _LOGS/                 # 📋 Logs
```

## 🔧 Setup Script für VPS

### 1. Basis-Struktur erstellen
```bash
#!/bin/bash
# VPS Organization Script

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   VPS Organization Setup               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"

# Erstelle Basis-Struktur
cd /var/www
sudo mkdir -p _ACTIVE_PROJECTS _CLAUDE_FLOW _DOCS _BACKUP _LOGS

# Verschiebe aktive Projekte
echo -e "${YELLOW}📦 Organisiere aktive Projekte...${NC}"
for domain in church faith stepup xtts mpm eabw studysource; do
    if [ -d "${domain}.assistent.my.id" ]; then
        sudo mv "${domain}.assistent.my.id" "_ACTIVE_PROJECTS/"
        echo -e "  ✓ ${domain}.assistent.my.id verschoben"
    fi
done

# Erstelle symbolische Links (für Nginx)
echo -e "${YELLOW}🔗 Erstelle symbolische Links...${NC}"
cd /var/www
for project in _ACTIVE_PROJECTS/*; do
    if [ -d "$project" ]; then
        basename=$(basename "$project")
        sudo ln -sf "$project" "$basename"
        echo -e "  ✓ Link erstellt: $basename"
    fi
done

echo -e "${GREEN}✅ VPS Organisation abgeschlossen!${NC}"
```

### 2. Claude-Flow für Production
```bash
# Claude-Flow Production Setup
cd /var/www/_CLAUDE_FLOW
mkdir -p production-hub
cd production-hub

# Installation
npm install -g claude-flow@alpha

# Production Config
cat > production-config.json << 'EOF'
{
  "mcp_server": {
    "port": 9000,
    "mode": "production",
    "ssl": true
  },
  "ui": {
    "port": 3008,
    "host": "0.0.0.0",
    "ssl": true
  },
  "hive_mind": {
    "max_concurrent_swarms": 5,
    "auto_cleanup": true,
    "cleanup_after_hours": 24
  }
}
EOF
```

### 3. Nginx Konfiguration
```nginx
# /etc/nginx/sites-available/claude-flow
server {
    listen 443 ssl http2;
    server_name claude.assistent.my.id;
    
    ssl_certificate /etc/letsencrypt/live/assistent.my.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/assistent.my.id/privkey.pem;
    
    location / {
        proxy_pass http://localhost:3008;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
    
    location /ws {
        proxy_pass http://localhost:9000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }
}
```

### 4. Systemd Service
```ini
# /etc/systemd/system/claude-flow.service
[Unit]
Description=Claude-Flow Hive Mind Production
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/_CLAUDE_FLOW/production-hub
ExecStart=/usr/bin/node /usr/bin/claude-flow start --ui --swarm --config production-config.json
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

## 🚀 Quick Commands für VPS

### Status prüfen
```bash
# Alle Docker Container
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Nginx Status
sudo nginx -t && sudo systemctl status nginx

# Claude-Flow Status
sudo systemctl status claude-flow
```

### Projekt-Verwaltung
```bash
# Neues Projekt hinzufügen
sudo /var/www/_DOCS/add-project.sh [projektname]

# Backup erstellen
sudo /var/www/_DOCS/backup-all.sh

# Logs anzeigen
tail -f /var/www/_LOGS/claude-flow.log
```

## 📦 Backup Strategie

```bash
#!/bin/bash
# Daily Backup Script
BACKUP_DIR="/var/www/_BACKUP/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

# Backup aller aktiven Projekte
for project in /var/www/_ACTIVE_PROJECTS/*; do
    if [ -d "$project" ]; then
        name=$(basename "$project")
        docker exec "${name}_db" pg_dump -U user dbname > "$BACKUP_DIR/${name}.sql"
        tar -czf "$BACKUP_DIR/${name}_files.tar.gz" "$project/uploads"
    fi
done

# Cleanup alte Backups (>30 Tage)
find /var/www/_BACKUP -type d -mtime +30 -exec rm -rf {} +
```

## 🔒 Sicherheit

1. **Firewall Rules**
   ```bash
   # Nur notwendige Ports
   sudo ufw allow 22/tcp    # SSH
   sudo ufw allow 80/tcp    # HTTP
   sudo ufw allow 443/tcp   # HTTPS
   sudo ufw allow 3008/tcp  # Claude-Flow (nur von localhost)
   ```

2. **Fail2ban für Nginx**
   ```bash
   sudo apt install fail2ban
   sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
   sudo systemctl enable fail2ban
   ```

3. **SSL Auto-Renewal**
   ```bash
   # Certbot timer prüfen
   sudo systemctl status certbot.timer
   ```