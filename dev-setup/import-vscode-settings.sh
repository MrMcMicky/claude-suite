#!/bin/bash
# VS Code Settings Import Script

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📋 VS Code Settings Import${NC}"

# VS Code Settings Pfade
WSL_VSCODE_PATH="$HOME/.vscode-server/data/Machine"
WIN_VSCODE_PATH="/mnt/c/Users/$USER/AppData/Roaming/Code/User"

# Erstelle Verzeichnisse
mkdir -p "$WSL_VSCODE_PATH"
mkdir -p "$WIN_VSCODE_PATH"

# Kopiere Settings
if [ -f "configs/.vscode/settings.json" ]; then
    cp configs/.vscode/settings.json "$WSL_VSCODE_PATH/settings.json"
    cp configs/.vscode/settings.json "$WIN_VSCODE_PATH/settings.json"
    echo -e "${GREEN}✅ VS Code Settings importiert${NC}"
else
    echo -e "${YELLOW}⚠️  Keine VS Code Settings gefunden${NC}"
fi

# Kopiere Keybindings
if [ -f "configs/.vscode/keybindings.json" ]; then
    cp configs/.vscode/keybindings.json "$WSL_VSCODE_PATH/keybindings.json"
    cp configs/.vscode/keybindings.json "$WIN_VSCODE_PATH/keybindings.json"
    echo -e "${GREEN}✅ Keybindings importiert${NC}"
fi

# Kopiere Snippets
if [ -d "configs/.vscode/snippets" ]; then
    cp -r configs/.vscode/snippets "$WSL_VSCODE_PATH/"
    cp -r configs/.vscode/snippets "$WIN_VSCODE_PATH/"
    echo -e "${GREEN}✅ Snippets importiert${NC}"
fi

echo -e "\n${BLUE}💡 Tipp:${NC}"
echo "Starte VS Code neu, um alle Settings zu aktivieren"