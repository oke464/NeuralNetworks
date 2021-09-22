function [ LPred ] = kNN(X, k, XTrain, LTrain)
% KNN Your implementation of the kNN algorithm
%    Inputs:
%              X      - Samples to be classified (matrix)
%              k      - Number of neighbors (scalar)
%              XTrain - Training samples (matrix)
%              LTrain - Correct labels of each sample (vector)
%
%    Output:
%              LPred  - Predicted labels for each sample (vector)

classes = unique(LTrain);
NClasses = length(classes);

% Add your own code here

% Every sample distance to every train point is on each row
allDist = pdist2(X,XTrain);

allLabels = [];
% Iterate over all input points X
for i=1:height(X)

    % Euclidian distance from input point to all training points
    eDist = allDist(i,:);

    % Combine distances with labels and sort regarding to distances
    distLabelMatrix = sortrows([eDist(:), LTrain(:)], 'ascend');

    % Now extract the k first rows and count how many of each label
    kNN = distLabelMatrix(1:k,:);

    % Extract all possible unique labels
    uniqueLabels = unique(LTrain);

    labelCount = [];
    % Iterate over the unique labels and count the amount
    for i = 1:length(uniqueLabels)
        label = uniqueLabels(i);
        amount = sum(kNN(:,2) == label);
        labelCount(i,1) = amount;
        labelCount(i,2) = label;
    end

    % Sort in descending order and extract first element which has the highest
    % value i.e. the most labels
    sortLabelCount = sortrows(labelCount, 'descend');

    if sortLabelCount(1,1) == sortLabelCount(2,1)
        % Use closest point if closest neighbours are equal
        kNNMostLabels = distLabelMatrix(1,2);
    else
        kNNMostLabels = sortLabelCount(1,2);
    
    end
    
    allLabels = [allLabels; kNNMostLabels];

end

LPred  = allLabels; %zeros(size(X,1),1);

end

