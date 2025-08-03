#!/bin/bash

# Claude-Flow tmux Starter - Simplified Version
# Starts Claude-Flow in tmux without complex checks

SESSION_NAME="claude-flow"
HUB_DIR="$HOME/claude-development/local-development-hub"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude-Flow tmux Quick Start         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Kill old processes first (but not this script)
echo -e "${YELLOW}🔧 Cleaning up old processes...${NC}"
for pid in $(pgrep -f "claude-flow" | grep -v $$); do
    kill $pid 2>/dev/null
done
sleep 2

# Kill existing tmux session if exists
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo -e "${YELLOW}🔧 Killing old tmux session...${NC}"
    tmux kill-session -t $SESSION_NAME
    sleep 1
fi

# Create new tmux session
echo -e "${GREEN}🚀 Starting Claude-Flow in tmux...${NC}"
echo ""

# Create tmux session
tmux new-session -d -s $SESSION_NAME -n "MCP-Server" -c "$HUB_DIR"

# Window 0: MCP Server
tmux send-keys -t $SESSION_NAME:0 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:0 "echo '📡 Starting MCP Server...'" C-m
tmux send-keys -t $SESSION_NAME:0 "npx claude-flow@alpha mcp start" C-m

# Window 1: UI + Orchestrator
tmux new-window -t $SESSION_NAME:1 -n "UI-Orchestrator" -c "$HUB_DIR"
tmux send-keys -t $SESSION_NAME:1 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:1 "echo '🌐 Starting UI + Orchestrator on port 3008...'" C-m
tmux send-keys -t $SESSION_NAME:1 "sleep 5" C-m
tmux send-keys -t $SESSION_NAME:1 "npx claude-flow@alpha start --ui --swarm --port 3008" C-m

# Window 2: Control
tmux new-window -t $SESSION_NAME:2 -n "Control" -c "$HUB_DIR"
tmux send-keys -t $SESSION_NAME:2 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:2 "clear" C-m
tmux send-keys -t $SESSION_NAME:2 "echo -e '${BLUE}╔════════════════════════════════════════╗${NC}'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo -e '${BLUE}║     Claude-Flow Control Terminal       ║${NC}'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo -e '${BLUE}╚════════════════════════════════════════╝${NC}'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '⏳ Waiting for services to start (15 seconds)...'" C-m
tmux send-keys -t $SESSION_NAME:2 "sleep 15" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '📊 System Status:'" C-m
tmux send-keys -t $SESSION_NAME:2 "npx claude-flow@alpha status" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '🐝 Ready for Hive Mind commands!'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo 'Example spawn command:'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo 'npx claude-flow@alpha hive-mind spawn \"Your objective\" --claude --max-workers 12'" C-m

# Window 3: Monitor
tmux new-window -t $SESSION_NAME:3 -n "Monitor" -c "$HUB_DIR"
tmux send-keys -t $SESSION_NAME:3 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:3 "watch -n 5 'ps aux | grep claude-flow | grep -v grep | grep -v watch'" C-m

echo -e "${GREEN}✅ Claude-Flow started successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Quick Reference:${NC}"
echo "  Attach:     tmux attach -t $SESSION_NAME"
echo "  Detach:     Ctrl+B, then D"
echo "  Switch:     Ctrl+B, then 0-3"
echo ""
echo -e "${BLUE}🌐 Services:${NC}"
echo "  UI:         http://localhost:3008/console"
echo "  MCP:        Running in stdio mode"
echo ""
echo -e "${BLUE}📺 Windows:${NC}"
echo "  0: MCP Server"
echo "  1: UI + Orchestrator"
echo "  2: Control (for commands)"
echo "  3: Monitor (process watch)"
echo ""

# Ask if user wants to attach
read -p "🎯 Attach to tmux session now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Attaching to tmux...${NC}"
    sleep 1
    tmux attach -t $SESSION_NAME
else
    echo -e "${GREEN}✅ Running in background.${NC}"
    echo -e "${YELLOW}Use 'tmux attach -t $SESSION_NAME' to connect.${NC}"
fi