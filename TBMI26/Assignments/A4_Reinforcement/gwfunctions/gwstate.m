function s = gwstate()
% GWSTATE returns the state of the world resulting from the last robot action.
% 
% Example:
%     gwinit(1);
%     s = GWSTATE()
% Output:
%     s = 
%       struct with fields:
%              xsize: 15
%              ysize: 10
%                pos: [2×1 double]
%         isterminal: 0
%            isvalid: 1
%           feedback: 0
%
% See also: gwinit
  
global GWPOS;
global GWXSIZE;
global GWYSIZE;
global GWLASTFEED;
global GWTERM;
global GWISVALID;

s = struct('xsize',GWXSIZE, ...
           'ysize',GWYSIZE, ...
           'pos', GWPOS, ...
           'isterminal', GWTERM(GWPOS(1),GWPOS(2)), ...
           'isvalid', GWISVALID, ...
           'feedback', GWLASTFEED);
       
end

