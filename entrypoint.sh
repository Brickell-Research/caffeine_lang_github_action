#!/bin/bash
set -e

echo "Caffeine Language Smoke Test"
echo "============================="

# Change to caffeine project directory
cd /caffeine

# Run Caffeine compiler smoke test
echo ""
echo "Running Caffeine compiler..."
if gleam run compile; then
    echo ""
    echo "✅ Caffeine compiler smoke test PASSED!"
    echo "Caffeine language is working correctly."
    exit 0
else
    echo ""
    echo "❌ Caffeine compiler smoke test FAILED!"
    exit 1
fi
