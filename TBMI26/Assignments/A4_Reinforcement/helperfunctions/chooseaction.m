function [action, opt_action] = chooseaction(Q, state_y, state_x, actions, prob_a, eps)
% CHOOSEACTION chooses an action from the vector of actions, based on the Q
% matrix and the current position [state_y, state_x]. The optimal action is
% chosen with probability (1-eps), otherwise a random action is chosen,
% with a probability for each action according to prob_a.
%
% Example:
%     [a, oa] = chooseaction(Q, 1, 2, [1 2 3 4], [1 1 1 1], 0.5);
%     returns the choosen action a and the optimal action oa. 50% chance to
%     select a random action, and the random actions are selected with
%     equal probability.
%

% Get the optimal action
Q_values=Q(state_y,state_x,:);
[~, index_opt]=max(Q_values);
opt_action=actions(index_opt);

% Sample random action
rand_action=sample(actions,prob_a);

% Select action
pos_actions=[opt_action rand_action];
action=sample(pos_actions,[1-eps, eps]);
    
end

