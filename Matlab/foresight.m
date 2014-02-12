function foresight_percentage = foresight(W, s, method)

if nargin == 1,
    s = 0;
    method = 'elo';
end

% Calculate ratings
switch method
    case 'elo'
        rating = datamatrix(W, s, 'elo');
    case 'keener'
        rating = datamatrix(W, s, 'keener');
    case 'ls'
        rating = datamatrix(W, s, 'ls');
    case 'eloscores'
        rating = datamatrix(W, s, 'eloscores');
end

% Determine if first draw is predicted
if s(1,1) == s(1,2)
    correct = 1;
else
    correct = 0;
end

% Calculate amount of correct results
winner = 0;
nog = length(W);
for game = 2:nog
    indices = find(W(game,:));
    team_a = indices(1);
    team_b = indices(2);
    
    % Determine draw
    if strcmp(method, 'elo') == 1 && (W(game, team_a) == 1) && ...
                                    (W(game, team_b) == 1)
            winner = -1;
    elseif strcmp(method, 'elo') ~= 1 && (s(game,1) == s(game,2))
            winner = -1;
    end
    
    % Determine real winner when not draw
    if winner ~= -1
        if W(game, team_a) == 1
            winner = team_a;
        else
            winner = team_b;
        end
    end
    
    % Determine predicted winner
    rating_a = rating(team_a,game-1);
    rating_b = rating(team_b,game-1);
    
    % Check correctness
    if (winner == 0) && (rating_a == rating_b)
        correct = correct + 1;
    elseif (winner == team_a) && (rating_a > rating_b)
        correct = correct + 1;
    elseif (winner == team_b) && (rating_b > rating_a)
        correct = correct + 1;
    end
end

foresight_percentage = (correct/nog) * 100;

end