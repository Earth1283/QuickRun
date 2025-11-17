import argparse
import subprocess
from rich.console import Console
from pathlib import Path

console = Console()


def main():
    parser = argparse.ArgumentParser(
        description="Running programs with ease!"
    )
    parser.add_argument(
        "command",
        help="The command, they are `this`, `that`, and `tests`"
    )
    try:
        args = parser.parse_args()
        console.log("Arguments OK")
    except SystemExit:
        raise

    match args.command:
        case "this":
            _run_file(get_last_edited())
        case "that":
            _run_second_last_edited()
        case "tests":
            _run_tests()
        case _:
            console.print(f"[red]Unknown command: {args.command}")


def _run_file(file_path):
    if file_path is None:
        console.print("[red]Sorry, we did not find any files we can process...")
        return
    
    file_name = str(file_path)
    try:
        console.log("Running file...")
        language, fname = process_lang(file_name)
        console.log(
            f"Found [#87CEEB]{fname}[/#87CEEB] coded with "
            f"[#90EE90]{language}[/#90EE90]"
        )
        console.log(f"Prepping for execution, method [#87CEEB]{language}[/#87CEEB]")
        run(fname, language)
    except ValueError:
        console.print("[red]Sorry, we did not find any files we can process...")


def _run_second_last_edited():
    try:
        console.log("Running second-to-last changed file...")
        current_dir = Path('.')
        files = [item for item in current_dir.iterdir() if item.is_file()]
        if len(files) < 2:
            raise ValueError("not enough files")
        second_most = sorted(
            files, key=lambda f: f.stat().st_mtime, reverse=True
        )[1]
        _run_file(second_most)
    except ValueError:
        console.print("[red]Sorry, we did not find any files we can process...")


def _run_tests():
    try:
        console.log("Attempting to run tests with [bold magenta]pytest[/bold magenta]...")
        
        # 1. Try to use pytest, the community standard
        pytest_result = subprocess.run(
            ["pytest"], 
            check=False, capture_output=True, text=True
        )
        
        # 2. If pytest isn't found (returncode != 0 and 'not found' in output),
        #    fall back to Python's built-in unittest
        if pytest_result.returncode != 0 and "not found" in pytest_result.stderr:
            console.print(
                "[yellow]pytest not found. "
                "Falling back to built-in [bold green]unittest[/bold green]..."
            )
            console.log("Running [green]unittest discover[/green]...")
            subprocess.run(["python3", "-m", "unittest", "discover"], check=False)
        else:
            # If pytest was found, print its output
            console.print(pytest_result.stdout)
            console.print(pytest_result.stderr)

    except Exception as e:
        console.print(f"[red]Error running tests: {e}")


def get_last_edited():
    current_dir = Path('.')
    files = [item for item in current_dir.iterdir() if item.is_file()]
    if not files:
        return None
    return max(files, key=lambda f: f.stat().st_mtime)


def process_lang(filename: str) -> tuple[str, str]:
    file_name, extension = filename.split(".")
    match extension:
        case "py":
            return "python", file_name
        case "cpp":
            return "cpp", file_name
        case "js":
            return "js", file_name
        case "sh":
            return "sh", file_name
        case "java":
            return "java", file_name
        case _:
            raise ValueError("unsupported file type")


def run(filename: str, language: str) -> bool:
    match language:
        case "python":
            console.log(f"Running program {filename}.py")
            subprocess.run(["python3", f"{filename}.py"], check=False)
            return True
        case "cpp":
            console.log(f"Running program {filename}.cpp")
            subprocess.run(["g++", f"{filename}.cpp", "-o", filename], check=False)
            console.log("[#90EE90]Compilation completed, attempting execution")
            subprocess.run([f"./{filename}"], check=False)
            console.log("[#87CEEB]Removing executable...")
            subprocess.run(["rm", filename], check=False)
            console.log("[#90EE90]Execution completed!")
            return True
        case "js":
            console.log(f"Running program {filename}.js")
            subprocess.run(["node", f"{filename}.js"], check=False)
            return True
        case "sh":
            console.log(f"Setting up permissions for {filename}.sh")
            subprocess.run(["chmod", "+x", f"{filename}.sh"], check=False)
            console.log(f"Running program {filename}.sh")
            subprocess.run([f"./{filename}.sh"], check=False)
            return True
        case "java":
            console.log(f"Running program {filename}.java")
            subprocess.run(["javac", f"{filename}.java"], check=False)
            subprocess.run(["java", filename], check=False)
            return True
        case _:
            raise ValueError


if __name__ == "__main__":
    main()