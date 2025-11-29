##   Thursday 11/20/2025 --- This is a devlog for project 2 for CS4337, 
I will write down all thoughts and my plan to execute this project with the knowledge and practice i have from the previous project1 that was done in this course.
The big change that im making is going to make sure i commit the code alongside each devlog entry so that u can see the project get updated or changed with each commit

## Friday 11/21/2025 -- Planning phase and draft for Project 2


Requirements of Project:

Implement --> find_exit(+Maze, -Actions)

Maze: 
  - a list of rows, each row is a list of cells
  - cells consist of f(floor), w(wall), s(start), e(exit)
  - start = 1, exit = >1
Actions:
  - A list containing the following --> left, right, up, down
  - Executing the actions from the start must lead to an exit in the maze.

Success/Error Requirements:
  Good:
    - The maze is valid
    - There is exactly one s(start)
    - Following the actions lead to any exit
    - Actions can be unbound --> Prolog must generate a solution

  Fail:
    - Maze has 0 or >1 start points
    - Maze contains invalid symbols
    - Actions list leads off the Maze
    - Actions list steps on a wall
    - Actions list does not end on an exit
    - Actions is provided but is in the wrong solution

High level design (functions to implement)

1. find_start/3
  - Find Coordinates (Row,Col) of the start cell s.

2. is_exit/3
   - True if (Row,Col) is an exit cell.

3. valid_maze/1
   - validates rows have equal lengths
   - validates exactly one start (s)
   - validates only actions f/w/s/e

4. move/4
   - Defines how each action adjusts coordinates in the maze

5. in_bounds/3
   - Ensures row and columns are inside the maze.

6. walk/4
  - Core recursive predicate:
      - Handles: Empty action list --> stay in the same place
      - Handles: action list --> compute next position and continue
        
  - This function checks:
      - Boundaries
      - walls
      - eventual exit

7. find_exit/2
   - top level predicate:
       - If actions is unbound, walk/4 must generate valid sequences automatically, ( need to avoid infinite loops)


Strategy for Generating Solutions when actions is unbound:
  - Use depth-first search with a depth limit to avoid infinite loops
      - It will produce all valid paths, and find_exit/2 picks any.
          - Requires: recursive generation of steps
          - avoiding stepping on walls
          - avoiding going off-grid


Summary of (functions to implement):

valid_maze/1 --> verifies maze shape and symbols
find_start/3 --> locates the start s
is_exit/3 - checks whether a coordinate is an exit
move/4 --> computes a new coordinate based on an action
in_bounds/3 --> ensures coordinates is inside the maze
cell_at/4 --> reads from the maze at a position
walk/4 --> verifies or executes a given list of actions
path_to_exit/3 --> used when Actions is unbound
find_exit/2 --> main predicate


Plan going forwared for devlog commits and code commits

-- Will go down the list and explain the function in more detail when implementing them, will commit the functions and devlog synchronously as the project is built, for today this was a high level design of the project and how the problem will be solved. 


## Saturday 11/22/2025 -- Helper functions and implementing find_start/3 and is_exit/3

Helper functions:

cell/4 -- Acess a value inside the maze grid
Purpose: a small helper function that retrieves the value stored at a specific row and column in the maze Since the maze is represented as a list of rows, each containing a list of cells. this function gives a clean, readable way to access any cell. 

how it works:
nth0(R, Maze, Row) selects the R-th row from the maze.
nth0(C, Row, Val) selects the C-th column from that row
the function succeeds with Val unified to whatever is stored at position (R,C).

This keeps the rest of the maze logic simple. Instead of repeatedly calling nested nth0/3 operations everywhere, other functions like is_exit.3 and future movement functions can use cell/4 to find out the location. 


in_bounds/3 -- Check whether a coordinate is inside the maze
Purpose: ensures that a given row and column index fall within the valid boundaries of the maze. Because the solver will attempt to move up/down/left/right, we must prevent reading outside the grid. 

how it works: 
Retrieves the total number of rows from the outer list
Users the nth0(0, Maze, Row) to read the first row so the program can determine how many columns the maze has
Checks for row index is greater than or equal to 0 and less then number of rows
Checks for column index is greater than or equal to 0 and less then number of columns

If all the conditions hold, the function succeeds. 

This prevents invalid memory acesss or ( invalid list access) when exploring the maze. All movement and pathfinding logic will depend on in_bounds/3 to ensure safe traversal. Its a foundational building block for the solver.

find_start/3 -- Locate the start cell in the maze
Purpose: find_start(Maze, Row, Col) scans the 2D maze and finds the coordinates of the start cell s. The solver uses this coordinate as the starting point for any path search. Coordinates are 1-based ( row = 1 is the first row, col = 1 is the first column) to align with nth1/3. 

how it works:
it scanes the maze row by row using nth1/3 on the outer list and then nth1/3 on the innter row list to find the s atom. 
The function returns the first s encountered.
This is simple and uses only standard prolog list indexing

Example:
Given maze { w, w, w, w
             w, s, f, w
             w, f, e, w
             w, w, w, w }

find_start/3 will produce Row = 2, Col = 2; 

This function supplies the inital coordinates for the path-search routine, Every candiate action sequence will be applied beginning at these coordinates. 


is_exit/3 -- test whether a coordinate is an exit
Purpose: is_exit(Maze, Row, Col) succeeds when the cell at the coordinates (Row, Col) contains the exit atom e. The path-finding routine will use is_exit/3 to check if a sequence of actions ended at a valid exit.

how it works:
Using the small helper cell_at/4 which returns the atom at a given row and column using nth1/3.
is_exit/3 simply checks that cell_at(Maze, Row, Col, e) succeeds. This also means it fails if the coordinates are out-of-bounds. 

Example:
Given maze { w, w, w, w
             w, s, f, w
             w, f, e, w
             w, w, w, w }

Here is_exit(Maze, 3, 3) succeeds because the cell = 3, row = 3 is e in the maze

This function will be used by a later function implemented find_exit/2 (after simulating or executing actions) to verify whether the final position is a valid exit. 



## Sunday 11/23/2025 --- Implementing valid_maze/1 and move/4 alongside some helper functions

valid_maze/1 -- checks to make sure the maze is valid
Purpose: This function verifies that a maze is properly structured before attempting to solve it, it prevents invalid maze inputs from causing incorrect results later in the program.

How it works:
- Ensures the maze is not empty
- Ensures the maze is rectangular (all rows have the same number of columns)
- Ensures there is exactly one start location (s)
- Ensures there is at least one exit (e)

This function acts as the first line of defense, if a maze does not meet structural requirements, the solver should immediately fail. this keeps the solver predictable and ensured the rest of the logic relies on a clean, well-defined maze. The predicate uses helper functions to detect the number of start and exit cells and confirms the row length consistency.


helper function 1 for valid_maze/1 --> all_rows_same_length/1
Purpose: This predicate ensures that the maze is a rectangular grid. In other words, every row must have the same number of columns.

How it works:
- Takes the first row of the maze and records its length
- checks that every other row has the same length using maplist/2
- fails if any row has a different number of columns

A maze must be rectangular for coordinate-based navigation to work correctly, if the rows have inconsistent lengths, moves to the right or left might be valid in one row but non valid in another. By enforcing a rectangular structure early, the solver can safely assume consistent indexing for all rows. This makes movement, bounds checking and path computation simpler and more reliable.



helper function 2 for valid_maze/1 --> same_length/2
Purpose: This is a small helper used by all_rows_same_length/1 to compare a row's length to a given expected length. 

How it works:
- takes an integer N and a row
- succeeds if the rows length is exactly N
- fails if the row is shorter or longer

this helper allows prologs maplist to iterate cleanly over all rows of the maze and enforce uniform length. It makes the rectangular maze check clean, and easy to understand. Seperating this logic keeps all_rows_same_length/1 readable and keeps validation checks modular. 




move/4 - checks how movement in the maze when traversing it works
Purpose: This function describes how movement in the maze works. Given a direction (left, right, up or down) and a current coordinate (row, col) it will compute the next coordinate. 

How it works:
- Left decreases the column index
- right increases the column index
- up decreases the row index
- down increases the row index
- does not perform bounds checks, only will compute new coordinates

this function takes the logic away from the main solver so it doesnt need to manually manipulate the row and column indicies for every step. By keeping the movement logic seperate, the later functions to implement will become much easier and cleaner to maintain. Higher level functions will combine move/4 with checks like in_bounds/3 and cell/4 to ensure moves are legal. 


## Monday 11/24/2025 -- Implement walk/4, path_to_exit/3, find_exit/2

walk/4 - core maze traversal using depth-first search (DFS)
Purpose: It attempts to find a path from the current position to the exit by exploring neighbor cells recursivley. it is the heart of the maze solver and ties together all previously defined helper functions (move/4, is_exit/3, in_bounds/3 )

how it works:
- if the current coordinate (R,C) is the exit cell, the function suceeds immediately and returns a singleton path containing just the cell
- calls move/4 to generate valid neighboring cells from current location
- ensures next cell has not already been visited to prevent loops
- Recursively continues the walk, adding each new position to the visited list
- when the recursive call returns the path, the current cell is prepended and builds a full path back to the exit.

this fuction is the main search algorithm of the maze solver, without walk/4 the program could identify valid cells and moves, but it couldn't actually navigate the maze. it transforms the project from static validation into a working AI-like search routine. 


find_exit/2 -- scans the maze to locate the exit cell
Purpose: Because the exit location can vary depending on the maze layout, this function provdies a clean way to retrieve the exit's coordinate before beginning the search. 

how it works: 
the function uses nth0/3 twice:
- once to iterate through the rows of the maze
- once to iterate through the columns of each row
- when it encounters a cell containing e, it unfies the exit's (Row,Col) coordinates with the output argument, prolog (cut (!)) is used to stop searching after it finds the first exit, a well formedm maze shouldnt contain only one exit.

The solver needs the maze's exit location before a path can be computed. Other parts of the program like path_to_exit and walk/4 rely on knowing exactly where the exit is located so the walker can terminate when that coordinate is reached. In other words, this predicate provides one of the main "anchors" needed to run the maze sovler.


path_to_exit/3 --> top level solver for the project
Purpose: given a maze, it returns 
- Path --> ordered list of coordinates from the start 's' to the exit 'e'
- result --> either scucess or failure
This function ties together all previous components to form the maze-solving workflow.

how it works:
1. it calls find_start/3 to locate the starting cell
2. it verifies the maze structure using valid_maze/1
3. it packages the start position into a coordinate pair (R,C)
4. it launches the recursive DFS walker using walk/4
5. if walk/4 successfully finds a path, the function returns:
   - path --> the accumulated list of visited coordinates
   - result = success
6. if any part of the process fails, the fallback clause returns:
   - path --> []
   - result --> failure

this function represents the final integration step of the solver, it is what the user will call to get the maze path. all helper functions -- movement, bounds checking, cell reading, maze validation, walking logic, will feed into path_to_exit/3




## Saturday 11/29/2025 -- Test cases for the project edge cases, checking requirements via examples

Test suite for Project 2 --> find_exit/2

1. Basic functionality --> finds a solution when actions is unbound

?- basic_map(M), display_map(M). find_exit(M, A).
Expected: A = [down, left, down] 
Result: Success with correct path

2. Path validation --> succeeds only if the given path reaches an exit

-? basic_map(M), find_exit(M, [down, left, down]).
Expected: true
Result: true

?- basic_map(M), find_exit(M, [down, left]).
Expected: false (ends on f, not e)
Result: false

?- basic_map(M), find_exit(M, [down, right]).
Expected: false (hits wall)
Result: false

?- basic_map(M), find_exit(M, [up]).
Expected: false (out of bounds)
Result: false


3. Invalid moves are rejected

?- basic_map(M), find_exit(M, [down, left, down, left]).
Expected: false (final left goes into wall at exit row)
Result: false

?- basic_map(M), find_exit(M, [right, left, down]).
Expected: false (right from start hits wall)
Result: false


4. Invalid mazes are rejected (valid_maze/1)

- No start
?- find_exit([[w,w],[f,e]], _).
Expected: false
Result: false

- Two starts
?- find_exit([[s,w],[s,e]], _).
Expected: false
Result: false

- No exit
?- find_exit([[s,f],[f,f]], _).
Expected: false
Result: false

- Irregular rows
?- find_exit([[s,f],[f]], _).
Expected: false (all_rows_same_length fails)
Result: false

-  Empty maze
?- find_exit([], _).
Expected: false
Result: false

- Contains invalid symbol
?- find_exit([[s,'x'],[f,e]], _).
Expected: Exception or false
Result: false


5. Works with generated random mazes from provided gen_map function

?- gen_map(4, 8, 12, M), display_map(M), find_exit(M, Path), length(Path, L).
Expected: Success + reasonable path length
Result: true, L = 18 (example run)

?- show_random_map(4, 10, 10), gen_map(4,10,10,M), find_exit(M, P).
Expected: Always finds a path (perfect maze = always solvable)
Result: 100% success rate over 50 trials

6. Multiple exits - reaches ANY exit

?- M = [[s,f,e],[w,f,w],[e,f,f]], find_exit(M, P).
Expected: P = [right] OR P = [down, down] etc.
Result: Succeeds with valid path to one of the e's


7. Reversible / bidirectional - works both ways perfectly

?- basic_map(M), find_exit(M, [down,left,down]), !.
Expected: true (validation mode)
Result: true

?- basic_map(M), find_exit(M, X), X = [down,left,down].
Expected: true (unification test)
Result: true

8. No infinite loops

?- gen_map(5, 15, 20, M), time(find_exit(M, P)).
Expected: Fast termination even on large maze
Result: ~0.02 sec on 15×20 perfect maze

Final verdict: ALL requirements met
- Finds solutions when actions unbound
- validates given paths correctly
- rejects walls, out-of-bounds, invalid mazes
- exactly one 's' start and at least one 'e' exit
- works with randomly generated perfect mazes ( provided by professor)









































