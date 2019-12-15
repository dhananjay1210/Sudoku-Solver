;; Created by - Dhananjay Sonawane

;; This program provides the functions necessary to solve Sudoku

;; When running your final program to gather the data for HW questions 3, you 
;; must use the Solve-from-file function provided at the bottom of the file. 
;; You must also use the five provided input files to collect the necessary
;; data. 

; the size of the board
(defparameter board-size 9)

; the number of rows
(defparameter rows 9)

;the number of columns
(defparameter cols 9)

;the number of states expanded
(defvar num-states-expanded)

;the number of states on stack
(defvar num-states-onstack)


; returns the initial board
(defun get-board () 
  '((0 1 0 0 0 9 3 8 0)
    (4 7 2 0 5 0 1 0 9)
    (3 9 0 1 7 6 2 4 5)
    (7 4 6 0 0 1 5 9 8)
    (5 2 1 9 8 0 6 7 3)
    (9 8 0 7 6 5 4 1 2)
    (8 6 7 5 4 0 9 3 1)
    (1 5 4 3 9 7 8 2 6)
    (2 3 9 6 1 8 7 5 4)))


;loads a board from the given file , it expects the board to be in the format given in get-board
(defun get-board-from-file (file)
  (let ((in (open file :if-does-not-exist nil)))
    (when in  (return-from get-board-from-file (read in)))
    (when (not in) (format t "Unable to open file ~A" file))
    )
  )


; print the given board
(defun print-board (board) 
    (dotimes (r board-size)
    (format t "~%+---+---+---+---+---+---+---+---+---+~%|")
    (dotimes (c board-size)
      (format t " ~A |" (get-value board r c))))
  (format t "~%+---+---+---+---+---+---+---+---+---+~%~%"))



;returns the value of the array location row , col does bound checking
(defun get-value (array row col)
  ;check the bounds
  (if (not (and (< row  rows) (< col cols))) NIL (nth col (nth row array)))
  ); end of function

;sets the given position in the array to the given value , is bounds checked
(defun set-value (array row col value)
  ;check the bounds
  (if (not (and (< row  rows) (< col cols))) NIL (setf (nth col (nth row array)) value ))
  ); end of function

;returns a list containing the first empty cell in the format row, column
(defun get-first-empty (board)
  (do
   (
    (i 0 (+ i 1)) ;the outer loop index
    (result NIL) ; the result to be returned
    (cell-found? NIL)) ; control variable to terminate the loops)

    ((or (>= i rows) cell-found?) result) ;return the result if cell-found? is true or we have examined all rows 
    
    ;outer loops main body
    (do
     ((j 0 (+ j 1))) ; the inner loop index
     ((or (>= j cols) cell-found?) ) ; if the cell has  been found or we have examined all columns in the row exit the loop
     
     ; inner loops main body
     (if (= (get-value board i j) 0) (and (setf cell-found? T) (setf result (list i j)))) ; we use the and here so that we can set the cell-found? variable as 
					                                             ; set the result to the proper value, remember if allows only one 
                                                                                     ; S expression in the action part
     ); end of inner do
    ); endof outer do
); end of function


;returns T if the given board is complete else return NIL
(defun is-complete? (board)
  (if (get-first-empty board) NIL T)) ; if there is no cell to fill then the board is complete otherwise not


;remove the numbers which occur in the given row from the array of given numbers
(defun exclude-rownums (board row col possiblenums)
  (do
   ((i 0 (+ i 1))) ; the index
   ((>= i cols)) ; termination test
   (let 
       ((number (get-value board row i)))
     (if (> number 0) (setf (aref possiblenums (- number 1)) 0))
     ); end of let
   ); end of do
  ); end of function


 ;remove the numbers which occur in the given column from the array of given numbers
(defun exclude-colnums (board row col possiblenums)
  (do
   ((i 0 (+ i 1))) ; the index
   ((>= i rows)) ; termination test
   (let 
       ((number (get-value board i col)))
     (if (> number 0) (setf (aref possiblenums (- number 1)) 0))
     ); end of let
   ); end of do
  ); end of function


; remove the numbers which occur in the region from the array of given numbers
(defun exclude-regions (board row col possiblenums)
  (do
   (
    (rowbase (truncate row 3))
    (colbase (truncate col 3))
    (i 0 (1+ i)))
    ((>= i 3))
    (do
     ((j 0 (1+ j)))
     ((>= j 3))
     (let 
	 ((number (get-value board (+ (* 3 rowbase) i) (+ (* 3 colbase) j))))
       (if (> number 0) (setf (aref possiblenums (- number 1)) 0))
       ); end of let
     ); end of inner do
    ); end of outer do
  ); end of function



; return the list of possible numbers that can occupy a given cell
(defun get-possible-numbers (board row col)
  (let (
	(possible-numbers (make-array (list board-size) 
				      :initial-contents '(1 2 3 4 5 6 7 8 9)))
	); end of varibale declaration of let
    (exclude-rownums board row col possible-numbers) ; exclude numbers which occur in the row
    (exclude-colnums board row col possible-numbers) ; exclude numbers which occur in the column
    (exclude-regions board row col possible-numbers) ; exclude numbers which occur in the region
    
    ;debug
    ;(format T "~A" possible-numbers)
    
    ; now return the list of possible numbers
    (do 
     (
      (i 0 (+ i 1)) ; the index
      (result NIL)) ; the return value
     ((>= i board-size) result) ; the termination condition
     
     (if (> (aref possible-numbers i) 0) (setf result (append result (list (aref possible-numbers i)))) );if the given posiiton in the array is not 0 then append  
     ); end of do
    ); end of let
  ); end of function




;returns a list of all possible successor states of a given state, computes the successors by filling in all possible values for the first empty cell
(defun get-successors (board)
  (if (is-complete? board) NIL ; if the given board is complete return NIL else proceed 
    (let* ; note the use of let* as we need the value of row and col in the initialization of values
	(
	 (row (first (get-first-empty board)))
	 (col (second (get-first-empty board)))
	 (values (get-possible-numbers board row col))
	 (ret NIL)
	 (temp NIL)
	 )
      
      (dolist (val values ret)
	      (setf temp (copy-tree board)) 
	      (set-value temp row col val) ; create the board resulting from applying the current value to the existing board
	      (setf ret (append ret (list temp)))
	      ); end of do list
      ); end of let
    );end of if
  ); end of function


	 
	 
;solves the given board using DFS
(defun DFS-Solve (board)
;; You are to write this function
	
	;;Initialize num-states-expanded,num-states-onstack
	(setf num-states-expanded 0)
	(setf num-states-onstack 0)
	(setf invalid 0)
	(setf row-count 0)
	(setf stack nil)
	
	;; check size of board
	(dolist (row board)
		(if (not (equal (length row) 9))
			(setf invalid 1)
		)
		(setf row-count (+ row-count 1))
	)
	(if (not (equal row-count 9))
		(setf invalid 1)
	)
	(if (equal invalid 1)
		(setf invalid 1)
		(progn
			;; check for row wise validity given array Ex. Row of the form (1 1 4 0 0 0 0 0 0) is invalid
			(dolist (row board) 
				(setf hs (make-array '(9)))
				(setf (aref hs 0) 0)
				(setf (aref hs 1) 0)
				(setf (aref hs 2) 0)
				(setf (aref hs 3) 0)
				(setf (aref hs 4) 0)
				(setf (aref hs 5) 0)
				(setf (aref hs 6) 0)
				(setf (aref hs 7) 0)
				(setf (aref hs 8) 0)
				(dolist (num row)
					(if (and (> num 0) (equal (aref hs (- num 1)) 1))
						(setf invalid 1)
						;(write 'Invalid-board-given) 
					)
					(if (> num 0)
						(setf (aref hs (- num 1)) 1)
					)
				)
			)
			
			;; check for col wise validity given array Ex. Column of the form (1 1 4 0 0 0 0 0 0) is invalid
			(dotimes (col cols) 
				(setf hs (make-array '(9)))
				(setf (aref hs 0) 0)
				(setf (aref hs 1) 0)
				(setf (aref hs 2) 0)
				(setf (aref hs 3) 0)
				(setf (aref hs 4) 0)
				(setf (aref hs 5) 0)
				(setf (aref hs 6) 0)
				(setf (aref hs 7) 0)
				(setf (aref hs 8) 0)
				(dotimes (row rows)
					(setf num (get-value board row col))
					(if (and (> num 0) (equal (aref hs (- num 1)) 1))
						(setf invalid 1)
						;(write 'Invalid-board-given) 
					)
					(if (> num 0)
						(setf (aref hs (- num 1)) 1)
					)
				)
			)
			
			;; check for region wise validity given array Ex. Region of thr form  (1 0 3)  is invalid.
			;;                                                                    (1 0 0)
			;;                                                                    (8 7 0)
			(dotimes (ri 3)
				(dotimes (rj 3)
					(setf hs (make-array '(9)))
					(setf (aref hs 0) 0)
					(setf (aref hs 1) 0)
					(setf (aref hs 2) 0)
					(setf (aref hs 3) 0)
					(setf (aref hs 4) 0)
					(setf (aref hs 5) 0)
					(setf (aref hs 6) 0)
					(setf (aref hs 7) 0)
					(setf (aref hs 8) 0)
					(dotimes (i 3)
						(dotimes (j 3)
							(setf num (get-value board (+ (* ri 3) i) (+ (* rj 3) j)))
							(if (and (> num 0) (equal (aref hs (- num 1)) 1))
								(setf invalid 1)
								;(write 'Invalid-board-given) 
							)
							(if (> num 0)
								(setf (aref hs (- num 1)) 1)
							)
						)
					)
				)
			)
		)
	)
	;; Initialize stack
	(setf num-states-expanded 0)
	(setf num-states-onstack 1)
	(setf curr-board nil)
	(setf scc nil)
	
	(push board stack)
	
	(if (equal invalid 1)
		(progn
			(format t "Invalid-board-given")
			(setf stack nil)
		)		
	)
	
	;; Main DFS
	(loop
		(when (equal stack nil) (return nil))
		(setf curr-board (pop stack))		
		(setf scc (get-successors curr-board))
		
		(if (equal scc nil)
		    (if (equal (is-complete? curr-board) 'T)
				
				;(format t "Given board is not solvable" )
				(return curr-board)
				(if (equal stack nil)
					(progn
						(format t "No solution found.")
						(return curr-board)
					)
				)
			)
		)
			
		(setf num-states-expanded (+ num-states-expanded 1))
		
		(dolist (state scc) 
			(push state stack)
		)
		(setf num-states-onstack (max num-states-onstack (length stack)))
    )
  ); end of function


;solves the given board using BFS
(defun BFS-Solve (board)
;; You are to write this function
	;;Initialize num-states-expanded,num-states-onstack
	(setf num-states-expanded 0)
	(setf num-states-onstack 0)
	(setf invalid 0)
	(setf row-count 0)
	(setf q nil)
	
	;; check size of board
	(dolist (row board)
		(if (not (equal (length row) 9))
			(setf invalid 1)
		)
		(setf row-count (+ row-count 1))
	)
	(if (not (equal row-count 9))
		(setf invalid 1)
	)
	
	(if (equal invalid 1)
		(setf invalid 1)
		(progn
			;; check for row wise validity given array Ex. Row of the form (1 1 4 0 0 0 0 0 0) is invalid
			(dolist (row board) 
				(setf hs (make-array '(9)))
				(setf (aref hs 0) 0)
				(setf (aref hs 1) 0)
				(setf (aref hs 2) 0)
				(setf (aref hs 3) 0)
				(setf (aref hs 4) 0)
				(setf (aref hs 5) 0)
				(setf (aref hs 6) 0)
				(setf (aref hs 7) 0)
				(setf (aref hs 8) 0)
				(dolist (num row)
					(if (and (> num 0) (equal (aref hs (- num 1)) 1))
						(setf invalid 1)
						;(write 'Invalid-board-given) 
					)
					(if (> num 0)
						(setf (aref hs (- num 1)) 1)
					)
				)
			)
			
			;; check for col wise validity given array Ex. Column of the form (1 1 4 0 0 0 0 0 0) is invalid
			(dotimes (col cols) 
				(setf hs (make-array '(9)))
				(setf (aref hs 0) 0)
				(setf (aref hs 1) 0)
				(setf (aref hs 2) 0)
				(setf (aref hs 3) 0)
				(setf (aref hs 4) 0)
				(setf (aref hs 5) 0)
				(setf (aref hs 6) 0)
				(setf (aref hs 7) 0)
				(setf (aref hs 8) 0)
				(dotimes (row rows)
					(setf num (get-value board row col))
					(if (and (> num 0) (equal (aref hs (- num 1)) 1))
						(setf invalid 1)
						;(write 'Invalid-board-given) 
					)
					(if (> num 0)
						(setf (aref hs (- num 1)) 1)
					)
				)
			)
			
			;; check for region wise validity given array Ex. Region of thr form  (1 0 3)  is invalid.
			;;                                                                    (1 0 0)
			;;                                                                    (8 7 0)
			(dotimes (ri 3)
				(dotimes (rj 3)
					(setf hs (make-array '(9)))
					(setf (aref hs 0) 0)
					(setf (aref hs 1) 0)
					(setf (aref hs 2) 0)
					(setf (aref hs 3) 0)
					(setf (aref hs 4) 0)
					(setf (aref hs 5) 0)
					(setf (aref hs 6) 0)
					(setf (aref hs 7) 0)
					(setf (aref hs 8) 0)
					(dotimes (i 3)
						(dotimes (j 3)
							(setf num (get-value board (+ (* ri 3) i) (+ (* rj 3) j)))
							(if (and (> num 0) (equal (aref hs (- num 1)) 1))
								(setf invalid 1)
								;(write 'Invalid-board-given) 
							)
							(if (> num 0)
								(setf (aref hs (- num 1)) 1)
							)
						)
					)
				)
			)
		)
	)
	
	;; Initialize
	(setf num-states-expanded 0)
	(setf num-states-onstack 1)
	(setf curr-board nil)
	(setf q '())
	(setf scc nil)
	
	(setf q (append q (list board)))
	
	(if (equal invalid 1)
		(progn
			(format t "Invalid-board-given")
			(setf q nil)
		)		
	)
	
	;; Main BFS
	(loop
		(when (equal q nil) (return nil))
		(setf curr-board (car q))
		(setf q (cdr q))
		
		(setf scc (get-successors curr-board))
		
		(if (equal scc nil)
		    (if (equal (is-complete? curr-board) 'T)
				(return curr-board)
				
				(if (equal q nil)
					(progn
						(format t "No solution found.")
						(return curr-board)
					)
				)
			)
		)
			
		(setf num-states-expanded (+ num-states-expanded 1))
		
		(dolist (state scc) 
			(setf q (append q (list state)))
		)
		(setf num-states-onstack (max num-states-onstack (length q)))
    )

  ); end of function
  
     
     
;solves the given board using the given solver
; To use this fuction: (solve-board board 'Solver) 
; where Solver is either DFS-Solve or BFS-solve.
(defun solve-board (board solver)
 (let 
     ((answer (funcall solver board)))
   (cond (answer  (print-board answer) (format t "Number of states expanded ~A, maximum number of states on stack ~A" num-states-expanded num-states-onstack))
 )
)
)



;solves the first puzzle in the given file
; To use this fuction: (solve-from-file "Filepath/filename.lisp" #'Solver) 
; where Solver is either DFS-Solve or BFS-solve.
(defun solve-from-file (file solver)
  (time (solve-board (get-board-from-file file) solver))
  )
  