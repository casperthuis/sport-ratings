function [ newW, newS ] = shuffle_tournament( W, s )
teams = size(W, 2); 
round_length = teams/2; 
games = (teams * (teams-1))/2; 

shuffle_W = W(1:round_length, :); 
shuffle_s = s(1:round_length, :); 

rest_W = W(round_length+1:games,:); 
rest_s = s(round_length+1:games,:); 

newW = [rest_W; shuffle_W];
newS = [rest_s; shuffle_s];
end

