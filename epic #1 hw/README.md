# Epic #1 Homework

This folder contains the InCollege program and the test cases for the first four
user stories.

## Run the program like the class slides

1. Start Docker Desktop.
2. Open the repository in VS Code.
3. Open a new terminal and go to the `epic #1 hw` folder.
4. Compile the program:

```sh
cobc -x -o InCollege InCollege.cob
```

5. Put the test actions in `InCollege-Input.txt`.
6. Run the program:

```sh
./InCollege
```

The program reads from `InCollege-Input.txt`. It shows the output on the screen
and saves the same output in `InCollege-Output.txt`. New accounts are saved in
`accounts.dat` so they can be used after the program restarts.

## Test files

The `tests` folder contains a short test report. Each story has one ZIP file for
its test inputs and one ZIP file for the actual outputs made by the program.
These names follow the Epic #1 assignment instructions.

To verify a test, run the program and compare the screen output with the output
file:

```sh
./InCollege | tee Screen-Output.txt
cmp Screen-Output.txt InCollege-Output.txt
```

If `cmp` shows nothing, the two outputs are identical.
