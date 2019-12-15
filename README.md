# Sudoku-Solver

Introduction

This is Sudoku Solver program written in LISP programming language.
Two algorithms are implemented - 1) Depth First Search
                                 2) Breadth First Search
                                 
Code returns 9 x 9 solution matrix to given input puzzle, number of states expanded during search, maximum stack/queue size, run time, memory used in bytes (requires linux system to display memory usage). 
If no solution is found, then program will report so displays partially solved puzzle. 
Invalid puzzles are not processed.

How to run the code?

Put all test file, Sudoku.lisp, gcl.exe in same folder.
Method 1 : Input puzzle given in get-board function of Sudoku.lisp
           Run below commands in gcl.exe
           - (load "Sudoku.lisp")
           - (setq board (get-board))
           - (solve-board board 'Solver) 			         - where Solver is bfs-solve or dfs-solve
           
Method 2 : Input puzzle given in seaparate test file
           Run below commands in gcl.exe
           - (load "Sudoku.lisp")
           - (solve-from-file  "filepath/filename.lisp" 'Solver')        - where Solver is bfs-solve or dfs-solve
