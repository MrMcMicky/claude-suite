#!/bin/bash
# 🚀 Claude Development Environment - Automated Setup
# Für neuen PC mit WSL und VS Code

set -e  # Exit on error

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Development Environment Setup         ║${NC}"
echo -e "${BLUE}║   Version: 3.2 - Vollautomatik                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"

# Funktion für Fortschritt
progress() {
    echo -e "\n${YELLOW}⏳ $1...${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ Fehler: $1${NC}"
    exit 1
}

# 1. System vorbereiten
progress "Prüfe System und installiere Basis-Tools"

# Update System
sudo apt update && sudo apt upgrade -y

# Basis Tools
sudo apt install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    tmux \
    htop \
    jq \
    unzip \
    wget

success "Basis-Tools installiert"

# 2. Node.js installieren (für Claude-Flow)
progress "Installiere Node.js v20"

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verifiziere
node_version=$(node --version)
npm_version=$(npm --version)
success "Node.js $node_version und npm $npm_version installiert"

# 3. Verzeichnisstruktur erstellen
progress "Erstelle Verzeichnisstruktur"

# Home directories
mkdir -p ~/claude-development/local-development-hub
mkdir -p ~/Projekte/VS_Code
mkdir -p ~/.claude/agents
mkdir -p ~/.vscode-server/data/Machine

# Copy configs from repo
cp -r configs/.claude/* ~/.claude/ 2>/dev/null || true
cp -r configs/tmux/.tmux.conf ~/ 2>/dev/null || true

success "Verzeichnisse erstellt"

# 4. Claude-Flow installieren
progress "Installiere Claude-Flow v3 (Alpha)"

npm install -g claude-flow@alpha

# Verifiziere
claude_version=$(claude-flow --version 2>/dev/null || echo "not installed")
success "Claude-Flow $claude_version installiert"

# 5. tmux Start-Scripts
progress "Erstelle tmux Start-Scripts"

cd ~/claude-development/local-development-hub

# Haupt Start-Script
cat > start-claude-flow-tmux.sh << 'EOF'
#!/bin/bash
SESSION="claude-flow"

if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Claude-Flow läuft bereits. Verbinde mit: tmux attach -t claude-flow"
    exit 0
fi

echo "Starte Claude-Flow Hive Mind..."

# Erstelle Session
tmux new-session -d -s $SESSION -n ui

# Window 0: UI
tmux send-keys -t $SESSION:0 'npx claude-flow@alpha start --ui' C-m

# Window 1: Swarm
tmux new-window -t $SESSION:1 -n swarm
tmux send-keys -t $SESSION:1 'npx claude-flow@alpha swarm' C-m

# Window 2: MCP
tmux new-window -t $SESSION:2 -n mcp
tmux send-keys -t $SESSION:2 'npx claude-flow@alpha start-mcp-hub' C-m

# Window 3: Monitor
tmux new-window -t $SESSION:3 -n monitor
tmux send-keys -t $SESSION:3 'htop' C-m

echo "✅ Claude-Flow gestartet!"
echo "   UI: http://localhost:3008"
echo "   Verbinden: tmux attach -t claude-flow"
echo "   Wechseln: Ctrl+B, dann 0-3"
EOF
chmod +x start-claude-flow-tmux.sh

# Auto-Start Script
cat > claude-flow-autostart.sh << 'EOF'
#!/bin/bash
# Füge zu ~/.bashrc hinzu für Auto-Start

if [ -z "$TMUX" ]; then
    cd ~/claude-development/local-development-hub
    if ! tmux has-session -t claude-flow 2>/dev/null; then
        ./start-claude-flow-tmux.sh
    fi
fi
EOF
chmod +x claude-flow-autostart.sh

success "tmux Scripts erstellt"

# 6. Claude Agents installieren
progress "Installiere 16 Claude Agents"

cd ~/.claude/agents

# Agents Array
AGENTS=(
    "frontend-engineer:React/Vue/Angular specialist"
    "backend-engineer:API and server development"
    "devops-engineer:Infrastructure and deployment"
    "database-engineer:Database design and optimization"
    "solution-architect:System design specialist"
    "qa-engineer:Testing and quality assurance"
    "code-reviewer:Code quality and security"
    "project-manager:Agile project management"
    "mobile-engineer:iOS/Android/React Native"
    "data-scientist:ML and data analysis"
    "cloud-architect:AWS/GCP/Azure expert"
    "game-developer:Game development"
    "blockchain-engineer:Web3 and smart contracts"
    "embedded-engineer:IoT and hardware"
    "ml-engineer:ML/AI implementation"
    "security-engineer:Cybersecurity expert"
)

for agent_info in "${AGENTS[@]}"; do
    IFS=':' read -r agent_name agent_desc <<< "$agent_info"
    
    cat > "${agent_name}.md" << EOF
# ${agent_name}

## Role
${agent_desc}

## Capabilities
- Specialized domain knowledge
- Integration with Claude-Flow
- Access to relevant tools

## Activation
Use --agent ${agent_name}
EOF
    
    echo "  ✓ ${agent_name}"
done

success "Alle 16 Agents installiert"

# 7. SuperClaude Config
progress "Installiere SuperClaude v3.2"

cat > ~/.claude/CLAUDE.md << 'EOF'
# SuperClaude v3.2 - VOLLAUTOMATIK 🤖

## 🎯 DU MUSST NICHTS MEHR MANUELL AUFRUFEN!

Claude Code erkennt automatisch was du brauchst:
- ✅ Analysiert deinen Text mit KI
- ✅ Aktiviert die richtigen Personas
- ✅ Lädt benötigte MCP Server
- ✅ Wählt optimale Tools
- ✅ Alles vollautomatisch!

## 🐝 Claude-Flow Hive Mind Integration

### Quick Spawns:
```bash
# Einfacher Spawn
npx claude-flow@alpha hive-mind spawn "Deine Aufgabe" --claude

# Mit Worker-Anzahl
npx claude-flow@alpha hive-mind spawn "Komplexe Aufgabe" --claude --max-workers 10

# Mit Queen-Type
npx claude-flow@alpha hive-mind spawn "Strategische Aufgabe" --claude --queen-type strategic
```

## 🤖 16 Verfügbare Agents
frontend-engineer, backend-engineer, devops-engineer, database-engineer,
solution-architect, qa-engineer, code-reviewer, project-manager,
mobile-engineer, data-scientist, cloud-architect, game-developer,
blockchain-engineer, embedded-engineer, ml-engineer, security-engineer

## 🔧 MCP Server
- Sequential: Komplexe Analysen
- Context7: Library Dokumentation
- Magic: UI Generation
- Playwright: Browser Testing
- Firecrawl: Web Scraping

## 📊 Vollautomatik aktiviert!
automatic_mode: full
experience_level: auto
EOF

# Config.yaml
cat > ~/.claude/config.yaml << 'EOF'
# SuperClaude Configuration v3.2
automatic_mode: full
experience_level: auto

auto_detection:
  sensitivity: high
  confidence_threshold: 0.5
  pattern_learning: true

mcp_servers:
  essential:
    - context7
    - sequential
  optional:
    - magic
    - playwright
    - firecrawl

docker_automation:
  auto_start: true
  check_before_tasks: true
  never_ask_user: true
EOF

success "SuperClaude v3.2 konfiguriert"

# 8. VS Code Extensions
progress "Installiere VS Code Extensions"

# Extension Liste
EXTENSIONS=(
    "anthropics.claude-code"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode.cpptools"
    "ms-python.python"
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "github.copilot"
    "eamodio.gitlens"
    "ms-azuretools.vscode-docker"
    "ritwickdey.liveserver"
)

for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" 2>/dev/null || true
done

success "VS Code Extensions installiert"

# 9. Git Konfiguration
progress "Konfiguriere Git"

read -p "Git Username eingeben: " git_user
read -p "Git Email eingeben: " git_email

git config --global user.name "$git_user"
git config --global user.email "$git_email"

success "Git konfiguriert"

# 10. Dokumentation kopieren
progress "Kopiere Dokumentationen"

cd ~/claude-development/local-development-hub

# Erstelle Guide Files
cp docs/*.md . 2>/dev/null || echo "  ℹ Docs werden beim ersten Start generiert"

# 11. Finale Konfiguration
progress "Finale Konfiguration"

# Füge zu .bashrc hinzu
if ! grep -q "claude-flow-autostart" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Claude-Flow Auto-Start" >> ~/.bashrc
    echo "source ~/claude-development/local-development-hub/claude-flow-autostart.sh" >> ~/.bashrc
fi

# Aliases
cat >> ~/.bashrc << 'EOF'

# Claude Aliases
alias cflow='tmux attach -t claude-flow'
alias cspawn='npx claude-flow@alpha hive-mind spawn'
alias cstatus='npx claude-flow@alpha status'
alias csessions='npx claude-flow@alpha hive-mind sessions'
EOF

success "Konfiguration abgeschlossen"

# 12. Abschluss
echo -e "\n${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✅ Installation erfolgreich!                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"

echo -e "\n${BLUE}📋 Nächste Schritte:${NC}"
echo "1. Terminal neu starten oder: source ~/.bashrc"
echo "2. Claude-Flow starten: cd ~/claude-development/local-development-hub && ./start-claude-flow-tmux.sh"
echo "3. Mit tmux verbinden: tmux attach -t claude-flow"
echo "4. VS Code öffnen: code ~/Projekte/"
echo ""
echo -e "${BLUE}🚀 Quick Test:${NC}"
echo "npx claude-flow@alpha hive-mind spawn \"Test installation\" --claude"
echo ""
echo -e "${YELLOW}💡 Tipp:${NC}"
echo "Dokumentation findest du in: ~/claude-development/local-development-hub/"
echo "UI erreichbar unter: http://localhost:3008"