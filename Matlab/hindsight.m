function hindsight_percentage = hindsight(W, s, method)

if nargin == 1,
    s = 0;
    method = 'elo';
end

% Calculate ratings
switch method
    case 'elo'
        rating = elo(W);
    case 'keener'
        rating = keener(W,s);
    case 'ls'
        rating = least_squares(W,s);
    case 'eloscores'
        rating = elo_scorebased(W,s);
end

% Calculate amount of correct results
winner = 0;
correct = 0;
nog = length(W);
for game = 1:nog
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
    rating_a = rating(team_a);
    rating_b = rating(team_b);
    
    % Check correctness
    if (winner == 0) && (rating_a == rating_b)
        correct = correct + 1;
    elseif (winner == team_a) && (rating_a > rating_b)
        correct = correct + 1;
    elseif (winner == team_b) && (rating_b > rating_a)
        correct = correct + 1;
    end
end

hindsight_percentage = (correct/nog) * 100;

end