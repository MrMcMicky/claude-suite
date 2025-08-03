#!/bin/bash

# Claude-Flow Universal Manager
# Alle Funktionen in einem Script

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben für bessere Lesbarkeit
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SESSION_NAME="claude-flow"

# ============= SWARM MANAGEMENT FUNCTIONS =============

function list_swarms() {
    echo -e "${BLUE}🐝 Listing all active Hive Mind sessions...${NC}"
    echo ""
    # Add timeout to prevent hanging
    timeout 10s npx claude-flow@alpha hive-mind sessions 2>/dev/null | grep -E "Session ID:|Objective:|Status:|Created:" | sed 's/^/  /' || echo -e "${RED}⚠️  Error: Could not fetch sessions (timeout)${NC}"
    echo ""
}

function terminate_all_swarms() {
    echo -e "${YELLOW}⚠️  Collecting all active sessions...${NC}"
    
    # Extract session IDs from the output with timeout
    SESSION_IDS=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>/dev/null | grep "Session ID:" | awk '{print $3}')
    
    if [ -z "$SESSION_IDS" ]; then
        echo -e "${GREEN}✅ No active sessions found.${NC}"
        return 0
    fi
    
    # Count sessions
    SESSION_COUNT=$(echo "$SESSION_IDS" | wc -l)
    echo -e "${YELLOW}Found $SESSION_COUNT active session(s).${NC}"
    echo ""
    
    # Confirmation
    echo -e "${RED}⚠️  WARNING: This will terminate ALL active swarms!${NC}"
    read -p "Are you sure you want to continue? (yes/no): " confirmation
    
    if [ "$confirmation" != "yes" ]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    # Terminate each session
    echo ""
    echo -e "${YELLOW}🛑 Terminating sessions...${NC}"
    
    while IFS= read -r session_id; do
        if [ ! -z "$session_id" ]; then
            echo -e "  Stopping: ${RED}$session_id${NC}"
            timeout 15s npx claude-flow@alpha hive-mind stop "$session_id" 2>&1 | grep -E "stopped|cleaned" | sed 's/^/    /' || echo -e "    ${RED}⚠️  Failed to stop session (timeout)${NC}"
            sleep 1
        fi
    done <<< "$SESSION_IDS"
    
    echo ""
    echo -e "${GREEN}✅ All sessions terminated.${NC}"
}

function terminate_single_swarm() {
    list_swarms
    echo ""
    read -p "Enter Session ID to terminate (or 'cancel'): " session_id
    
    if [ "$session_id" == "cancel" ]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}🛑 Terminating session: $session_id${NC}"
    timeout 15s npx claude-flow@alpha hive-mind stop "$session_id" || echo -e "${RED}⚠️  Failed to stop session (timeout)${NC}"
}

function kill_all_processes() {
    echo -e "${YELLOW}🔪 Killing all claude-flow processes...${NC}"
    pkill -f claude-flow
    sleep 2
    
    # Check if any processes remain
    if pgrep -f claude-flow > /dev/null; then
        echo -e "${RED}⚠️  Some processes still running. Force killing...${NC}"
        pkill -9 -f claude-flow
    fi
    
    echo -e "${GREEN}✅ All processes terminated.${NC}"
}

function reconnect_to_swarm() {
    echo -e "${BLUE}🔄 Reconnecting to existing swarm...${NC}"
    echo ""
    
    # First, list available swarms
    echo -e "${YELLOW}Available swarms:${NC}"
    echo ""
    
    # Get sessions with timeout and better parsing
    SESSIONS=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>/dev/null)
    
    if [ -z "$SESSIONS" ]; then
        echo -e "${RED}No active sessions found or timeout occurred.${NC}"
        return 1
    fi
    
    # Parse sessions and create an array
    declare -a session_ids=()
    declare -a session_objectives=()
    
    while IFS= read -r line; do
        if [[ $line =~ "Session ID: "(.+) ]]; then
            current_id="${BASH_REMATCH[1]}"
            session_ids+=("$current_id")
        elif [[ $line =~ "Objective: "(.+) ]]; then
            current_objective="${BASH_REMATCH[1]}"
            session_objectives+=("$current_objective")
        fi
    done <<< "$SESSIONS"
    
    # Display sessions
    if [ ${#session_ids[@]} -eq 0 ]; then
        echo -e "${RED}No active sessions found.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Found ${#session_ids[@]} active session(s):${NC}"
    echo ""
    
    for i in "${!session_ids[@]}"; do
        echo -e "  ${YELLOW}$((i+1)))${NC} Session: ${BLUE}${session_ids[$i]}${NC}"
        if [ $i -lt ${#session_objectives[@]} ]; then
            echo -e "     Objective: ${session_objectives[$i]}"
        fi
        echo ""
    done
    
    # Ask user to select
    read -p "Select session number (1-${#session_ids[@]}) or 'cancel': " selection
    
    if [ "$selection" == "cancel" ]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    # Validate selection
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#session_ids[@]}" ]; then
        echo -e "${RED}Invalid selection!${NC}"
        return 1
    fi
    
    # Get selected session ID
    selected_id="${session_ids[$((selection-1))]}"
    
    echo -e "${GREEN}🔗 Reconnecting to session: $selected_id${NC}"
    echo ""
    
    # Open tmux session if not already in one
    if [ -z "$TMUX" ]; then
        # Create or attach to tmux session
        SESSION_NAME="claude-flow-reconnect"
        
        # Kill old session if exists
        tmux kill-session -t $SESSION_NAME 2>/dev/null
        
        # Create new session
        tmux new-session -d -s $SESSION_NAME -n "Swarm-$selected_id"
        
        # Send reconnect command
        tmux send-keys -t $SESSION_NAME:0 "npx claude-flow@alpha hive-mind attach $selected_id --verbose" C-m
        
        echo -e "${GREEN}✅ Reconnecting in tmux session: $SESSION_NAME${NC}"
        echo ""
        echo "Commands:"
        echo "  Attach:  tmux attach -t $SESSION_NAME"
        echo "  Detach:  Ctrl+B, then D"
        echo ""
        
        read -p "Attach to session now? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            tmux attach -t $SESSION_NAME
        fi
    else
        # Already in tmux, just run the command
        echo "Running: npx claude-flow@alpha hive-mind attach $selected_id --verbose"
        npx claude-flow@alpha hive-mind attach "$selected_id" --verbose
    fi
}

# ============= STARTUP FUNCTIONS =============

function check_status() {
    echo -e "${YELLOW}🔍 Checking system status...${NC}"
    echo ""
    
    RUNNING_PROCESSES=$(pgrep -f claude-flow | wc -l)
    TMUX_SESSION_EXISTS=$(tmux has-session -t $SESSION_NAME 2>/dev/null && echo "yes" || echo "no")
    ACTIVE_SWARMS=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>/dev/null | grep -c "Status: active" | head -1 || echo "0")
    
    echo -e "  Claude-Flow processes: ${YELLOW}$RUNNING_PROCESSES${NC}"
    echo -e "  tmux session exists: ${YELLOW}$TMUX_SESSION_EXISTS${NC}"
    echo -e "  Active swarms: ${YELLOW}$ACTIVE_SWARMS${NC}"
    echo ""
    
    # Check services
    echo -e "${BLUE}📊 Service Status:${NC}"
    timeout 10s npx claude-flow@alpha status 2>/dev/null || echo -e "${RED}Could not get status${NC}"
    echo ""
}

function start_fresh_instance() {
    echo -e "${GREEN}🚀 Starting fresh Claude-Flow instance...${NC}"
    echo ""
    
    # Kill existing session if any
    tmux kill-session -t $SESSION_NAME 2>/dev/null
    
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
    echo "  Switch:     Ctrl+B, then 0-4"
    echo ""
    echo -e "${BLUE}🌐 Services:${NC}"
    echo "  UI:         http://localhost:3008/console"
    echo "  MCP:        Running in stdio mode"
    echo "  Control:    Window 2 for commands"
    echo ""
}

function spawn_new_swarm() {
    echo -e "${PURPLE}🐝 Spawning new Hive Mind swarm...${NC}"
    echo ""
    
    read -p "Enter swarm objective (or press Enter for default): " objective
    
    if [ -z "$objective" ]; then
        objective="Create amazing AI-powered development workflow"
    fi
    
    echo ""
    echo -e "${BLUE}Configuration:${NC}"
    echo "  Objective: $objective"
    echo "  Max Workers: 20"
    echo "  Queen Type: adaptive"
    echo "  Auto-scale: enabled"
    echo ""
    
    read -p "Continue with these settings? (y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    # Check if we're in tmux
    if [ -z "$TMUX" ]; then
        # Create new tmux window for swarm
        tmux new-session -d -s "swarm-spawn" -n "New-Swarm"
        tmux send-keys -t "swarm-spawn:0" "cd $SCRIPT_DIR" C-m
        tmux send-keys -t "swarm-spawn:0" "npx claude-flow@alpha hive-mind spawn \"$objective\" --claude --max-workers 20 --queen-type adaptive --auto-scale --verbose" C-m
        
        echo -e "${GREEN}✅ Swarm spawning in background tmux session: swarm-spawn${NC}"
        echo ""
        read -p "Attach to see progress? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            tmux attach -t "swarm-spawn"
        fi
    else
        # Already in tmux, run directly
        echo "Spawning swarm..."
        npx claude-flow@alpha hive-mind spawn "$objective" \
            --claude \
            --max-workers 20 \
            --queen-type adaptive \
            --auto-scale \
            --verbose
    fi
}

function attach_to_tmux() {
    if tmux has-session -t $SESSION_NAME 2>/dev/null; then
        echo -e "${BLUE}Attaching to tmux session: $SESSION_NAME${NC}"
        tmux attach -t $SESSION_NAME
    else
        echo -e "${RED}No active tmux session found!${NC}"
        echo "Start Claude-Flow first (Option 2)"
    fi
}

function stop_everything() {
    echo -e "${RED}🛑 Stopping all Claude-Flow services...${NC}"
    echo ""
    
    # Stop tmux session
    if tmux has-session -t $SESSION_NAME 2>/dev/null; then
        echo "  - Killing tmux session..."
        tmux kill-session -t $SESSION_NAME 2>/dev/null
    fi
    
    # Stop all swarms
    echo "  - Stopping all swarms..."
    terminate_all_swarms
    
    # Kill all processes
    echo "  - Killing all processes..."
    kill_all_processes
    
    echo ""
    echo -e "${GREEN}✅ All services stopped.${NC}"
}

function view_logs() {
    echo -e "${CYAN}📋 Viewing Claude-Flow logs...${NC}"
    echo ""
    
    LOG_DIR="$HOME/.claude-flow/logs"
    
    if [ ! -d "$LOG_DIR" ]; then
        echo -e "${RED}No log directory found.${NC}"
        return 1
    fi
    
    # List available logs
    echo "Available logs:"
    ls -la "$LOG_DIR"/*.log 2>/dev/null || echo "No logs found"
    echo ""
    
    # Tail the most recent log
    LATEST_LOG=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
    
    if [ -n "$LATEST_LOG" ]; then
        echo "Showing latest log: $LATEST_LOG"
        echo "Press Ctrl+C to exit"
        echo ""
        tail -f "$LATEST_LOG"
    fi
}

function show_guide() {
    echo -e "${CYAN}📚 Claude-Flow Quick Guide${NC}"
    echo ""
    
    if [ -f "CLAUDE_FLOW_GUIDE.md" ]; then
        cat "CLAUDE_FLOW_GUIDE.md" | head -50
        echo ""
        echo "... (truncated, see full guide in CLAUDE_FLOW_GUIDE.md)"
    else
        echo "Quick Commands:"
        echo ""
        echo "  Spawn swarm:    npx claude-flow@alpha hive-mind spawn \"objective\""
        echo "  List swarms:    npx claude-flow@alpha hive-mind sessions"
        echo "  Attach swarm:   npx claude-flow@alpha hive-mind attach [session-id]"
        echo "  Stop swarm:     npx claude-flow@alpha hive-mind stop [session-id]"
        echo "  Check status:   npx claude-flow@alpha status"
        echo ""
        echo "UI Console:     http://localhost:3008/console"
    fi
}

# ============= MAIN MENU =============

function main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║        Claude-Flow Universal Manager               ║${NC}"
        echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}━━━ System Management ━━━${NC}"
        echo "  1) Check system status"
        echo "  2) Start fresh Claude-Flow instance"
        echo "  3) Attach to running tmux session"
        echo "  4) Stop everything"
        echo ""
        echo -e "${YELLOW}━━━ Swarm Management ━━━${NC}"
        echo "  5) List active swarms"
        echo "  6) Spawn new swarm"
        echo "  7) Reconnect to existing swarm"
        echo "  8) Terminate single swarm"
        echo "  9) Terminate ALL swarms"
        echo ""
        echo -e "${PURPLE}━━━ Utilities ━━━${NC}"
        echo " 10) Kill all claude-flow processes"
        echo " 11) View logs"
        echo " 12) Show quick guide"
        echo ""
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo " 13) Exit"
        echo ""
        read -p "Choose an option (1-13): " choice
        echo ""
        
        case $choice in
            1)
                check_status
                ;;
            2)
                start_fresh_instance
                ;;
            3)
                attach_to_tmux
                break
                ;;
            4)
                stop_everything
                ;;
            5)
                list_swarms
                ;;
            6)
                spawn_new_swarm
                ;;
            7)
                reconnect_to_swarm
                ;;
            8)
                terminate_single_swarm
                ;;
            9)
                terminate_all_swarms
                ;;
            10)
                kill_all_processes
                ;;
            11)
                view_logs
                break
                ;;
            12)
                show_guide
                ;;
            13)
                echo -e "${GREEN}👋 Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option!${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${BLUE}Press any key to continue...${NC}"
        read -n 1
    done
}

# Start the main menu
main_menu