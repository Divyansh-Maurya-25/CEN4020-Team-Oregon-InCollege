InCollege — Epic #1

Overview

This repository contains Epic #1: Log In, Part 1 for the CEN 4020 InCollege project.

The program is written in COBOL and implements the first version of the InCollege authentication and navigation system.

Implemented functionality includes:

Create a new InCollege account

Log in to an existing account

Validate password requirements

Prevent duplicate usernames

Limit the system to five accounts

Save accounts between program executions

Store hashed passwords instead of plaintext passwords

Handle failed login attempts and allow retries

Display initial post-login navigation

Simulate Job Search and Find Someone features

Display a five-option Learn New Skill menu

Support returning from the skill menu

Support logout

Read all user input from a file

Display all output on the console

Write identical output to an output file

Team

CEN 4020 — Team Oregon

Epic #1 focuses on implementing the initial authentication, persistence, file I/O, and navigation functionality for InCollege.

Requirements

The program is designed to run using GnuCOBOL.

The course development environment uses:

GnuCOBOL 3.1.2

The recommended environment is the CEN 4020 VS Code Dev Container with Docker Desktop running.

To verify that GnuCOBOL is available:

cobc --version

Compile the Program

From the directory containing InCollege.cob, run:

cobc -x -o InCollege InCollege.cob

If compilation succeeds, an executable named InCollege will be created.

Run the Program

Run:

./InCollege

The program does not require interactive keyboard input.

All user input is read from:

InCollege-Input.txt

Input File

InCollege-Input.txt contains the sequence of user actions the program will execute.

Example:

2
allen
GoodPass1!
1
allen
GoodPass1!
1
2
3
1
6
4

This sample input performs the following sequence:

Create a new account

Use username allen

Use a valid password

Log in

Search for a job

Select Find Someone

Open Learn New Skill

Select a skill

Go back

Log out

Password Requirements

Passwords must:

Be at least 8 characters long

Be no more than 12 characters long

Contain at least one uppercase letter

Contain at least one digit

Contain at least one special character

Passwords are validated during account creation.

For this course project, the persistence file stores a deterministic hash value instead of the plaintext password.

Note: The hashing implementation is intended for the assignment and is not a production-grade password security implementation.

Account Persistence

Created accounts are stored in:

accounts.dat

This allows accounts to remain available after the program terminates and is started again.

The persistence file stores:

Username

Password hash

Plaintext passwords are not stored in accounts.dat.

Output

Program output is:

Displayed in the terminal

Written to:

InCollege-Output.txt

The console output and InCollege-Output.txt are designed to be identical.

This can be verified with:

./InCollege | tee console.txt
diff -u console.txt InCollege-Output.txt

If diff produces no output, the console output and output file are identical.

Post-Login Menu

After a successful login, the user is presented with:

1. Search for a job
2. Find someone you know
3. Learn a new skill
4. Logout

Search for a Job

Displays an under-construction message.

Find Someone You Know

Displays an under-construction message.

Learn a New Skill

Displays five skills:

1. Python
2. Java
3. Cybersecurity
4. Data Science
5. Web Development
6. Go Back

Selecting any skill displays an under-construction message.

Go Back returns the user to the previous menu.

Testing

The project includes test cases covering:

Valid account registration

Duplicate usernames

Password shorter than 8 characters

Password longer than 12 characters

Missing uppercase letter

Missing digit

Missing special character

Password boundary of exactly 8 characters

Password boundary of exactly 12 characters

Successful login

Incorrect username

Incorrect password

Login retry behavior

Five-account limit

Account persistence

Password hash storage

Post-login navigation

File-based input/output

Test input files are located in:

tests/input/

Generated test outputs are located in:

tests/output/

The submission test archives are:

Epic1-Storyx-Test-Input.zip
Epic1-Storyx-Test-Output.zip

Running the Test Suite

A helper script is included:

chmod +x run-tests.sh
./run-tests.sh

The script compiles the COBOL program, executes the prepared test inputs, and compares console output against the generated output files.

Testing should still be manually reviewed against the Epic #1 requirements.

Main Project Files

InCollege.cob
InCollege-Input.txt
InCollege-Output.txt
Roles.txt
README.md
Epic1-Storyx-Test-Input.zip
Epic1-Storyx-Test-Output.zip
tests/
run-tests.sh

Project Status

Epic #1 implementation and testing are complete.

The program currently supports account registration, authentication, persistent account storage, password validation, password hashing, initial post-login navigation, file-driven input, and matching console/file output.
