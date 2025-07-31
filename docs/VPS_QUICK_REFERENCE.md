# 🎯 VPS Claude-Flow Quick Reference

## 🚀 Schnellstart (Copy & Paste)

### 1. Mit VPS verbinden & Status prüfen
```bash
ssh root@69.62.119.90
claude-status
```

### 2. tmux Session öffnen
```bash
tmux attach -t claude-flow
# Verlassen mit: Ctrl+B, dann D
```

### 3. Einfacher Spawn
```bash
claude-spawn "Deine Aufgabe hier"
```

## 📋 Die wichtigsten Spawns für deine Projekte

### Church-NextJS
```bash
# Feature hinzufügen
claude-spawn "Add [FEATURE] to church-nextjs at /var/www/church.assistent.my.id" --max-workers 10

# Bug fixen
claude-spawn "Fix [ISSUE] in church-nextjs" --max-workers 6
```

### FaithTranslate
```bash
# Neue Sprache
claude-spawn "Add [LANGUAGE] support to faith-translate at /var/www/faith.assistent.my.id" --max-workers 8

# Performance
claude-spawn "Optimize faith-translate translation speed" --max-workers 10
```

### StepUpFundraiser
```bash
# Neues Feature
claude-spawn "Create [FEATURE] for stepupfundraiser at /var/www/stepup.assistent.my.id" --max-workers 12

# Analytics
claude-spawn "Add analytics dashboard to stepupfundraiser" --max-workers 15
```

## 🔧 Häufige Operationen

### Alle Projekte analysieren
```bash
claude-spawn "Analyze all projects in /var/www and create optimization report" --max-workers 20
```

### Security Check
```bash
claude-spawn "Security audit for all services in /var/www" --max-workers 10 --agents "security-engineer"
```

### Performance Optimierung
```bash
claude-spawn "Optimize performance across all projects" --max-workers 15 --queen-type strategic
```

## 📊 Monitoring

### Aktive Schwärme anzeigen
```bash
claude-flow hive-mind sessions
```

### Schwarm beenden
```bash
claude-flow hive-mind sessions  # SESSION_ID kopieren
claude-flow hive-mind terminate [SESSION_ID]
```

### Logs anschauen
```bash
# System Logs
tail -f /var/log/claude-flow/main.log

# Service Logs
journalctl -u claude-flow -f
```

## 🚨 Wenn was nicht funktioniert

### Service neustarten
```bash
systemctl restart claude-flow
```

### tmux neu starten
```bash
tmux kill-session -t claude-flow
/root/claude-development/production-hub/start-claude-flow.sh
```

### Kompletter Reset
```bash
systemctl stop claude-flow
pkill -f claude-flow
systemctl start claude-flow
```

## 🌐 Web UI

```bash
# Auf VPS
http://69.62.119.90:8888

# Oder SSH Tunnel (sicherer)
# Lokal ausführen:
ssh -L 8888:localhost:8888 root@69.62.119.90
# Dann: http://localhost:8888
```

## 💡 Power User Tips

### 1. Spawn mit mehreren Agents
```bash
claude-spawn "Build complete feature" \
  --agents "frontend-engineer,backend-engineer,qa-engineer" \
  --max-workers 12
```

### 2. Batch Spawns
```bash
# Update alle Dependencies
for proj in church faith stepup; do
  claude-spawn "Update dependencies in /var/www/${proj}.assistent.my.id" --max-workers 5
  sleep 30
done
```

### 3. Spawn mit Priorität
```bash
claude-spawn "Critical bug fix" --priority high --max-workers 10
```

---

**Pro Tip**: Diese Datei auf VPS kopieren:
```bash
scp VPS_QUICK_REFERENCE.md root@69.62.119.90:/root/
```

Dann auf VPS: `cat /root/VPS_QUICK_REFERENCE.md`