#!/usr/bin/env bash

set -euo pipefail

echo "Testing Cursor package build..."

# Build the package
echo "Building package..."
nix build

# Check version
echo "Checking version..."
VERSION=$(./result/bin/cursor --version 2>/dev/null | head -1)
echo "Built version: $VERSION"

# Expected version
EXPECTED="1.4.2"
if [[ "$VERSION" == "$EXPECTED" ]]; then
    echo "✅ Version check passed!"
else
    echo "❌ Version check failed. Expected: $EXPECTED, Got: $VERSION"
    exit 1
fi

# Check that binary exists and is executable
if [[ -x "./result/bin/cursor" ]]; then
    echo "✅ Binary is executable!"
else
    echo "❌ Binary is not executable"
    exit 1
fi

# Test help command works
echo "Testing help command..."
if ./result/bin/cursor --help >/dev/null 2>&1; then
    echo "✅ Help command works!"
else
    echo "❌ Help command failed"
    exit 1
fi

echo "🎉 All tests passed!"
echo "You can now run cursor with: nix run .#cursor"
