#!/bin/bash
#
# QuickRun Easy Install Script
# Detects bash/zsh and adds aliases or PATH export.
# Can be run from within the repo or via:
# curl -fsSL https://raw.githubusercontent.com/Earth1283/QuickRun/main/install.sh | bash

# --- Configuration ---
GITHUB_REPO_URL="https://raw.githubusercontent.com/Earth1283/QuickRun/main"
PROJECT_FILES=("run.py" "open.py" "install.sh")
# By default, we'll install to ~/QuickRun if run remotely
REMOTE_INSTALL_DIR="$HOME/QuickRun"


# Get the directory where the script *thinks* it is.
# If run via curl|bash, this will be the user's CWD.
# If run from file, it's the script's dir.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# --- Smart Installer Logic ---
# Check if we're running inside the cloned repo by looking for run.py
if [ ! -f "$SCRIPT_DIR/run.py" ]; then
    echo "🔎 QuickRun files not found. Assuming remote install..."
    echo "Installing to $REMOTE_INSTALL_DIR..."
    
    # Check for git, prefer it if available
    if command -v git &> /dev/null; then
        if [ -d "$REMOTE_INSTALL_DIR" ]; then
            echo "Directory $REMOTE_INSTALL_DIR already exists. Skipping clone."
        else
            echo "Cloning repository via git..."
            git clone https://github.com/Earth1283/QuickRun.git "$REMOTE_INSTALL_DIR"
        fi
    else
        # Fallback to curl if git isn't available
        echo "git not found. Downloading files manually via curl..."
        mkdir -p "$REMOTE_INSTALL_DIR"
        for FILE in "${PROJECT_FILES[@]}"; do
            echo "Downloading $FILE..."
            curl -fsSL "$GITHUB_REPO_URL/$FILE" -o "$REMOTE_INSTALL_DIR/$FILE"
        done
    fi
    
    # IMPORTANT: Update SCRIPT_DIR to point to the new location
    SCRIPT_DIR="$REMOTE_INSTALL_DIR"
    echo "✅ Project files are now in $SCRIPT_DIR"
    echo ""
fi

# --- Shell Detection ---
# Now, we proceed with the original logic, using the (potentially new) SCRIPT_DIR
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
    echo "Note: If you moved the project, run this installer again."
    exit 0
fi

# --- Ask for Installation Method ---
METHOD_CHOICE=""

# Check if stdin is a terminal (running interactively)
if [ -t 0 ]; then
    echo "How do you want to install QuickRun?"
    echo "  1) Alias Method (Simple, works everywhere)"
    echo "  2) PATH Method (Recommended, turns scripts into 'real' commands)"
    echo ""
    read -p "Enter your choice (1 or 2) [Default: 2]: " METHOD_CHOICE
    echo ""
    # Default to 2 if user just hits enter
    if [ -z "$METHOD_CHOICE" ]; then
        METHOD_CHOICE="2"
    fi
else
    # Not running interactively (e.g., curl | bash)
    echo "Running in non-interactive mode. Defaulting to recommended PATH Method (2)."
    METHOD_CHOICE="2"
fi


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
