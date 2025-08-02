#!/bin/bash

# Claude-Suite Complete Manager
# Umfassende Integration aller Claude-Flow & Hive Mind Features

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben für bessere Lesbarkeit
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
MAGENTA='\033[0;95m'
NC='\033[0m' # No Color

# Version Info
VERSION="3.0"
CLAUDE_FLOW_VERSION="v2.0.0-alpha.83"

# ============= CONFIGURATION =============
# Default values from documentation
DEFAULT_WORKERS=8
MAX_WORKERS=24
DEFAULT_QUEEN="strategic"
DEFAULT_MEMORY=100
DEFAULT_PORT=3008

# Project configurations from PROJECT_SPAWN_TEMPLATES.md
declare -A PROJECT_WORKERS=(
    ["stepupfundraiser"]=14
    ["xtts"]=10
    ["inorout"]=8
    ["faithtranslate"]=12
    ["studysourceverifier"]=10
    ["eabw-cms"]=10
    ["mpm"]=16
    ["church-nextjs"]=14
    ["bldb-webapp"]=12
    ["anlass"]=14
    ["churchtools"]=8
    ["webcloner"]=10
    ["claudeflow"]=8
)

declare -A PROJECT_QUEENS=(
    ["stepupfundraiser"]="strategic"
    ["xtts"]="adaptive"
    ["inorout"]="tactical"
    ["faithtranslate"]="strategic"
    ["studysourceverifier"]="adaptive"
    ["eabw-cms"]="strategic"
    ["mpm"]="strategic"
    ["church-nextjs"]="strategic"
    ["bldb-webapp"]="adaptive"
    ["anlass"]="strategic"
    ["churchtools"]="tactical"
    ["webcloner"]="exploratory"
    ["claudeflow"]="adaptive"
)

# ============= HELPER FUNCTIONS =============

function show_banner() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Claude-Suite Complete Manager v${VERSION}              ║${NC}"
    echo -e "${BLUE}║         Professional Hive Mind Orchestration System            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

function check_prerequisites() {
    echo -e "${YELLOW}Checking prerequisites...${NC}"
    
    # Check npx
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}✗ npx not found. Please install Node.js${NC}"
        return 1
    fi
    
    # Check claude-flow
    local cf_version=$(npx claude-flow@alpha --version 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Claude-Flow installed: $cf_version${NC}"
    else
        echo -e "${YELLOW}⚠ Claude-Flow will be installed on first use${NC}"
    fi
    
    # Check directory structure
    if [ ! -d ".hive-mind" ]; then
        echo -e "${YELLOW}Creating .hive-mind directory...${NC}"
        mkdir -p .hive-mind
    fi
    
    echo -e "${GREEN}✓ Prerequisites check complete${NC}"
    echo ""
}

# ============= SWARM MANAGEMENT FUNCTIONS =============

function spawn_custom_swarm() {
    echo -e "${PURPLE}🐝 Custom Swarm Configuration${NC}"
    echo ""
    
    # Objective
    read -p "Swarm Objective: " objective
    if [ -z "$objective" ]; then
        echo -e "${RED}Objective is required!${NC}"
        return 1
    fi
    
    # Queen Type
    echo ""
    echo -e "${CYAN}Queen Types:${NC}"
    echo "  1) strategic   - Long-term planning, systematic (default)"
    echo "  2) adaptive    - Flexible, iterative, learns during execution"
    echo "  3) tactical    - Short-term, action-oriented, efficient"
    echo "  4) exploratory - Research, creative, innovative"
    read -p "Select Queen Type (1-4, default=1): " queen_choice
    
    case "$queen_choice" in
        2) queen_type="adaptive" ;;
        3) queen_type="tactical" ;;
        4) queen_type="exploratory" ;;
        *) queen_type="strategic" ;;
    esac
    
    # Workers
    echo ""
    read -p "Max Workers (4-24, default=8): " max_workers
    max_workers=${max_workers:-8}
    
    # Worker Types
    echo ""
    echo -e "${CYAN}Worker Type Presets:${NC}"
    echo "  1) Full Stack (architect,frontend,backend,database,tester)"
    echo "  2) Frontend   (frontend,ui,ux,tester)"
    echo "  3) Backend    (backend,database,api,tester)"
    echo "  4) Research   (researcher,analyst,documenter)"
    echo "  5) Security   (security,pentester,analyst,auditor)"
    echo "  6) Custom     (enter your own)"
    read -p "Select preset (1-6, default=1): " worker_preset
    
    case "$worker_preset" in
        2) worker_types="frontend,ui,ux,tester" ;;
        3) worker_types="backend,database,api,tester" ;;
        4) worker_types="researcher,analyst,documenter" ;;
        5) worker_types="security,pentester,analyst,auditor" ;;
        6) 
            read -p "Enter worker types (comma-separated): " worker_types
            ;;
        *) worker_types="architect,frontend,backend,database,tester" ;;
    esac
    
    # Advanced Options
    echo ""
    echo -e "${CYAN}Advanced Options:${NC}"
    read -p "Auto-scale? (y/n, default=y): " auto_scale
    auto_scale=${auto_scale:-y}
    
    read -p "Memory size in MB (100-1000, default=100): " memory_size
    memory_size=${memory_size:-100}
    
    read -p "Verbose logging? (y/n, default=y): " verbose
    verbose=${verbose:-y}
    
    # Build command
    local cmd="npx claude-flow@alpha hive-mind spawn \"$objective\""
    cmd="$cmd --claude"
    cmd="$cmd --queen-type $queen_type"
    cmd="$cmd --max-workers $max_workers"
    cmd="$cmd --worker-types \"$worker_types\""
    cmd="$cmd --memory-size $memory_size"
    
    [ "$auto_scale" = "y" ] && cmd="$cmd --auto-scale"
    [ "$verbose" = "y" ] && cmd="$cmd --verbose"
    
    # Confirm
    echo ""
    echo -e "${BLUE}Configuration Summary:${NC}"
    echo "  Objective: $objective"
    echo "  Queen: $queen_type"
    echo "  Workers: $max_workers"
    echo "  Types: $worker_types"
    echo "  Memory: ${memory_size}MB"
    echo "  Auto-scale: $auto_scale"
    echo ""
    echo -e "${CYAN}Command:${NC}"
    echo "$cmd"
    echo ""
    
    read -p "Spawn this swarm? (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo -e "${YELLOW}Cancelled${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${GREEN}Spawning swarm...${NC}"
    eval "$cmd"
}

function spawn_project_swarm() {
    echo -e "${PURPLE}🚀 Project-Specific Swarm Templates${NC}"
    echo ""
    
    echo -e "${CYAN}Available Projects:${NC}"
    echo "  1) StepUpFundraiser    - Fundraising Platform (Port 8000)"
    echo "  2) XTTS Voice Cloning  - Voice Cloning Suite (Port 7862)"
    echo "  3) In or Out           - Party Game (Port 3101)"
    echo "  4) FaithTranslate      - S2S Translation (Port 7500)"
    echo "  5) StudySourceVerifier - Academic Verification (Port 8501)"
    echo "  6) EABW-CMS           - Content Management (Port 8100)"
    echo "  7) MPM Manager        - Project Management (Port 5100)"
    echo "  8) Church-NextJS      - Central Hub (Port 3001)"
    echo "  9) BLDB-Webapp        - Laravel+Vue (Port 3000)"
    echo " 10) Anlass-System     - Event Management (Port 4000)"
    echo " 11) ChurchTools       - Search Interface (Port 8080)"
    echo " 12) Web Cloner Pro    - Website Cloning"
    echo " 13) Claude-Flow       - Management Tool (Port 3008)"
    echo ""
    
    read -p "Select project (1-13): " project_choice
    
    case "$project_choice" in
        1)
            npx claude-flow@alpha hive-mind spawn \
                "Optimize StepUpFundraiser Django backend, fix frontend URL routing to root, implement modern dashboard with shadcn/ui" \
                --claude \
                --queen-type strategic \
                --max-workers 14 \
                --worker-types "backend,frontend,database,ui,tester,security" \
                --auto-scale
            ;;
        2)
            npx claude-flow@alpha hive-mind spawn \
                "Enhance XTTS Voice Cloning UI with batch processing, improve Docker performance, add voice library management" \
                --claude \
                --queen-type adaptive \
                --max-workers 10 \
                --worker-types "ml,frontend,audio,performance,tester"
            ;;
        3)
            npx claude-flow@alpha hive-mind spawn \
                "Complete In or Out game with full German/English localization, fix UI consistency, add Docker setup" \
                --claude \
                --queen-type tactical \
                --max-workers 8 \
                --worker-types "frontend,game,localization,tester"
            ;;
        4)
            npx claude-flow@alpha hive-mind spawn \
                "Complete FaithTranslate s2s translation with Gemini Flash 2.5, optimize real-time performance, add theological term accuracy" \
                --claude \
                --queen-type strategic \
                --max-workers 12 \
                --worker-types "backend,ml,api,audio,localization,tester" \
                --memory-size 200
            ;;
        5)
            npx claude-flow@alpha hive-mind spawn \
                "Enhance StudySourceVerifier with PDF analysis, improve Streamlit UI, add batch verification mode" \
                --claude \
                --queen-type adaptive \
                --max-workers 10 \
                --worker-types "researcher,scraper,ui,analyst,tester"
            ;;
        6)
            npx claude-flow@alpha hive-mind spawn \
                "Maintain EABW-CMS clone accuracy, add admin features, optimize performance with caching" \
                --claude \
                --queen-type strategic \
                --max-workers 10 \
                --worker-types "frontend,backend,cms,performance,tester"
            ;;
        7)
            npx claude-flow@alpha hive-mind spawn \
                "Enhance MPM with real-time collaboration, optimize React performance, add advanced reporting features" \
                --claude \
                --queen-type strategic \
                --max-workers 16 \
                --worker-types "architect,frontend,backend,database,realtime,ui,tester" \
                --auto-scale
            ;;
        8)
            npx claude-flow@alpha hive-mind spawn \
                "Optimize Church-NextJS performance, implement advanced caching, enhance UI with modern animations" \
                --claude \
                --queen-type strategic \
                --max-workers 14 \
                --worker-types "nextjs,frontend,backend,performance,database,tester" \
                --memory-size 300
            ;;
        9)
            npx claude-flow@alpha hive-mind spawn \
                "Develop BLDB-Webapp with Laravel API and Vue.js frontend, implement Docker setup, create responsive design" \
                --claude \
                --queen-type adaptive \
                --max-workers 12 \
                --worker-types "laravel,vue,database,api,ui,tester"
            ;;
        10)
            npx claude-flow@alpha hive-mind spawn \
                "Build Anlass event management system from scratch with modern stack, Docker-first approach" \
                --claude \
                --queen-type strategic \
                --max-workers 14 \
                --worker-types "architect,frontend,backend,database,calendar,tester"
            ;;
        11)
            npx claude-flow@alpha hive-mind spawn \
                "Create ChurchTools search interface with API integration, implement caching, build responsive UI" \
                --claude \
                --queen-type tactical \
                --max-workers 8 \
                --worker-types "api,frontend,search,cache,tester"
            ;;
        12)
            npx claude-flow@alpha hive-mind spawn \
                "Enhance web-cloner-pro with 4K screenshot support, improve CSS extraction, add batch cloning mode" \
                --claude \
                --queen-type exploratory \
                --max-workers 10 \
                --worker-types "scraper,analyzer,frontend,automation,tester"
            ;;
        13)
            npx claude-flow@alpha hive-mind spawn \
                "Fix Claude-Flow MCP server and UI communication, improve tmux integration, enhance WebSocket stability" \
                --claude \
                --queen-type adaptive \
                --max-workers 8 \
                --worker-types "backend,websocket,ui,devops,tester"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            return 1
            ;;
    esac
}

function spawn_multi_project_swarm() {
    echo -e "${PURPLE}🌐 Multi-Project Operations${NC}"
    echo ""
    
    echo "  1) Full Environment Optimization"
    echo "  2) Security Audit (All Projects)"
    echo "  3) Performance Campaign"
    echo "  4) Docker Standardization"
    echo "  5) Custom Multi-Project"
    echo ""
    
    read -p "Select operation (1-5): " op_choice
    
    case "$op_choice" in
        1)
            npx claude-flow@alpha hive-mind spawn \
                "Analyze and optimize entire VS Code multi-project setup, implement consistent Docker patterns, create unified development workflow" \
                --claude \
                --queen-type strategic \
                --max-workers 20 \
                --worker-types "architect,devops,analyzer,docker,automation,documenter,tester" \
                --auto-scale \
                --memory-size 500
            ;;
        2)
            npx claude-flow@alpha hive-mind spawn \
                "Conduct comprehensive security audit across all projects, prioritize auth systems, create security report" \
                --claude \
                --queen-type exploratory \
                --max-workers 16 \
                --worker-types "security,pentester,analyst,auditor,documenter" \
                --consensus weighted
            ;;
        3)
            npx claude-flow@alpha hive-mind spawn \
                "Optimize performance across all web projects, implement caching strategies, reduce load times below 2s" \
                --claude \
                --queen-type tactical \
                --max-workers 18 \
                --worker-types "performance,frontend,backend,cache,database,tester" \
                --auto-scale
            ;;
        4)
            npx claude-flow@alpha hive-mind spawn \
                "Standardize Docker setup across all projects, create reusable templates, implement docker-compose best practices" \
                --claude \
                --queen-type strategic \
                --max-workers 12 \
                --worker-types "devops,docker,architect,automation,tester"
            ;;
        5)
            read -p "Enter custom multi-project objective: " custom_obj
            if [ -z "$custom_obj" ]; then
                echo -e "${RED}Objective required${NC}"
                return 1
            fi
            npx claude-flow@alpha hive-mind spawn \
                "$custom_obj" \
                --claude \
                --queen-type strategic \
                --max-workers 16 \
                --auto-scale
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            return 1
            ;;
    esac
}

function list_active_swarms() {
    echo -e "${BLUE}📋 Active Hive Mind Sessions${NC}"
    echo ""
    
    # Try to get sessions with error handling
    local sessions_output=$(timeout 10s npx claude-flow@alpha hive-mind sessions 2>&1)
    
    if [ $? -ne 0 ]; then
        # If command fails, try alternative approach
        echo -e "${YELLOW}Standard command failed, trying alternative...${NC}"
        
        # Check database directly if possible
        if [ -f ".hive-mind/hive.db" ]; then
            echo -e "${CYAN}Database info:${NC}"
            echo "  Size: $(du -h .hive-mind/hive.db | cut -f1)"
            echo "  Modified: $(stat -c %y .hive-mind/hive.db 2>/dev/null || stat -f %Sm .hive-mind/hive.db 2>/dev/null)"
            echo ""
        fi
        
        # Try to parse partial output
        echo "$sessions_output" | grep -E "(Session ID:|Status:|Objective:)" | head -20
    else
        echo "$sessions_output"
    fi
}

function show_hive_status() {
    echo -e "${BLUE}📊 Hive Mind Status${NC}"
    echo ""
    
    # Status
    timeout 10s npx claude-flow@alpha hive-mind status 2>&1 || echo -e "${YELLOW}Status command timed out${NC}"
    echo ""
    
    # Metrics
    echo -e "${BLUE}📈 Performance Metrics${NC}"
    timeout 10s npx claude-flow@alpha hive-mind metrics 2>&1 || echo -e "${YELLOW}Metrics not available${NC}"
}

function show_collective_memory() {
    echo -e "${BLUE}🧠 Collective Memory${NC}"
    echo ""
    
    timeout 10s npx claude-flow@alpha hive-mind memory 2>&1 || echo -e "${YELLOW}Memory not available${NC}"
}

function manage_swarm_session() {
    echo -e "${CYAN}🔧 Manage Swarm Session${NC}"
    echo ""
    
    # First list sessions
    list_active_swarms
    echo ""
    
    echo "Options:"
    echo "  1) Resume session (background)"
    echo "  2) Attach to session (interactive)"
    echo "  3) Stop session"
    echo "  4) Show consensus decisions"
    echo "  5) Back"
    echo ""
    
    read -p "Choice (1-5): " manage_choice
    
    case "$manage_choice" in
        1)
            read -p "Enter Session ID to resume: " session_id
            [ -n "$session_id" ] && npx claude-flow@alpha hive-mind resume "$session_id"
            ;;
        2)
            attach_to_swarm
            ;;
        3)
            read -p "Enter Session ID to stop: " session_id
            [ -n "$session_id" ] && npx claude-flow@alpha hive-mind stop "$session_id"
            ;;
        4)
            npx claude-flow@alpha hive-mind consensus
            ;;
        5)
            return
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
}

function attach_to_swarm() {
    # Use the standalone swarm-attach.sh script
    if [ -x "$SCRIPT_DIR/swarm-attach.sh" ]; then
        "$SCRIPT_DIR/swarm-attach.sh"
    else
        echo -e "${RED}❌ swarm-attach.sh not found or not executable!${NC}"
        echo ""
        echo "Please ensure swarm-attach.sh exists in: $SCRIPT_DIR"
        echo "Run: chmod +x $SCRIPT_DIR/swarm-attach.sh"
    fi
    local latest_session=$(ls -t .hive-mind/sessions/session-*.json 2>/dev/null | head -1)
    if [ -n "$latest_session" ]; then
        local session_id=$(basename "$latest_session" | sed 's/session-\(.*\)-auto-.*/\1/')
        echo -e "${YELLOW}1) Connect via Session ID:${NC}"
        echo "   Session: $session_id"
        echo "   Command: npx claude-flow@alpha hive-mind connect $session_id"
        echo ""
    fi
    
    # Method 2: Via WebSocket/UI
    if nc -z localhost 9000 2>/dev/null; then
        echo -e "${YELLOW}2) Connect via WebSocket (Port 9000 active):${NC}"
        echo "   Run: npx claude-flow@alpha hive-mind ui"
        echo "   Open: http://localhost:3008/console"
        echo ""
    fi
    
    # Method 3: Via reptyr (if available)
    if command -v reptyr &> /dev/null && [ -n "$main_pid" ]; then
        echo -e "${YELLOW}3) Attach to process terminal (requires sudo):${NC}"
        echo "   Command: sudo reptyr $main_pid"
        echo ""
    fi
    
    # Method 4: Create new tmux session
    echo -e "${YELLOW}4) Create monitoring session in tmux:${NC}"
    echo "   This will create a new tmux session to monitor the swarm"
    echo ""
    
    read -p "Select method (1-4) or 'cancel': " choice
    
    case "$choice" in
        1)
            if [ -n "$session_id" ]; then
                echo ""
                echo -e "${GREEN}Connecting to session $session_id...${NC}"
                echo "Note: This may take a moment to establish connection"
                echo ""
                # Try different connection commands
                npx claude-flow@alpha hive-mind connect "$session_id" || \
                npx claude-flow@alpha hive-mind attach "$session_id" || \
                npx claude-flow@alpha hive-mind resume "$session_id" --interactive --verbose
            else
                echo -e "${RED}No session ID found${NC}"
            fi
            ;;
        2)
            echo ""
            echo -e "${GREEN}Starting UI server...${NC}"
            echo "Opening browser at http://localhost:3008/console"
            npx claude-flow@alpha hive-mind ui
            ;;
        3)
            if [ -n "$main_pid" ]; then
                echo ""
                echo -e "${GREEN}Attaching to process $main_pid...${NC}"
                echo "This requires sudo permissions"
                sudo reptyr $main_pid
            else
                echo -e "${RED}No main PID found${NC}"
            fi
            ;;
        4)
            if [ -n "$main_pid" ]; then
                reconnect_to_swarm_monitor "$main_pid"
            else
                echo -e "${RED}No swarm process found to monitor${NC}"
            fi
            ;;
        *)
            echo -e "${BLUE}Cancelled${NC}"
            ;;
    esac
}

function reconnect_to_swarm_monitor() {
    local pid="$1"
    local session_name="swarm-monitor-$pid"
    
    echo ""
    echo -e "${GREEN}Creating tmux monitoring session...${NC}"
    
    # Kill old session if exists
    tmux kill-session -t "$session_name" 2>/dev/null
    
    # Create new tmux session
    tmux new-session -d -s "$session_name" -n "Monitor"
    
    # Window 1: Process monitoring
    tmux send-keys -t "$session_name:0" "echo 'Monitoring Swarm Process PID: $pid'" C-m
    tmux send-keys -t "$session_name:0" "echo ''" C-m
    tmux send-keys -t "$session_name:0" "# Tail any logs if available" C-m
    tmux send-keys -t "$session_name:0" "tail -f ~/.claude-flow/logs/*.log 2>/dev/null || echo 'No logs available'" C-m
    
    # Window 2: Try to connect
    tmux new-window -t "$session_name:1" -n "Connect"
    tmux send-keys -t "$session_name:1" "cd $SCRIPT_DIR" C-m
    
    # Try to find and connect to session
    local latest_session=$(ls -t .hive-mind/sessions/session-*.json 2>/dev/null | head -1)
    if [ -n "$latest_session" ]; then
        local session_id=$(basename "$latest_session" | sed 's/session-\(.*\)-auto-.*/\1/')
        tmux send-keys -t "$session_name:1" "echo 'Attempting to connect to session: $session_id'" C-m
        tmux send-keys -t "$session_name:1" "npx claude-flow@alpha hive-mind connect $session_id" C-m
    else
        tmux send-keys -t "$session_name:1" "echo 'Monitoring swarm activity...'" C-m
        tmux send-keys -t "$session_name:1" "watch -n 5 'ps aux | grep $pid | grep -v grep'" C-m
    fi
    
    echo ""
    echo -e "${GREEN}✅ tmux session created: $session_name${NC}"
    echo ""
    echo "Commands:"
    echo "  Attach:  tmux attach -t $session_name"
    echo "  Detach:  Ctrl+B, then D"
    echo "  Switch:  Ctrl+B, then 0-1"
    echo ""
    
    read -p "Attach now? (y/n): " attach_now
    if [ "$attach_now" = "y" ]; then
        tmux attach -t "$session_name"
    fi
}

function reconnect_to_swarm_tmux() {
    echo -e "${GREEN}🔗 Reconnect to Swarm in tmux${NC}"
    echo ""
    
    # List sessions first
    list_active_swarms
    echo ""
    
    read -p "Enter Session ID to reconnect: " session_id
    
    if [ -z "$session_id" ]; then
        echo -e "${RED}Session ID required${NC}"
        return 1
    fi
    
    # Create or reuse tmux session
    local tmux_session="swarm-$session_id"
    
    # Check if tmux session already exists
    if tmux has-session -t "$tmux_session" 2>/dev/null; then
        echo -e "${YELLOW}tmux session already exists, attaching...${NC}"
        tmux attach -t "$tmux_session"
    else
        echo -e "${GREEN}Creating new tmux session for swarm...${NC}"
        
        # Create new tmux session
        tmux new-session -d -s "$tmux_session" -n "Swarm-$session_id"
        
        # Send attach command
        tmux send-keys -t "$tmux_session:0" "cd $SCRIPT_DIR" C-m
        tmux send-keys -t "$tmux_session:0" "npx claude-flow@alpha hive-mind attach $session_id --interactive --verbose" C-m
        
        echo ""
        echo -e "${GREEN}✅ tmux session created: $tmux_session${NC}"
        echo ""
        echo "Commands:"
        echo "  Attach:  tmux attach -t $tmux_session"
        echo "  Detach:  Ctrl+B, then D"
        echo ""
        
        read -p "Attach now? (y/n): " attach_now
        if [ "$attach_now" = "y" ]; then
            tmux attach -t "$tmux_session"
        fi
    fi
}

# ============= QUICK ACTIONS =============

function quick_spawn_adaptive() {
    echo -e "${GREEN}🚀 Quick Spawn (Adaptive)${NC}"
    echo ""
    
    read -p "Objective: " objective
    [ -z "$objective" ] && return 1
    
    npx claude-flow@alpha hive-mind spawn "$objective" \
        --claude \
        --queen-type adaptive \
        --max-workers 10 \
        --auto-scale \
        --verbose
}

function quick_spawn_tactical() {
    echo -e "${GREEN}🚀 Quick Spawn (Tactical)${NC}"
    echo ""
    
    read -p "Quick task: " task
    [ -z "$task" ] && return 1
    
    npx claude-flow@alpha hive-mind spawn "$task" \
        --claude \
        --queen-type tactical \
        --max-workers 6 \
        --verbose
}

# ============= HELP & GUIDES =============

function show_queen_guide() {
    echo -e "${MAGENTA}👑 Queen Types Guide${NC}"
    echo ""
    echo -e "${CYAN}Strategic (Default):${NC}"
    echo "  • Long-term planning, systematic, thorough"
    echo "  • Best for: New projects, architecture, refactoring"
    echo "  • Workers: 12-20 recommended"
    echo ""
    echo -e "${CYAN}Adaptive:${NC}"
    echo "  • Flexible, learning, iterative"
    echo "  • Best for: MVPs, prototypes, unclear requirements"
    echo "  • Workers: 8-12 recommended"
    echo ""
    echo -e "${CYAN}Tactical:${NC}"
    echo "  • Short-term, action-oriented, efficient"
    echo "  • Best for: Bug fixes, small features, deadlines"
    echo "  • Workers: 4-8 recommended"
    echo ""
    echo -e "${CYAN}Exploratory:${NC}"
    echo "  • Research, creative, innovative"
    echo "  • Best for: Tech research, best practices, new frameworks"
    echo "  • Workers: 8-12 recommended"
}

function show_worker_guide() {
    echo -e "${MAGENTA}🐝 Worker Configuration Guide${NC}"
    echo ""
    echo -e "${CYAN}Worker Count Recommendations:${NC}"
    echo "  • Small task/bug fix: 4-6 workers"
    echo "  • Medium feature: 8-10 workers"
    echo "  • Large feature: 12-16 workers"
    echo "  • Full application: 16-20 workers"
    echo "  • Enterprise project: 20-24 workers"
    echo ""
    echo -e "${CYAN}Worker Type Examples:${NC}"
    echo "  • Frontend: frontend, ui, ux, designer"
    echo "  • Backend: backend, api, database, server"
    echo "  • Full Stack: architect, frontend, backend, database"
    echo "  • Testing: tester, qa, automation, security"
    echo "  • Research: researcher, analyst, documenter"
    echo "  • DevOps: devops, docker, ci/cd, infrastructure"
}

function show_tips() {
    echo -e "${MAGENTA}💡 Pro Tips${NC}"
    echo ""
    echo "1. Start with fewer workers and use --auto-scale"
    echo "2. Match queen type to your task urgency"
    echo "3. Always use --claude flag for Claude Code integration"
    echo "4. Use --verbose for detailed logging"
    echo "5. Increase memory for complex projects (--memory-size 500)"
    echo "6. Use weighted consensus for critical decisions"
    echo "7. Run in tmux/screen for long-running swarms"
}

# ============= SYSTEM MANAGEMENT =============

function system_cleanup() {
    echo -e "${RED}🧹 System Cleanup${NC}"
    echo ""
    
    echo "This will:"
    echo "  • Stop all active swarms"
    echo "  • Kill all claude-flow processes"
    echo "  • Clean temporary files"
    echo "  • Reset database (optional)"
    echo ""
    
    read -p "Continue? (yes/no): " confirm
    [ "$confirm" != "yes" ] && return 1
    
    # Stop all swarms
    echo -e "${YELLOW}Stopping all swarms...${NC}"
    local sessions=$(timeout 5s npx claude-flow@alpha hive-mind sessions 2>&1 | grep -oP 'Session ID:\s*\K[a-z0-9-]+' || true)
    
    if [ -n "$sessions" ]; then
        echo "$sessions" | while read -r session; do
            echo "Stopping $session..."
            timeout 10s npx claude-flow@alpha hive-mind stop "$session" 2>&1 || true
        done
    fi
    
    # Kill processes
    echo -e "${YELLOW}Killing processes...${NC}"
    pkill -f "claude-flow" || true
    sleep 2
    pkill -9 -f "claude-flow" || true
    
    # Clean temp files
    echo -e "${YELLOW}Cleaning temporary files...${NC}"
    rm -rf .claude-flow/temp/* 2>/dev/null
    rm -rf /tmp/claude-flow-* 2>/dev/null
    rm -f nohup.out swarm-spawn.log 2>/dev/null
    
    # Ask about database
    read -p "Reset database? (y/n): " reset_db
    if [ "$reset_db" = "y" ]; then
        rm -rf .hive-mind/*.db* 2>/dev/null
        echo -e "${GREEN}Database reset${NC}"
    fi
    
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

function check_system_health() {
    echo -e "${CYAN}🏥 System Health Check${NC}"
    echo ""
    
    # Node/NPM
    echo -e "${BLUE}Node.js Environment:${NC}"
    echo "  Node: $(node --version 2>/dev/null || echo 'Not found')"
    echo "  NPM: $(npm --version 2>/dev/null || echo 'Not found')"
    echo "  NPX: $(which npx 2>/dev/null || echo 'Not found')"
    echo ""
    
    # Claude-Flow
    echo -e "${BLUE}Claude-Flow:${NC}"
    local cf_version=$(timeout 5s npx claude-flow@alpha --version 2>&1 || echo "Check failed")
    echo "  Version: $cf_version"
    echo ""
    
    # Processes
    echo -e "${BLUE}Running Processes:${NC}"
    local proc_count=$(pgrep -f "claude-flow" | wc -l)
    echo "  Claude-Flow processes: $proc_count"
    
    if [ $proc_count -gt 0 ]; then
        echo -e "${YELLOW}  Warning: Processes running may interfere with new swarms${NC}"
    fi
    echo ""
    
    # Database
    echo -e "${BLUE}Database:${NC}"
    if [ -f ".hive-mind/hive.db" ]; then
        echo "  ✓ Database exists ($(du -h .hive-mind/hive.db | cut -f1))"
    else
        echo "  ✗ No database found"
    fi
    
    # Disk space
    echo ""
    echo -e "${BLUE}Disk Space:${NC}"
    df -h . | tail -1
}

# ============= MAIN MENU =============

function main_menu() {
    while true; do
        show_banner
        
        # Quick status
        local proc_count=$(pgrep -f "claude-flow" | wc -l)
        if [ $proc_count -gt 0 ]; then
            echo -e "${YELLOW}⚠  Active processes: $proc_count${NC}"
        else
            echo -e "${GREEN}✓ System ready${NC}"
        fi
        echo ""
        
        echo -e "${GREEN}━━━ Quick Actions ━━━${NC}"
        echo "  1) Quick Spawn (Adaptive)"
        echo "  2) Quick Spawn (Tactical)"
        echo ""
        
        echo -e "${PURPLE}━━━ Swarm Operations ━━━${NC}"
        echo "  3) Custom Swarm Configuration"
        echo "  4) Project-Specific Templates"
        echo "  5) Multi-Project Operations"
        echo ""
        
        echo -e "${BLUE}━━━ Management ━━━${NC}"
        echo "  6) List Active Swarms"
        echo "  7) Show Hive Status & Metrics"
        echo "  8) Show Collective Memory"
        echo "  9) Manage Sessions (Resume/Stop)"
        echo " 10) Attach to Running Swarm (Interactive)"
        echo " 11) Reconnect via tmux"
        echo ""
        
        echo -e "${MAGENTA}━━━ Help & Guides ━━━${NC}"
        echo " 12) Queen Types Guide"
        echo " 13) Worker Configuration Guide"
        echo " 14) Pro Tips"
        echo ""
        
        echo -e "${CYAN}━━━ System ━━━${NC}"
        echo " 15) System Health Check"
        echo " 16) System Cleanup"
        echo " 17) Exit"
        echo ""
        
        read -p "Select option (1-17): " choice
        echo ""
        
        case $choice in
            1) quick_spawn_adaptive ;;
            2) quick_spawn_tactical ;;
            3) spawn_custom_swarm ;;
            4) spawn_project_swarm ;;
            5) spawn_multi_project_swarm ;;
            6) list_active_swarms ;;
            7) show_hive_status ;;
            8) show_collective_memory ;;
            9) manage_swarm_session ;;
            10) attach_to_swarm ;;
            11) reconnect_to_swarm_tmux ;;
            12) show_queen_guide ;;
            13) show_worker_guide ;;
            14) show_tips ;;
            15) check_system_health ;;
            16) system_cleanup ;;
            17)
                echo -e "${GREEN}👋 Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${BLUE}Press any key to continue...${NC}"
        read -n 1
    done
}

# ============= STARTUP =============

# Check prerequisites
check_prerequisites

# Check for command line arguments
if [ $# -gt 0 ]; then
    case "$1" in
        --help|-h)
            echo "Claude-Suite Manager v${VERSION}"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h     Show this help"
            echo "  --quick        Quick spawn (adaptive)"
            echo "  --tactical     Quick spawn (tactical)"
            echo "  --status       Show system status and exit"
            echo "  --cleanup      Run system cleanup"
            echo ""
            echo "Without options, starts interactive menu"
            exit 0
            ;;
        --quick)
            quick_spawn_adaptive
            exit $?
            ;;
        --tactical)
            quick_spawn_tactical
            exit $?
            ;;
        --status)
            check_system_health
            exit 0
            ;;
        --cleanup)
            system_cleanup
            exit $?
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
fi

# Start interactive menu
main_menu
main_menu