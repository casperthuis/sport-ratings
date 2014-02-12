%{
Sport ranking - Maximum Likelihood method. 
Input: 
    - matrix W containing wins and losses of each team.
      1 is a win, -1 is a loss, 0 is not played.
    - corresponding score differences in vector s
        OR
      a matrix with two columns, containing the scores of
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

function [ r ] = maximum_likelihood(W, s)

%pause('on')

%   Ri = Wi/(SUM(i/=j)(Gij/(Ri+Rj)))
%   Every point is a win, while it gives less chance on 0 wins
O = createO(W,s);
totalnog = size(O,1);
not = size(O,2);
r_old = zeros(not,1);
r = ones(not,1);
dif = abs((r_old - r));

% calculate number of wins
% W(i,j) in the formula
now = sum(O,1)';

% calculate total score for each duo of teams
% G(i,j) in the formula
scores = zeros(not,not);
for c = 1:totalnog
    game = W(c,:); % get the individual game
    playing = find(game ~= 0); % get array of indices of playing teams
    a = playing(1); % define a (index of first playing team) 
    b = playing(2); % define b (index of last playing team)
    totalscore = O(c,a) + O(c,b);
    scores(a,b) = totalscore;
    scores(b,a) = totalscore;
end

iteration = 0;
while sum(dif < (ones(not,1)*0.001)) < not
    r_old = r;
    for i = 1:(not - 1),
        % calculate sum of games/rankings
        sgr = 0;
        for j = 1:not,
            if j == i,
                continue
            end
            sgr = sgr + (scores(i,j)/(r(i,1)+r(j,1)));
        end
        % calculate new ranking
        r(i,1) = now(i,1) / sgr;
    end
    iteration = iteration + 1;
    dif = abs((r_old - r));
    %pause(3)
end
% scale to make a rating of 1 to be "average"
r_product = prod(r);
x = nthroot(r_product, not);
r = r/x;
fprintf('Iterations: %d\n', iteration)
end