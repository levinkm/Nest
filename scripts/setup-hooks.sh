#!/bin/bash
# Setup script for pre-commit hooks

echo "🔧 Setting up pre-commit hooks..."

# Copy pre-commit hook
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Pre-commit hooks installed successfully!"
echo "💡 The hook will run 'flutter analyze' and 'flutter format' before each commit."
