
% Project 2: Maze Solver


% cell(+Maze, +Row, +Col, -Value)
% Retrieves the value of a cell at (Row, Col) in the maze.
cell(Maze, R, C, Val) :-
    nth0(R, Maze, Row),   % Get the R-th row
    nth0(C, Row, Val).    % Get the C-th column in that row


% in_bounds(+Maze, +Row, +Col)
% Checks if (Row, Col) is within the maze boundaries.
in_bounds(Maze, R, C) :-
    length(Maze, NumRows),
    R >= 0, R < NumRows,
    nth0(0, Maze, Row),
    length(Row, NumCols),
    C >= 0, C < NumCols.


% move(+Direction, +Row, +Col, -NewPos)
% Computes new coordinates after moving in a direction.
move(left,  R, C, (R, C2)) :- C2 is C - 1.
move(right, R, C, (R, C2)) :- C2 is C + 1.
move(up,    R, C, (R2, C)) :- R2 is R - 1.
move(down,  R, C, (R2, C)) :- R2 is R + 1.


% find_start(+Maze, -Row, -Col)
% Finds the coordinates of the start cell 's'.
find_start(Maze, R, C) :-
    nth0(R, Maze, Row),
    nth0(C, Row, s).


% is_exit(+Maze, +Row, +Col)
% True if the cell at (Row, Col) is an exit 'e'.
is_exit(Maze, R, C) :-
    cell(Maze, R, C, e).


% valid_maze(+Maze)
% Checks that the maze:
% 1. Is not empty
% 2. All rows have the same length
% 3. Has exactly one start 's'
% 4. Has at least one exit 'e'
valid_maze(Maze) :-
    Maze \= [],
    all_rows_same_length(Maze),
    findall((R,C), find_start(Maze, R, C), Starts),
    length(Starts, 1),            % Exactly one start
    findall((R,C), is_exit(Maze, R, C), Exits),
    Exits \= [].                  % At least one exit exists


% all_rows_same_length(+Maze)
% True if all rows have the same number of columns.
all_rows_same_length([FirstRow|OtherRows]) :-
    length(FirstRow, N),
    maplist(same_length(N), OtherRows).

same_length(N, Row) :- length(Row, N).


% walk_actions(+Maze, +CurrentPos, +Visited, -Actions)
% Recursively explores the maze generating a valid sequence of actions to exit.
walk_actions(Maze, (R, C), _, []) :-
    is_exit(Maze, R, C), !.  % Base case: reached exit

walk_actions(Maze, (R, C), Visited, [Act|RestActions]) :-
    member(Act, [left, right, up, down]),
    move(Act, R, C, (R2, C2)),
    in_bounds(Maze, R2, C2),
    cell(Maze, R2, C2, Cell),
    Cell \= w,
    \+ member((R2, C2), Visited),
    walk_actions(Maze, (R2, C2), [(R2, C2)|Visited], RestActions).


% find_exit(+Maze, -Actions)
% Top-level predicate: finds a valid sequence of moves from start to exit.
find_exit(Maze, Actions) :-
    valid_maze(Maze),
    find_start(Maze, StartR, StartC),
    Start = (StartR, StartC),
    walk_actions(Maze, Start, [Start], Actions).
