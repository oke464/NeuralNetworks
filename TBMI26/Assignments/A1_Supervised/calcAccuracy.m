function [ acc ] = calcAccuracy( cM )
% CALCACCURACY Takes a confusion matrix amd calculates the accuracy

% Add your own code here
acc = 0;

% Get row amount (same as colonns) 
size = height(cM);

diagSum = 0; 

for i=1:size
   diagSum = diagSum + cM(i,i);
end

totalSum = sum(cM, 'all');

% Acc is correct predictions (diagonal in cM) divided by total
acc = diagSum/totalSum;

end

