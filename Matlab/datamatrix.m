function [ data ] = datamatrix(W, s, method, round_length)
% if round_length not given
if nargin == 3,
    round_length = 1;
end

nog = size(W,1); %nr. of games
not = size(W,2); %nr. of teams
rating = zeros(not,1);
data = zeros(not,nog+1);

% loop through all games
for i = 1:nog,
    Wi = W(1:i,:);
    si = s(1:i,:);
    
    switch method
        case 'ls'
            rating = least_squares(Wi,si);
        case 'elo'
            rating = elo(Wi);
        case 'keener'
            rating = keener(Wi,si);
        case 'eloscores'
            rating = elo_scorebased(Wi,si);
    end
    
    data(:,i+1) = rating;
end

data = data(:, 1:round_length:end);

end