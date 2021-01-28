function [ cM ] = calcConfusionMatrix( LPred, LTrue )
% CALCCONFUSIONMATRIX returns the confusion matrix of the predicted labels

classes  = unique(LTrue);
NClasses = length(classes);

% Add your own code here

cM = zeros(NClasses);

for i=1:length(LPred)
    cM(LPred(i), LTrue(i)) = cM(LPred(i), LTrue(i)) + 1;
end



end

