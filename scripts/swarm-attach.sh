#!/bin/bash

# Swarm Attach Tool - Reconnect to running swarms

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║               Swarm Attach Tool - Reconnect                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check for running swarms
SWARM_PIDS=$(pgrep -f "hive-mind spawn" | grep -v grep)

if [ -z "$SWARM_PIDS" ]; then
    echo -e "${RED}❌ No running swarms found!${NC}"
    echo ""
    echo "Start a new swarm first with:"
    echo "  npx claude-flow@alpha hive-mind spawn \"Your objective\" --claude"
    exit 1
fi

# Show running swarms
echo -e "${GREEN}✅ Found running swarm(s):${NC}"
echo ""

# Display process info
ps aux | grep -E "hive-mind spawn" | grep -v grep | while read line; do
    PID=$(echo "$line" | awk '{print $2}')
    TTY=$(echo "$line" | awk '{print $7}')
    CMD=$(echo "$line" | sed 's/.*hive-mind spawn//' | cut -c1-80)
    echo -e "${YELLOW}PID:${NC} $PID ${YELLOW}TTY:${NC} $TTY"
    echo -e "${BLUE}Objective:${NC}$CMD..."
    echo ""
done

# Get main PID and session info
MAIN_PID=$(pgrep -f "simple-cli.js hive-mind spawn" | head -1)
echo -e "${CYAN}Main Process: PID $MAIN_PID${NC}"
echo ""

# Find session files
LATEST_SESSION=$(ls -t .hive-mind/sessions/session-*.json 2>/dev/null | head -1)
if [ -n "$LATEST_SESSION" ]; then
    SESSION_ID=$(basename "$LATEST_SESSION" | sed 's/session-\(.*\)-auto-.*/\1/')
    echo -e "${GREEN}Session ID: $SESSION_ID${NC}"
else
    echo -e "${YELLOW}⚠️  No session files found${NC}"
fi

echo ""
echo -e "${CYAN}━━━ Connection Methods ━━━${NC}"
echo ""

# Method 1: Create tmux monitoring session
echo -e "${YELLOW}1) Create tmux monitoring session${NC}"
echo "   This creates a new tmux session to monitor and try to connect"
echo ""

# Method 2: Try WebSocket UI
if nc -z localhost 9000 2>/dev/null; then
    echo -e "${YELLOW}2) WebSocket UI (Port 9000 active)${NC}"
    echo "   Start UI server and connect via browser"
    echo ""
fi

# Method 3: Direct connection attempt
if [ -n "$SESSION_ID" ]; then
    echo -e "${YELLOW}3) Direct connection attempt${NC}"
    echo "   Try to connect using session ID: $SESSION_ID"
    echo ""
fi

# Method 4: Manual reconnect guide
echo -e "${YELLOW}4) Manual reconnect guide${NC}"
echo "   Show commands for manual reconnection"
echo ""

read -p "Select method (1-4): " choice

case "$choice" in
    1)
        # Create tmux monitoring session
        TMUX_SESSION="swarm-monitor-$MAIN_PID"
        echo ""
        echo -e "${GREEN}Creating tmux session: $TMUX_SESSION${NC}"
        
        # Kill old session if exists
        tmux kill-session -t "$TMUX_SESSION" 2>/dev/null
        
        # Create new session
        tmux new-session -d -s "$TMUX_SESSION" -n "Monitor"
        
        # Window 1: Monitor logs
        tmux send-keys -t "$TMUX_SESSION:0" "echo 'Monitoring Swarm PID: $MAIN_PID'" C-m
        tmux send-keys -t "$TMUX_SESSION:0" "echo ''" C-m
        tmux send-keys -t "$TMUX_SESSION:0" "# Watching process...'" C-m
        tmux send-keys -t "$TMUX_SESSION:0" "watch -n 2 'ps aux | grep $MAIN_PID | grep -v grep'" C-m
        
        # Window 2: Try connection
        tmux new-window -t "$TMUX_SESSION:1" -n "Connect"
        if [ -n "$SESSION_ID" ]; then
            tmux send-keys -t "$TMUX_SESSION:1" "echo 'Trying to connect to session: $SESSION_ID'" C-m
            tmux send-keys -t "$TMUX_SESSION:1" "echo ''" C-m
            tmux send-keys -t "$TMUX_SESSION:1" "# Connection attempts:'" C-m
            tmux send-keys -t "$TMUX_SESSION:1" "echo '1. Trying connect...'" C-m
            tmux send-keys -t "$TMUX_SESSION:1" "npx claude-flow@alpha hive-mind connect $SESSION_ID" C-m
        else
            tmux send-keys -t "$TMUX_SESSION:1" "echo 'No session ID available'" C-m
            tmux send-keys -t "$TMUX_SESSION:1" "echo 'Monitoring swarm activity...'" C-m
        fi
        
        echo ""
        echo -e "${GREEN}✅ tmux session created!${NC}"
        echo ""
        echo "Commands:"
        echo "  Attach:  tmux attach -t $TMUX_SESSION"
        echo "  Detach:  Ctrl+B, then D"
        echo "  Switch:  Ctrl+B, then 0-1"
        echo ""
        
        read -p "Attach now? (y/n): " attach_now
        if [ "$attach_now" = "y" ]; then
            tmux attach -t "$TMUX_SESSION"
        fi
        ;;
        
    2)
        echo ""
        echo -e "${GREEN}Starting UI server...${NC}"
        echo "This will open the web interface"
        echo ""
        npx claude-flow@alpha hive-mind ui
        ;;
        
    3)
        if [ -n "$SESSION_ID" ]; then
            echo ""
            echo -e "${GREEN}Attempting direct connection...${NC}"
            echo "Session ID: $SESSION_ID"
            echo ""
            echo "Trying different connection methods:"
            echo ""
            
            echo "1. connect command:"
            npx claude-flow@alpha hive-mind connect "$SESSION_ID" || echo "Failed"
            
            echo ""
            echo "2. attach command:"
            npx claude-flow@alpha hive-mind attach "$SESSION_ID" || echo "Failed"
            
            echo ""
            echo "3. resume command:"
            npx claude-flow@alpha hive-mind resume "$SESSION_ID" --interactive --verbose || echo "Failed"
        else
            echo -e "${RED}No session ID found${NC}"
        fi
        ;;
        
    4)
        echo ""
        echo -e "${CYAN}Manual Reconnect Guide:${NC}"
        echo ""
        echo "The swarm is running on PID: $MAIN_PID"
        if [ -n "$SESSION_ID" ]; then
            echo "Session ID: $SESSION_ID"
        fi
        echo ""
        echo "Try these commands:"
        echo ""
        echo "1. Check if swarm is in tmux/screen:"
        echo "   tmux ls"
        echo "   screen -ls"
        echo ""
        echo "2. Try WebSocket connection:"
        echo "   npx claude-flow@alpha hive-mind ui"
        echo "   Open: http://localhost:3008/console"
        echo ""
        if [ -n "$SESSION_ID" ]; then
            echo "3. Try connection commands:"
            echo "   npx claude-flow@alpha hive-mind connect $SESSION_ID"
            echo "   npx claude-flow@alpha hive-mind attach $SESSION_ID"
            echo "   npx claude-flow@alpha hive-mind resume $SESSION_ID"
        fi
        echo ""
        echo "4. Monitor the process:"
        echo "   tail -f ~/.claude-flow/logs/*.log"
        echo "   watch 'ps aux | grep $MAIN_PID'"
        echo ""
        echo "5. Check port 9000:"
        echo "   curl http://localhost:9000/status"
        echo "   wscat -c ws://localhost:9000"
        ;;
        
    *)
        echo -e "${BLUE}Cancelled${NC}"
        ;;
esac

echo ""
echo -e "${CYAN}Note: Claude-Flow's attach/resume commands may not work properly in alpha.${NC}"
echo -e "${CYAN}The tmux monitoring method (option 1) is usually the most reliable.${NC}"