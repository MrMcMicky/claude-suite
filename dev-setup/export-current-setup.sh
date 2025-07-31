#!/bin/bash
# Export current setup to Git repository

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📤 Exportiere aktuelles Setup...${NC}"

# 1. Claude Configs
echo -e "${YELLOW}Exportiere Claude Konfigurationen...${NC}"
mkdir -p configs/.claude/agents
cp ~/.claude/CLAUDE.md configs/.claude/
cp ~/.claude/config.yaml configs/.claude/
cp ~/.claude/agents/*.md configs/.claude/agents/ 2>/dev/null || true

# 2. VS Code Settings
echo -e "${YELLOW}Exportiere VS Code Settings...${NC}"
mkdir -p configs/.vscode
# Von WSL
cp ~/.vscode-server/data/Machine/settings.json configs/.vscode/ 2>/dev/null || \
# Oder von Windows
cp /mnt/c/Users/$USER/AppData/Roaming/Code/User/settings.json configs/.vscode/ 2>/dev/null || \
echo "  ⚠️  VS Code Settings nicht gefunden"

# 3. tmux Config
echo -e "${YELLOW}Exportiere tmux Konfiguration...${NC}"
mkdir -p configs/tmux
cp ~/.tmux.conf configs/tmux/ 2>/dev/null || echo "  ⚠️  Keine tmux config gefunden"

# 4. Scripts
echo -e "${YELLOW}Kopiere Scripts...${NC}"
mkdir -p scripts
cp ~/claude-development/local-development-hub/*.sh scripts/ 2>/dev/null || true

# 5. Dokumentationen
echo -e "${YELLOW}Kopiere Dokumentationen...${NC}"
mkdir -p docs
cp ~/claude-development/local-development-hub/*.md docs/ 2>/dev/null || true
cp /mnt/c/Projekte/VS_Code/_CLAUDE_FLOW/claude-flow-docs/*.md docs/ 2>/dev/null || true
cp /mnt/c/Projekte/VS_Code/_DOCS/*.md docs/ 2>/dev/null || true

# 6. Templates
echo -e "${YELLOW}Erstelle Projekt Templates...${NC}"
mkdir -p templates
cat > templates/spawn-examples.md << 'EOF'
# Claude-Flow Spawn Examples

## Basic Spawns
```bash
npx claude-flow@alpha hive-mind spawn "Create React component" --claude
npx claude-flow@alpha hive-mind spawn "Optimize database queries" --claude --max-workers 8
npx claude-flow@alpha hive-mind spawn "Build REST API" --claude --queen-type strategic
```

## Project-Specific
```bash
# Church Management
npx claude-flow@alpha hive-mind spawn "Add prayer request feature to church app" --claude --max-workers 10

# Translation App  
npx claude-flow@alpha hive-mind spawn "Implement Hebrew language support" --claude --agents "backend-engineer,ml-engineer"

# Fundraising Platform
npx claude-flow@alpha hive-mind spawn "Create donation analytics dashboard" --claude --queen-type adaptive
```
EOF

# 7. Environment Template
cat > .env.example << 'EOF'
# Claude API (falls benötigt)
CLAUDE_API_KEY=your_api_key_here

# GitHub
GITHUB_TOKEN=your_github_token

# Optional: Custom Ports
CLAUDE_FLOW_UI_PORT=3008
CLAUDE_FLOW_API_PORT=9000
EOF

echo -e "\n${GREEN}✅ Export abgeschlossen!${NC}"
echo -e "\n${BLUE}📋 Nächste Schritte:${NC}"
echo "1. Git Repository erstellen:"
echo "   git init"
echo "   git add ."
echo "   git commit -m \"Initial Claude Dev Setup\""
echo ""
echo "2. Auf GitHub pushen:"
echo "   git remote add origin https://github.com/[username]/claude-dev-setup.git"
echo "   git push -u origin main"
echo ""
echo "3. Auf neuem PC:"
echo "   git clone https://github.com/[username]/claude-dev-setup.git"
echo "   cd claude-dev-setup"
echo "   ./install.sh"