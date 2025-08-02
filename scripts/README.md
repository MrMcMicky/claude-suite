# Claude-Suite Scripts

This directory contains all management scripts for the Claude-Flow Hive Mind system.

## 🚀 Main Script

### **claude-suite-manager.sh** (RECOMMENDED)
The comprehensive management tool with all features from the Claude-Suite documentation.

```bash
cd ~/claude-development/local-development-hub/
./claude-suite-manager.sh
```

**Key Features:**
- ✅ Quick Spawn (Adaptive/Tactical)
- ✅ Custom Swarm Configuration
- ✅ Project-Specific Templates (13 Projects)
- ✅ Multi-Project Operations
- ✅ Queen Types & Worker Guides
- ✅ System Health Check & Cleanup
- 🆕 **Attach to Running Swarms** (Interactive mode)
- 🆕 **Reconnect via tmux** (After closing console)

**Command-line Options:**
```bash
./claude-suite-manager.sh --help      # Show help
./claude-suite-manager.sh --quick     # Quick Spawn (Adaptive)
./claude-suite-manager.sh --tactical  # Quick Spawn (Tactical)
./claude-suite-manager.sh --status    # System Status
./claude-suite-manager.sh --cleanup   # System Cleanup
```

## 🔗 Reconnect to Running Swarms

After closing your console, you can reconnect to running swarms:

**Method 1: Via Manager Script**
```bash
./claude-suite-manager.sh
# Choose: 10) Attach to Running Swarm (Interactive)
# or:     11) Reconnect via tmux
```

**Method 2: Direct Commands**
```bash
# Attach interactively
npx claude-flow@alpha hive-mind attach [session-id] --interactive

# Resume with verbose output
npx claude-flow@alpha hive-mind resume [session-id] --interactive --verbose
```

**Method 3: tmux Sessions**
```bash
# Start in tmux (recommended for long tasks)
tmux new -s swarm-work
./claude-suite-manager.sh  # Spawn your swarm
# Ctrl+B, then D to detach

# Later, reattach
tmux attach -t swarm-work
```

## 📁 Other Scripts

### **claude-flow-fixed.sh**
Robust script focusing on process management and error handling.
- Force kill functions
- Background spawning
- Process control

### **claude-flow-simple.sh**
Simple script for direct commands without tmux.
- Direct command execution
- No tmux dependency
- Quick operations

### **claude-flow-manager-v2.sh**
Improved management tool with corrected commands.
- Timeouts for all commands
- Better error handling

### **claude-flow-debug.sh**
Debug tool for testing installation and troubleshooting.

## 📋 Quick Start

1. **Check System Status:**
   ```bash
   ./claude-suite-manager.sh --status
   ```

2. **Quick Spawn a Swarm:**
   ```bash
   ./claude-suite-manager.sh --quick
   # Enter your objective when prompted
   ```

3. **Project-Specific Spawn:**
   ```bash
   ./claude-suite-manager.sh
   # Choose: 4) Project-Specific Templates
   # Select your project
   ```

4. **Reconnect to Running Swarm:**
   ```bash
   ./claude-suite-manager.sh
   # Choose: 10) Attach to Running Swarm
   ```

## 🐛 Troubleshooting

If commands hang:
1. Kill all processes: `./claude-suite-manager.sh` → 16) System Cleanup
2. Check status: `./claude-suite-manager.sh --status`
3. Try again

For more details, see `/docs/CLAUDE_FLOW_QUICK_REFERENCE.md`