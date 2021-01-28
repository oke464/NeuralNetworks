function [ XBins, DBins, LBins ] = selectTrainingSamples(X, D, L, NSamplesPerLabelPerBin, NBins, selectAtRandom)
% SELECTTRAININGSAMPLES Split data into separate equal-sized bins.
%    Input:
%             X - Data samples
%             D - Training targets for all samples
%             L - Data labels for all samples
%             NSamplesPerLabelPerBin - Number of samples from each label in
%                                      each bin, can be set to "inf" to use
%                                      as much of the data as possible
%             NBins          - Number of bins
%             selectAtRandom - True/False to randomize the selections
%
%   Output:
%             XBins - Output bins with data from X (cell array)
%             DBins - Output bins with targets from D (cell array)
%             LBins - Output bins with labels from L (cell array)

labels = unique(L(:)');
NLabels = length(labels);

[n, b] = hist(L,labels);

XBins = {};
DBins = {};
LBins = {};
if isinf(NSamplesPerLabelPerBin)
    NSamplesPerLabelPerBin = floor(min(n)/NBins);
end

if selectAtRandom
    % If random selection
    for m = 1:NBins
        XBins{m} = [];
        DBins{m} = [];
        LBins{m} = [];
        for n = 1:NLabels
            labelInds = find(L == labels(n));
            rnd = rand(1,length(labelInds));
            [~,ord] = sort(rnd);

            inds = labelInds(ord(1:NSamplesPerLabelPerBin));
            XBins{m} = [XBins{m}; X(inds,:)];
            DBins{m} = [DBins{m}; D(inds,:)];
            LBins{m} = [LBins{m}; L(inds)];
            X(inds,:) = [];
            D(inds,:) = [];
            L(inds)   = [];
        end
    end
else
    % If not random selection
    for m = 1:NBins
        XBins{m} = [];
        DBins{m} = [];
        LBins{m} = [];
        for n = 1:NLabels
            labelInds = find(L == labels(n));
            inds = labelInds(1:NSamplesPerLabelPerBin);

            XBins{m} = [XBins{m}; X(inds,:)];
            DBins{m} = [DBins{m}; D(inds,:)];
            LBins{m} = [LBins{m}; L(inds)];
            X(inds,:) = [];
            D(inds,:) = [];
            L(inds)   = [];
        end
    end
end
end


