# 🚀 Claude-Flow Complete Guide

## 📂 Script Location
**Alle Scripts befinden sich in:**
```bash
~/claude-development/local-development-hub/
```

## 📋 Quick Start

### 1. Swarms aufräumen (falls nötig)
```bash
./swarm-manager.sh
# Option 2 wählen für "Terminate ALL swarms"
```

### 2. Claude-Flow mit tmux starten
```bash
./claude-flow-autostart.sh
# Prüft automatisch ob etwas läuft und fragt nach
```

### 3. Neuen Swarm spawnen
```bash
# In tmux Window 2 (Control) oder neuem Terminal:
cd ~/claude-development/local-development-hub
npx claude-flow@alpha hive-mind spawn "Dein Ziel hier" --claude --max-workers 20
```

## 🐝 Hive Mind Spawn - Alle Parameter

### Basis Syntax
```bash
npx claude-flow@alpha hive-mind spawn "OBJECTIVE" [OPTIONS]
```

### Alle verfügbaren Parameter:

#### Queen Type (Führungsstil)
```bash
--queen-type strategic    # Langfristige Planung (default)
--queen-type adaptive     # Flexible Anpassung
--queen-type tactical     # Kurzfristige Taktik
--queen-type exploratory  # Forschung & Entdeckung
```

#### Worker Configuration
```bash
--max-workers 20          # Anzahl der Worker (default: 8)
--worker-types "researcher,coder,analyst,tester,architect,reviewer"
```

#### Consensus & Decision Making
```bash
--consensus majority      # Mehrheitsentscheidung (default)
--consensus weighted      # Gewichtete Entscheidung
--consensus byzantine     # Byzantine fault tolerance
```

#### Memory & Performance
```bash
--memory-size 200         # Kollektiver Speicher in MB (default: 100)
--auto-scale             # Automatische Skalierung
--monitor                # Real-time Monitoring Dashboard
```

#### Claude Code Integration
```bash
--claude                 # Erstellt Claude Code spawn command
--auto-spawn            # Startet Claude Code automatisch
--execute               # Führt Command sofort aus
```

#### Weitere Optionen
```bash
--encryption            # Verschlüsselte Kommunikation
--verbose              # Detailliertes Logging
--no-interactive       # Nicht-interaktiver Modus
```

### 📝 Beispiel-Commands

#### Standard Swarm (4 Workers)
```bash
npx claude-flow@alpha hive-mind spawn "Build a REST API" --claude
```

#### Power User Swarm (20 Workers, adaptive)
```bash
npx claude-flow@alpha hive-mind spawn \
  "Analyze and optimize entire codebase" \
  --claude \
  --max-workers 20 \
  --queen-type adaptive \
  --auto-scale \
  --memory-size 500 \
  --verbose
```

#### Research Swarm (exploratory)
```bash
npx claude-flow@alpha hive-mind spawn \
  "Research AI development best practices" \
  --claude \
  --queen-type exploratory \
  --max-workers 12 \
  --worker-types "researcher,analyst"
```

#### Development Swarm (full stack)
```bash
npx claude-flow@alpha hive-mind spawn \
  "Build complete web application with auth" \
  --claude \
  --max-workers 16 \
  --worker-types "architect,frontend,backend,tester,devops" \
  --consensus weighted \
  --auto-scale
```

## 🔧 Management Commands

### Status & Monitoring
```bash
# Alle Swarms anzeigen
npx claude-flow@alpha hive-mind status

# Detaillierte Sessions
npx claude-flow@alpha hive-mind sessions

# Performance Metriken
npx claude-flow@alpha hive-mind metrics

# Kollektives Gedächtnis
npx claude-flow@alpha hive-mind memory
```

### Session Control
```bash
# Session fortsetzen
npx claude-flow@alpha hive-mind resume [session-id]

# Session stoppen
npx claude-flow@alpha hive-mind stop [session-id]

# Consensus Entscheidungen anzeigen
npx claude-flow@alpha hive-mind consensus
```

## 🌐 VPS vs. Local - Keine Konflikte!

### Warum sie sich NICHT stören:

1. **Getrennte Environments**
   - VPS: `/var/www` mit lokaler npx Installation
   - WSL: `~/claude-development/local-development-hub` mit globaler Installation
   
2. **Unterschiedliche Ports**
   - VPS: Port 8019 (oder wie konfiguriert)
   - Local: Port 3008
   
3. **Separate Datenbanken**
   - VPS: `/var/www/.hive-mind/hive.db`
   - Local: `~/claude-development/local-development-hub/.hive-mind/hive.db`

4. **Isolierte Prozesse**
   - Keine gemeinsamen PIDs
   - Keine gemeinsamen Sockets
   - Keine gemeinsamen Memory Stores

### Parallel-Betrieb möglich:
```bash
# VPS (Remote)
ssh user@vps
cd /var/www
npx claude-flow@alpha hive-mind spawn "Production optimization" --claude

# Local (WSL)
cd ~/claude-development/local-development-hub
npx claude-flow@alpha hive-mind spawn "Local development" --claude
```

## 📊 tmux Cheat Sheet

### Navigation
- **Attach**: `tmux attach -t claude-flow`
- **Detach**: `Ctrl+B`, dann `D`
- **Switch Windows**: `Ctrl+B`, dann `0-3`
- **Kill Session**: `tmux kill-session -t claude-flow`

### Windows
- **0**: MCP Server
- **1**: UI + Orchestrator
- **2**: Control (Commands)
- **3**: Monitor (htop/top)

## 🚨 Troubleshooting

### Services starten nicht
```bash
# Alles killen und neu starten
pkill -9 -f claude-flow
./claude-flow-autostart.sh
```

### "MCP Server: Stopped" Status
Das ist ein Display-Bug. Prüfe mit:
```bash
npx claude-flow@alpha hive-mind status
# Wenn Swarms aktiv sind, läuft alles
```

### Port bereits belegt
```bash
lsof -i :3008
# Kill den Prozess oder wähle anderen Port
```

## 🎯 Best Practices

1. **Immer tmux verwenden** für persistente Sessions
2. **Regelmäßig alte Swarms aufräumen** mit swarm-manager.sh
3. **Spezifische Objectives** formulieren für bessere Ergebnisse
4. **Worker-Anzahl** an Aufgabe anpassen (nicht immer 20 nötig)
5. **Queen-Type** bewusst wählen je nach Aufgabe

---

**Scripts Location**: `~/claude-development/local-development-hub/`
- `swarm-manager.sh` - Swarm Verwaltung
- `claude-flow-autostart.sh` - Auto-Start mit Checks
- `tmux-claude-flow.sh` - Basis tmux Setup
- `CLAUDE_FLOW_GUIDE.md` - Diese Anleitung