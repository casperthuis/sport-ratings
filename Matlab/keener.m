%{
Sport ranking - Keener's method. 
Input: 
    - matrix W containing wins and losses of each team.
      1 is a win, -1 is a loss, 0 is not played.
    - a matrix with two columns, containing the scores of
      both playing teams
Output: 
    - vector r containing the ratings of each team.       

Possible inputs: 
Paper example.
W = [1, -1, 0, 0; 0, 0, 1, -1; 0, -1, 0, 1; 1, 0, 0, -1; 0, 1, -1, 0]
s = [10, 6; 4, 4; 9, 2; 8, 6; 3, 2]


Simple one.
W = [-1, 0, 1; 1, -1, 0; 0, -1, 1]
s = [1, 2; 10, 3; 2, 1]
%}

function [ r ] = keener(W, s)
not = size(W,2);

%   Every point is a win, while it gives less chance on 0 wins
O = createO(W,s);
S = createS(O);

% OPTIONAL
% Skewing
for i = 1:not,
    for j = 1:not,
        S(i,j) = 0.5 + ((sign(S(i,j)-0.5)*sqrt(abs(2*S(i,j)-1)))/2);
    end
end

% OPTIONAL
% Normalization
% aij = aij/ni

% OPTIONAL
% Force Irreducibility and Primitivity
%e = 0.0001;
%A = A + e; 

% SOLVE R
[~, r] = perron(S);

end