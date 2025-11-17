import subprocess
from pathlib import Path
import argparse
from run import get_last_edited
from rich import print

def main():
    parser = argparse.ArgumentParser(
        description="VSCODE! OPEN THAT"
    )
    parser.add_argument(
        "command",
        help="The command, args are: that, this, those, these"
    )
    try:
        args = parser.parse_args()
        print("Arguments OK")
    except SystemExit:
        raise

    match args.command:
        case "this":
            subprocess.run(["code", str(get_last_edited())], check=False)
        case "that":
            subprocess.run(["code", str(get_second_to_last_edited())], check=False)
        case "those":
            subprocess.run(["code", str(get_most_recent_dir())], check=False)
        case "these":
            subprocess.run(["code", "."], check=False)

def get_last_edited_dir():
    current_dir = Path('.')
    dirs = [item for item in current_dir.iterdir() if item.is_dir()]
    if not dirs:
        return None
    return max(dirs, key=lambda d: d.stat().st_mtime)

def get_second_to_last_edited():
    current_dir = Path('.')
    files = [item for item in current_dir.iterdir() if item.is_file()]
    if len(files) < 2:
        return None
    sorted_files = sorted(files, key=lambda f: f.stat().st_mtime, reverse=True)
    return sorted_files[1]

def get_most_recent_dir():
    current_dir = Path('.')
    dirs = [item for item in current_dir.iterdir() if item.is_dir()]
    if not dirs:
        return None
    return max(dirs, key=lambda d: d.stat().st_mtime)

if __name__ == "__main__":
    main()
