#!/bin/bash

# Claude-Flow Simple Launcher
# Direkte Commands ohne tmux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

function show_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    Claude-Flow Simple Launcher         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "1) Quick spawn new swarm"
    echo "2) List active swarms"
    echo "3) Show swarm status"
    echo "4) Resume swarm session"
    echo "5) Stop swarm"
    echo "6) Kill all claude-flow"
    echo "7) Exit"
    echo ""
}

function quick_spawn() {
    echo -e "${GREEN}🐝 Quick Swarm Spawn${NC}"
    echo ""
    read -p "Enter objective: " objective
    
    if [ -z "$objective" ]; then
        echo -e "${RED}Objective required!${NC}"
        return
    fi
    
    echo ""
    echo "Starting swarm with:"
    echo "  - Objective: $objective"
    echo "  - Workers: 8"
    echo "  - Type: adaptive"
    echo ""
    
    npx claude-flow@alpha hive-mind spawn "$objective" \
        --claude \
        --max-workers 8 \
        --queen-type adaptive \
        --auto-scale \
        --verbose
}

function list_swarms() {
    echo -e "${BLUE}📋 Active Swarms:${NC}"
    echo ""
    npx claude-flow@alpha hive-mind sessions
}

function show_status() {
    echo -e "${BLUE}📊 Swarm Status:${NC}"
    echo ""
    npx claude-flow@alpha hive-mind status
}

function resume_swarm() {
    list_swarms
    echo ""
    read -p "Enter Session ID to resume: " session_id
    
    if [ -z "$session_id" ]; then
        return
    fi
    
    npx claude-flow@alpha hive-mind resume "$session_id"
}

function stop_swarm() {
    list_swarms
    echo ""
    read -p "Enter Session ID to stop: " session_id
    
    if [ -z "$session_id" ]; then
        return
    fi
    
    npx claude-flow@alpha hive-mind stop "$session_id"
}

function kill_all() {
    echo -e "${YELLOW}Killing all claude-flow processes...${NC}"
    pkill -f claude-flow
    sleep 2
    
    if pgrep -f claude-flow > /dev/null; then
        echo "Force killing remaining..."
        pkill -9 -f claude-flow
    fi
    
    echo -e "${GREEN}Done!${NC}"
}

# Main loop
while true; do
    show_menu
    read -p "Choice: " choice
    echo ""
    
    case $choice in
        1) quick_spawn ;;
        2) list_swarms ;;
        3) show_status ;;
        4) resume_swarm ;;
        5) stop_swarm ;;
        6) kill_all ;;
        7) 
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *) 
            echo -e "${RED}Invalid choice!${NC}"
            ;;
    esac
    
    echo ""
    echo "Press any key to continue..."
    read -n 1
done