function [ r ] = least_squares(W, s) 
% Cast from int to double if necessary
W = double(W); 
s = double(s); 
% If s contains scores, calculate score differences. 
if(size(s, 2) == 2)
    s = abs(s(:,1) - s(:,2));
end
%compute
X = W' * W; 
y = W' * s;
% Scaling
y(size(y,1)) = 0;
X(size(X,1),:) = ones(1,size(X,1));
% Calculate ratings (~ to supress output)
[r, ~] = lsqr(X,y,[],100);
end
