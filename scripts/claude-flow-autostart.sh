#!/bin/bash

# Claude-Flow Auto-Start with tmux
# Prüft bestehende Prozesse und startet sauber neu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SESSION_NAME="claude-flow"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude-Flow Auto-Start System        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# 1. Check for running processes
echo -e "${YELLOW}🔍 Checking for running processes...${NC}"

RUNNING_PROCESSES=$(pgrep -f claude-flow | wc -l)
TMUX_SESSION_EXISTS=$(tmux has-session -t $SESSION_NAME 2>/dev/null && echo "yes" || echo "no")
ACTIVE_SWARMS=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>/dev/null | grep -c "Status: active" | head -1 || echo "0")

echo -e "  Claude-Flow processes: ${YELLOW}$RUNNING_PROCESSES${NC}"
echo -e "  tmux session exists: ${YELLOW}$TMUX_SESSION_EXISTS${NC}"
echo -e "  Active swarms: ${YELLOW}$ACTIVE_SWARMS${NC}"
echo ""

# 2. Decision logic
if [ $RUNNING_PROCESSES -gt 0 ] || [ "$TMUX_SESSION_EXISTS" == "yes" ] || [ $ACTIVE_SWARMS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found existing Claude-Flow instances!${NC}"
    echo ""
    echo "What would you like to do?"
    echo "1) Stop everything and restart fresh"
    echo "2) Keep existing and exit"
    echo "3) Show detailed status"
    echo ""
    read -p "Choose (1-3): " action
    
    case $action in
        1)
            echo ""
            echo -e "${RED}🛑 Stopping all existing instances...${NC}"
            
            # Stop tmux session
            if [ "$TMUX_SESSION_EXISTS" == "yes" ]; then
                echo "  - Killing tmux session..."
                tmux kill-session -t $SESSION_NAME 2>/dev/null
            fi
            
            # Stop all swarms
            if [ "$ACTIVE_SWARMS" -gt "0" ] 2>/dev/null; then
                echo "  - Stopping all swarms..."
                # Use timeout to prevent hanging
                timeout 30s bash "$SCRIPT_DIR/swarm-manager.sh" <<< "2"$'\n'"yes"$'\n' || echo "  - Swarm cleanup timed out"
            fi
            
            # Kill processes (but not this script!)
            echo "  - Killing all processes..."
            # Get PIDs of claude-flow processes, excluding this script
            PIDS_TO_KILL=$(pgrep -f "claude-flow" | grep -v "$$" | grep -v "$PPID")
            if [ ! -z "$PIDS_TO_KILL" ]; then
                echo "$PIDS_TO_KILL" | xargs kill 2>/dev/null
                sleep 2
                # Force kill if still running
                PIDS_TO_KILL=$(pgrep -f "claude-flow" | grep -v "$$" | grep -v "$PPID")
                if [ ! -z "$PIDS_TO_KILL" ]; then
                    echo "$PIDS_TO_KILL" | xargs kill -9 2>/dev/null
                fi
            fi
            
            echo -e "${GREEN}✅ Cleanup complete!${NC}"
            echo ""
            ;;
        2)
            echo -e "${BLUE}👋 Keeping existing setup. Exiting...${NC}"
            exit 0
            ;;
        3)
            echo ""
            echo -e "${BLUE}📊 Detailed Status:${NC}"
            echo ""
            echo "=== Processes ==="
            ps aux | grep claude-flow | grep -v grep
            echo ""
            echo "=== tmux Sessions ==="
            tmux ls 2>/dev/null || echo "No tmux sessions"
            echo ""
            echo "=== Active Swarms ==="
            timeout 10s npx claude-flow@alpha hive-mind sessions 2>/dev/null | head -20 || echo "Could not fetch sessions (timeout)"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            exit 1
            ;;
    esac
fi

# 3. Start fresh tmux session
echo -e "${GREEN}🚀 Starting fresh Claude-Flow instance...${NC}"
echo ""

# Create tmux session
tmux new-session -d -s $SESSION_NAME -n "MCP-Server" -c "$SCRIPT_DIR"

# Window 0: MCP Server
tmux send-keys -t $SESSION_NAME:0 "echo '📡 Starting MCP Server...'" C-m
tmux send-keys -t $SESSION_NAME:0 "timeout 30s npx claude-flow@alpha mcp start || echo 'MCP Server failed to start'" C-m

# Window 1: UI + Orchestrator
tmux new-window -t $SESSION_NAME:1 -n "UI-Orchestrator" -c "$SCRIPT_DIR"
tmux send-keys -t $SESSION_NAME:1 "echo '🌐 Starting UI + Orchestrator on port 3008...'" C-m
tmux send-keys -t $SESSION_NAME:1 "sleep 5" C-m
tmux send-keys -t $SESSION_NAME:1 "timeout 30s npx claude-flow@alpha start --ui --swarm --port 3008 || echo 'UI/Orchestrator failed to start'" C-m

# Window 2: Control
tmux new-window -t $SESSION_NAME:2 -n "Control" -c "$SCRIPT_DIR"
tmux send-keys -t $SESSION_NAME:2 "clear" C-m
tmux send-keys -t $SESSION_NAME:2 "echo -e '${BLUE}╔════════════════════════════════════════╗${NC}'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo -e '${BLUE}║     Claude-Flow Control Terminal       ║${NC}'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo -e '${BLUE}╚════════════════════════════════════════╝${NC}'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '⏳ Waiting for services to start...'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo 'Checking services readiness...'" C-m
tmux send-keys -t $SESSION_NAME:2 "for i in {1..10}; do echo -n '.'; sleep 1; done; echo" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '📊 System Status:'" C-m
tmux send-keys -t $SESSION_NAME:2 "timeout 10s npx claude-flow@alpha status || echo 'Status check failed'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '🐝 Ready for Hive Mind commands!'" C-m

# Window 3: Monitor
tmux new-window -t $SESSION_NAME:3 -n "Monitor" -c "$SCRIPT_DIR"
tmux send-keys -t $SESSION_NAME:3 "htop -F claude-flow 2>/dev/null || top" C-m

# Window 4: Logs (for debugging)
tmux new-window -t $SESSION_NAME:4 -n "Logs" -c "$SCRIPT_DIR"
tmux send-keys -t $SESSION_NAME:4 "echo '📋 Monitoring Claude-Flow logs...'" C-m
tmux send-keys -t $SESSION_NAME:4 "tail -f ~/.claude-flow/logs/*.log 2>/dev/null || echo 'No logs available yet'" C-m

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
echo "  Control:    Window 2 for commands"
echo ""

# Ask if user wants to attach
read -p "🎯 Attach to tmux session now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Attaching to tmux...${NC}"
    sleep 1
    tmux attach -t $SESSION_NAME
else
    echo -e "${GREEN}✅ Running in background. Use 'tmux attach -t $SESSION_NAME' to connect.${NC}"
fi