function [ Y, L ] = runSingleLayer(X, W)
% RUNSINGLELAYER Performs one forward pass of the single layer network, i.e
% it takes the input data and calculates the output for each sample.
%
%    Inputs:
%              X - Samples to be classified (matrix)
%              W - Weights of the neurons (matrix)
%
%    Output:
%              Y - Output for each sample and class (matrix)
%              L - The resulting label of each sample (vector) 

% Add your own code here
Y = 0;

% Calculate labels
[~, L] = max(Y, [], 2);

end

