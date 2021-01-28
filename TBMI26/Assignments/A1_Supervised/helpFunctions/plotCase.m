function plotCase(X,D)
% PLOTCASE Simple plot of the dataset. Can only be used with dataset
% 1, 2, and 3.

[~,I]  = max(D,[],2);

clf;
hold on;

for k = 1:3
   ind = I == k;
   if k == 1
      scatter(X(ind,1), X(ind,2), 'r.');
   elseif k == 2
      scatter(X(ind,1), X(ind,2), 'g.');
   elseif k == 3
      scatter(X(ind,1), X(ind,2), 'b.');
   end
end

hold off;
box on;
axis ij;

end