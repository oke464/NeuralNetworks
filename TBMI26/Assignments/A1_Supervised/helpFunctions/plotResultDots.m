function plotResultDots(XTrain,LTrain,LPredTrain,XTest,LTest,LPredTest,Type,Ws,k)
% PLOTRESULTDOTS Used to plot training and test data for dataset 1, 2, or 3.
% Indicates corect and incorrect label predictions, and plots the
% prediction fields as the background color.
% If called from kNN script, k should be provided and Ws is ignored.
% If called from single-layer script, Ws should be a {W} cell array, and k is ignored.
% If called from multi-layer script, Ws should be a {W,V} cell array, and k is ignored.

%% Create background meshgrid for plotting label fields
%  Change nx and ny to set the resolution of the fields

nx = 150;
ny = 150;
xi = linspace(min(XTrain(:,1))-1, max(XTrain(:,1))+1, nx);
yi = linspace(min(XTrain(:,2))-1, max(XTrain(:,2))+1, ny);
[XI,YI] = meshgrid(xi,yi);

%% Setup data depending on classifier type

if (strcmp(Type, 'single'))
    XGrid = [XI(:), YI(:), ones(length(XI(:)),1)];
    [~,LGrid] = runSingleLayer(XGrid, Ws{1});
    XTrain = XTrain(:,1:2);
    XTest  = XTest(:,1:2);
elseif (strcmp(Type, 'multi'))
    XGrid = [XI(:), YI(:), ones(length(XI(:)),1)];
    [~,LGrid] = runMultiLayer(XGrid, Ws{1}, Ws{2});
    XTrain = XTrain(:,1:2);
    XTest  = XTest(:,1:2);
elseif (strcmp(Type, 'kNN'))
    XGrid = [XI(:), YI(:)];
    LGrid = kNN(XGrid, k, XTrain, LTrain);
end

%% Plot training data

figure(1103);
clf;
imagesc(xi,yi,reshape(LGrid,[nx ny]));
colormap(gray);
title('Training data result (green ok, red error)');
plotData(XTrain,LTrain,LPredTrain);

%% Plot test data

figure(1104);
clf;
imagesc(xi,yi,reshape(LGrid,[nx ny]));
colormap(gray);
title('Test data result (green ok, red error)');
plotData(XTest,LTest,LPredTest);

end

