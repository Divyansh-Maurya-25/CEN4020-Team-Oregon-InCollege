       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. IN-COLLEGE.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT INPUT-FILE ASSIGN TO "InCollege-Input.txt"
        ORGANIZATION IS LINE SEQUENTIAL
        FILE STATUS IS WS-INPUT-STATUS.
    SELECT OUTPUT-FILE ASSIGN TO "InCollege-Output.txt"
        ORGANIZATION IS LINE SEQUENTIAL.
    SELECT OPTIONAL ACCOUNT-FILE ASSIGN TO "accounts.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        FILE STATUS IS WS-ACCOUNT-STATUS.
    SELECT OPTIONAL PROFILE-FILE ASSIGN TO "profiles.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        FILE STATUS IS WS-PROFILE-STATUS.

DATA DIVISION.
FILE SECTION.
FD INPUT-FILE.
01 INPUT-RECORD PIC X(100).

FD OUTPUT-FILE.
01 OUTPUT-RECORD PIC X(100).

FD ACCOUNT-FILE.
01 ACCOUNT-RECORD.
    05 ACCOUNT-RECORD-USERNAME PIC X(20).
    05 ACCOUNT-RECORD-PASSWORD-HASH PIC 9(10).

*> Epic #2 profile persistence record.
FD PROFILE-FILE.
01 PROFILE-RECORD.
    05 PR-USERNAME PIC X(20).
    05 PR-FIRST-NAME PIC X(30).
    05 PR-LAST-NAME PIC X(30).
    05 PR-UNIVERSITY PIC X(60).
    05 PR-MAJOR PIC X(50).
    05 PR-GRAD-YEAR PIC X(4).
    05 PR-ABOUT-ME PIC X(200).
    05 PR-EXPERIENCE-COUNT PIC 9.
    05 PR-EXPERIENCES.
        10 PR-EXPERIENCE OCCURS 3 TIMES.
            15 PR-EXP-TITLE PIC X(50).
            15 PR-EXP-COMPANY PIC X(60).
            15 PR-EXP-DATES PIC X(40).
            15 PR-EXP-DESCRIPTION PIC X(100).
    05 PR-EDUCATION-COUNT PIC 9.
    05 PR-EDUCATION-ENTRIES.
        10 PR-EDUCATION OCCURS 3 TIMES.
            15 PR-EDU-DEGREE PIC X(50).
            15 PR-EDU-UNIVERSITY PIC X(60).
            15 PR-EDU-YEARS PIC X(20).

WORKING-STORAGE SECTION.
01 WS-INPUT-STATUS PIC XX VALUE SPACES.
01 WS-ACCOUNT-STATUS PIC XX VALUE SPACES.
01 WS-END-INPUT PIC X VALUE "N".
01 WS-END-ACCOUNTS PIC X VALUE "N".
01 WS-ACCOUNT-COUNT PIC 9 VALUE 0.
01 WS-ACCOUNT-INDEX PIC 9 VALUE 0.
01 WS-ACCOUNT-FOUND PIC X VALUE "N".
01 WS-PASSWORD-OK PIC X VALUE "N".
01 WS-HAS-CAPITAL PIC X VALUE "N".
01 WS-HAS-DIGIT PIC X VALUE "N".
01 WS-HAS-SPECIAL PIC X VALUE "N".
01 WS-PASSWORD-LENGTH PIC 99 VALUE 0.
01 WS-CHAR-INDEX PIC 99 VALUE 0.
01 WS-CHARACTER PIC X VALUE SPACE.
01 WS-CHOICE PIC X VALUE SPACE.
01 WS-POST-LOGIN-CHOICE PIC X VALUE SPACE.
01 WS-SKILL-CHOICE PIC X VALUE SPACE.
01 WS-LOGOUT PIC X VALUE "N".
01 WS-GO-BACK PIC X VALUE "N".
01 WS-USERNAME PIC X(20) VALUE SPACES.
01 WS-PASSWORD PIC X(12) VALUE SPACES.
01 WS-PASSWORD-HASH PIC 9(10) VALUE 0.
01 WS-HASH-ACCUM PIC 9(18) VALUE 0.
01 WS-MESSAGE PIC X(100) VALUE SPACES.
01 WS-ACCOUNTS.
    05 WS-ACCOUNT OCCURS 5 TIMES.
        10 WS-SAVED-USERNAME PIC X(20).
        10 WS-SAVED-PASSWORD-HASH PIC 9(10).

*> ================================================================
*> Epic #2 - Divyansh assigned profile tasks
*> - edit/load/save an existing profile
*> - work experience OCCURS table + prompts + three-entry limit
*> - education OCCURS table + prompts + three-entry limit
*> - profile persistence linked by username
*> - all prompts continue to use SHOW-TEXT for mirrored output
*> ================================================================
01 WS-PROFILE-STATUS PIC XX VALUE SPACES.
01 WS-END-PROFILES PIC X VALUE "N".
01 WS-PROFILE-COUNT PIC 9 VALUE 0.
01 WS-PROFILE-INDEX PIC 9 VALUE 0.
01 WS-CURRENT-PROFILE-INDEX PIC 9 VALUE 0.
01 WS-PROFILE-FOUND PIC X VALUE "N".
01 WS-ENTRY-INDEX PIC 9 VALUE 0.
01 WS-ENTRY-STOP PIC X VALUE "N".

*> In-memory saved profiles.  There can be at most five because
*> Epic #1 permits at most five accounts.
01 WS-PROFILES.
    05 WS-PROFILE OCCURS 5 TIMES.
        10 WS-PROFILE-USERNAME PIC X(20).
        10 WS-PROFILE-FIRST-NAME PIC X(30).
        10 WS-PROFILE-LAST-NAME PIC X(30).
        10 WS-PROFILE-UNIVERSITY PIC X(60).
        10 WS-PROFILE-MAJOR PIC X(50).
        10 WS-PROFILE-GRAD-YEAR PIC X(4).
        10 WS-PROFILE-ABOUT-ME PIC X(200).
        10 WS-PROFILE-EXPERIENCE-COUNT PIC 9.
        10 WS-PROFILE-EXPERIENCES.
            15 WS-PROFILE-EXPERIENCE OCCURS 3 TIMES.
                20 WS-PROFILE-EXP-TITLE PIC X(50).
                20 WS-PROFILE-EXP-COMPANY PIC X(60).
                20 WS-PROFILE-EXP-DATES PIC X(40).
                20 WS-PROFILE-EXP-DESCRIPTION PIC X(100).
        10 WS-PROFILE-EDUCATION-COUNT PIC 9.
        10 WS-PROFILE-EDUCATION-ENTRIES.
            15 WS-PROFILE-EDUCATION OCCURS 3 TIMES.
                20 WS-PROFILE-EDU-DEGREE PIC X(50).
                20 WS-PROFILE-EDU-UNIVERSITY PIC X(60).
                20 WS-PROFILE-EDU-YEARS PIC X(20).

*> Active profile buffer.  The logged-in user's profile is loaded
*> here before editing, then copied back into WS-PROFILES on save.
01 WS-CURRENT-PROFILE.
    05 WS-CURRENT-PROFILE-USERNAME PIC X(20).
    05 WS-CURRENT-FIRST-NAME PIC X(30).
    05 WS-CURRENT-LAST-NAME PIC X(30).
    05 WS-CURRENT-UNIVERSITY PIC X(60).
    05 WS-CURRENT-MAJOR PIC X(50).
    05 WS-CURRENT-GRAD-YEAR PIC X(4).
    05 WS-CURRENT-ABOUT-ME PIC X(200).
    05 WS-CURRENT-EXPERIENCE-COUNT PIC 9.
    05 WS-CURRENT-EXPERIENCES.
        10 WS-CURRENT-EXPERIENCE OCCURS 3 TIMES.
            15 WS-CURRENT-EXP-TITLE PIC X(50).
            15 WS-CURRENT-EXP-COMPANY PIC X(60).
            15 WS-CURRENT-EXP-DATES PIC X(40).
            15 WS-CURRENT-EXP-DESCRIPTION PIC X(100).
    05 WS-CURRENT-EDUCATION-COUNT PIC 9.
    05 WS-CURRENT-EDUCATION-ENTRIES.
        10 WS-CURRENT-EDUCATION OCCURS 3 TIMES.
            15 WS-CURRENT-EDU-DEGREE PIC X(50).
            15 WS-CURRENT-EDU-UNIVERSITY PIC X(60).
            15 WS-CURRENT-EDU-YEARS PIC X(20).

PROCEDURE DIVISION.
MAIN.
    *> Open the files.
    OPEN INPUT INPUT-FILE
    IF WS-INPUT-STATUS NOT = "00"
        DISPLAY "Could not open InCollege-Input.txt"
        STOP RUN
    END-IF

    OPEN OUTPUT OUTPUT-FILE
    PERFORM LOAD-ACCOUNTS
    *> SCRUM-120: load saved profiles when the program starts.
    PERFORM LOAD-PROFILES

    PERFORM UNTIL WS-END-INPUT = "Y"
        PERFORM SHOW-MENU
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD(1:1) TO WS-CHOICE

            EVALUATE WS-CHOICE
                WHEN "1"
                    PERFORM LOGIN
                WHEN "2"
                    PERFORM CREATE-ACCOUNT
                WHEN OTHER
                    MOVE "Please enter 1 or 2." TO WS-MESSAGE
                    PERFORM SHOW-TEXT
            END-EVALUATE
        END-IF
    END-PERFORM

    MOVE "--- END_OF_PROGRAM_EXECUTION ---" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    CLOSE INPUT-FILE OUTPUT-FILE
    STOP RUN.

SHOW-MENU.
    MOVE "Welcome to InCollege!" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "1. Log In" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "2. Create New Account" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "Enter your choice:" TO WS-MESSAGE
    PERFORM SHOW-TEXT.

CREATE-ACCOUNT.
    IF WS-ACCOUNT-COUNT >= 5
        MOVE "All permitted accounts have been created, please come back later"
            TO WS-MESSAGE
        PERFORM SHOW-TEXT
    ELSE
        MOVE "Please enter your username:" TO WS-MESSAGE
        PERFORM SHOW-TEXT
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD TO WS-USERNAME
            PERFORM FIND-USERNAME

            IF WS-ACCOUNT-FOUND = "Y"
                MOVE "That username already exists, please try again"
                    TO WS-MESSAGE
                PERFORM SHOW-TEXT
            ELSE
                MOVE "Please enter your password:" TO WS-MESSAGE
                PERFORM SHOW-TEXT
                PERFORM READ-INPUT

                IF WS-END-INPUT = "N"
                    PERFORM CHECK-PASSWORD

                    IF WS-PASSWORD-OK = "Y"
                        MOVE INPUT-RECORD TO WS-PASSWORD
                        PERFORM HASH-PASSWORD
                        PERFORM SAVE-ACCOUNT
                        MOVE "Account created successfully" TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                    ELSE
                        MOVE "Password must be 8-12 characters and include a capital letter, digit, and special character"
                            TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                    END-IF
                END-IF
            END-IF
        END-IF
    END-IF.

LOGIN.
    MOVE "N" TO WS-ACCOUNT-FOUND

    PERFORM UNTIL WS-ACCOUNT-FOUND = "Y" OR WS-END-INPUT = "Y"
        MOVE "Please enter your username:" TO WS-MESSAGE
        PERFORM SHOW-TEXT
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD TO WS-USERNAME
            MOVE "Please enter your password:" TO WS-MESSAGE
            PERFORM SHOW-TEXT
            PERFORM READ-INPUT
        END-IF

        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD TO WS-PASSWORD
            PERFORM HASH-PASSWORD
            PERFORM CHECK-LOGIN

            IF WS-ACCOUNT-FOUND = "Y"
                MOVE "You have successfully logged in" TO WS-MESSAGE
                PERFORM SHOW-TEXT
                PERFORM POST-LOGIN-MENU
            ELSE
                MOVE "Incorrect username/password, please try again"
                    TO WS-MESSAGE
                PERFORM SHOW-TEXT
            END-IF
        END-IF
    END-PERFORM.


POST-LOGIN-MENU.
    MOVE "N" TO WS-LOGOUT
    MOVE SPACES TO WS-MESSAGE
    STRING
        "Welcome, " DELIMITED BY SIZE
        WS-USERNAME DELIMITED BY SPACE
        "!" DELIMITED BY SIZE
        INTO WS-MESSAGE
    END-STRING
    PERFORM SHOW-TEXT

    PERFORM UNTIL WS-LOGOUT = "Y" OR WS-END-INPUT = "Y"
        PERFORM SHOW-POST-LOGIN-MENU
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD(1:1) TO WS-POST-LOGIN-CHOICE

            EVALUATE WS-POST-LOGIN-CHOICE
                WHEN "1"
                    MOVE "Job search/internship is under construction."
                        TO WS-MESSAGE
                    PERFORM SHOW-TEXT
                WHEN "2"
                    MOVE "Find someone you know is under construction."
                        TO WS-MESSAGE
                    PERFORM SHOW-TEXT
                WHEN "3"
                    PERFORM SKILL-MENU
                WHEN "4"
                    MOVE "Y" TO WS-LOGOUT
                    MOVE "Y" TO WS-END-INPUT
                WHEN OTHER
                    MOVE "Please enter 1, 2, 3, or 4." TO WS-MESSAGE
                    PERFORM SHOW-TEXT
            END-EVALUATE
        END-IF
    END-PERFORM.

SHOW-POST-LOGIN-MENU.
    MOVE "1. Search for a job" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "2. Find someone you know" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "3. Learn a new skill" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "4. Logout" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "Enter your choice:" TO WS-MESSAGE
    PERFORM SHOW-TEXT.

SKILL-MENU.
    MOVE "N" TO WS-GO-BACK

    PERFORM UNTIL WS-GO-BACK = "Y" OR WS-END-INPUT = "Y"
        PERFORM SHOW-SKILL-MENU
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD(1:1) TO WS-SKILL-CHOICE

            IF WS-SKILL-CHOICE >= "1" AND WS-SKILL-CHOICE <= "5"
                MOVE "This skill is under construction." TO WS-MESSAGE
                PERFORM SHOW-TEXT
            ELSE
                EVALUATE WS-SKILL-CHOICE
                    WHEN "6"
                        MOVE "Y" TO WS-GO-BACK
                    WHEN OTHER
                        MOVE "Please enter a number from 1 to 6."
                            TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                END-EVALUATE
            END-IF
        END-IF
    END-PERFORM.

SHOW-SKILL-MENU.
    MOVE "Learn a New Skill:" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "1. Python" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "2. Java" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "3. Cybersecurity" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "4. Data Science" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "5. Web Development" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "6. Go Back" TO WS-MESSAGE
    PERFORM SHOW-TEXT
    MOVE "Enter your choice:" TO WS-MESSAGE
    PERFORM SHOW-TEXT.

LOAD-ACCOUNTS.
    *> Load saved accounts.
    MOVE 0 TO WS-ACCOUNT-COUNT
    MOVE "N" TO WS-END-ACCOUNTS
    OPEN INPUT ACCOUNT-FILE

    IF WS-ACCOUNT-STATUS = "00" OR WS-ACCOUNT-STATUS = "05"
        PERFORM UNTIL WS-END-ACCOUNTS = "Y" OR WS-ACCOUNT-COUNT >= 5
            READ ACCOUNT-FILE
                AT END
                    MOVE "Y" TO WS-END-ACCOUNTS
                NOT AT END
                    ADD 1 TO WS-ACCOUNT-COUNT
                    MOVE ACCOUNT-RECORD-USERNAME
                        TO WS-SAVED-USERNAME(WS-ACCOUNT-COUNT)
                    MOVE ACCOUNT-RECORD-PASSWORD-HASH
                        TO WS-SAVED-PASSWORD-HASH(WS-ACCOUNT-COUNT)
            END-READ
        END-PERFORM
        CLOSE ACCOUNT-FILE
    END-IF.

SAVE-ACCOUNT.
    *> Save the account.
    ADD 1 TO WS-ACCOUNT-COUNT
    MOVE WS-USERNAME TO WS-SAVED-USERNAME(WS-ACCOUNT-COUNT)
    MOVE WS-PASSWORD-HASH
        TO WS-SAVED-PASSWORD-HASH(WS-ACCOUNT-COUNT)
    MOVE WS-USERNAME TO ACCOUNT-RECORD-USERNAME
    MOVE WS-PASSWORD-HASH TO ACCOUNT-RECORD-PASSWORD-HASH

    OPEN EXTEND ACCOUNT-FILE
    WRITE ACCOUNT-RECORD
    CLOSE ACCOUNT-FILE.


*> ================================================================
*> Epic #2 profile procedures for Divyansh's assigned Jira tasks.
*> These are intentionally modular so the teammates implementing the
*> create/view/menu stories can call them without duplicating logic.
*> ================================================================

LOAD-PROFILES.
    *> SCRUM-120: load saved profiles at startup.
    MOVE 0 TO WS-PROFILE-COUNT
    MOVE "N" TO WS-END-PROFILES
    OPEN INPUT PROFILE-FILE

    IF WS-PROFILE-STATUS = "00" OR WS-PROFILE-STATUS = "05"
        PERFORM UNTIL WS-END-PROFILES = "Y" OR WS-PROFILE-COUNT >= 5
            READ PROFILE-FILE
                AT END
                    MOVE "Y" TO WS-END-PROFILES
                NOT AT END
                    ADD 1 TO WS-PROFILE-COUNT
                    MOVE PROFILE-RECORD
                        TO WS-PROFILE(WS-PROFILE-COUNT)
            END-READ
        END-PERFORM
        CLOSE PROFILE-FILE
    END-IF.

FIND-PROFILE-BY-USERNAME.
    *> SCRUM-88 / SCRUM-118: profiles are linked to account username.
    MOVE "N" TO WS-PROFILE-FOUND
    MOVE 0 TO WS-CURRENT-PROFILE-INDEX

    PERFORM VARYING WS-PROFILE-INDEX FROM 1 BY 1
        UNTIL WS-PROFILE-INDEX > WS-PROFILE-COUNT
        IF WS-USERNAME = WS-PROFILE-USERNAME(WS-PROFILE-INDEX)
            MOVE "Y" TO WS-PROFILE-FOUND
            MOVE WS-PROFILE-INDEX TO WS-CURRENT-PROFILE-INDEX
        END-IF
    END-PERFORM.

LOAD-CURRENT-PROFILE.
    *> SCRUM-88: load the logged-in user's current profile by username.
    PERFORM FIND-PROFILE-BY-USERNAME

    IF WS-PROFILE-FOUND = "Y"
        MOVE WS-PROFILE(WS-CURRENT-PROFILE-INDEX)
            TO WS-CURRENT-PROFILE
    ELSE
        INITIALIZE WS-CURRENT-PROFILE
        MOVE WS-USERNAME TO WS-CURRENT-PROFILE-USERNAME
    END-IF.

SAVE-CURRENT-PROFILE.
    *> SCRUM-89 / SCRUM-92 / SCRUM-119:
    *> - an edited profile replaces the previous in-memory record
    *> - a new profile is added if none exists yet
    *> - username always links the profile to the logged-in account
    MOVE WS-USERNAME TO WS-CURRENT-PROFILE-USERNAME
    PERFORM FIND-PROFILE-BY-USERNAME

    IF WS-PROFILE-FOUND = "Y"
        MOVE WS-CURRENT-PROFILE
            TO WS-PROFILE(WS-CURRENT-PROFILE-INDEX)
    ELSE
        IF WS-PROFILE-COUNT < 5
            ADD 1 TO WS-PROFILE-COUNT
            MOVE WS-PROFILE-COUNT TO WS-CURRENT-PROFILE-INDEX
            MOVE WS-CURRENT-PROFILE
                TO WS-PROFILE(WS-CURRENT-PROFILE-INDEX)
        ELSE
            MOVE "Unable to save another profile." TO WS-MESSAGE
            PERFORM SHOW-TEXT
        END-IF
    END-IF

    IF WS-CURRENT-PROFILE-INDEX > 0
        PERFORM WRITE-ALL-PROFILES
    END-IF.

WRITE-ALL-PROFILES.
    *> SCRUM-119: rewriting the sequential file makes edited records
    *> replace their previous values while preserving the other users.
    OPEN OUTPUT PROFILE-FILE

    PERFORM VARYING WS-PROFILE-INDEX FROM 1 BY 1
        UNTIL WS-PROFILE-INDEX > WS-PROFILE-COUNT
        MOVE WS-PROFILE(WS-PROFILE-INDEX) TO PROFILE-RECORD
        WRITE PROFILE-RECORD
    END-PERFORM

    CLOSE PROFILE-FILE.

EDIT-WORK-EXPERIENCE.
    *> SCRUM-108 / SCRUM-109 / SCRUM-110.
    *> Re-entering this section replaces the user's previous list.
    MOVE 0 TO WS-CURRENT-EXPERIENCE-COUNT
    INITIALIZE WS-CURRENT-EXPERIENCES
    MOVE "N" TO WS-ENTRY-STOP

    PERFORM VARYING WS-ENTRY-INDEX FROM 1 BY 1
        UNTIL WS-ENTRY-INDEX > 3
            OR WS-ENTRY-STOP = "Y"
            OR WS-END-INPUT = "Y"

        MOVE SPACES TO WS-MESSAGE
        STRING
            "Experience #" DELIMITED BY SIZE
            WS-ENTRY-INDEX DELIMITED BY SIZE
            " - Title (or DONE to finish):" DELIMITED BY SIZE
            INTO WS-MESSAGE
        END-STRING
        PERFORM SHOW-TEXT
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            IF FUNCTION UPPER-CASE(FUNCTION TRIM(INPUT-RECORD)) = "DONE"
                MOVE "Y" TO WS-ENTRY-STOP
            ELSE
                MOVE INPUT-RECORD
                    TO WS-CURRENT-EXP-TITLE(WS-ENTRY-INDEX)

                MOVE SPACES TO WS-MESSAGE
                STRING
                    "Experience #" DELIMITED BY SIZE
                    WS-ENTRY-INDEX DELIMITED BY SIZE
                    " - Company/Organization:" DELIMITED BY SIZE
                    INTO WS-MESSAGE
                END-STRING
                PERFORM SHOW-TEXT
                PERFORM READ-INPUT

                IF WS-END-INPUT = "N"
                    MOVE INPUT-RECORD
                        TO WS-CURRENT-EXP-COMPANY(WS-ENTRY-INDEX)

                    MOVE SPACES TO WS-MESSAGE
                    STRING
                        "Experience #" DELIMITED BY SIZE
                        WS-ENTRY-INDEX DELIMITED BY SIZE
                        " - Dates:" DELIMITED BY SIZE
                        INTO WS-MESSAGE
                    END-STRING
                    PERFORM SHOW-TEXT
                    PERFORM READ-INPUT
                END-IF

                IF WS-END-INPUT = "N"
                    MOVE INPUT-RECORD
                        TO WS-CURRENT-EXP-DATES(WS-ENTRY-INDEX)

                    MOVE SPACES TO WS-MESSAGE
                    STRING
                        "Experience #" DELIMITED BY SIZE
                        WS-ENTRY-INDEX DELIMITED BY SIZE
                        " - Description (optional):" DELIMITED BY SIZE
                        INTO WS-MESSAGE
                    END-STRING
                    PERFORM SHOW-TEXT
                    PERFORM READ-INPUT
                END-IF

                IF WS-END-INPUT = "N"
                    MOVE INPUT-RECORD
                        TO WS-CURRENT-EXP-DESCRIPTION(WS-ENTRY-INDEX)
                    ADD 1 TO WS-CURRENT-EXPERIENCE-COUNT
                END-IF
            END-IF
        END-IF
    END-PERFORM

    IF WS-CURRENT-EXPERIENCE-COUNT = 3
        MOVE "Maximum of 3 experience entries reached." TO WS-MESSAGE
        PERFORM SHOW-TEXT
    END-IF.

EDIT-EDUCATION.
    *> SCRUM-113 / SCRUM-114 / SCRUM-115.
    *> Re-entering this section replaces the user's previous list.
    MOVE 0 TO WS-CURRENT-EDUCATION-COUNT
    INITIALIZE WS-CURRENT-EDUCATION-ENTRIES
    MOVE "N" TO WS-ENTRY-STOP

    PERFORM VARYING WS-ENTRY-INDEX FROM 1 BY 1
        UNTIL WS-ENTRY-INDEX > 3
            OR WS-ENTRY-STOP = "Y"
            OR WS-END-INPUT = "Y"

        MOVE SPACES TO WS-MESSAGE
        STRING
            "Education #" DELIMITED BY SIZE
            WS-ENTRY-INDEX DELIMITED BY SIZE
            " - Degree (or DONE to finish):" DELIMITED BY SIZE
            INTO WS-MESSAGE
        END-STRING
        PERFORM SHOW-TEXT
        PERFORM READ-INPUT

        IF WS-END-INPUT = "N"
            IF FUNCTION UPPER-CASE(FUNCTION TRIM(INPUT-RECORD)) = "DONE"
                MOVE "Y" TO WS-ENTRY-STOP
            ELSE
                MOVE INPUT-RECORD
                    TO WS-CURRENT-EDU-DEGREE(WS-ENTRY-INDEX)

                MOVE SPACES TO WS-MESSAGE
                STRING
                    "Education #" DELIMITED BY SIZE
                    WS-ENTRY-INDEX DELIMITED BY SIZE
                    " - University/College:" DELIMITED BY SIZE
                    INTO WS-MESSAGE
                END-STRING
                PERFORM SHOW-TEXT
                PERFORM READ-INPUT

                IF WS-END-INPUT = "N"
                    MOVE INPUT-RECORD
                        TO WS-CURRENT-EDU-UNIVERSITY(WS-ENTRY-INDEX)

                    MOVE SPACES TO WS-MESSAGE
                    STRING
                        "Education #" DELIMITED BY SIZE
                        WS-ENTRY-INDEX DELIMITED BY SIZE
                        " - Years Attended:" DELIMITED BY SIZE
                        INTO WS-MESSAGE
                    END-STRING
                    PERFORM SHOW-TEXT
                    PERFORM READ-INPUT
                END-IF

                IF WS-END-INPUT = "N"
                    MOVE INPUT-RECORD
                        TO WS-CURRENT-EDU-YEARS(WS-ENTRY-INDEX)
                    ADD 1 TO WS-CURRENT-EDUCATION-COUNT
                END-IF
            END-IF
        END-IF
    END-PERFORM

    IF WS-CURRENT-EDUCATION-COUNT = 3
        MOVE "Maximum of 3 education entries reached." TO WS-MESSAGE
        PERFORM SHOW-TEXT
    END-IF.

HASH-PASSWORD.
    *> Epic #1 mentions storing a hashed password.  This is a simple
    *> deterministic course-project hash, not production cryptography.
    MOVE 5381 TO WS-HASH-ACCUM
    COMPUTE WS-PASSWORD-LENGTH =
        FUNCTION LENGTH(FUNCTION TRIM(WS-PASSWORD))

    PERFORM VARYING WS-CHAR-INDEX FROM 1 BY 1
        UNTIL WS-CHAR-INDEX > WS-PASSWORD-LENGTH
        MOVE WS-PASSWORD(WS-CHAR-INDEX:1) TO WS-CHARACTER
        COMPUTE WS-HASH-ACCUM = FUNCTION MOD(
            (WS-HASH-ACCUM * 33) + FUNCTION ORD(WS-CHARACTER),
            1000000000)
    END-PERFORM

    MOVE WS-HASH-ACCUM TO WS-PASSWORD-HASH.

FIND-USERNAME.
    MOVE "N" TO WS-ACCOUNT-FOUND
    PERFORM VARYING WS-ACCOUNT-INDEX FROM 1 BY 1
        UNTIL WS-ACCOUNT-INDEX > WS-ACCOUNT-COUNT
        IF WS-USERNAME = WS-SAVED-USERNAME(WS-ACCOUNT-INDEX)
            MOVE "Y" TO WS-ACCOUNT-FOUND
        END-IF
    END-PERFORM.

CHECK-LOGIN.
    MOVE "N" TO WS-ACCOUNT-FOUND
    PERFORM VARYING WS-ACCOUNT-INDEX FROM 1 BY 1
        UNTIL WS-ACCOUNT-INDEX > WS-ACCOUNT-COUNT
        IF WS-USERNAME = WS-SAVED-USERNAME(WS-ACCOUNT-INDEX)
            AND WS-PASSWORD-HASH =
                WS-SAVED-PASSWORD-HASH(WS-ACCOUNT-INDEX)
            MOVE "Y" TO WS-ACCOUNT-FOUND
        END-IF
    END-PERFORM.

CHECK-PASSWORD.
    *> Check the password rules.
    MOVE "N" TO WS-PASSWORD-OK WS-HAS-CAPITAL WS-HAS-DIGIT WS-HAS-SPECIAL
    COMPUTE WS-PASSWORD-LENGTH = FUNCTION LENGTH(FUNCTION TRIM(INPUT-RECORD))

    IF WS-PASSWORD-LENGTH >= 8 AND WS-PASSWORD-LENGTH <= 12
        PERFORM VARYING WS-CHAR-INDEX FROM 1 BY 1
            UNTIL WS-CHAR-INDEX > WS-PASSWORD-LENGTH
            MOVE INPUT-RECORD(WS-CHAR-INDEX:1) TO WS-CHARACTER

            EVALUATE TRUE
                WHEN WS-CHARACTER >= "A" AND WS-CHARACTER <= "Z"
                    MOVE "Y" TO WS-HAS-CAPITAL
                WHEN WS-CHARACTER >= "0" AND WS-CHARACTER <= "9"
                    MOVE "Y" TO WS-HAS-DIGIT
                WHEN WS-CHARACTER >= "a" AND WS-CHARACTER <= "z"
                    CONTINUE
                WHEN OTHER
                    MOVE "Y" TO WS-HAS-SPECIAL
            END-EVALUATE
        END-PERFORM
    END-IF

    IF WS-PASSWORD-LENGTH >= 8 AND WS-PASSWORD-LENGTH <= 12
        AND WS-HAS-CAPITAL = "Y"
        AND WS-HAS-DIGIT = "Y"
        AND WS-HAS-SPECIAL = "Y"
        MOVE "Y" TO WS-PASSWORD-OK
    END-IF.

READ-INPUT.
    READ INPUT-FILE
        AT END
            MOVE "Y" TO WS-END-INPUT
        NOT AT END
            MOVE INPUT-RECORD TO WS-MESSAGE
            PERFORM SHOW-TEXT
    END-READ.

SHOW-TEXT.
    DISPLAY FUNCTION TRIM(WS-MESSAGE)
    MOVE WS-MESSAGE TO OUTPUT-RECORD
    WRITE OUTPUT-RECORD
    MOVE SPACES TO WS-MESSAGE.
