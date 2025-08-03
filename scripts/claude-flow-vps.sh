#!/bin/bash

# Claude-Flow VPS Management Script - FUNCTIONAL VERSION
# Non-interactive commands that actually work
# Created: 2025-08-03

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
cd "$BASE_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Version Info
VERSION="1.0"
CLAUDE_FLOW_VERSION=$(npx claude-flow@alpha --version 2>/dev/null || echo "not installed")

# Default configurations
DEFAULT_WORKERS=8
DEFAULT_QUEEN="strategic"
DEFAULT_MEMORY=100

# VPS Project configurations
declare -A PROJECT_CONFIGS=(
    ["church-nextjs"]="14:strategic:200"
    ["bldb-webapp"]="12:strategic:150"
    ["standorte"]="10:adaptive:120"
    ["anlass"]="14:strategic:180"
    ["doc-generator"]="10:adaptive:150"
    ["in-or-out"]="8:adaptive:100"
    ["divine-words"]="8:tactical:100"
    ["shepherds-helper"]="10:strategic:120"
)

# ============= FUNCTIONS =============

function show_help() {
    cat << EOF
Claude-Flow VPS Management Script v${VERSION}

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    init                    Initialize hive-mind system
    spawn <objective>       Start new swarm with objective
    status                  Show system status
    sessions, list          List all sessions
    resume <session-id>     Resume a paused session
    stop, kill <session-id> Stop a running session
    cleanup, clean          Clean up all processes
    project <name>          Spawn with project preset
    quick-fix, fix <desc>   Quick tactical spawn (4 workers)
    analyze <desc>          Analysis spawn (10 workers)
    test-spawn, test <desc> Test with minimal resources (2 workers)
    batch <file>            Spawn multiple swarms from file
    monitor                 Live monitoring mode
    health, check           System health check
    
OPTIONS:
    -w, --workers <n>       Number of workers (default: 8)
    -q, --queen <type>      Queen type: strategic|tactical|adaptive (default: strategic)
    -m, --memory <mb>       Memory size in MB (default: 100)
    -a, --auto-scale        Enable auto-scaling
    -v, --verbose           Verbose output
    -h, --help             Show this help

EXAMPLES:
    # Initialize system (run once)
    $0 init

    # Simple spawn
    $0 spawn "Build a REST API for user management"

    # Spawn with options
    $0 spawn "Complex refactoring task" -w 12 -q strategic -a

    # Use project preset
    $0 project church-nextjs "Add new feature for member directory"

    # Quick bug fix
    $0 quick-fix "Fix login authentication error"

    # System status
    $0 status

    # List sessions
    $0 sessions

    # Health check
    $0 health

    # Monitor mode
    $0 monitor

VPS PROJECTS:
    church-nextjs    (14 workers, strategic)
    bldb-webapp      (12 workers, strategic)
    standorte        (10 workers, adaptive)
    anlass           (14 workers, strategic)
    doc-generator    (10 workers, adaptive)
    in-or-out        (8 workers, adaptive)
    divine-words     (8 workers, tactical)
    shepherds-helper (10 workers, strategic)

EOF
}

function check_claude_flow() {
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}Error: npx not found. Please install Node.js${NC}"
        exit 1
    fi
    
    if [[ "$CLAUDE_FLOW_VERSION" == "not installed" ]]; then
        echo -e "${YELLOW}Claude-Flow not found. It will be installed on first use.${NC}"
    fi
}

function init_hive_mind() {
    echo -e "${BLUE}Initializing Hive Mind system...${NC}"
    
    # Check if already initialized
    if [ -f ".hive-mind/hive.db" ]; then
        echo -e "${YELLOW}Hive Mind already initialized. Reinitializing...${NC}"
    fi
    
    npx claude-flow@alpha hive-mind init
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Hive Mind initialized successfully${NC}"
    else
        echo -e "${RED}✗ Failed to initialize Hive Mind${NC}"
        exit 1
    fi
}

function spawn_swarm() {
    local objective="$1"
    shift
    
    if [ -z "$objective" ]; then
        echo -e "${RED}Error: Objective required${NC}"
        echo "Usage: $0 spawn \"Your objective here\""
        exit 1
    fi
    
    # Parse additional options
    local workers=$DEFAULT_WORKERS
    local queen=$DEFAULT_QUEEN
    local memory=$DEFAULT_MEMORY
    local auto_scale=""
    local verbose=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -w|--workers)
                workers="$2"
                shift 2
                ;;
            -q|--queen)
                queen="$2"
                shift 2
                ;;
            -m|--memory)
                memory="$2"
                shift 2
                ;;
            -a|--auto-scale)
                auto_scale="--auto-scale"
                shift
                ;;
            -v|--verbose)
                verbose="--verbose"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    echo -e "${GREEN}🐝 Spawning swarm...${NC}"
    echo -e "  Objective: ${CYAN}$objective${NC}"
    echo -e "  Workers: $workers"
    echo -e "  Queen: $queen"
    echo -e "  Memory: ${memory}MB"
    [ -n "$auto_scale" ] && echo -e "  Auto-scale: enabled"
    echo ""
    
    # Execute spawn command
    npx claude-flow@alpha hive-mind spawn "$objective" \
        --max-workers "$workers" \
        --queen-type "$queen" \
        --memory-size "$memory" \
        $auto_scale \
        $verbose
}

function show_status() {
    echo -e "${BLUE}📊 System Status${NC}"
    echo ""
    
    # Show Claude-Flow version
    echo -e "Claude-Flow: ${CYAN}$CLAUDE_FLOW_VERSION${NC}"
    echo ""
    
    # Show active processes
    local proc_count=$(pgrep -f "claude-flow" | wc -l)
    echo -e "Active processes: ${YELLOW}$proc_count${NC}"
    
    # Show hive-mind status
    npx claude-flow@alpha hive-mind status
}

function list_sessions() {
    echo -e "${BLUE}📋 Active Sessions${NC}"
    echo ""
    npx claude-flow@alpha hive-mind sessions
}

function resume_session() {
    local session_id="$1"
    
    if [ -z "$session_id" ]; then
        echo -e "${RED}Error: Session ID required${NC}"
        echo "Usage: $0 resume <session-id>"
        echo ""
        echo "Available sessions:"
        list_sessions
        exit 1
    fi
    
    echo -e "${GREEN}▶️  Resuming session: $session_id${NC}"
    npx claude-flow@alpha hive-mind resume "$session_id"
}

function stop_session() {
    local session_id="$1"
    
    if [ -z "$session_id" ]; then
        echo -e "${RED}Error: Session ID required${NC}"
        echo "Usage: $0 stop <session-id>"
        echo ""
        echo "Available sessions:"
        list_sessions
        exit 1
    fi
    
    echo -e "${YELLOW}⏹️  Stopping session: $session_id${NC}"
    npx claude-flow@alpha hive-mind stop "$session_id"
}

function cleanup_all() {
    echo -e "${YELLOW}🧹 Cleaning up all Claude-Flow processes...${NC}"
    
    # Kill processes
    pkill -f "claude-flow" 2>/dev/null
    
    sleep 2
    
    # Check if any remain
    if pgrep -f "claude-flow" > /dev/null; then
        echo -e "${YELLOW}Force killing remaining processes...${NC}"
        pkill -9 -f "claude-flow" 2>/dev/null
    fi
    
    echo -e "${GREEN}✓ Cleanup complete${NC}"
}

function spawn_project() {
    local project="$1"
    local objective="$2"
    shift 2
    
    if [ -z "$project" ] || [ -z "$objective" ]; then
        echo -e "${RED}Error: Project name and objective required${NC}"
        echo "Usage: $0 project <project-name> \"objective\""
        echo ""
        echo "Available projects:"
        for proj in "${!PROJECT_CONFIGS[@]}"; do
            echo "  - $proj"
        done
        exit 1
    fi
    
    # Get project configuration
    local config="${PROJECT_CONFIGS[$project]}"
    if [ -z "$config" ]; then
        echo -e "${RED}Error: Unknown project '$project'${NC}"
        echo "Available projects:"
        for proj in "${!PROJECT_CONFIGS[@]}"; do
            echo "  - $proj"
        done
        exit 1
    fi
    
    # Parse configuration
    IFS=':' read -r workers queen memory <<< "$config"
    
    echo -e "${PURPLE}🚀 Project: $project${NC}"
    
    # Spawn with project settings
    spawn_swarm "[$project] $objective" -w "$workers" -q "$queen" -m "$memory" "$@"
}

function quick_fix() {
    local desc="$1"
    shift
    
    if [ -z "$desc" ]; then
        echo -e "${RED}Error: Description required${NC}"
        echo "Usage: $0 quick-fix \"description\""
        exit 1
    fi
    
    echo -e "${YELLOW}⚡ Quick Fix Mode${NC}"
    spawn_swarm "Quick fix: $desc" -w 4 -q tactical "$@"
}

function analyze_task() {
    local desc="$1"
    shift
    
    if [ -z "$desc" ]; then
        echo -e "${RED}Error: Description required${NC}"
        echo "Usage: $0 analyze \"description\""
        exit 1
    fi
    
    echo -e "${CYAN}🔍 Analysis Mode${NC}"
    spawn_swarm "Analyze: $desc" -w 10 -q strategic -a "$@"
}

# ============= ADDITIONAL HELPER FUNCTIONS =============

function test_spawn() {
    local desc="$1"
    shift
    
    if [ -z "$desc" ]; then
        echo -e "${RED}Error: Description required${NC}"
        echo "Usage: $0 test-spawn \"description\""
        exit 1
    fi
    
    echo -e "${PURPLE}🧪 Test Spawn Mode${NC}"
    spawn_swarm "Test spawn: $desc" -w 2 -q tactical -m 50 "$@"
}

function batch_spawn() {
    echo -e "${CYAN}📦 Batch Spawn Mode${NC}"
    echo ""
    
    if [ ! -f "$1" ]; then
        echo -e "${RED}Error: Batch file not found${NC}"
        echo "Usage: $0 batch <file>"
        echo ""
        echo "Batch file format (one per line):"
        echo "workers:queen:memory:objective"
        echo ""
        echo "Example:"
        echo "8:strategic:100:Build REST API for user management"
        echo "6:tactical:80:Fix authentication bug"
        exit 1
    fi
    
    local count=0
    while IFS=':' read -r workers queen memory objective; do
        if [ -n "$objective" ]; then
            ((count++))
            echo -e "${BLUE}[$count] Starting: $objective${NC}"
            spawn_swarm "$objective" -w "$workers" -q "$queen" -m "$memory"
            sleep 5  # Brief pause between spawns
        fi
    done < "$1"
    
    echo -e "${GREEN}✓ Spawned $count swarms${NC}"
}

function monitor_mode() {
    echo -e "${BLUE}📊 Monitor Mode${NC}"
    echo "Press Ctrl+C to exit"
    echo ""
    
    while true; do
        clear
        echo -e "${BLUE}📊 Claude-Flow Monitor - $(date)${NC}"
        echo "========================================"
        echo ""
        
        # Show process count
        local proc_count=$(pgrep -f "claude-flow" | wc -l)
        echo -e "Active processes: ${YELLOW}$proc_count${NC}"
        echo ""
        
        # Show sessions
        echo -e "${CYAN}Sessions:${NC}"
        npx claude-flow@alpha hive-mind sessions 2>&1 | head -20
        
        sleep 5
    done
}

function health_check() {
    echo -e "${CYAN}🏥 System Health Check${NC}"
    echo ""
    
    # Check Node.js
    echo -n "Node.js: "
    if command -v node &> /dev/null; then
        echo -e "${GREEN}✓ $(node --version)${NC}"
    else
        echo -e "${RED}✗ Not found${NC}"
    fi
    
    # Check NPM
    echo -n "NPM: "
    if command -v npm &> /dev/null; then
        echo -e "${GREEN}✓ $(npm --version)${NC}"
    else
        echo -e "${RED}✗ Not found${NC}"
    fi
    
    # Check claude-flow
    echo -n "Claude-Flow: "
    if [[ "$CLAUDE_FLOW_VERSION" != "not installed" ]]; then
        echo -e "${GREEN}✓ $CLAUDE_FLOW_VERSION${NC}"
    else
        echo -e "${YELLOW}⚠ Will be installed on first use${NC}"
    fi
    
    # Check database
    echo -n "Database: "
    if [ -f ".hive-mind/hive.db" ]; then
        echo -e "${GREEN}✓ Initialized ($(du -h .hive-mind/hive.db | cut -f1))${NC}"
    else
        echo -e "${YELLOW}⚠ Not initialized (run: $0 init)${NC}"
    fi
    
    # Check processes
    local proc_count=$(pgrep -f "claude-flow" | wc -l)
    echo -n "Active processes: "
    if [ $proc_count -eq 0 ]; then
        echo -e "${GREEN}✓ None (clean state)${NC}"
    else
        echo -e "${YELLOW}⚠ $proc_count running${NC}"
    fi
    
    echo ""
}

# ============= MAIN =============

# Check if claude-flow is available
check_claude_flow

# Parse command
case "${1:-help}" in
    init)
        init_hive_mind
        ;;
    spawn)
        shift
        spawn_swarm "$@"
        ;;
    status)
        show_status
        ;;
    sessions|list)
        list_sessions
        ;;
    resume)
        resume_session "$2"
        ;;
    stop|kill)
        stop_session "$2"
        ;;
    cleanup|clean)
        cleanup_all
        ;;
    project)
        shift
        spawn_project "$@"
        ;;
    quick-fix|fix)
        shift
        quick_fix "$@"
        ;;
    analyze)
        shift
        analyze_task "$@"
        ;;
    test-spawn|test)
        shift
        test_spawn "$@"
        ;;
    batch)
        batch_spawn "$2"
        ;;
    monitor)
        monitor_mode
        ;;
    health|check)
        health_check
        ;;
    -h|--help|help)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac