function gwdraw(varargin)
% GWDRAW draws gridworld and robot. If the episode number "e" is provided,
% the episode number will be shown in the title. If the policy "P" is
% provided, it will also be drawn on top of the world.
%
% Example:
%     P = getpolicy(Q);
%     e = 10;
%     GWDRAW(e, P);
%
% See also: getpolicy, gwdrawpolicy

% Parse optional inputs
DEFAULT_POLICY  = NaN;
DEFAULT_EPISODE = NaN;
DEFAULT_ARROW_STYLE = 'Pretty';
DEFAULT_ARROW_COLOR = 'r';
Parser = inputParser();
addParameter(Parser ,'Policy', DEFAULT_POLICY, @isnumeric);
addParameter(Parser ,'Episode', DEFAULT_EPISODE, @(x) isnumeric(x) && isscalar(x));
addParameter(Parser ,'ArrowStyle', DEFAULT_ARROW_STYLE, @(x) isstring(x) || ischar(x));
addParameter(Parser ,'ArrowColor', DEFAULT_ARROW_COLOR, @ischar);
parse(Parser, varargin{:});

% Load global variables
global GWWORLD;
global GWXSIZE;
global GWYSIZE;
global GWPOS;
global GWFEED;
global GWTERM;
global GWNAME;

% Draw background and set format
cla;
hold on;
imagesc(GWFEED, 'AlphaData', ~isnan(GWFEED));
xlabel('X');
ylabel('Y');

% Set title
if (isnan(Parser.Results.Episode))
    title(sprintf('Feedback Map, World %i\n%s', GWWORLD, GWNAME));
else
    title(sprintf('Feedback Map, World %i\n%s\nEpisode %i', GWWORLD, GWNAME, Parser.Results.Episode));
end

% Create a gray rectangle for the robot
rectangle('Position',[GWPOS(2)-0.5, GWPOS(1)-0.5, 1, 1], 'FaceColor', [0.5,0.5,0.5]);

% If you want to see the color scale of the world you can uncomment this
% line. This will slow down the drawing significantly.
%colorbar;

% Green circle for the goal
for x = 1:GWXSIZE
  for y = 1:GWYSIZE
    if GWTERM(y,x)
      radius = 0.5;
      rectangle('Position',[x-0.5, y-0.5, radius*2, radius*2],...
                'Curvature',[1,1],...
                'FaceColor','g');
    end
  end
end

% If you want to make the robot move slower (to make it easier to
% understand what it does) you can uncomment this line.
%pause(0.1);

if (~(isnan(Parser.Results.Policy) | isscalar(Parser.Results.Policy)))
    gwdrawpolicy(Parser.Results.Policy, 'ArrowStyle', Parser.Results.ArrowStyle, 'ArrowColor', Parser.Results.ArrowColor);
end

axis image;
axis ij;
drawnow;
end


