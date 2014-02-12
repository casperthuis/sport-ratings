%{
Sport ranking - Elo method with scores 
Input: 
    - matrix W containing wins and losses of each team.
      1 is a win, -1 is a loss, 0 is not played.
      Two 1's in one row is a draw.
    - s which contains the scores
Output: 
    - vector r containing the ratings of each team.       

Possible inputs: 
Paper example.
W = [1, -1, 0, 0; 0, 0, 1, -1; 0, -1, 0, 1; 1, 0, 0, -1; 0, 1, -1, 0]
%} 

function [ r ] = elo_scorebased( W, s )
nog = size(W,1); 
not = size(W,2);

% get scores, amount of games played and amount of teams playing. 
O = createO(W,s);
S = createS(O);

% initialise variables
r_old = zeros(not,1); 
r_new = zeros(not,1); 
mu = zeros(1,not);
 
% set parameters logistic parameter P and K. 
P = 1000; 
K = 32; 

% loop through each game
for c = 1:nog,
    game = W(c,:); % get the individual game
    playing = find(game ~= 0); % get array of indices of playing teams
    i = playing(1); % define i (index of first playing team) 
    j = playing(2); % define j (index of last playing team)
        
    %calculate mu for i and j
    mu(i) = 1 / (1 + 10^(-1*((r_old(i) - r_old(j)))/P));
    mu(j) = 1 / (1 + 10^(-1*((r_old(j) - r_old(i)))/P)); 
    
    %get new ratings
    r_new(i) = r_old(i) + (K * (S(i,j) - mu(i)));
    r_new(j) = r_old(j) + (K * (S(j,i) - mu(j))); 

    %reset mu and r_old
    mu = zeros(1,not); 
    r_old = r_new; 
end

%return ratings. 
r = r_new; 
end