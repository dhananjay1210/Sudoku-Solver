## Sudoku-Solver

#Introduction

This is Sudoku Solver program written in LISP programming language.<br />
Two algorithms are implemented - <br />
1) Depth First Search<br />
2) Breadth First Search<br />
                                 
Code returns 9 x 9 solution matrix to given input puzzle, number of states expanded during search, maximum stack/queue size, run time, memory used in bytes (requires linux system to display memory usage). <br />
If no solution is found, then program will report so displays partially solved puzzle. <br />
Invalid puzzles are not processed.<br />

#How to run the code?

Put all test file, Sudoku.lisp, gcl.exe in same folder.<br />
Method 1 : Input puzzle given in get-board function of Sudoku.lisp<br />
           Run below commands in gcl.exe<br />
           - (load "Sudoku.lisp")<br />
           - (setq board (get-board))<br />
           - (solve-board board 'Solver) 			         - where Solver is bfs-solve or dfs-solve<br />
<br />
Method 2 : Input puzzle given in seaparate test file<br />
           Run below commands in gcl.exe<br />
           - (load "Sudoku.lisp")<br />
           - (solve-from-file  "filepath/filename.lisp" 'Solver')        - where Solver is bfs-solve or dfs-solve<br />
