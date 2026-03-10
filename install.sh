#!/bin/bash
# SI Demo Installer
# Run: curl -sSL https://raw.githubusercontent.com/sfc-gh-tracker/si-demo/main/install.sh | bash

echo "Installing SI Demo..."

~/.local/bin/cortex skill add https://github.com/sfc-gh-tracker/si-demo

echo ""
echo "✅ SI Demo installed!"
echo ""
echo "Usage (inside Cortex Code):"
echo "  /si-demo https://company.com"
echo ""
echo "Example:"
echo "  /si-demo https://acme.com"
