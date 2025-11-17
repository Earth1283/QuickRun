#!/bin/bash
#
# QuickRun Easy Install Script
# Detects bash/zsh and adds aliases or PATH export.

# Get the directory where the install script is located (the project root)
# This ensures paths are absolute and correct, even if run from elsewhere.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# --- Shell Detection ---
CURRENT_SHELL=$(basename "$SHELL")
CONFIG_FILE=""

if [ "$CURRENT_SHELL" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ "$CURRENT_SHELL" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    echo "❌ Unsupported shell: $CURRENT_SHELL. Only bash and zsh are supported by this installer."
    echo "Please follow the Manual Setup instructions in the README.md."
    exit 1
fi

echo "Hello! Let's install QuickRun."
echo "-----------------------------------"
echo "✨ Detected Shell: $CURRENT_SHELL"
echo "✨ Config file:    $CONFIG_FILE"
echo "✨ Project path:   $SCRIPT_DIR"
echo ""

# --- Check for existing installation ---
if grep -q "# --- QuickRun" "$CONFIG_FILE"; then
    echo "✅ QuickRun setup already found in $CONFIG_FILE."
    echo "To reinstall, please remove the QuickRun section from that file first."
    exit 0
fi

# --- Ask for Installation Method ---
echo "How do you want to install QuickRun?"
echo "  1) Alias Method (Simple, works everywhere)"
echo "  2) PATH Method (Recommended, turns scripts into 'real' commands)"
echo ""
read -p "Enter your choice (1 or 2): " METHOD_CHOICE
echo ""

# --- Installation Logic ---
if [ "$METHOD_CHOICE" = "1" ]; then
    # --- ALIAS METHOD ---
    echo "Adding Alias configuration to $CONFIG_FILE..."
    echo "" >> "$CONFIG_FILE"
    echo "# --- QuickRun Aliases ---" >> "$CONFIG_FILE"
    echo "alias run=\"python3 $SCRIPT_DIR/run.py\"" >> "$CONFIG_FILE"
    echo "alias open=\"python3 $SCRIPT_DIR/open.py\"" >> "$CONFIG_FILE"

elif [ "$METHOD_CHOICE" = "2" ]; then
    # --- PATH METHOD ---
    echo "Adding PATH configuration to $CONFIG_FILE..."
    
    # 1. Make scripts executable
    echo "Making run.py and open.py executable..."
    chmod +x "$SCRIPT_DIR/run.py"
    chmod +x "$SCRIPT_DIR/open.py"

    # 2. Add shebang line to run.py if not present
    if ! head -n 1 "$SCRIPT_DIR/run.py" | grep -q "#!/usr/bin/env python3"; then
        echo "Adding shebang to run.py..."
        # Use a temp file and mv to avoid sed -i portability issues
        echo "#!/usr/bin/env python3" > run.py.tmp
        cat "$SCRIPT_DIR/run.py" >> run.py.tmp
        mv run.py.tmp "$SCRIPT_DIR/run.py"
    fi
    
    # 3. Add shebang line to open.py if not present
    if ! head -n 1 "$SCRIPT_DIR/open.py" | grep -q "#!/usr/bin/env python3"; then
        echo "Adding shebang to open.py..."
        echo "#!/usr/bin/env python3" > open.py.tmp
        cat "$SCRIPT_DIR/open.py" >> open.py.tmp
        mv open.py.tmp "$SCRIPT_DIR/open.py"
    fi
    
    echo "Scripts are now executable."

    # 4. Add to PATH
    echo "" >> "$CONFIG_FILE"
    echo "# --- QuickRun Path ---" >> "$CONFIG_FILE"
    echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$CONFIG_FILE"

else
    echo "❌ Invalid choice. Exiting."
    exit 1
fi

echo ""
echo "✅ Success! QuickRun has been added to your $CONFIG_FILE."
echo ""
echo "To apply changes, please restart your terminal or run:"
echo "  source $CONFIG_FILE"
echo ""
