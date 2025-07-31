#!/bin/bash

# AI Workflow Automation Script for Claude
# Compatible with SuperClaude v3.2 and all configured agents/personas

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Show usage
usage() {
    cat << EOF
Usage: $(basename "$0") <task> [target]

Tasks:
  analyze    - Deep code analysis with Sequential MCP
  build      - Build components with Magic MCP
  improve    - Performance optimization
  test       - Comprehensive testing with Playwright
  security   - Security audit and validation
  deploy     - Safe deployment with validation
  
Target: File, directory, or project path (default: current directory)

Examples:
  $(basename "$0") analyze src/
  $(basename "$0") build "user authentication"
  $(basename "$0") test
  $(basename "$0") security --comprehensive
EOF
}

# Check for Claude CLI
if ! command_exists claude; then
    print_error "Claude CLI not found! Please install it."
    print_info "Visit: https://claude.ai/download"
    exit 1
fi

# Parse arguments
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

task="$1"
target="${2:-.}"

# Main workflow
print_header "🤖 AI Workflow: $task"
print_info "Target: $target"

# Run AI analysis based on task
case $task in
    "analyze")
        print_info "Running deep analysis with Sequential thinking..."
        claude analyze "$target" --think --all-mcp
        ;;
    "build")
        print_info "Building with Magic UI generation..."
        claude build "$target" --magic --context7 --uc
        ;;
    "improve")
        print_info "Optimizing performance..."
        claude improve "$target" --focus performance --think
        ;;
    "test")
        print_info "Running comprehensive tests..."
        claude test --playwright --comprehensive
        ;;
    "security")
        print_info "Performing security audit..."
        claude scan "$target" --security --validate
        ;;
    "deploy")
        print_info "Deploying with validation..."
        claude deploy --validate --safe-mode
        ;;
    *)
        print_info "Running custom command: $task"
        claude "$task" "$target" --think
        ;;
esac

# Post-analysis actions
if [ $? -eq 0 ]; then
    print_success "AI workflow completed successfully!"
    
    # Optional: Show summary if available
    if [ -f ".claude/last-analysis.md" ]; then
        print_info "Analysis summary available at: .claude/last-analysis.md"
    fi
else
    print_error "AI workflow failed. Check the output above for details."
    exit 1
fi

# Optional: Git integration
if command_exists git && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if [ "$task" == "improve" ] || [ "$task" == "build" ]; then
        print_info "Git status:"
        git status --short
    fi
fi

print_header "✨ Workflow Complete!"