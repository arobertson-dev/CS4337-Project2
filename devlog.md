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












































