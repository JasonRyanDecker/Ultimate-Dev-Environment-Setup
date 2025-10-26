#!/usr/bin/env bash
# ========================================
# ✅ Verify Dev Environment Installation
# ========================================

echo "🔎 Checking environment setup..."

check_cmd() {
  if command -v "$1" &> /dev/null; then
    echo "✅ $1 is installed: $($1 --version | head -n 1)"
  else
    echo "❌ $1 not found"
  fi
}

check_cmd node
check_cmd npm
check_cmd yarn
check_cmd pnpm
check_cmd code
check_cmd vim
check_cmd git
check_cmd nvm

echo ""
echo "🎯 Check complete!"
