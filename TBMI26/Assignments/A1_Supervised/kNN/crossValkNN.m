%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 4; % Change this to load new data 

% X - Data samples
% D - Desired output from classifier for each sample
% L - Labels for each sample
[X, D, L] = loadDataSet( dataSetNr );

% You can plot and study dataset 1 to 3 by running:
%plotCase(X,D)

%% Select a subset of the training samples
% Use this one for crossval
numBins = 4;                    % Number of bins you want to devide your data into
numSamplesPerLabelPerBin = inf; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true;          % true = select samples at random, false = select the first features

[XBins, DBins, LBins] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom);

% Note: XBins, DBins, LBins will be cell arrays, to extract a single bin from them use e.g.
% XBin1 = XBins{1};
%
% Or use the combineBins helper function to combine several bins into one matrix (good for cross validataion)
% XBinComb = combineBins(XBins, [1,2,3]);

%% Calc kNN and accuracy for 3 fold cross validation

% Initialize accuracy list
kAccList = [];

% Iterate over different k

% Perform cross validation over the data bins

% Combine the bins according to cross validation 
XTrain1 = combineBins(XBins, [1,2]);
LTrain1 = combineBins(LBins, [1,2]);
XTest1  = XBins{3};
LTest1  = LBins{3};

XTrain2 = combineBins(XBins, [2,3]);
LTrain2 = combineBins(LBins, [2,3]);
XTest2  = XBins{1};
LTest2  = LBins{1};

XTrain3 = combineBins(XBins, [3,1]);
LTrain3 = combineBins(LBins, [3,1]);
XTest3  = XBins{2};
LTest3  = LBins{2};

XTrain4 = combineBins(XBins, [1,2,3]);
LTrain4 = combineBins(LBins, [1,2,3]);
XTest4  = XBins{4};
LTest4  = LBins{4};

% Calculate predictions for all combinations of data

for k=1:50
    % Classify test data
    LPredTest1  = kNN(XTest1 , k, XTrain1, LTrain1);
    LPredTest2  = kNN(XTest2 , k, XTrain2, LTrain2);
    LPredTest3  = kNN(XTest3 , k, XTrain3, LTrain3);

    % Calculate accuracy and average

    % The confucionMatrix
    cM1 = calcConfusionMatrix(LPredTest1, LTest1);
    % The accuracy
    acc1 = calcAccuracy(cM1);

    % The confucionMatrix
    cM2 = calcConfusionMatrix(LPredTest2, LTest2);
    % The accuracy
    acc2 = calcAccuracy(cM2);

    % The confucionMatrix
    cM3 = calcConfusionMatrix(LPredTest3, LTest3);
    % The accuracy
    acc3 = calcAccuracy(cM3);


    % Average accuracies and store in list

    avrAcc = (acc1 + acc2 + acc3)/3;
    % Store in list
    kAccList = [kAccList; k, avrAcc];

end

% Sort with respect to column 2
sortedkAccList = sortrows(kAccList, 2, 'descend')

% Select the best acc k (first element) 
bestK = sortedkAccList(1,1)

% Classify test data on the final bin with best k
LPredTest4  = kNN(XTest4 , bestK, XTrain4, LTrain4);
LPredTrain4  = kNN(XTrain4 , bestK, XTrain4, LTrain4);

% The confucionMatrix
confMTest4 = calcConfusionMatrix(LPredTest4, LTest4);
% The accuracy of the final test bin
accTest4 = calcAccuracy(confMTest4)

% The confucionMatrix
confMTrain4 = calcConfusionMatrix(LPredTrain4, LTrain4);
% The accuracy of the final test bin
accTrain4 = calcAccuracy(confMTrain4)


%% Plot classifications
%  Note: You should not have to modify this code

if dataSetNr < 4
    plotResultDots(XTrain4, LTrain4, LPredTrain4, XTest4, LTest4, LPredTest4, 'kNN', [], bestK);
else
    plotResultsOCR(XTest4, LTest4, LPredTest4)
end




