# InCollege — Team Oregon

## Overview

This repository contains the CEN 4020 Team Oregon implementation of InCollege through Epic #2.

Epic #2 builds on the Epic #1 authentication and navigation system by adding user profile creation, editing, viewing, and persistent profile storage.

The project is written in COBOL and uses file-based input and output.

## Team

- Allen Nguyen — Scrum Master
- Divyansh Maurya — Developer I
- Gabbriel McIntosh — Developer II
- Abdallah Mostafa Mohamed Mohamed Metwaly — Tester
- Lucas Montanaro — Tester

## Implemented Functionality

### Epic #1

The program supports:

- Create a new InCollege account
- Log in to an existing account
- Validate password requirements
- Prevent duplicate usernames
- Limit the system to five accounts
- Save accounts between program executions
- Store hashed passwords instead of plaintext passwords
- Handle failed login attempts
- Display post-login navigation
- Search for a job placeholder
- Find someone placeholder
- Learn a New Skill menu
- Logout
- File-based input
- Console output
- Matching output-file generation

### Epic #2

Epic #2 adds:

- Create a user profile
- Edit an existing profile
- View the logged-in user's profile
- Required profile-field validation
- Graduation-year validation
- Optional About Me section
- Up to three experience entries
- Up to three education entries
- Persistent profile storage
- Profiles associated with usernames
- Profile data retained after restarting the program

## Requirements

The project uses GnuCOBOL.

The course development environment uses:

```text
GnuCOBOL 3.1.2
Verify installation with:
cobc --version
Compile
From the directory containing InCollege.cob:
cobc -x -o InCollege InCollege.cob
Run
Run:
./InCollege
The program does not require interactive keyboard input.
All input is read from:
InCollege-Input.txt
Output is:
Displayed in the terminal
Written to InCollege-Output.txt
The console output and output file are designed to be identical.
They can be checked with:
./InCollege | tee console.txt
diff -u console.txt InCollege-Output.txt
If diff produces no output, the console and output file match.
Account Creation and Login
Before login, the program displays:
1. Log In
2. Create New Account
Users may create an account and then log in using the created username and password.
Password Requirements
Passwords must:
Be at least 8 characters long
Be no more than 12 characters long
Contain at least one uppercase letter
Contain at least one digit
Contain at least one special character
Account data is stored in:
accounts.dat
The project stores a deterministic password hash rather than the plaintext password.
The hashing implementation is intended for this course assignment and is not a production-grade password-security system.
Post-Login Menu
After successful login, the user is presented with:
1. Create/Edit My Profile
2. View My Profile
3. Search for a job
4. Find someone you know
5. Learn a New Skill
6. Logout
Create/Edit My Profile
A logged-in user can create or edit their profile.
Required Fields
The following fields are required:
First Name
Last Name
University/College Attended
Major
Graduation Year
The graduation year must:
Contain exactly four digits
Be greater than 2025
Be less than 2034
Therefore, valid graduation years are:
2026 through 2033
About Me
The user may optionally provide an About Me section.
The field may also be left blank.
Experience
A profile may contain up to three experience entries.
Each experience entry contains:
Title
Company/Organization
Dates
Description — optional
The user may enter DONE when no additional experience entries are needed.
Education
A profile may contain up to three education entries.
Each education entry contains:
Degree
University/College
Years Attended
The user may enter DONE when no additional education entries are needed.
View My Profile
A logged-in user can select:
2. View My Profile
The program displays the complete saved profile, including:
Name
University
Major
Graduation Year
About Me
Experience entries
Education entries
Profile Persistence
Profile information is stored in:
profiles.dat
Each profile is associated with the username of the account that created it.
Profile data remains available after the program terminates and is started again.
Account persistence continues to use:
accounts.dat
Example Epic #2 Input
Example InCollege-Input.txt:
2
allen
GoodPass1!
1
allen
GoodPass1!
1
John
Doe
University of South Florida
Computer Science
2027
I am a computer science student.
Software Intern
Example Company
May 2026 - August 2026
Built software features.
DONE
Bachelor of Science in Computer Science
University of South Florida
2024 - 2027
DONE
2
6
This input:
Creates an account
Logs in
Creates a profile
Adds an About Me section
Adds one experience entry
Adds one education entry
Saves the profile
Views the profile
Logs out
Testing
Epic #2 testing covers:
Profile creation
Profile editing
Profile persistence
Viewing a profile
Blank required fields
Invalid graduation years
Non-numeric graduation years
Minimum valid graduation year
Maximum valid graduation year
Optional About Me
Three experience entries
Three education entries
File-based input
Matching console and output-file results
The Epic #2 submission test archives are:
Epic2-Storyx-Test-Input.zip
Epic2-Storyx-Test-Output.zip
Epic #1 functionality remains integrated into the final program and is used as the authentication and navigation foundation for Epic #2.
Main Project Files
InCollege.cob
InCollege-Input.txt
InCollege-Output.txt
Roles.txt
README.md
Additional test files and previous Epic artifacts may also be stored in the repository.
Project Status
Epic #1 and Epic #2 functionality have been integrated.
The current program supports account registration, authentication, account persistence, password validation, profile creation and editing, profile viewing, profile persistence, experience and education sections, file-driven input, and matching console/file output.

### Do this now

Open:

```bash
code README.md
