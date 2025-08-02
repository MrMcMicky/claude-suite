#!/bin/bash

# Claude-Flow Universal Manager V2
# Korrigierte Version basierend auf der Dokumentation

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

# ============= HELPER FUNCTIONS =============

function check_npx() {
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}Error: npx not found. Please install Node.js and npm.${NC}"
        exit 1
    fi
}

function safe_execute() {
    local command="$1"
    local timeout_duration="${2:-15}"
    local description="$3"
    
    if [ -n "$description" ]; then
        echo -e "${BLUE}${description}...${NC}"
    fi
    
    # Use timeout but don't exit on failure
    timeout "${timeout_duration}s" bash -c "$command" 2>&1 || {
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${YELLOW}⚠️  Command timed out after ${timeout_duration}s${NC}"
        else
            echo -e "${YELLOW}⚠️  Command failed with exit code: $exit_code${NC}"
        fi
        return $exit_code
    }
}

# ============= SWARM MANAGEMENT FUNCTIONS =============

function list_swarms() {
    echo -e "${BLUE}🐝 Listing all active Hive Mind sessions...${NC}"
    echo ""
    
    # Use correct command from documentation
    safe_execute "npx claude-flow@alpha hive-mind sessions" 10 "Fetching sessions"
    echo ""
}

function show_swarm_status() {
    echo -e "${BLUE}📊 Showing Hive Mind status...${NC}"
    echo ""
    
    # Use correct command from documentation
    safe_execute "npx claude-flow@alpha hive-mind status" 10 "Getting status"
    echo ""
}

function show_swarm_metrics() {
    echo -e "${BLUE}📈 Showing performance metrics...${NC}"
    echo ""
    
    safe_execute "npx claude-flow@alpha hive-mind metrics" 10 "Getting metrics"
    echo ""
}

function show_collective_memory() {
    echo -e "${BLUE}🧠 Showing collective memory...${NC}"
    echo ""
    
    safe_execute "npx claude-flow@alpha hive-mind memory" 10 "Getting memory"
    echo ""
}

function terminate_all_swarms() {
    echo -e "${YELLOW}⚠️  Collecting all active sessions...${NC}"
    
    # Get session IDs
    local sessions_output=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>&1)
    
    if [ $? -ne 0 ] || [ -z "$sessions_output" ]; then
        echo -e "${RED}Could not fetch sessions.${NC}"
        return 1
    fi
    
    # Extract session IDs more reliably
    local session_ids=$(echo "$sessions_output" | grep -oP 'Session ID:\s*\K[a-z0-9-]+' | sort -u)
    
    if [ -z "$session_ids" ]; then
        echo -e "${GREEN}✅ No active sessions found.${NC}"
        return 0
    fi
    
    # Count sessions
    local session_count=$(echo "$session_ids" | wc -l)
    echo -e "${YELLOW}Found $session_count active session(s).${NC}"
    echo ""
    
    # Show sessions
    echo "$session_ids" | while read -r id; do
        echo -e "  - ${CYAN}$id${NC}"
    done
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
    
    echo "$session_ids" | while read -r session_id; do
        if [ ! -z "$session_id" ]; then
            echo -e "  Stopping: ${RED}$session_id${NC}"
            safe_execute "npx claude-flow@alpha hive-mind stop $session_id" 15
            sleep 1
        fi
    done
    
    echo ""
    echo -e "${GREEN}✅ All sessions terminated.${NC}"
}

function terminate_single_swarm() {
    # First list swarms
    list_swarms
    
    echo ""
    read -p "Enter Session ID to terminate (or 'cancel'): " session_id
    
    if [ "$session_id" == "cancel" ] || [ -z "$session_id" ]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}🛑 Terminating session: $session_id${NC}"
    safe_execute "npx claude-flow@alpha hive-mind stop $session_id" 15
}

function reconnect_to_swarm() {
    echo -e "${BLUE}🔄 Reconnecting to existing swarm...${NC}"
    echo ""
    
    # Get sessions
    local sessions_output=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>&1)
    
    if [ $? -ne 0 ] || [ -z "$sessions_output" ]; then
        echo -e "${RED}No active sessions found or timeout occurred.${NC}"
        return 1
    fi
    
    # Parse sessions more reliably
    local session_data=$(echo "$sessions_output" | grep -E "(Session ID:|Objective:|Status:)" | paste -d' ' - - - 2>/dev/null)
    
    if [ -z "$session_data" ]; then
        echo -e "${RED}No active sessions found.${NC}"
        return 1
    fi
    
    # Display sessions
    echo -e "${GREEN}Active sessions:${NC}"
    echo ""
    
    local i=1
    echo "$sessions_output" | grep -B1 -A2 "Session ID:" | while IFS= read -r line; do
        if [[ $line =~ "Session ID:" ]]; then
            echo -e "  ${YELLOW}$i)${NC} $line"
            ((i++))
        elif [[ $line =~ "Objective:" ]] || [[ $line =~ "Status:" ]]; then
            echo "     $line"
        elif [[ $line == "--" ]]; then
            echo ""
        fi
    done
    
    echo ""
    read -p "Enter Session ID to reconnect (or 'cancel'): " session_id
    
    if [ "$session_id" == "cancel" ] || [ -z "$session_id" ]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}🔗 Reconnecting to session: $session_id${NC}"
    echo ""
    
    # Use resume command from documentation
    safe_execute "npx claude-flow@alpha hive-mind resume $session_id" 30
}

function spawn_new_swarm() {
    echo -e "${PURPLE}🐝 Spawning new Hive Mind swarm...${NC}"
    echo ""
    
    read -p "Enter swarm objective: " objective
    
    if [ -z "$objective" ]; then
        echo -e "${RED}Objective cannot be empty!${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}Select Queen Type:${NC}"
    echo "  1) strategic - Long-term planning (default)"
    echo "  2) adaptive - Flexible adaptation"
    echo "  3) tactical - Short-term tactics"
    echo "  4) exploratory - Research & discovery"
    read -p "Choice (1-4, default=1): " queen_choice
    
    case "$queen_choice" in
        2) queen_type="adaptive" ;;
        3) queen_type="tactical" ;;
        4) queen_type="exploratory" ;;
        *) queen_type="strategic" ;;
    esac
    
    read -p "Max workers (default=8, max=20): " max_workers
    max_workers=${max_workers:-8}
    
    echo ""
    echo -e "${BLUE}Configuration:${NC}"
    echo "  Objective: $objective"
    echo "  Queen Type: $queen_type"
    echo "  Max Workers: $max_workers"
    echo "  Auto-scale: enabled"
    echo ""
    
    read -p "Continue? (y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${GREEN}Spawning swarm...${NC}"
    
    # Build command
    local cmd="npx claude-flow@alpha hive-mind spawn \"$objective\" --claude --queen-type $queen_type --max-workers $max_workers --auto-scale --verbose"
    
    echo -e "${CYAN}Command: $cmd${NC}"
    echo ""
    
    # Execute without timeout for spawn
    eval "$cmd"
}

# ============= PROCESS MANAGEMENT FUNCTIONS =============

function kill_all_processes() {
    echo -e "${YELLOW}🔪 Killing all claude-flow processes...${NC}"
    
    # Get process count before
    local before_count=$(pgrep -f "claude-flow" | wc -l)
    echo "Found $before_count claude-flow process(es)"
    
    if [ $before_count -eq 0 ]; then
        echo -e "${GREEN}No processes to kill.${NC}"
        return 0
    fi
    
    # Kill gracefully first
    pkill -f "claude-flow"
    sleep 2
    
    # Check if any remain
    local after_count=$(pgrep -f "claude-flow" | wc -l)
    
    if [ $after_count -gt 0 ]; then
        echo -e "${RED}$after_count process(es) still running. Force killing...${NC}"
        pkill -9 -f "claude-flow"
        sleep 1
    fi
    
    # Final check
    local final_count=$(pgrep -f "claude-flow" | wc -l)
    if [ $final_count -eq 0 ]; then
        echo -e "${GREEN}✅ All processes terminated.${NC}"
    else
        echo -e "${RED}⚠️  $final_count process(es) could not be killed.${NC}"
    fi
}

function check_system_status() {
    echo -e "${YELLOW}🔍 Checking system status...${NC}"
    echo ""
    
    # Check running processes
    echo -e "${BLUE}Running processes:${NC}"
    local process_count=$(pgrep -f "claude-flow" | wc -l)
    echo "  Claude-Flow processes: $process_count"
    
    if [ $process_count -gt 0 ]; then
        echo ""
        echo -e "${CYAN}Process details:${NC}"
        ps aux | grep -E "claude-flow" | grep -v grep | awk '{print "  PID:", $2, "CMD:", substr($0, index($0,$11))}'
    fi
    
    echo ""
    
    # Check database
    echo -e "${BLUE}Database status:${NC}"
    if [ -d ".hive-mind" ]; then
        echo "  ✓ .hive-mind directory exists"
        if [ -f ".hive-mind/hive.db" ]; then
            local db_size=$(du -h .hive-mind/hive.db | cut -f1)
            echo "  ✓ hive.db exists (size: $db_size)"
        else
            echo "  ✗ hive.db not found"
        fi
    else
        echo "  ✗ .hive-mind directory not found"
    fi
    
    echo ""
    
    # Try to get hive-mind status
    echo -e "${BLUE}Hive Mind status:${NC}"
    safe_execute "npx claude-flow@alpha hive-mind status" 10
}

function view_logs() {
    echo -e "${CYAN}📋 Viewing Claude-Flow logs...${NC}"
    echo ""
    
    # Check multiple possible log locations
    local log_dirs=(
        "$HOME/.claude-flow/logs"
        "./.claude-flow/logs"
        "./logs"
        "./.hive-mind/logs"
    )
    
    local found_logs=false
    
    for log_dir in "${log_dirs[@]}"; do
        if [ -d "$log_dir" ] && [ "$(ls -A $log_dir 2>/dev/null)" ]; then
            found_logs=true
            echo -e "${GREEN}Found logs in: $log_dir${NC}"
            echo ""
            
            # List log files
            echo "Available logs:"
            ls -la "$log_dir"/*.log 2>/dev/null | tail -10
            echo ""
            
            # Show latest log
            local latest_log=$(ls -t "$log_dir"/*.log 2>/dev/null | head -1)
            if [ -n "$latest_log" ]; then
                echo "Showing last 50 lines of: $latest_log"
                echo "Press Ctrl+C to exit tail -f mode"
                echo ""
                tail -50 "$latest_log"
                read -p "Follow log file? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    tail -f "$latest_log"
                fi
            fi
            break
        fi
    done
    
    if [ "$found_logs" = false ]; then
        echo -e "${YELLOW}No log files found in standard locations.${NC}"
        echo "Checked:"
        for dir in "${log_dirs[@]}"; do
            echo "  - $dir"
        done
    fi
}

function clean_environment() {
    echo -e "${RED}🧹 Cleaning Claude-Flow environment...${NC}"
    echo ""
    echo -e "${YELLOW}This will:${NC}"
    echo "  - Kill all processes"
    echo "  - Terminate all swarms"
    echo "  - Clean temporary files"
    echo ""
    
    read -p "Are you sure? (yes/no): " confirmation
    
    if [ "$confirmation" != "yes" ]; then
        echo -e "${BLUE}❌ Operation cancelled.${NC}"
        return 1
    fi
    
    # Terminate swarms
    echo -e "${YELLOW}Terminating swarms...${NC}"
    terminate_all_swarms
    
    # Kill processes
    echo -e "${YELLOW}Killing processes...${NC}"
    kill_all_processes
    
    # Clean temp files
    echo -e "${YELLOW}Cleaning temporary files...${NC}"
    rm -rf ./.claude-flow/temp/* 2>/dev/null
    rm -rf /tmp/claude-flow-* 2>/dev/null
    
    echo -e "${GREEN}✅ Environment cleaned.${NC}"
}

# ============= MAIN MENU =============

function main_menu() {
    check_npx
    
    while true; do
        clear
        echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║        Claude-Flow Universal Manager V2            ║${NC}"
        echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}━━━ Swarm Operations ━━━${NC}"
        echo "  1) List active swarms (sessions)"
        echo "  2) Show swarm status"
        echo "  3) Show performance metrics"
        echo "  4) Show collective memory"
        echo "  5) Spawn new swarm"
        echo "  6) Reconnect to swarm (resume)"
        echo ""
        echo -e "${YELLOW}━━━ Management ━━━${NC}"
        echo "  7) Terminate single swarm"
        echo "  8) Terminate ALL swarms"
        echo "  9) Kill all processes"
        echo " 10) Check system status"
        echo ""
        echo -e "${PURPLE}━━━ Utilities ━━━${NC}"
        echo " 11) View logs"
        echo " 12) Clean environment"
        echo ""
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo " 13) Exit"
        echo ""
        read -p "Choose an option (1-13): " choice
        echo ""
        
        case $choice in
            1) list_swarms ;;
            2) show_swarm_status ;;
            3) show_swarm_metrics ;;
            4) show_collective_memory ;;
            5) spawn_new_swarm ;;
            6) reconnect_to_swarm ;;
            7) terminate_single_swarm ;;
            8) terminate_all_swarms ;;
            9) kill_all_processes ;;
            10) check_system_status ;;
            11) view_logs ;;
            12) clean_environment ;;
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