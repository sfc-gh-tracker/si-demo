#!/bin/bash
# SI Demo Installer
# Run: curl -sSL https://raw.githubusercontent.com/sfc-gh-tracker/si-demo/main/install.sh | bash

echo "Installing SI Demo..."

# Install the skill
~/.local/bin/cortex skill add https://github.com/sfc-gh-tracker/si-demo

# Create the wrapper script
mkdir -p ~/.local/bin
cat > ~/.local/bin/si-demo << 'EOF'
#!/bin/bash
# SI Demo - One command to generate Snowflake Intelligence demos
# Usage: /si-demo https://company.com

if [ -z "$1" ]; then
    echo "Usage: /si-demo <company-url>"
    echo "Example: /si-demo https://acme.com"
    exit 1
fi

exec ~/.local/bin/cortex \
    --bypass \
    --dangerously-allow-all-tool-calls \
    --auto-accept-plans \
    -p "/si-demo prep $1"
EOF
chmod +x ~/.local/bin/si-demo

echo ""
echo "✅ SI Demo installed!"
echo ""
echo "Usage:"
echo "  /si-demo https://company.com"
echo ""
echo "Example:"
echo "  /si-demo https://acme.com"
