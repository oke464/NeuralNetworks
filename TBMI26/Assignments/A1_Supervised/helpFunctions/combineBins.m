function [ CombBin ] = combineBins(AllBins, indexes)
% COMBINEBINS Combines several bins into one matrix. Use to setup data for
% cross validataion, or to create training and test datasets of different
% sizes.

CombBin = cell2mat(AllBins(indexes)');

end

