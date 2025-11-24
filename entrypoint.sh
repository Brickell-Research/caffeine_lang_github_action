#!/bin/bash
set -e

# Get arguments (now relative paths from repository)
SPEC_DIR="${1:-spec}"
INST_DIR="${2:-inst}"
OUTPUT_DIR="${3:-out}"

echo "Caffeine Language Compiler"
echo "=========================="

# The repository files are mounted at /github/workspace
WORKSPACE="/github/workspace"

# Convert relative paths to absolute paths within the workspace
SPEC_PATH="$WORKSPACE/$SPEC_DIR"
INST_PATH="$WORKSPACE/$INST_DIR"
OUTPUT_PATH="$WORKSPACE/$OUTPUT_DIR"

echo "Specification directory: $SPEC_PATH"
echo "Instantiation directory: $INST_PATH"
echo "Output directory: $OUTPUT_PATH"

# Check if directories exist
if [ ! -d "$SPEC_PATH" ]; then
    echo "Error: Specification directory not found: $SPEC_PATH"
    exit 1
fi

if [ ! -d "$INST_PATH" ]; then
    echo "Error: Instantiation directory not found: $INST_PATH"
    exit 1
fi

echo "Found both directories"
echo ""

# Show Caffeine version
echo "Caffeine version:"
caffeine --help | head -1 || echo "caffeine binary not found"
echo ""

# Run Caffeine compiler with the repository directories
echo "Running Caffeine compiler..."
if caffeine compile "$SPEC_PATH" "$INST_PATH" "$OUTPUT_PATH"; then
    echo ""
    echo "Caffeine compilation SUCCESSFUL!"
    echo "Your Caffeine specifications have been compiled successfully."
    exit 0
else
    echo ""
    echo "Caffeine compilation FAILED!"
    echo "Check your specification and instantiation files for errors."
    exit 1
fi
