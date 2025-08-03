#!/bin/bash
# Quick spawn for church-nextjs project

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

if [ -z "$1" ]; then
    echo "Usage: $0 \"objective for church-nextjs\""
    echo ""
    echo "Examples:"
    echo "  $0 \"Add member registration feature\""
    echo "  $0 \"Fix navigation bug on mobile\""
    echo "  $0 \"Improve performance of member list\""
    exit 1
fi

# Use church-nextjs preset (14 workers, strategic)
./claude-flow-vps.sh project church-nextjs "$1"