function [ T, s ] = generate_tournament( teams )
% Write the generated tournaments to file
if ( ~exist('Generated','dir') )
    mkdir Generated
end

filenameTournament = strcat('Generated/', int2str(teams), '-tournament.dat');
filenameScores = strcat('Generated/', int2str(teams), '-scores.dat'); 

if ( ~exist( filenameTournament,'dir' ) )
	% Function that generates a tournament in rounds
	games = (teams * (teams-1))/2; % number of games to be played
	rounds = games / (teams/2); % number of rounds to be played
	W = zeros(1, teams); 
	s = zeros(1,2); 

	shuffled = 1:teams; 
	[W, s] = assign_round(shuffled, W, s);

	for i=1:rounds
		shuffled = shuffle_teams(teams, shuffled);
		[W,s] = assign_round(shuffled, W, s); 
	end

	T = W(2:games+1,:); 
	s = s(2:games+1,:); 

	csvwrite(filenameTournament, T); 
	csvwrite(filenameScores, s); 

else 


T = csvread(filenameTournament); 
s = csvread(filenameScores); 
end 


end

% function to shuffle teams
function [shuffled] = shuffle_teams(teams, prevShuffle)
partial = prevShuffle(2:teams);
newpartial = zeros(size(partial,1), size(partial,2)); 

for i=1:(teams-2)
	newpartial(i+1) = partial(i);
end

newpartial(1) = partial(teams-1);

shuffled = [1, newpartial];
end

% function to assign the new round as scores and games to W and s
function [W,s] = assign_round(shuffled, W, s)
teams = size(W,2); 
opponent = teams/2; 
shuffled = [shuffled(1:opponent), fliplr(shuffled(opponent+1:teams))]
for i=1:opponent
    match = zeros(1,teams);
    if(shuffled(i) < shuffled(i+opponent)) 
        match(shuffled(i)) = -1; 
        match(shuffled(i+opponent)) = 1;
    else
        match(shuffled(i)) = 1; 
        match(shuffled(i+opponent)) = -1; 
    end

    W = [W; match]; 
    s = [s; [shuffled(i), shuffled(i+opponent)]];
end
end 


