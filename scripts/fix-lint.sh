#!/bin/bash
# Auto-fix common lint issues

echo "🔧 Auto-fixing lint issues..."

# Format code
echo "📝 Formatting code..."
flutter format lib/

# Fix unused imports (requires dart fix)
echo "🧹 Removing unused imports..."
dart fix --apply

echo "✅ Auto-fix complete! Run 'flutter analyze' to check remaining issues."
