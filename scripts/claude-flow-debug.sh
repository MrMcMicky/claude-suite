#!/bin/bash

# Claude-Flow Debug & Test Script
# Testet verschiedene Commands und zeigt was funktioniert

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    Claude-Flow Debug & Test            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Test 1: Check installation
echo -e "${YELLOW}1. Checking claude-flow installation...${NC}"
if npx claude-flow@alpha --version 2>/dev/null; then
    echo -e "${GREEN}✓ Claude-flow is installed${NC}"
else
    echo -e "${RED}✗ Claude-flow not properly installed${NC}"
fi
echo ""

# Test 2: Check for running processes
echo -e "${YELLOW}2. Checking for running processes...${NC}"
PROCS=$(pgrep -f "claude-flow" | wc -l)
echo "Found $PROCS claude-flow process(es)"
if [ $PROCS -gt 0 ]; then
    echo -e "${YELLOW}Process details:${NC}"
    ps aux | grep -E "claude-flow" | grep -v grep | head -5
fi
echo ""

# Test 3: Check database
echo -e "${YELLOW}3. Checking database...${NC}"
if [ -f ".hive-mind/hive.db" ]; then
    echo -e "${GREEN}✓ Database exists${NC}"
    echo "Size: $(du -h .hive-mind/hive.db | cut -f1)"
    
    # Try to query database directly
    if command -v sqlite3 &> /dev/null; then
        echo ""
        echo "Sessions in database:"
        sqlite3 .hive-mind/hive.db "SELECT id, status, objective FROM sessions;" 2>/dev/null | head -10
    fi
else
    echo -e "${RED}✗ No database found${NC}"
fi
echo ""

# Test 4: Try different commands with error handling
echo -e "${YELLOW}4. Testing commands...${NC}"

test_command() {
    local cmd="$1"
    local desc="$2"
    echo -n "Testing: $desc... "
    
    # Run with timeout and capture both stdout and stderr
    if timeout 5s bash -c "$cmd" &>/dev/null; then
        echo -e "${GREEN}✓ Works${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed/Timeout${NC}"
        return 1
    fi
}

test_command "npx claude-flow@alpha --help" "Help command"
test_command "npx claude-flow@alpha hive-mind --help" "Hive-mind help"

echo ""

# Test 5: Alternative session listing
echo -e "${YELLOW}5. Alternative session check...${NC}"

# Try to get session IDs from the error output
echo "Attempting to parse active sessions..."

# Create a wrapper script to capture partial output
cat > /tmp/get-sessions.sh << 'EOF'
#!/bin/bash
(
    timeout 3s npx claude-flow@alpha hive-mind sessions 2>&1 | 
    grep -E "(Session ID:|Status:|Objective:)" | 
    head -20
) || true
EOF

chmod +x /tmp/get-sessions.sh
bash /tmp/get-sessions.sh
rm -f /tmp/get-sessions.sh

echo ""

# Test 6: Direct database query for sessions
echo -e "${YELLOW}6. Direct database query (if sqlite3 available)...${NC}"
if command -v sqlite3 &> /dev/null && [ -f ".hive-mind/hive.db" ]; then
    echo "Active sessions from database:"
    sqlite3 .hive-mind/hive.db << 'SQL'
.mode column
.headers on
SELECT 
    substr(id, 1, 20) as session_id,
    status,
    substr(objective, 1, 40) as objective,
    datetime(created_at/1000, 'unixepoch', 'localtime') as created
FROM sessions
WHERE status = 'active'
LIMIT 10;
SQL
else
    echo "sqlite3 not available or database not found"
fi

echo ""
echo -e "${BLUE}Debug complete. Check output above for issues.${NC}"