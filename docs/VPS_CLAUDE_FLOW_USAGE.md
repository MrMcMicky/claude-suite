# 🚀 VPS Claude-Flow Verwendung - Komplettanleitung

## 📍 Verbindung zum VPS

```bash
# Von deinem lokalen Terminal:
ssh root@69.62.119.90

# Oder mit VS Code Remote SSH
```

## 🐝 Claude-Flow Hive Mind Befehle

### 1. **Status prüfen**
```bash
# Quick Status
claude-status

# Detaillierter Status
claude-flow status --detailed

# tmux Sessions anzeigen
tmux ls

# Aktive Schwärme anzeigen
claude-flow hive-mind sessions
```

### 2. **tmux Session Management**
```bash
# Mit Claude-Flow verbinden
tmux attach -t claude-flow

# Zwischen Fenstern wechseln (in tmux)
Ctrl+B, dann:
  0 - UI/Console
  1 - Swarm Manager
  2 - MCP Servers
  3 - Hive Monitor
  4 - System Monitor (htop)

# tmux verlassen (Session läuft weiter!)
Ctrl+B, dann D

# Neue tmux Session starten (falls gestoppt)
/root/claude-development/production-hub/start-claude-flow.sh
```

### 3. **Spawn Commands (Schwärme starten)**

#### Einfache Beispiele:
```bash
# Basis Spawn
claude-spawn "Analyze the faith-translate codebase"

# Mit Worker-Anzahl
claude-spawn "Optimize church-nextjs performance" --max-workers 10

# Mit Queen-Type
claude-spawn "Create comprehensive test suite for stepupfundraiser" \
  --max-workers 8 \
  --queen-type strategic
```

#### Projekt-spezifische Spawns:

**Church-NextJS:**
```bash
# Feature hinzufügen
npx claude-flow hive-mind spawn \
  "Add prayer request management feature to /var/www/church.assistent.my.id" \
  --claude \
  --max-workers 12 \
  --queen-type adaptive

# Bug Fix
npx claude-flow hive-mind spawn \
  "Fix authentication issues in /var/www/church.assistent.my.id/api" \
  --claude \
  --max-workers 6 \
  --queen-type tactical
```

**FaithTranslate:**
```bash
# Neue Sprache
npx claude-flow hive-mind spawn \
  "Add Hebrew language support to /var/www/faith.assistent.my.id" \
  --claude \
  --max-workers 10 \
  --queen-type specialized \
  --focus "language-processing,api-integration"

# Performance
npx claude-flow hive-mind spawn \
  "Optimize real-time translation in /var/www/faith.assistent.my.id" \
  --claude \
  --max-workers 8 \
  --queen-type strategic
```

**StepUpFundraiser:**
```bash
# Analytics Dashboard
npx claude-flow hive-mind spawn \
  "Create donation analytics dashboard for /var/www/stepup.assistent.my.id" \
  --claude \
  --max-workers 15 \
  --queen-type strategic \
  --agents "frontend-engineer,data-scientist,database-engineer"

# Payment Integration
npx claude-flow hive-mind spawn \
  "Integrate Stripe payment gateway in /var/www/stepup.assistent.my.id" \
  --claude \
  --max-workers 10 \
  --queen-type tactical
```

### 4. **Queen Types Übersicht**

```bash
# Strategic Queen - Für große, komplexe Aufgaben
claude-spawn "Redesign entire authentication system" --queen-type strategic

# Tactical Queen - Für spezifische, fokussierte Aufgaben
claude-spawn "Fix specific bug in payment module" --queen-type tactical

# Adaptive Queen - Passt sich dynamisch an
claude-spawn "Improve overall application performance" --queen-type adaptive

# Specialized Queen - Für Domain-spezifische Aufgaben
claude-spawn "Implement ML model for user predictions" --queen-type specialized
```

### 5. **Agent-spezifische Spawns**

```bash
# Frontend Task
npx claude-flow hive-mind spawn \
  "Create responsive dashboard UI" \
  --claude \
  --agents "frontend-engineer,ui-ux-designer" \
  --max-workers 6

# Backend Task
npx claude-flow hive-mind spawn \
  "Optimize database queries and API performance" \
  --claude \
  --agents "backend-engineer,database-engineer" \
  --max-workers 8

# Full-Stack Task
npx claude-flow hive-mind spawn \
  "Build complete user management system" \
  --claude \
  --agents "frontend-engineer,backend-engineer,database-engineer,qa-engineer" \
  --max-workers 12

# DevOps Task
npx claude-flow hive-mind spawn \
  "Setup CI/CD pipeline with monitoring" \
  --claude \
  --agents "devops-engineer,sre-engineer" \
  --max-workers 6
```

### 6. **Swarm Management**

```bash
# Alle aktiven Schwärme anzeigen
claude-flow hive-mind sessions

# Detaillierte Info zu einem Schwarm
claude-flow hive-mind session [SESSION_ID]

# Schwarm-Fortschritt beobachten
claude-flow hive-mind monitor [SESSION_ID]

# Schwarm beenden
claude-flow hive-mind terminate [SESSION_ID]

# Alle Schwärme beenden
claude-flow hive-mind terminate-all
```

### 7. **Log-Analyse**

```bash
# Claude-Flow Logs
tail -f /var/log/claude-flow/main.log

# Swarm-spezifische Logs
claude-flow logs [SESSION_ID]

# Error Logs
journalctl -u claude-flow -f

# tmux Session Logs
tmux capture-pane -t claude-flow:0 -p
```

## 🎯 Praktische Workflows

### Workflow 1: **Neues Feature entwickeln**
```bash
# 1. Status prüfen
claude-status

# 2. Spawn starten
claude-spawn \
  "Implement user notification system in /var/www/church.assistent.my.id" \
  --max-workers 10 \
  --queen-type adaptive

# 3. Progress überwachen
tmux attach -t claude-flow
# Wechsel zu Window 3 (Hive Monitor)

# 4. Ergebnisse prüfen
cd /var/www/church.assistent.my.id
git status
git diff
```

### Workflow 2: **Multi-Projekt Optimierung**
```bash
# Alle Projekte analysieren
npx claude-flow hive-mind spawn \
  "Analyze and optimize all projects in /var/www: \
   - church.assistent.my.id \
   - faith.assistent.my.id \
   - stepup.assistent.my.id \
   Focus on: performance, security, code quality" \
  --claude \
  --max-workers 20 \
  --queen-type strategic \
  --auto-scale
```

### Workflow 3: **Debugging Session**
```bash
# Debug mit spezialisierten Agents
npx claude-flow hive-mind spawn \
  "Debug authentication issues across all services" \
  --claude \
  --agents "backend-engineer,security-engineer,database-engineer" \
  --max-workers 8 \
  --queen-type tactical \
  --priority high
```

## 🌐 Web UI Zugriff

```bash
# Lokal über SSH-Tunnel (sicherer)
ssh -L 8888:localhost:8888 root@69.62.119.90
# Dann im Browser: http://localhost:8888

# Oder direkt (weniger sicher)
http://69.62.119.90:8888
```

## 🔧 Service Management

```bash
# Service Status
systemctl status claude-flow

# Service neustarten
systemctl restart claude-flow

# Service stoppen
systemctl stop claude-flow

# Service starten
systemctl start claude-flow

# Logs anzeigen
journalctl -u claude-flow -f
```

## 💡 Pro Tips

1. **Resource Monitoring während Spawns:**
   ```bash
   # In separatem Terminal
   htop
   # oder
   docker stats
   ```

2. **Batch Operations:**
   ```bash
   # Mehrere Spawns nacheinander
   for project in church faith stepup; do
     claude-spawn "Update dependencies in /var/www/${project}.assistent.my.id" \
       --max-workers 5
     sleep 30
   done
   ```

3. **Result Collection:**
   ```bash
   # Spawn mit Output-Sammlung
   SESSION_ID=$(claude-flow hive-mind spawn "Analyze codebase" --claude --json | jq -r '.session_id')
   
   # Warte auf Completion
   claude-flow hive-mind wait $SESSION_ID
   
   # Hole Ergebnisse
   claude-flow hive-mind results $SESSION_ID > analysis-results.md
   ```

## 🚨 Troubleshooting

```bash
# Claude-Flow hängt?
systemctl restart claude-flow

# tmux Session weg?
/root/claude-development/production-hub/start-claude-flow.sh

# Ports blockiert?
netstat -tulpn | grep -E "3008|9000|8888"

# Speicher voll?
df -h
docker system prune -a

# Prozesse beenden
pkill -f claude-flow
tmux kill-server
```

## 📝 Cheat Sheet

```bash
# Die wichtigsten Commands
claude-status                    # Status check
claude-spawn "task"              # Neuer Schwarm
tmux attach -t claude-flow       # Session öffnen
Ctrl+B, D                        # tmux verlassen
claude-flow hive-mind sessions   # Aktive Schwärme
systemctl restart claude-flow    # Neustart
```

---

**Tipp**: Speichere diese Anleitung auf dem VPS:
```bash
scp /mnt/c/Projekte/VS_Code/_DOCS/VPS_CLAUDE_FLOW_USAGE.md root@69.62.119.90:/root/
```