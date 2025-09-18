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
ORG_DIR="$SPEC_DIR/some_organization"
SPEC_SUBDIR="$ORG_DIR/$SPEC_DIR/specifications"
PLATFORM_DIR="$ORG_DIR/$INST_DIR/platform"
FRONTEND_DIR="$ORG_DIR/$INST_DIR/frontend"
mkdir -p "$SPEC_SUBDIR" "$PLATFORM_DIR" "$FRONTEND_DIR"

# Create basic_types.yaml
cat > "$SPEC_SUBDIR/basic_types.yaml" << 'EOF'
basic_types:
  - attribute_name: number_of_users
    attribute_type: Integer
EOF

# Create query_template_types.yaml
cat > "$SPEC_SUBDIR/query_template_types.yaml" << 'EOF'
query_template_types:
  - name: "good_over_bad"
    metric_attributes: ["number_of_users"]
EOF

# Create sli_types.yaml
cat > "$SPEC_SUBDIR/sli_types.yaml" << 'EOF'
types:
  - name: error_rate
    query_template_type: good_over_bad
    metric_attributes:
      - numerator_query
      - denominator_query
    filters:
      - number_of_users
EOF

# Create services.yaml
cat > "$SPEC_SUBDIR/services.yaml" << 'EOF'
services:
  - name: reliable_service
    sli_types:
      - error_rate
  - name: less_reliable_service
    sli_types:
      - error_rate
EOF

# Create platform team instantiation
cat > "$PLATFORM_DIR/reliable_service.yaml" << 'EOF'
slos:
  - sli_type: "error_rate"
    filters:
      "number_of_users": "100"
    threshold: 99.5
    window_in_days: 30
EOF

# Create frontend team instantiation
cat > "$FRONTEND_DIR/less_reliable_service.yaml" << 'EOF'
slos:
  - sli_type: "error_rate"
    filters:
      "number_of_users": "100"
    threshold: 99.5
    window_in_days: 30
EOF

# Run Caffeine compiler with spec and inst directories
echo ""
echo "Running Caffeine compiler..."
if gleam run -- compile "$SPEC_SUBDIR" "$ORG_DIR"; then
    echo ""
    echo "✅ Caffeine compiler smoke test PASSED!"
    echo "Caffeine language is working correctly."
    exit 0
else
    echo ""
    echo "❌ Caffeine compiler smoke test FAILED!"
    exit 1
fi
