%% Hyper-parameters

% Number of randomized Haar-features
nbrHaarFeatures = 25;
% Number of training images, will be evenly split between faces and
% non-faces. (Should be even.)
nbrTrainImages = 500;
% Number of weak classifiers
nbrWeakClassifiers = 150;

%% Load face and non-face data and plot a few examples
load faces;
load nonfaces;
faces = double(faces(:,:,randperm(size(faces,3))));
nonfaces = double(nonfaces(:,:,randperm(size(nonfaces,3))));

figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k));
    axis image;
    axis off;
end

figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k));
    axis image;
    axis off;
end

%% Generate Haar feature masks
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3);
colormap gray;
for k = 1:25
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    axis image;
    axis off;
end

%% Create image sets (do not modify!)

% Create a training data set with examples from both classes.
% Non-faces = class label y=-1, faces = class label y=1
trainImages = cat(3,faces(:,:,1:nbrTrainImages/2),nonfaces(:,:,1:nbrTrainImages/2));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainImages/2), -ones(1,nbrTrainImages/2)];

% Create a test data set, using the rest of the faces and non-faces.
testImages  = cat(3,faces(:,:,(nbrTrainImages/2+1):end),...
                    nonfaces(:,:,(nbrTrainImages/2+1):end));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,size(faces,3)-nbrTrainImages/2), -ones(1,size(nonfaces,3)-nbrTrainImages/2)];

% Variable for the number of test-data.
nbrTestImages = length(yTest);

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError

% Nr samples
M = width(xTrain); 
% Nr features
N = height(xTrain); 

% Define every iteration of weakclassifier. (i.e. amount of base/weak
% classifiers.
T = nbrWeakClassifiers;
% Init vector storing decision stumps/ threshhold
Taos = zeros(1,T);

% Storing weights for each iteration 
D = ones(M, T) .* 1/nbrTrainImages;

% Polarity
P = zeros(1,T);

% Init a vector of infinite
EMin = ones(1,T);
EMin = EMin.*77;

% Init alpha
alphas = zeros(1, T); 

% Each classification iteration is column and row is classified sample.
% h(x) on trainingdata
Classes = zeros(M, T); 

% Store bestfeature corresponding to best threshhold.
BestFeatures = zeros(1, T);

for t = 1:T
    % Find minimum error for each possible threshhold tao in xTrain of
    % each feature and sample
    for k = 1:nbrHaarFeatures
        for i = 1:M
            % All possible thresholds will be every sample for current feature component
            tao = xTrain(k,i); 
            % Set P
            p = 1;
            % Run weak classifier
            classs = WeakClassifier(tao, p, xTrain(k,:));
            %Calc error
            eps = WeakClassifierError(classs, D(:, t), yTrain);
            
            if isa(eps, 'complex double')
                
            end
            
            if eps > 0.5
                % Set P
                p = -1;
                % Invert error 
                eps = 1 - eps; 
                % Invert classification
                classs = -classs;
            end
            
            if eps < EMin(t)
                % Store the smallest error
                EMin(t) = eps;
                % Add the best tao yieldiing the smallest error
                Taos(t) = tao;
                % Add the corresponding polarity
                P(t) = p;
                % Store haarfeature
                BestFeatures(t) = k;
                
                % Store classified data
                Classes(:, t) = classs';
            end 
        end
    end
    
    % Update alpha
    alpha = (1/2) * log((1 - EMin(t)) / EMin(t));
    alphas(t) = alpha;
    
    % Update weight vector 
    if t + 1 <= T
        D(:, t+1) = D(:,t) .* exp(-alpha * yTrain .* Classes(:, t)')' ;
        % Normalize
        normScale = sum(D(:, t+1));
        D(:, t+1) = D(:, t+1) ./ normScale;
        Thisshouldbeone = sum(D(:, t+1));
    end 
end
%%
figure(6);
plot(EMin, alphas, '*');

    
%% Evaluate your strong classifier here
%  Evaluate on both the training data and test data, but only the test
%  accuracy can be used as a performance metric since the training accuracy
%  is biased.

hTrain = zeros(M, T); 
hTest = zeros(nbrTestImages, T); 
% Classify the test and train data with base/weak classifiers
for t = 1:T    
    hTrain(:,t) = WeakClassifier(Taos(1,t), P(1,t), xTrain(BestFeatures(t),:))';
    hTest(:,t) = WeakClassifier(Taos(1,t), P(1,t), xTest(BestFeatures(t),:))';
end 

% Strong classifier
HTrain = sign(alphas * hTrain');
HTest = sign(alphas * hTest');

% Count correct classifications
correctTrain = sum(HTrain == yTrain);
correctTest = sum(HTest == yTest);

% Calc accuracy
trainAcc = correctTrain/nbrTrainImages;
testAcc = correctTest/nbrTestImages;

%% Plot the error of the strong classifier as a function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.

accumHTrain = zeros(M, T);
accumHTest = zeros(nbrTestImages, T); 

accumTrainAcc = zeros(1, T);
accumTestAcc = zeros(1, T);

% The idea is to create a strong classification using classifier amount
% 1:nbrWeakClassifier
for t = 1:T
    % Iterate from 1:t to create an accumulative ensemble H
    hTr = hTrain(:, 1:t)';
    hTe = hTest(:, 1:t)';
    
    % Extract 1:t in alpha and h, then calc: H, error, and accuracy.
    accumHTrain(:,t) = sign(alphas(1, 1:t) * hTr);
    accumHTest(:,t) = sign(alphas(1, 1:t) * hTe);
    
    % Count correct classifications
    correctTrain = sum(accumHTrain(:,t)' == yTrain);
    correctTest = sum(accumHTest(:,t)' == yTest);

    % Calc accuracy
    accumTrainAcc(t) = correctTrain/nbrTrainImages;
    accumTestAcc(t) = correctTest/nbrTestImages;
end 


%%
figure(4)
plot(1:T, accumTrainAcc);
title('Classification accuracy trainingdata')
xlabel('Num. of weak classifiers')
ylabel('Accuracy (%)')
figure(5)
plot(1:T, accumTestAcc);
title('Classification accuracy testdata')
xlabel('Num. of weak classifiers')
ylabel('Accuracy (%)')

%% Plot some of the misclassified faces and non-faces
%  Use the subplot command to make nice figures with multiple images.
missClassified = (HTest ~= yTest);

missClassifiedIndex = zeros(1,length(missClassified));
% Index Counter
i=1;
% Storage position in index list
j=1; 
while i ~= length(missClassified)
    if missClassified(i)
        missClassifiedIndex(j) = i;
        j=j+1;
    end
    i=i+1;
end

% Extract the 25 first items to plot a 5x5 images
missClassifiedIndex = missClassifiedIndex(1:25);

figure(5);
colormap gray;
% Plot 5x5 images
for k = 1:25
    subplot(5,5,k),imagesc(testImages(:,:,missClassifiedIndex(k)));
    axis image;
    axis off;
end
sgtitle('Missclassified faces')


%% Plot your choosen Haar-features
%  Use the subplot command to make nice figures with multiple images.

figure(6);
colormap gray;

for k = 1:nbrHaarFeatures
    subplot(8,8,k),imagesc(haarFeatureMasks(:,:,BestFeatures(k)),[-1 2]);
    axis image;
    axis off;
end
sgtitle('Used Haar features')

