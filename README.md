# QuickRun ⚡️

> One syllable commands to read your mind 🧠

Stop wasting cycles spamming your up-arrow or grepping .zsh_history. QuickRun is a set of two simple scripts for developers who value efficiency (aka "lazyness").

It lets you run and open files based on what you're thinking about (i.e., what you just edited), not what you have to find and type.

## Core Features

Run this 💨: Instantly execute the last file you saved.

Run that ⏳: Execute the second-to-last file you saved.

Run tests 🧪: A smart test runner that tries pytest first, then falls back to unittest if not found.

Open this/that 📝: Immediately open your last (or second-to-last) edited file in VS Code.

Open these/those 📂: Open your current directory (these) or the last-modified directory (those) in VS Code.

Multi-Language 🌐: run script supports executing Python, C++, Java, JavaScript, and shell scripts out of the box.

## 🚀 Easy Install (Recommended)

Just copy and paste this command into your terminal. It will automatically download the project to ~/QuickRun (if needed) and run the interactive installer.

Just 📋copy-paste the following command:
```bash
curl -fsSL [https://raw.githubusercontent.com/Earth1283/QuickRun/main/install.sh](https://raw.githubusercontent.com/Earth1283/QuickRun/main/install.sh) | bash
```

**Reload your shell:**
After the script finishes, apply the changes to your current session (or just open a new session).

# If you use zsh
`source ~/.zshrc`

# If you use bash
`source ~/.bashrc`


You're done! You can now use the run and open commands from anywhere.

## 🛠️ Manual Setup

To get the true "one-syllable" experience, you need to make these scripts available in your shell.

**1. Dependencies**

This project uses rich for nice console output.

```bash
pip install rich
```

**2. Make Scripts Executable**

(Only required for the PATH method)

chmod +x run.py open.py


3. Make the Magic Happen (Add to Shell) ✨

Pick one of the two methods below. Add the lines to your ~/.zshrc (for zsh) or ~/.bashrc (for bash).

Replace /path/to/your/QuickRun with the actual full path to this project folder (e.g., ~/run).

Option A: The Alias Method (Simple)

```
# --- QuickRun Aliases ---
alias run="python3 /path/to/your/QuickRun/run.py"
alias open="python3 /path/to/your/QuickRun/open.py"
```

Option B: The PATH Method (Recommended)

This method assumes you made the files executable (Step 2) and added #!/usr/bin/env python3 to the top of both .py files.

```
# --- QuickRun Path ---
export PATH="/path/to/your/QuickRun:$PATH"
```

4. Reload Your Shell

Apply the changes to your current session.

```bash
source ~/.zshrc
# or
source ~/.bashrc
```

## 📖 Command Reference

### run

(from run.py)

`run this`: Finds the most recently edited file in the current directory and executes it.

`run that`: Finds the second-most recently edited file and executes it.

`run tests`: Attempts to run tests using pytest. If pytest isn't found, it falls back to python3 -m unittest discover.

### open

(from open.py)

Note: This script assumes you have the code command for VS Code in your system's PATH.

`open this`: Opens the most recently edited file in VS Code.

`open that`: Opens the second-most recently edited file in VS Code.

`open those`: Finds the most recently modified directory and opens it in VS Code.

`open these`: Opens the current working directory (.) in VS Code.
