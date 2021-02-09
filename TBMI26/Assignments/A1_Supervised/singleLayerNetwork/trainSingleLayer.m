function [Wout, ErrTrain, ErrTest] = trainSingleLayer(XTrain,DTrain,XTest,DTest,W0,numIterations,learningRate)
% TRAINSINGLELAYER Trains the single-layer network (Learning)
%    Inputs:
%                X* - Training/test samples (matrix)
%                D* - Training/test desired output of net (matrix)
%                W0 - Initial weights of the neurons (matrix)
%                numIterations - Number of learning steps (scalar)
%                learningRate  - The learning rate (scalar)
%    Output:
%                Wout - Weights after training (matrix)
%                ErrTrain - The training error for each iteration (vector)
%                ErrTest  - The test error for each iteration (vector)

% Initialize variables
ErrTrain = nan(numIterations+1, 1);
ErrTest  = nan(numIterations+1, 1);
NTrain = size(XTrain, 1);
NTest  = size(XTest , 1);
Wout = W0;

% Calculate initial error
YTrain = runSingleLayer(XTrain, Wout);
YTest  = runSingleLayer(XTest , Wout);
ErrTrain(1) = sum(sum((YTrain - DTrain).^2)) / NTrain;
ErrTest(1)  = sum(sum((YTest  - DTest ).^2)) / NTest;

for n = 1:numIterations
    % Add your own code here
    % Each w_j vector (for each node) is row wise. Use grad func on lecture
    % 2 slide 18.
    grad_w = (2/NTrain)*(YTrain - DTrain)' * XTrain;
    
    % Take a learning step
    Wout = Wout - learningRate * grad_w;
    
    % Evaluate errors
    YTrain = runSingleLayer(XTrain, Wout);
    YTest  = runSingleLayer(XTest , Wout);
    ErrTrain(n+1) = sum(sum((YTrain - DTrain).^2)) / NTrain;
    ErrTest(n+1)  = sum(sum((YTest  - DTest ).^2)) / NTest;
end
end

