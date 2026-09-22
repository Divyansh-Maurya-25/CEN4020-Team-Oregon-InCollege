"""Small end-to-end check for the Epic 3 COBOL changes."""

import os
import shutil
import subprocess
import tempfile
from pathlib import Path


PROJECT = Path(__file__).resolve().parent.parent
PROGRAM = Path(__file__).resolve().parent / "InCollege.exe"


def run_program(folder: Path, input_text: str) -> str:
    (folder / "InCollege-Input.txt").write_text(input_text, encoding="utf-8")
    env = os.environ.copy()
    env["PATH"] = r"C:\msys64\ucrt64\bin;" + env.get("PATH", "")
    result = subprocess.run(
        [str(PROGRAM)], cwd=folder, env=env, capture_output=True,
        text=True, check=True,
    )
    screen_lines = result.stdout.splitlines()
    file_lines = (folder / "InCollege-Output.txt").read_text(
        encoding="utf-8"
    ).splitlines()
    assert screen_lines == file_lines, "Screen and output file differ"
    return result.stdout


with tempfile.TemporaryDirectory(dir=PROJECT / "chat gpt") as temp:
    folder = Path(temp)

    # Create John Doe, save a full profile, and view it.
    first_input = (PROJECT / "InCollege-Input.txt").read_text(encoding="utf-8")
    first = run_program(folder, first_input)
    assert "==== Profile for John Doe" in first
    assert "About Me: I am a computer science student." in first
    assert "Experience #1" in first and "Education #1" in first
    assert "--- Found User Profile ---\n==== Profile for John Doe" in first
    assert "No one by that name could be found." in first
    shutil.copyfile(folder / "InCollege-Output.txt", PROJECT / "InCollege-Output.txt")

    # A new program run must find John's profile in saved records.
    second_input = "\n".join([
        "2", "jane", "GoodPass1!", "1", "jane", "GoodPass1!",
        "1", "Jane", "Smith", "City College", "Physics", "2028",
        "", "DONE", "DONE", "2", "4", "John Doe", "4", "John",
        "4", "john doe", "4", "Jane Smith", "6", "",
    ])
    second = run_program(folder, second_input)
    assert "==== Profile for Jane Smith" in second
    assert "Experience:\nNone\nEducation:\nNone" in second
    assert "--- Found User Profile ---\n==== Profile for John Doe" in second
    assert "Title: Software Intern" in second
    assert "No one by that name could be found." in second
    assert second.count("No one by that name could be found.") == 2
    assert "Find someone you know is under construction." not in second

    # The maximum-length About Me entry must not be cut off by its label.
    long_about = "A" * 200
    third_input = "\n".join([
        "2", "sam", "GoodPass1!", "1", "sam", "GoodPass1!",
        "1", "Sam", "Long", "City College", "Math", "2028",
        long_about, "DONE", "DONE", "2", "6", "",
    ])
    third = run_program(folder, third_input)
    assert "About Me: " + long_about in third

print("Epic 3 checks passed: profile display, saved search, exact match, and mirrored output.")
