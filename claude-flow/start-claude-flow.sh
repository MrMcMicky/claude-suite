#!/bin/bash

# Claude-Flow Local Development Hub Starter
echo "🚀 Starting Claude-Flow Local Development Hub..."

# Kill any existing processes
echo "🔧 Cleaning up old processes..."
pkill -f claude-flow 2>/dev/null || true
sleep 2

# Change to the hub directory
cd ~/claude-development/local-development-hub

# Start MCP Server in HTTP mode (background)
echo "📡 Starting MCP Server on port 9000..."
npx claude-flow@alpha mcp start --mode http --port 9000 > mcp.log 2>&1 &
MCP_PID=$!
echo "   MCP Server PID: $MCP_PID"

# Wait for MCP to start
sleep 3

# Start Orchestrator + UI
echo "🌐 Starting UI + Orchestrator on port 3008..."
npx claude-flow@alpha start --ui --swarm --port 3008 --mcp-endpoint http://localhost:9000 > ui.log 2>&1 &
UI_PID=$!
echo "   UI PID: $UI_PID"

# Wait for services to start
sleep 3

# Check status
echo ""
echo "🔍 Checking status..."
npx claude-flow@alpha status

echo ""
echo "✅ Services should be running!"
echo "🌐 Open http://localhost:3008/console in your browser"
echo ""
echo "📋 To stop all services, run: pkill -f claude-flow"
echo "📊 Logs: mcp.log (MCP Server) and ui.log (UI)"