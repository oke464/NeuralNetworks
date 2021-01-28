function s = gwaction(action)
% state = GWACTION(action)
% Let the robot perform an action and then return the resulting robot state.
%  
% action           - integer, moves the robot, 1=down, 2=up, 3=right and 4=left
% 
% state.feedback   - reward for this action
% state.pos        - robot position after action, [y,x]
% state.isterminal - 1=robot reached goal, 0=goal not reached
% state.isvalid    - 1=action valid, 0=action invalid 
%
% Typical reasons for invalid actions is when the robot bumps into
% a wall. When this happens, simply ignore all state variables and
% perform another (hopefully) valid action.
%
% Example:
%     s = gwinit(1);
%     s.pos --> [5,2]; (initial position is random)
%     s = gwaction(3);
%     s.pos --> [5,3];
%
% See also: gwinit, gwstate
  
global GWWORLD;
global GWPOS;
global GWXSIZE;
global GWYSIZE;
global GWFEED;
global GWTERM;
global GWISVALID;
global GWLASTFEED;

%GWLASTFEED = GWFEED(GWPOS(1),GWPOS(2));

if GWTERM(GWPOS(1),GWPOS(2))
  GWISVALID = 0;
  s = gwstate;  
  return
end

if GWWORLD == 4 % The read home from HG
    if rand < 0.3
        action = sample([1,2,3,4],[0.25,0.25,0.25,0.25]);
    end
end

if GWWORLD == 12 % The final boss
    if rand < 0.1
        action = sample([1,2,3,4],[0.25,0.25,0.25,0.25]);
    end
end

next_position = GWPOS + [(action==1) - (action==2),(action==3) - (action==4)]';

if (next_position(2) < 1       || ...
    next_position(2) > GWXSIZE || ...
    next_position(1) < 1       || ...
    next_position(1) > GWYSIZE || ...
    isnan(GWFEED(next_position(1), next_position(2))))
  GWISVALID = 0;
else
  GWISVALID = 1;
  GWPOS = next_position;
end

% Warp relay, world 8
if GWFEED(GWPOS(1),GWPOS(2)) == 0.1234
  GWPOS = [6 14]';
end

% Save feedback from this action
GWLASTFEED = GWFEED(GWPOS(1),GWPOS(2));

% Return current state
s = gwstate;

end

