# Epic 3 task notes

These are Allen Nguyen's open developer subtasks from Jira on September 21, 2026.

| Jira tasks | What changed |
| --- | --- |
| SCRUM-143 through SCRUM-146 | The saved profile loads and shows all basic and optional fields. |
| SCRUM-148 through SCRUM-150 | The profile has the required `==== Profile for ...` header and clear Experience and Education sections. |
| SCRUM-153 through SCRUM-156 | Search reads the full name from the input file and checks saved profiles for an exact match. |
| SCRUM-158 through SCRUM-161 | A matching saved profile is shown with the same formatting and mirrored to the output file. |

`verify_epic3.py` checks those features with a real compiled COBOL program. It uses temporary files so saved accounts from one test do not affect another folder. The program code stays in `InCollege.cob`.
