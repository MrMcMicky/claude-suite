# 🚀 Claude-Suite Quick Reference

## 📋 Verfügbare Scripts

### 1. **claude-suite-manager.sh** (NEU - EMPFOHLEN)
Das umfassende Management-Tool mit allen Features aus der Dokumentation.
```bash
./claude-suite-manager.sh
```

**Features:**
- ✅ Quick Spawn (Adaptive/Tactical)
- ✅ Custom Swarm Configuration
- ✅ Project-Specific Templates (13 Projekte)
- ✅ Multi-Project Operations
- ✅ Queen Types Guide
- ✅ Worker Configuration
- ✅ System Health Check
- ✅ Cleanup & Management
- 🆕 **Attach to Running Swarms** (Interaktiv)
- 🆕 **Reconnect via tmux** (Nach Konsole schließen)

**Command-Line Options:**
```bash
./claude-suite-manager.sh --help      # Zeigt Hilfe
./claude-suite-manager.sh --quick     # Quick Spawn (Adaptive)
./claude-suite-manager.sh --tactical  # Quick Spawn (Tactical)
./claude-suite-manager.sh --status    # System Status
./claude-suite-manager.sh --cleanup   # System Cleanup
```

### 2. **claude-flow-fixed.sh**
Robustes Script für Prozess-Management und Fehlerbehandlung.
```bash
./claude-flow-fixed.sh
```
- Fokus auf Prozess-Kontrolle
- Force Kill Funktionen
- Spawn im Hintergrund

### 3. **claude-flow-simple.sh**
Einfaches Script für direkte Commands ohne tmux.
```bash
./claude-flow-simple.sh
```
- Direkte Command-Ausführung
- Keine tmux-Abhängigkeit
- Schnelle Operationen

### 4. **claude-flow-manager-v2.sh**
Verbessertes Management-Tool mit korrigierten Commands.
```bash
./claude-flow-manager-v2.sh
```
- Timeouts für alle Commands
- Bessere Fehlerbehandlung

## 🔗 Reconnect/Attach zu laufenden Swarms

### Nach Konsole schließen wieder verbinden:
```bash
# Option 1: Über das Manager-Script
./claude-suite-manager.sh
# Wähle: 10 (Attach to Running Swarm)
# oder: 11 (Reconnect via tmux)

# Option 2: Direkte Commands
npx claude-flow@alpha hive-mind attach [session-id] --interactive
npx claude-flow@alpha hive-mind resume [session-id] --interactive --verbose
```

### tmux Session Management:
```bash
# Swarm in tmux starten (empfohlen für lange Tasks)
tmux new -s swarm-work
./claude-suite-manager.sh  # Spawn swarm
# Ctrl+B, dann D zum Detachen

# Später wieder attachen
tmux attach -t swarm-work
```

## 🐝 Wichtigste Hive Mind Commands

### Neuen Swarm spawnen
```bash
# Einfach (Adaptive, 8 Workers)
npx claude-flow@alpha hive-mind spawn "Dein Ziel" --claude

# Mit Konfiguration
npx claude-flow@alpha hive-mind spawn "Dein Ziel" \
  --claude \
  --queen-type strategic \
  --max-workers 16 \
  --worker-types "architect,frontend,backend,tester" \
  --auto-scale \
  --verbose
```

### Swarm Management
```bash
# Sessions anzeigen
npx claude-flow@alpha hive-mind sessions

# Status prüfen
npx claude-flow@alpha hive-mind status

# Metriken anzeigen
npx claude-flow@alpha hive-mind metrics

# Session fortsetzen
npx claude-flow@alpha hive-mind resume [session-id]

# Session stoppen
npx claude-flow@alpha hive-mind stop [session-id]
```

## 👑 Queen Types Übersicht

| Queen Type | Charakteristik | Ideal für | Workers |
|------------|----------------|-----------|---------|
| **strategic** | Langfristig, systematisch | Neue Projekte, Architektur | 12-20 |
| **adaptive** | Flexibel, lernfähig | MVPs, Prototypen | 8-12 |
| **tactical** | Kurzfristig, effizient | Bug Fixes, kleine Features | 4-8 |
| **exploratory** | Forschend, kreativ | Research, Best Practices | 8-12 |

## 📊 Worker-Anzahl Empfehlungen

- **Kleines Feature/Bug**: 4-6 Workers
- **Mittleres Feature**: 8-10 Workers
- **Großes Feature**: 12-16 Workers
- **Full Stack App**: 16-20 Workers
- **Enterprise/Migration**: 20-24 Workers

## 🛠️ Worker Types Beispiele

```bash
# Full Stack
--worker-types "architect,frontend,backend,database,tester"

# Frontend Focus
--worker-types "frontend,ui,ux,designer,tester"

# Backend Focus
--worker-types "backend,api,database,devops,tester"

# Research
--worker-types "researcher,analyst,documenter"

# Security
--worker-types "security,pentester,analyst,auditor"
```

## 🚨 Troubleshooting

### Problem: Commands hängen
```bash
# 1. Prozesse prüfen
ps aux | grep claude-flow

# 2. Alle Prozesse killen
pkill -9 -f claude-flow

# 3. Neu starten
./claude-suite-manager.sh
```

### Problem: "EPIPE" Fehler
- Bekannter Bug in claude-flow@alpha
- Workaround: Verwende die Scripts statt direkte Commands

### Problem: Database locked
```bash
# Database zurücksetzen
rm -rf .hive-mind/*.db*
mkdir -p .hive-mind
```

## 💡 Best Practices

1. **Immer `--claude` Flag verwenden** für Claude Code Integration
2. **Start klein**: Beginne mit 8-10 Workers, nutze `--auto-scale`
3. **Queen Type passend wählen**: Strategic für Planung, Tactical für schnelle Fixes
4. **Logs im Auge behalten**: Nutze `--verbose` für Details
5. **Regelmäßig aufräumen**: `./claude-suite-manager.sh --cleanup`

## 🎯 Quick Start für Projekte

### StepUpFundraiser
```bash
./claude-suite-manager.sh
# Wähle: 4 → 1 (Project Templates → StepUpFundraiser)
```

### XTTS Voice Cloning
```bash
./claude-suite-manager.sh
# Wähle: 4 → 2 (Project Templates → XTTS)
```

### Custom Project
```bash
./claude-suite-manager.sh
# Wähle: 3 (Custom Swarm Configuration)
```

---

**Tipp**: Nutze `./claude-suite-manager.sh` für die beste Erfahrung mit allen Features!