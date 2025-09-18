#!/bin/bash
set -e

# Get arguments
SPEC_DIR="${1:-/app/spec}"
INST_DIR="${2:-/app/inst}"

echo "Caffeine Language Smoke Test"
echo "============================="

# Change to caffeine project directory
cd /caffeine

# Show Caffeine version
echo "Caffeine version info:"
gleam deps list | grep caffeine_lang || echo "caffeine_lang package not found"
echo ""

# Create test directories matching the working structure
SPEC_SUBDIR="$SPEC_DIR"
INST_SUBDIR="$INST_DIR"

# Run Caffeine compiler with spec and inst directories
echo ""
echo "Running Caffeine compiler..."
if gleam run -- compile "$SPEC_SUBDIR" "$INST_SUBDIR"; then
    echo ""
    echo "✅ Caffeine compiler smoke test PASSED!"
    echo "Caffeine language is working correctly."
    exit 0
else
    echo ""
    echo "❌ Caffeine compiler smoke test FAILED!"
    exit 1
fi
