

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

