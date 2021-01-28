function gwdrawpolicy(Policy, varargin)
% GWDRAWPOLICY draws the policy of the gridworld as an arrow in each state,
% pointing in the direction to move from that state. This should be used
% together with gwdraw. If the policy "P" is provided to the gwdraw
% function, GWDRAWPOLICY will be called automatically.
%
% Example:
%     P = getpolicy(Q);
%     gwdraw();
%     GWDRAWPOLICY(P);
%
% See also: gwdraw

% Parse optional inputs
DEFAULT_ARROW_STYLE = 'Pretty';
DEFAULT_ARROW_COLOR = 'r';
Parser = inputParser();
addRequired(Parser, 'Policy', @isnumeric);
addParameter(Parser ,'ArrowStyle', DEFAULT_ARROW_STYLE, @(x) isstring(x) || ischar(x));
addParameter(Parser ,'ArrowColor', DEFAULT_ARROW_COLOR, @ischar);
parse(Parser, Policy, varargin{:});

% Load global variables
global GWXSIZE;
global GWYSIZE;
global GWFEED;
global GWTERM;

if (strcmp(Parser.Results.ArrowStyle, 'Fast'))
    % Using Matlab built-in function (looks worse but is faster)
    [MX,MY] = meshgrid(1:GWXSIZE, 1:GWYSIZE);
    VALID = (GWTERM==0) & ~isnan(GWFEED);
    U = ((Policy==3)-(Policy==4)) .* double(VALID);
    V = ((Policy==1)-(Policy==2)) .* double(VALID);
    quiver(MX,MY,U,V, 'AutoScaleFactor', 0.45, 'Color', Parser.Results.ArrowColor, 'LineWidth', 1);
    scatter(MX(U==0 & V==0 & VALID), MY(U==0 & V==0 & VALID), [Parser.Results.ArrowColor, '.']);
elseif (strcmp(Parser.Results.ArrowStyle, 'Pretty'))
    % Using custom arrows (looks nicer but is slower)
    for x = 1:GWXSIZE
        for y = 1:GWYSIZE
            if ~GWTERM(y,x) && ~isnan(GWFEED(y,x))
                gwplotarrow([y x], Policy(y, x), 'Color', Parser.Results.ArrowColor);
            end
        end
    end
end

end

