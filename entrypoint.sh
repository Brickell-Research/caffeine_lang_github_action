#!/bin/bash
set -e

# Get arguments
BLUEPRINT_FILE="${1:-blueprints.json}"
EXPECTATIONS_DIR="${2:-expectations}"
OUTPUT_PATH="${3:-output}"

echo "Caffeine Language Compiler"
echo "=========================="

# The repository files are mounted at /github/workspace
WORKSPACE="/github/workspace"

# Convert relative paths to absolute paths within the workspace
BLUEPRINT_PATH="$WORKSPACE/$BLUEPRINT_FILE"
EXPECTATIONS_PATH="$WORKSPACE/$EXPECTATIONS_DIR"
OUTPUT_FULL_PATH="$WORKSPACE/$OUTPUT_PATH"

echo "Blueprint file: $BLUEPRINT_PATH"
echo "Expectations directory: $EXPECTATIONS_PATH"
echo "Output path: $OUTPUT_FULL_PATH"

# Check if blueprint file exists
if [ ! -f "$BLUEPRINT_PATH" ]; then
    echo "Error: Blueprint file not found: $BLUEPRINT_PATH"
    exit 1
fi

# Check if expectations directory exists
if [ ! -d "$EXPECTATIONS_PATH" ]; then
    echo "Error: Expectations directory not found: $EXPECTATIONS_PATH"
    exit 1
fi

echo "Found blueprint file and expectations directory"
echo ""

# Show Caffeine version
echo "Caffeine version:"
caffeine --version || echo "caffeine binary not found"
echo ""

# Create output directory if it doesn't exist and output_path looks like a directory
if [[ "$OUTPUT_PATH" != *.tf ]] && [[ "$OUTPUT_PATH" != *.json ]]; then
    mkdir -p "$OUTPUT_FULL_PATH"
fi

# Run Caffeine compiler
echo "Running Caffeine compiler..."
if caffeine compile "$BLUEPRINT_PATH" "$EXPECTATIONS_PATH" "$OUTPUT_FULL_PATH"; then
    echo ""
    echo "Caffeine compilation SUCCESSFUL!"
    exit 0
else
    echo ""
    echo "Caffeine compilation FAILED!"
    echo "Check your blueprint and expectation files for errors."
    exit 1
fi
