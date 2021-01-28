function gwplotarrow(Position, Action, varargin)
% GWPLOTARROW plots an arrow at a position given the action. Same encoding
% of actions as in gwaction. Useful for plotting the behaviour of an optimal
% policy given a Q-function. This is automatically used by gwplotpolicy and
% there is no need to use this function directly unless you want to draw a
% specific path of the agent.
%
% The position argument is a 2-element vector of coordinates [y,x], and
% the action argumant is a scalar from 1 to 4 according to the encoding
% used in gwaction.
%
% Example:
%     gwdraw();
%     GWPLOTARROW([5,3], 2);
%
% See also: gwaction, gwdraw, gwdrawpolicy

% Parse optional inputs
DEFAULT_COLOR = 'r';
Parser = inputParser();
addRequired(Parser, 'Position', @(x) isnumeric(x) && (length(x) == 2));
addRequired(Parser, 'Action', @isnumeric);
addParameter(Parser ,'Color', DEFAULT_COLOR, @ischar);
parse(Parser, Position, Action, varargin{:});

pos = Parser.Results.Position;
act = Parser.Results.Action;
col = Parser.Results.Color;

hold on;
switch (act)
    case 1
        symb = [col, 'v'];
        next_pos = [pos(1) pos(2)]' + 0.5*[1 0]';
    case 2
        symb = [col, '^'];
        next_pos = [pos(1) pos(2)]' + 0.5*[-1 0]';
    case 3
        symb = [col, '>'];
        next_pos = [pos(1) pos(2)]' + 0.5*[0 1]';
    case 4
        symb = [col, '<'];
        next_pos = [pos(1) pos(2)]' + 0.5*[0 -1]';
    otherwise
        symb = [col, '.'];
        next_pos = pos;
end
plot([pos(2),next_pos(2)], [pos(1),next_pos(1)], col);
plot(next_pos(2), next_pos(1), symb);
hold off;

end