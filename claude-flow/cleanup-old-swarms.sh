#!/bin/bash

echo "🧹 Cleaning up old Hive Mind sessions..."

# List of old session IDs to stop
OLD_SESSIONS=(
    "session-1753946764986-3gd2z1xgz"  # General task coordination
    "session-1753632880037-xco2cjiwl"  # WSL analysis
    "session-1753630935178-lk0cefxvi"  # AI research
    "session-1753630711954-eau0yai9o"  # Dev workflow
    "session-1753630523978-v77lwv7lp"  # Local env analysis
    "session-1753629569173-x37p6t9ey"  # Multi-project coordination
)

# Keep the newest one (Fix MCP communication)
echo "✅ Keeping: session-1753946915137-b5yqfmbsj (Fix MCP communication)"

# Stop each old session
for session in "${OLD_SESSIONS[@]}"; do
    echo "🛑 Stopping: $session"
    npx claude-flow@alpha hive-mind stop "$session"
    sleep 1
done

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "🔍 Remaining sessions:"
npx claude-flow@alpha hive-mind sessions