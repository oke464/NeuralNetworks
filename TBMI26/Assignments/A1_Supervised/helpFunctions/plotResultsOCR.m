function plotResultsOCR(X, L, LPred)
% PLOTRESULTSOCR Plots the results using the 4th dataset (OCR). Selects a
% random set of 16 samples each time.

% Remove bias (last feature)
if size(X,2) == 65
    X = X(:,1:end-1);
end

% Create random sort vector
[~, ord] = sort(rand(1,size(X,1)));

figure(1103);
clf;

% Plot 16 samples
for n = 1:16
    idx = ord(n);
    subplot(4,4,n);
    imagesc(reshape(X(idx,:), [8,8])');
    colormap(gray);
    title(['L_{true}=' num2str(L(idx)-1) ', L_{pred}=' num2str(LPred(idx)-1)]);
    axis image;
    axis off;
end

end

