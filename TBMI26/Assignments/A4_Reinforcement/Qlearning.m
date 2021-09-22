%% Initialization
%  Initialize the world, Q-table, and hyperparameters

% Redefine action directions
down = 1;
up = 2;
right = 3;
left = 4;

% Init with world 
% 1 ”Irritating blob”
% 2 ”Suddenly irritating blob”
% 3 ”The road to HG”
% 4 ”The road home from HG”
world = 10;
initState = gwinit(world);

% Get board size to get number of states
numStates = initState.xsize * initState.ysize;

% Q-lookup table Q(s, a) 
% Init Q-table with 4 possible actions and numState possible states
Q = zeros(initState.ysize, initState.xsize, 4);
% Boundary conditions of invalid movements
Q(1,:,up) = -inf;
Q(initState.ysize, :, down) = -inf;
Q(:, 1, left) = -inf;
Q(:, initState.xsize, right) = -inf;

% Init value at state s V(s)
V = rand(initState.ysize, initState.xsize);

% eta learning rate 0 < eta < 1
learningRate = 0.1;

% Gamma discountFactor 0 < gamma < 1
discountFactor = 0.9;

% epsilon exploration factor 0 < eps < 1
explorationFactor = 1.0;

% Probabilty of action selection, all ones => all actions equal probability
prob_a = [1 1 1 1];


%% Training loop
%  Train the agent using the Q-learning algorithm.

episodes = 7000;

for episode = 1:episodes
    % Get start state randomizes starting position automatically
    currState = gwinit(world);
    nextState = currState;
    
    % Loop until not at terminal (goal position)
    while currState.isterminal ~= 1
        % state.pos(1) is y coord, state.pos(2) is x coord
        currYPos = currState.pos(1);
        currXPos = currState.pos(2);
        [actionDir, ~] = chooseaction(Q, currYPos, currXPos, [down up right left], prob_a, explorationFactor);
        % Store state
        %currState = nextState;
        % Take resulting action
        gwaction(actionDir);
        % Get new state
        nextState = gwstate();
        
        
        % Get reward
        r = currState.feedback;

        % Get value
        nextYPos = nextState.pos(1);
        nextXPos = nextState.pos(2);
        V = getvalue(Q);

        % Calculate Q-value for current state and action
        Q(currYPos, currXPos, actionDir) = (1 - learningRate) * Q(currYPos, currXPos, actionDir) ...
            + learningRate * (r + discountFactor * V(nextYPos, nextXPos)); 

        % Update current state to new state
        currState = nextState; 
    end
    % At goal set Q to zero for all actions
    Q(currState.pos(1), currState.pos(2), :) = 0;
    % Reduce epsilon to lower exploration for each iteration
    explorationFactor = getepsilon(episode, explorationFactor);
end
%%

figure(5)
P = getpolicy(Q);
gwdraw();
gwdrawpolicy(P);

% for k =1:4
%     figure(k)
%     imagesc(Q(:, :, k))
% end

figure(6)
imagesc(V(:, :))



%% Test loop
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0; always pick
%  the optimal action.

currState = gwinit(world);
figure(7)
gwdraw();
while currState.isterminal ~= 1
    % Get policy
    currXPos = currState.pos(2);
    currYPos = currState.pos(1);
    [actionDir, ~] = chooseaction(Q, currYPos, currXPos, [down up right left], prob_a, 0);
    nextState = gwaction(actionDir);
    gwplotarrow(currState.pos,actionDir);
    pause(0.1)
    currState = nextState;
    gwdraw();
end


while currState.isterminal ~= 1
    % Get policy
    currXPos = currState.pos(2);
    currYPos = currState.pos(1);
    [actionDir, ~] = chooseaction(Q, currYPos, currXPos, [down up right left], prob_a, 0);
    nextState = gwaction(actionDir);
    %gwplotarrow(currState.pos,actionDir);
    
    gwdraw();
    pause(0.1)
    currState = nextState;
end

