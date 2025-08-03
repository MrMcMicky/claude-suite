#!/bin/bash
# Quick spawn wrapper - interactive mode

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐝 Claude-Flow Quick Spawn${NC}"
echo ""

# Get objective
read -p "What do you want to accomplish? " objective

if [ -z "$objective" ]; then
    echo "Error: Objective required!"
    exit 1
fi

# Quick options
echo ""
echo "Speed:"
echo "1) Fast (tactical, 4 workers)"
echo "2) Standard (adaptive, 8 workers)"
echo "3) Thorough (strategic, 12 workers)"
echo ""
read -p "Choose speed (1-3, default=2): " speed

case "$speed" in
    1)
        ./claude-flow-vps.sh spawn "$objective" -w 4 -q tactical
        ;;
    3)
        ./claude-flow-vps.sh spawn "$objective" -w 12 -q strategic -a
        ;;
    *)
        ./claude-flow-vps.sh spawn "$objective" -w 8 -q adaptive -a
        ;;
esac