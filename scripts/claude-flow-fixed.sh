#!/bin/bash

# Claude-Flow Fixed Manager
# Robuste Version mit Fehlerbehandlung

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============= HELPER FUNCTIONS =============

function check_blocking_processes() {
    local count=$(pgrep -f "claude-flow" | wc -l)
    if [ $count -gt 1 ]; then
        echo -e "${YELLOW}⚠️  Warning: $count claude-flow processes are running${NC}"
        echo "This might cause commands to hang or fail."
        echo ""
        echo "Running processes:"
        ps aux | grep -E "claude-flow" | grep -v grep | awk '{print "  PID:", $2, "CMD:", substr($0, index($0,$11), 80) "..."}'
        echo ""
        return 1
    fi
    return 0
}

function force_kill_all() {
    echo -e "${RED}Force killing all claude-flow processes...${NC}"
    
    # Get all PIDs
    local pids=$(pgrep -f "claude-flow")
    
    if [ -z "$pids" ]; then
        echo "No processes to kill."
        return 0
    fi
    
    # Kill each PID
    for pid in $pids; do
        echo "Killing PID $pid..."
        kill -9 $pid 2>/dev/null
    done
    
    sleep 2
    
    # Verify
    local remaining=$(pgrep -f "claude-flow" | wc -l)
    if [ $remaining -eq 0 ]; then
        echo -e "${GREEN}✅ All processes terminated.${NC}"
    else
        echo -e "${RED}⚠️  $remaining processes still running!${NC}"
    fi
}

function safe_spawn_swarm() {
    echo -e "${GREEN}🐝 Spawning new swarm (simplified)${NC}"
    echo ""
    
    # Check for blocking processes
    if ! check_blocking_processes; then
        echo -e "${RED}Cannot spawn new swarm while other processes are running.${NC}"
        echo "Please kill existing processes first (Option 1)."
        return 1
    fi
    
    read -p "Enter swarm objective: " objective
    
    if [ -z "$objective" ]; then
        echo -e "${RED}Objective required!${NC}"
        return 1
    fi
    
    # Simple spawn command
    echo ""
    echo "Spawning swarm..."
    echo ""
    
    # Run in background to avoid hanging
    nohup npx claude-flow@alpha hive-mind spawn "$objective" --claude --max-workers 8 > swarm-spawn.log 2>&1 &
    local pid=$!
    
    echo -e "${GREEN}Swarm spawning in background (PID: $pid)${NC}"
    echo "Check swarm-spawn.log for details"
    echo ""
    
    # Wait a bit and check if it started
    sleep 3
    
    if ps -p $pid > /dev/null; then
        echo -e "${GREEN}✅ Swarm process started successfully${NC}"
    else
        echo -e "${RED}⚠️  Swarm process may have failed to start${NC}"
        echo "Check swarm-spawn.log for errors"
    fi
}

function view_spawn_log() {
    if [ -f "swarm-spawn.log" ]; then
        echo -e "${CYAN}Last 50 lines of swarm-spawn.log:${NC}"
        echo ""
        tail -50 swarm-spawn.log
    else
        echo -e "${YELLOW}No spawn log found.${NC}"
    fi
}

function check_database_sessions() {
    echo -e "${BLUE}📊 Checking database for sessions...${NC}"
    echo ""
    
    if [ ! -f ".hive-mind/hive.db" ]; then
        echo -e "${RED}No database found.${NC}"
        return 1
    fi
    
    # Try to read database file info
    echo "Database info:"
    echo "  Size: $(du -h .hive-mind/hive.db | cut -f1)"
    echo "  Modified: $(stat -c %y .hive-mind/hive.db 2>/dev/null || stat -f %Sm .hive-mind/hive.db 2>/dev/null)"
    echo ""
    
    # Check for WAL file (indicates active database)
    if [ -f ".hive-mind/hive.db-wal" ]; then
        echo -e "${YELLOW}Database appears to be in use (WAL file exists)${NC}"
    fi
}

function emergency_cleanup() {
    echo -e "${RED}🚨 Emergency Cleanup${NC}"
    echo ""
    echo "This will:"
    echo "  1. Force kill ALL claude-flow processes"
    echo "  2. Clean up temporary files"
    echo "  3. Reset the environment"
    echo ""
    
    read -p "Continue? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        echo "Cancelled."
        return
    fi
    
    # Kill everything
    force_kill_all
    
    # Clean temp files
    echo "Cleaning temporary files..."
    rm -f swarm-spawn.log
    rm -f nohup.out
    rm -rf /tmp/claude-flow-*
    rm -rf .claude-flow/temp/*
    
    echo -e "${GREEN}✅ Emergency cleanup complete.${NC}"
}

function show_process_tree() {
    echo -e "${BLUE}📊 Claude-Flow Process Tree:${NC}"
    echo ""
    
    # Find all claude-flow processes
    local pids=$(pgrep -f "claude-flow" | tr '\n' ',' | sed 's/,$//')
    
    if [ -z "$pids" ]; then
        echo "No claude-flow processes running."
        return
    fi
    
    # Show process tree
    if command -v pstree &> /dev/null; then
        pstree -p $pids 2>/dev/null || ps aux | grep claude-flow | grep -v grep
    else
        ps aux | grep claude-flow | grep -v grep
    fi
}

# ============= MAIN MENU =============

function main_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║     Claude-Flow Fixed Manager (Robust Version)     ║${NC}"
        echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        # Quick status check
        local proc_count=$(pgrep -f "claude-flow" | wc -l)
        if [ $proc_count -gt 0 ]; then
            echo -e "${YELLOW}⚠️  Active processes: $proc_count${NC}"
        else
            echo -e "${GREEN}✓ No active processes${NC}"
        fi
        echo ""
        
        echo -e "${RED}━━━ Process Management ━━━${NC}"
        echo "  1) Force kill ALL processes"
        echo "  2) Show process tree"
        echo "  3) Check for blocking processes"
        echo ""
        echo -e "${GREEN}━━━ Swarm Operations ━━━${NC}"
        echo "  4) Spawn new swarm (safe mode)"
        echo "  5) View spawn log"
        echo "  6) Check database sessions"
        echo ""
        echo -e "${YELLOW}━━━ Maintenance ━━━${NC}"
        echo "  7) Emergency cleanup"
        echo "  8) Exit"
        echo ""
        read -p "Choose an option (1-8): " choice
        echo ""
        
        case $choice in
            1) force_kill_all ;;
            2) show_process_tree ;;
            3) check_blocking_processes ;;
            4) safe_spawn_swarm ;;
            5) view_spawn_log ;;
            6) check_database_sessions ;;
            7) emergency_cleanup ;;
            8)
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

# Check if we're in the right directory
if [ ! -d ".hive-mind" ] && [ ! -f "package.json" ]; then
    echo -e "${YELLOW}Creating .hive-mind directory...${NC}"
    mkdir -p .hive-mind
fi

# Start menu
main_menu