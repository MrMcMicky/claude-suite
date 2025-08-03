#!/bin/bash
# Quick spawn for bldb-webapp project

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

if [ -z "$1" ]; then
    echo "Usage: $0 \"objective for bldb-webapp\""
    echo ""
    echo "Examples:"
    echo "  $0 \"Add email notification feature\""
    echo "  $0 \"Fix authentication timeout bug\""
    echo "  $0 \"Optimize database queries\""
    exit 1
fi

# Use bldb-webapp preset (12 workers, strategic)
./claude-flow-vps.sh project bldb-webapp "$1"