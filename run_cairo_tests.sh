#!/bin/bash

# ----------------------------
# Configuration (edit this)
# ----------------------------
cairo_project_dir="my_contract"
# ----------------------------

# Absolute path to project directory
FULL_PATH="$(realpath "$cairo_project_dir")"

# Check that project exists
if [ ! -d "$FULL_PATH" ]; then
  echo "❌ Error: '$FULL_PATH' is not a valid directory."
  exit 1
fi

# Ensure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"

# Install snfoundryup if not available
if ! command -v snfoundryup &>/dev/null; then
  echo "📦 Installing Starknet Foundry via snfoundryup..."
  curl -L https://get.foundry.sh/starknet | bash
  source "$HOME/.bashrc"
fi

# Install snforge + universal-sierra-compiler if not already installed
if ! command -v snforge &>/dev/null || ! command -v universal-sierra-compiler &>/dev/null; then
  echo "🔧 Installing snforge and universal-sierra-compiler..."
  snfoundryup
fi

# Final check
if ! command -v snforge &>/dev/null || ! command -v universal-sierra-compiler &>/dev/null; then
  echo "❌ Error: Tools still not found in PATH. Check your ~/.bashrc and PATH."
  exit 1
fi

# Run tests
echo "🧪 Running snforge tests in: $FULL_PATH"
cd "$FULL_PATH"
scarb test