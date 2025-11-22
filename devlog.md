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


