# InCollege - Epic #2

## Project Overview

This repository contains the combined Epic #1 and Epic #2 work for the
CEN 4020 Team Oregon InCollege project. The program is written in COBOL.

Epic #2 adds personal profiles. A user must create an account and log in
before creating or viewing a profile.

## Epic #2 Features

- Create a personal profile.
- Edit an existing profile.
- View the profile for the logged-in user.
- Require a first name, last name, university, major, and graduation year.
- Allow an optional About Me section.
- Allow zero through three work experience entries.
- Allow zero through three education entries.
- Save profiles in `profiles.dat`.
- Load saved profiles after the program is restarted.
- Read all program input from `InCollege-Input.txt`.
- Display output on the console and write the same output to
  `InCollege-Output.txt`.

## Team Roles

- Allen Nguyen - Scrum Master
- Divyansh Maurya - Developer
- Gabbriel McIntosh - Developer
- Abdallah Mostafa Mohamed Mohamed Metwaly - Tester
- Lucas Montanaro - Tester

## Requirements

The course uses GnuCOBOL. This project was checked with GnuCOBOL 3.2.0.

Verify the compiler:

```text
cobc --version
```

Compile the program:

```text
cobc -x -o InCollege InCollege.cob
```

On Windows, the output file can be named `InCollege.exe`.

Run the program from the same folder as `InCollege-Input.txt`:

```text
./InCollege
```

## Program Files

- `InCollege.cob` - main COBOL source code
- `InCollege-Input.txt` - actions and information read by the program
- `InCollege-Output.txt` - program output
- `accounts.dat` - saved accounts created while the program runs
- `profiles.dat` - saved profiles created while the program runs
- `Roles.txt` - team roles
- `INTEGRATION-TESTING.txt` - combined-build testing instructions
- `Epic2-Storyx-Test-Input` - Epic #2 tester input files
- `Epic2-Storyx-Test-Output` - earlier Epic #2 output files
- `Epic2-Combined-Test-Input` - integration retest inputs
- `Epic2-Lucas-Test-Input` - prepared inputs for the five remaining tests
- `Epic1-Archive` - test files retained from the completed Epic #1 sprint

## Post-Login Menu

After logging in, the user sees:

1. Create/Edit My Profile
2. View My Profile
3. Search for a job
4. Find someone you know
5. Learn a New Skill
6. Logout

## Profile Information

Required fields:

- First name
- Last name
- University or college
- Major
- Graduation year from 2026 through 2033

Optional profile information:

- About Me
- Up to three work experience entries
- Up to three education entries

Enter `DONE` when no more experience or education entries are needed.

## Testing

Compile the program before testing. Each independent test should start in a
clean folder unless it is specifically testing persistence. Remove
`accounts.dat` and `profiles.dat` before a clean test.

For a persistence test, keep both data files between the first and second
program runs. The test is successful when the same account and profile load
after restarting the executable.

The screen output and `InCollege-Output.txt` should be identical.

## Current Status

The two Epic #2 developer branches have been combined on the
`epic2-integration` branch. The combined source compiles and runs. Abdallah's
assigned testing is complete. Lucas's five remaining Jira tests must be run
against this exact integration branch before it is merged into `main`.
