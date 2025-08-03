# 🚀 Claude-Flow VPS Commands Guide

**Location**: `/var/www/claude-suite-local`  
**Version**: Claude-Flow v2.0.0-alpha.83  
**Created**: 2025-08-03

## ✅ **NEW FUNCTIONAL SCRIPTS**

### **Main Management Script**
```bash
/var/www/claude-suite-local/scripts/claude-flow-vps.sh
```

### **Quick Wrapper**
```bash
/var/www/claude-suite-local/scripts/cf
```

### **Project-Specific Launchers**
```bash
/var/www/claude-suite-local/scripts/spawn-church.sh
/var/www/claude-suite-local/scripts/spawn-bldb.sh
/var/www/claude-suite-local/scripts/quick-spawn.sh
```

## 📋 **COMMAND REFERENCE**

### **1. System Management**

#### **Initialize Hive Mind (REQUIRED FIRST)**
```bash
./scripts/cf init
```

#### **Check System Health**
```bash
./scripts/cf health
# Shows: Node.js, NPM, Claude-Flow version, Database status, Active processes
```

#### **System Status**
```bash
./scripts/cf status
```

#### **List All Sessions**
```bash
./scripts/cf sessions
# Alternative: ./scripts/cf list
```

#### **Clean Up All Processes**
```bash
./scripts/cf cleanup
# Alternative: ./scripts/cf clean
```

### **2. Spawning Swarms**

#### **Basic Spawn**
```bash
./scripts/cf spawn "Your objective here"
# Default: 8 workers, strategic queen, 100MB memory
```

#### **Spawn with Options**
```bash
./scripts/cf spawn "Complex task" -w 12 -q strategic -a -v
# -w: workers (2-20)
# -q: queen type (strategic|tactical|adaptive)
# -a: auto-scale
# -v: verbose
# -m: memory in MB
```

#### **Quick Fix (Tactical, 4 workers)**
```bash
./scripts/cf quick-fix "Fix authentication bug"
# Alternative: ./scripts/cf fix "description"
```

#### **Analysis (Strategic, 10 workers)**
```bash
./scripts/cf analyze "Analyze performance bottlenecks"
```

#### **Test Spawn (Minimal, 2 workers)**
```bash
./scripts/cf test "Test basic functionality"
# Uses only 2 workers, 50MB memory
```

### **3. Project-Specific Commands**

#### **Using Project Presets**
```bash
./scripts/cf project church-nextjs "Add member registration"
./scripts/cf project bldb-webapp "Fix email system"
./scripts/cf project standorte "Add new location feature"
```

#### **Direct Project Scripts**
```bash
# Church-NextJS (14 workers, strategic)
./scripts/spawn-church.sh "Add notification system"

# BLDB-Webapp (12 workers, strategic)
./scripts/spawn-bldb.sh "Optimize database queries"
```

### **4. Session Management**

#### **Resume Session**
```bash
./scripts/cf resume session-1234567890-abcdef
```

#### **Stop Session**
```bash
./scripts/cf stop session-1234567890-abcdef
# Alternative: ./scripts/cf kill session-id
```

### **5. Advanced Features**

#### **Batch Spawning**
```bash
# Create batch file
cat > batch.txt << EOF
8:strategic:100:Build user authentication system
6:tactical:80:Fix navigation bug
10:adaptive:150:Analyze and optimize performance
EOF

# Run batch
./scripts/cf batch batch.txt
```

#### **Monitor Mode**
```bash
./scripts/cf monitor
# Live updating display (Ctrl+C to exit)
```

### **6. Interactive Quick Spawn**
```bash
./scripts/quick-spawn.sh
# Interactive prompts for objective and speed
```

## 🎯 **QUICK REFERENCE**

### **Most Common Commands**
```bash
# Initialize (once)
./scripts/cf init

# Check health
./scripts/cf health

# List sessions
./scripts/cf sessions

# Quick spawn
./scripts/cf spawn "Build feature X"

# Project spawn
./scripts/cf project church-nextjs "Add feature Y"

# Stop session
./scripts/cf stop SESSION-ID

# Cleanup
./scripts/cf cleanup
```

### **VPS Project Configurations**
| Project | Workers | Queen | Memory |
|---------|---------|--------|---------|
| church-nextjs | 14 | strategic | 200MB |
| bldb-webapp | 12 | strategic | 150MB |
| standorte | 10 | adaptive | 120MB |
| anlass | 14 | strategic | 180MB |
| doc-generator | 10 | adaptive | 150MB |
| in-or-out | 8 | adaptive | 100MB |
| divine-words | 8 | tactical | 100MB |
| shepherds-helper | 10 | strategic | 120MB |

### **Queen Types**
- **strategic**: Long-term planning, complex projects
- **tactical**: Quick fixes, immediate action
- **adaptive**: Flexible, learning, experimental

### **Worker Recommendations**
- Small bug fix: 2-4 workers
- Feature development: 6-10 workers
- Large feature: 10-14 workers
- System refactoring: 14-20 workers

## 🚨 **TROUBLESHOOTING**

### **Database Error**
```bash
# If you see "Error: no such table"
./scripts/cf init
```

### **Check Running Processes**
```bash
ps aux | grep claude-flow
```

### **Force Kill All**
```bash
./scripts/cf cleanup
# or manually:
pkill -9 -f claude-flow
```

### **Session Won't Resume**
```bash
# Check if session exists
./scripts/cf sessions

# Try verbose mode
npx claude-flow@alpha hive-mind resume SESSION-ID --verbose
```

## 💡 **BEST PRACTICES**

### **1. Always Initialize First**
```bash
cd /var/www/claude-suite-local
./scripts/cf init
```

### **2. Use Appropriate Worker Counts**
- VPS-friendly: 4-12 workers
- Avoid >14 workers unless necessary

### **3. Choose Right Queen Type**
- Bug fixes → tactical
- Features → strategic
- Experiments → adaptive

### **4. Monitor Active Sessions**
```bash
# Regular checks
./scripts/cf sessions

# Clean up old sessions
./scripts/cf stop OLD-SESSION-ID
```

### **5. Use Project Presets**
```bash
# Better than manual configuration
./scripts/cf project bldb-webapp "objective"
```

## 📊 **EXAMPLE WORKFLOWS**

### **Quick Bug Fix**
```bash
./scripts/cf quick-fix "Fix login timeout bug in bldb-webapp"
```

### **Feature Development**
```bash
./scripts/cf project church-nextjs "Implement member directory with search"
```

### **System Analysis**
```bash
./scripts/cf analyze "Analyze standorte multi-domain architecture"
```

### **Batch Operations**
```bash
# Morning tasks
cat > morning-tasks.txt << EOF
4:tactical:50:Fix navigation bug in church-nextjs
6:tactical:80:Update email templates in bldb-webapp
8:strategic:100:Plan Phase 5 features for church-nextjs
EOF

./scripts/cf batch morning-tasks.txt
```

## 🔧 **ADVANCED USAGE**

### **Custom Spawn with All Options**
```bash
./scripts/cf spawn "Complex refactoring of authentication system" \
  --workers 12 \
  --queen strategic \
  --memory 200 \
  --auto-scale \
  --verbose
```

### **Monitor and Manage**
```bash
# Terminal 1: Monitor
./scripts/cf monitor

# Terminal 2: Work
./scripts/cf spawn "Build feature"
```

---

**Pro Tip**: Add to your `.bashrc`:
```bash
alias cf="/var/www/claude-suite-local/scripts/cf"
alias cfs="/var/www/claude-suite-local/scripts/cf sessions"
alias cfh="/var/www/claude-suite-local/scripts/cf health"
```

Then use from anywhere:
```bash
cf spawn "Build awesome feature"
cfs  # list sessions
cfh  # check health
```