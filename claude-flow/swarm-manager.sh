#!/bin/bash

# Claude-Flow Swarm Manager
# Verwaltet alle laufenden Swarms

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben für bessere Lesbarkeit
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function list_swarms() {
    echo -e "${BLUE}🐝 Listing all active Hive Mind sessions...${NC}"
    echo ""
    npx claude-flow@alpha hive-mind sessions | grep -E "Session ID:|Objective:|Status:|Created:" | sed 's/^/  /'
    echo ""
}

function terminate_all_swarms() {
    echo -e "${YELLOW}⚠️  Collecting all active sessions...${NC}"
    
    # Extract session IDs from the output
    SESSION_IDS=$(npx claude-flow@alpha hive-mind sessions | grep "Session ID:" | awk '{print $3}')
    
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
            npx claude-flow@alpha hive-mind stop "$session_id" 2>&1 | grep -E "stopped|cleaned" | sed 's/^/    /'
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
    npx claude-flow@alpha hive-mind stop "$session_id"
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

# Main Menu
clear
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Claude-Flow Swarm Manager          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo "1) List all active swarms"
echo "2) Terminate ALL swarms"
echo "3) Terminate single swarm"
echo "4) Kill all claude-flow processes"
echo "5) Exit"
echo ""
read -p "Choose an option (1-5): " choice

case $choice in
    1)
        list_swarms
        ;;
    2)
        terminate_all_swarms
        ;;
    3)
        terminate_single_swarm
        ;;
    4)
        kill_all_processes
        ;;
    5)
        echo -e "${GREEN}👋 Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option!${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}Press any key to exit...${NC}"
read -n 1