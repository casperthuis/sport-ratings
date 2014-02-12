% create all possible shuffles
function [ scores ] = round_order_compare(teams, method)

[W, s] = generate_tournament(teams); 
foresight(W,s,'elo'); 
games = (teams * (teams-1))/2; % number of games to be played
rounds = games / (teams/2); % number of rounds to be played

scores = zeros(rounds,2); 


for i=1:rounds
    [W,s] = shuffle_tournament(W,s); 
	scores(i,1) = foresight(W,s,method);
	scores(i,2) = hindsight(W,s,method); 
end

end