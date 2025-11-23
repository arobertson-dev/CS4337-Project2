

% in_bounds(+Maze, +Row, +Col)
% Succeeds if (Row, Col) is within the valid dimensions of the maze.
% Checks that Row is between 0 and NumRows-1, and Col is between 0 and NumCols-1.
cell(Maze, R, C, Val) :-
    nth0(R, Maze, Row), % get the R-th row of the maze
    nth0(C, Row, Val).  % get the C-th cell in that row


% in_bounds(+Maze, +Row, +Col)
% Succeeds if (Row, Col) is within the valid dimensions of the maze.
% Checks that Row is between 0 and NumRows-1, and Col is between 0 and NumCols-1.
in_bounds(Maze, R, C) :-
    length(Maze, NumRows),  % Number of rows
    R >= 0,
    R < NumRows,
    nth0(0, Maze, Row),     % Assume every row has the same number of columns
    length(Row, NumCols),   % Number of columns
    C >= 0,
    C < NumCols.


% find_start(+Maze, -Row, -Col)
% Finds the coordinates (Row, Col) of the start cell 's'.
% Succeeds when Row and Col index into a cell containing 's'.
find_start(Maze, R, C) :-
    nth0(R, Maze, Row),     % Get row by index
    nth0(C, Row, s).        % Find column where the value is 's'


% is_exit(+Maze, +Row, +Col)
% True if the cell at (Row, Col) contains an exit 'e'.
% Reuses the cell/4 helper predicate for readability.
is_exit(Maze, R, C) :-
    cell(Maze, R, C, e).    % Check if the value at (R, C) is 'e'


% valid_maze(+Maze)
% Succeeds if the maze is properly formed:
%   - Maze is a non-empty list.
%   - All rows have the same number of columns.
%   - There is exactly one start cell 's'.
%   - There is at least one exit cell 'e'.
valid_maze(Maze) :-
    Maze \= [],                     % Maze cannot be empty
    all_rows_same_length(Maze),     % Ensure rectangular grid
    findall((R,C), find_start(Maze, R, C), Starts),
    length(Starts, start_count),    % Should be exactly one 's'
    start_count =:= 1,
    findall((R,C), is_exit(Maze, R, C), Exits),
    Exits \= [].                    % Must have at least one exit


% Helper function: true if all rows have the same number of columns.
all_rows_same_length([FirstRow | OtherRows]) :-
    length(FirstRow, N),
    maplist(same_length(N), OtherRows).

% Helper function: succeeds if Row has length N.
same_length(N, Row) :-
    length(Row, N).


% move(+Direction, +Row, +Col, -NewRow-Col)
% Computes new coordinates given a Direction.
% Does NOT check bounds or walls — higher-level predicates handle that.
move(left,  R, C, R-NewC) :-
    NewC is C - 1.

move(right, R, C, R-NewC) :-
    NewC is C + 1.

move(up,    R, C, NewR-C) :-
    NewR is R - 1.

move(down,  R, C, NewR-C) :-
    NewR is R + 1.


