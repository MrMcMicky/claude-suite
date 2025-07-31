#!/bin/bash

# Claude-Flow tmux Session Manager
# Erstellt persistente tmux Sessions für Hive Mind

SESSION_NAME="claude-flow"
HUB_DIR="$HOME/claude-development/local-development-hub"

echo "🚀 Starting Claude-Flow in tmux..."

# Kill alte Session falls vorhanden
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? == 0 ]; then
    echo "⚠️  Alte Session gefunden. Stoppe sie..."
    tmux kill-session -t $SESSION_NAME
    sleep 2
fi

# Erstelle neue tmux Session
echo "📺 Erstelle neue tmux Session: $SESSION_NAME"
tmux new-session -d -s $SESSION_NAME -n "MCP-Server" -c $HUB_DIR

# Window 0: MCP Server
tmux send-keys -t $SESSION_NAME:0 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:0 "echo '📡 Starting MCP Server...'" C-m
tmux send-keys -t $SESSION_NAME:0 "npx claude-flow@alpha mcp start" C-m

# Window 1: UI + Orchestrator
tmux new-window -t $SESSION_NAME:1 -n "UI-Orchestrator" -c $HUB_DIR
tmux send-keys -t $SESSION_NAME:1 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:1 "echo '🌐 Starting UI + Orchestrator...'" C-m
tmux send-keys -t $SESSION_NAME:1 "sleep 5" C-m  # Warte auf MCP
tmux send-keys -t $SESSION_NAME:1 "npx claude-flow@alpha start --ui --swarm --port 3008" C-m

# Window 2: Control Terminal
tmux new-window -t $SESSION_NAME:2 -n "Control" -c $HUB_DIR
tmux send-keys -t $SESSION_NAME:2 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '🎮 Control Terminal Ready!'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '📋 Useful commands:'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '  npx claude-flow@alpha hive-mind status'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '  npx claude-flow@alpha hive-mind spawn \"Your objective\" --claude'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo '  npx claude-flow@alpha hive-mind sessions'" C-m
tmux send-keys -t $SESSION_NAME:2 "echo ''" C-m
tmux send-keys -t $SESSION_NAME:2 "sleep 10 && npx claude-flow@alpha status" C-m

# Window 3: Logs Monitoring
tmux new-window -t $SESSION_NAME:3 -n "Logs" -c $HUB_DIR
tmux send-keys -t $SESSION_NAME:3 "cd $HUB_DIR" C-m
tmux send-keys -t $SESSION_NAME:3 "echo '📊 Log Monitoring'" C-m
tmux send-keys -t $SESSION_NAME:3 "# tail -f mcp.log ui.log (wenn Logs verfügbar)" C-m

echo ""
echo "✅ Claude-Flow tmux Session gestartet!"
echo ""
echo "🔧 tmux Befehle:"
echo "  Attach:     tmux attach -t $SESSION_NAME"
echo "  Detach:     Ctrl+B, dann D"
echo "  Wechseln:   Ctrl+B, dann 0-3"
echo "  Liste:      tmux ls"
echo ""
echo "📺 Windows:"
echo "  0: MCP-Server"
echo "  1: UI-Orchestrator"
echo "  2: Control (für Befehle)"
echo "  3: Logs"
echo ""
echo "🌐 UI erreichbar unter: http://localhost:3008/console"

# Optional: Direkt attachen
read -p "🎯 Möchtest du dich direkt verbinden? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    tmux attach -t $SESSION_NAME
fi