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

### Claude-Flow starten:
```bash
cd ~/claude-development/local-development-hub
./start-claude-flow-tmux.sh
tmux attach -t claude-flow
```

### Erster Spawn:
```bash
npx claude-flow@alpha hive-mind spawn "Hello World test" --claude
```

## 📁 Repository Struktur

```
claude-suite/
├── claude-flow/          # Hive Mind Scripts & Configs
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
