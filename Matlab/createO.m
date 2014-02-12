function [ O ] = createO(W, s)

%   creates an object O given W and s. O is a matrix which contains the
%   scores.
nog = size(W,1);
not = size(W,2);
O = zeros(not,not);
for k = 1:nog,
    % Determine scores
    if s(k,1) < s(k,2),
        slow = s(k,1);
        shigh = s(k,2);
    else
        slow = s(k,2);
        shigh = s(k,1);
    end
    % Determine winner/loser and attach scores
    indices = find(W(k,:));
    team_a = indices(1);
    team_b = indices(2);
    if (W(k,team_a) == 1) && (W(k,team_b) == -1)
        score_a = shigh;
        score_b = slow;
    else
        score_a = slow;
        score_b = shigh;
    end
    % Fill O
    O(team_a,team_b) = O(team_a,team_b) + score_a;
    O(team_b,team_a) = O(team_b,team_a) + score_b;
end

end