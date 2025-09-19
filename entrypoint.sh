#!/bin/bash
set -e

# Get arguments (now relative paths from repository)
SPEC_DIR="${1:-spec}"
INST_DIR="${2:-inst}"

echo "Caffeine Language Compiler"
echo "=========================="

# The repository files are mounted at /github/workspace
WORKSPACE="/github/workspace"

# Convert relative paths to absolute paths within the workspace
SPEC_PATH="$WORKSPACE/$SPEC_DIR"
INST_PATH="$WORKSPACE/$INST_DIR"

echo "Specification directory: $SPEC_PATH"
echo "Instantiation directory: $INST_PATH"

# Check if directories exist
if [ ! -d "$SPEC_PATH" ]; then
    echo "❌ Specification directory not found: $SPEC_PATH"
    exit 1
fi

if [ ! -d "$INST_PATH" ]; then
    echo "❌ Instantiation directory not found: $INST_PATH"
    exit 1
fi

echo "✅ Found both directories"
echo ""

# Change to caffeine project directory for compilation
cd /caffeine

# Show Caffeine version
echo "Caffeine version info:"
gleam deps list | grep caffeine_lang || echo "caffeine_lang package not found"
echo ""

# Run Caffeine compiler with the repository directories
echo "Running Caffeine compiler..."
if gleam run -- compile "$SPEC_PATH" "$INST_PATH"; then
    echo ""
    echo "✅ Caffeine compilation SUCCESSFUL!"
    echo "Your Caffeine specifications have been compiled successfully."
    exit 0
else
    echo ""
    echo "❌ Caffeine compilation FAILED!"
    echo "Check your specification and instantiation files for errors."
    exit 1
fi
