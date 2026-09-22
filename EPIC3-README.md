# Epic 3: Profiles and Finding People

This folder is Allen Nguyen's Epic 3 work for CEN 4020 Team Oregon.
The assignment is in `InCollege Software Req - Epic #3.pdf`.

## What this work does

- Shows a saved profile with a name heading and labeled details.
- Shows About Me, Experience, and Education when the user entered them.
- Lets a logged-in user choose `4. Find someone you know` and search for an exact first and last name.
- Shows the matching person's profile or a message when no saved profile matches.
- Writes the same results to the screen and `InCollege-Output.txt`.

## Files

- `InCollege.cob` is the COBOL program. It includes the earlier account and profile features needed for Epic 3 to run.
- `InCollege-Input.txt` is sample input for profile viewing and name searches.
- `InCollege-Output.txt` is the matching sample output.
- `Roles.txt` lists the Epic 3 team roles.
- `chat gpt/Task notes.md` maps Allen's Jira subtasks to the work.
- `chat gpt/verify_epic3.py` checks the Epic 3 behavior.

## Run

Compile with GnuCOBOL from this folder:

```text
cobc -x -o InCollege InCollege.cob
```

Run `InCollege` (`./InCollege` on macOS or Linux). It reads commands from
`InCollege-Input.txt` and writes results to `InCollege-Output.txt`.

To check the Epic 3 work on Windows with GnuCOBOL installed:

```text
python "chat gpt/verify_epic3.py"
```

The name search is exact, including capitalization. Saved accounts and
profiles are kept in `accounts.dat` and `profiles.dat` when the program runs.
