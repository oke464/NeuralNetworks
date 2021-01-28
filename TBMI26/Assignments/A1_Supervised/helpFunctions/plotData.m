function plotData(X,L,LPred)
% PLOTDATA Plot dataset 1, 2, or 3. Indicates correct and incorrect label
% predictions as green and red respectively.

c='xo+*sd';
hold on;
for k = 1:6
    ind     = (L == k) & (L == LPred);
    ind_err = (L == k) & (L ~= LPred);
    scatter(X(ind    ,1), X(ind    ,2), strcat('g',c(k)));
    scatter(X(ind_err,1), X(ind_err,2), strcat('r',c(k)));
end
hold off;

end

