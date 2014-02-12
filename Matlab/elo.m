function [ r ] = elo( W )
% get amount of games played and amount of teams playing. 
nog = size(W,1); 
not = size(W,2); 

% initialise variables
r_old = zeros(not,1); 
r_new = zeros(not,1); 
mu = zeros(1,not);
S = zeros(1,2); 
 
% set parameters: logistic parameter P and K. 
P = 1000; 
K = 32; 

% loop through each game
for c = 1:nog,
    game = W(c,:); % get the individual game
    playing = find(game ~= 0); % get array of indices of playing teams
    i = playing(1); % define i (index of first playing team) 
    j = playing(2); % define j (index of last playing team)
    
    % get S 
    if(game(i) > game(j))
        S(i) = 1;
        S(j) = 0; 
    elseif(game(i) < game(j))
        S(i) = 0;
        S(j) = 1;
    elseif(game(i) == game(j))
        S(i) = 0.5; 
        S(j) = 0.5; 
    end
        
    %calculate mu for i and j
    mu(i) = 1 / (1 + 10^(-1*((r_old(i) - r_old(j)))/P));
    mu(j) = 1 / (1 + 10^(-1*((r_old(j) - r_old(i)))/P)); 
    
    %get new ratings
    r_new(i) = r_old(i) + (K * (S(i) - mu(i)));
    r_new(j) = r_old(j) + (K * (S(j) - mu(j))); 

    %reset mu and r_old
    mu = zeros(1,not); 
    r_old = r_new; 
end

%return ratings. 
r = r_new; 
end