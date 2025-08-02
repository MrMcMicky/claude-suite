# 🚀 Claude-Suite

Komplettes Ecosystem für Claude-Flow, SuperClaude, Agents und automatisierte Dev-Umgebung.

## 🎯 Was ist enthalten?

### 1. **Claude-Flow** (Hive Mind)
- Parallele Verarbeitung mit bis zu 20 Claude-Instanzen
- Queen-basierte Orchestrierung
- tmux Integration
- MCP Server Hub

### 2. **SuperClaude v3.2**
- Vollautomatik-Modus
- 16 spezialisierte Agents
- Automatische Tool-Auswahl
- Context-aware Aktivierung

### 3. **Dev-Setup**
- One-Click Installation für neue PCs
- VS Code Integration
- WSL2 Support
- Alle Konfigurationen

## ⚡ Quick Start

### Installation auf neuem PC:
```bash
git clone https://github.com/MrMcMicky/claude-suite.git
cd claude-suite
./dev-setup/install.sh
```

### Claude-Flow Manager starten (EMPFOHLEN):
```bash
cd ~/claude-development/local-development-hub
./claude-suite-manager.sh
```

### Quick Spawn:
```bash
# Adaptive (flexibel, lernfähig)
./claude-suite-manager.sh --quick

# Tactical (schnell, effizient)
./claude-suite-manager.sh --tactical
```

### Zu laufendem Swarm reconnecten:
```bash
./claude-suite-manager.sh
# Wähle: 10) Attach to Running Swarm
```

## 🆕 Neue Features (2025-08-02)

### Claude-Suite Manager
Das neue Hauptscript vereint alle Features:
- **Quick Spawn**: Schneller Start mit Adaptive/Tactical Mode
- **Custom Configuration**: Volle Kontrolle über Queen Types, Workers, Memory
- **Project Templates**: 13 vorkonfigurierte Projekt-Spawns
- **Multi-Project Operations**: Security Audits, Performance Campaigns
- **Attach/Reconnect**: Zu laufenden Swarms wieder verbinden
- **System Management**: Health Check, Cleanup, Process Control

### Reconnect zu laufenden Swarms
Nach dem Schließen der Konsole könnt ihr euch wieder mit laufenden Swarms verbinden:
- **Interactive Attach**: Direkt mit dem Swarm interagieren
- **tmux Reconnect**: Über tmux Sessions wieder einsteigen
- **Session Management**: Resume, Stop, Consensus anzeigen

## 📁 Repository Struktur

```
claude-suite/
├── claude-flow/          # Hive Mind Scripts & Configs
├── scripts/              # Alle Management-Scripts
│   ├── claude-suite-manager.sh    # 🆕 Hauptscript mit allen Features
│   ├── claude-flow-fixed.sh      # Robustes Process Management
│   ├── claude-flow-simple.sh     # Einfache Commands
│   └── README.md                 # Script-Dokumentation
├── superclaude/         # SuperClaude Vollautomatik
│   └── agents/          # 16 Spezialisierte Agents
├── dev-setup/           # Automatisierte Installation
│   ├── scripts/         # Setup Scripts
│   └── configs/         # Konfigurationen
├── docs/                # Alle Dokumentationen
└── templates/           # Projekt Templates
```

## 🤖 Verfügbare Agents

- frontend-engineer
- backend-engineer
- devops-engineer
- database-engineer
- solution-architect
- qa-engineer
- code-reviewer
- project-manager
- mobile-engineer
- data-scientist
- cloud-architect
- game-developer
- blockchain-engineer
- embedded-engineer
- ml-engineer
- security-engineer

## 📚 Dokumentation

Siehe `/docs` Ordner für:
- CLAUDE_FLOW_GUIDE.md
- QUEEN_MODES_GUIDE.md
- PROJECT_SPAWN_TEMPLATES.md
- VPS_SETUP_GUIDE.md
- Und viele mehr...

## 🔧 Konfiguration

Nach der Installation findest du:
- Claude Config: `~/.claude/`
- Claude-Flow: `~/claude-development/local-development-hub/`
- VS Code Settings: Automatisch importiert

## 🌐 VPS Deployment

Für VPS Installation siehe: `docs/VPS_SETUP_GUIDE.md`

## 📝 Lizenz

MIT License - Siehe LICENSE Datei

## 🤝 Contributing

Pull Requests willkommen! Bitte erstelle erst ein Issue.

---

**Version**: 3.2  
**Maintainer**: MrMcMicky  
**Last Update**: $(date +%Y-%m-%d)
