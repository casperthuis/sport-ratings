function [] = comparison( W,s )
% This function compares al the implemented rating methods by displaying a
% plot with al the final rankings and displaying all the hindsight and
% foresight percentages.
not = size(W,2); %number of teams

% get hindsight scores for all methods
hindsight_ls = hindsight(W, s, 'ls');
hindsight_keener = hindsight(W, s, 'keener');
hindsight_elo = hindsight(W, s, 'elo');
hindsight_eloscores = hindsight(W, s, 'eloscores');

% display hindsight scores for all methods
display(hindsight_ls)
display(hindsight_keener)
display(hindsight_elo)
display(hindsight_eloscores)

% get all foresight scores 
foresight_ls = foresight(W, s, 'ls');
foresight_keener = foresight(W, s, 'keener');
foresight_elo = foresight(W, s, 'elo');
foresight_eloscores = foresight(W, s, 'eloscores');

% display all foresight scores
display(foresight_ls)
display(foresight_keener)
display(foresight_elo)
display(foresight_eloscores)

ratings = zeros(not,4);
ratings(:,1) = least_squares(W,s);
ratings(:,4) = keener(W,s);
ratings(:,2) = elo(W);
ratings(:,3) = elo_scorebased(W,s);

% Normalization
ratings = bsxfun(@minus,ratings,mean(ratings));
ratings = bsxfun(@rdivide,ratings,std(ratings));

figure(1)
x = 1:not;
plot(x, ratings(:,1), x, ratings(:,2), x, ratings(:,3), x, ratings(:,4))
xlim([1, not]);
xlabel('Teams')
ylabel('Normalized Rating')
set(gca,'XTick',1:not)
leg = legend('Least Squares', 'Keener', 'ELO', 'ELO Scorebased');
set(leg,'Location','NorthEastOut')

rankings_ls = sort(ratings(:,1), 'descend');
rankings_keener = sort(ratings(:,2), 'descend');
rankings_elo = sort(ratings(:,3), 'descend');
rankings_eloscores = sort(ratings(:,4), 'descend');
rankings = zeros(not,4);

for i = 1:not
    index_ls = find(ratings(:,1) == rankings_ls(i));
    index_keener = find(ratings(:,2) == rankings_keener(i));
    index_elo = find(ratings(:,3) == rankings_elo(i));
    index_eloscores = find(ratings(:,4) == rankings_eloscores(i));
    rankings(i,1) = index_ls;
    rankings(i,2) = index_keener;
    rankings(i,3) = index_elo;
    rankings(i,4) = index_eloscores;
end

display(rankings)

figure(2)
x = 1:not;
for j = 1:not
    hold all
    [indices, ~] = find(rankings == j);
    name = sprintf('Team %d', j);
    plot(1:4, indices, 'DisplayName', name);
end
xlabel('Method')
ylabel('Ranking')
set(gca,'XTick',1:4)
ylim([0,not+1]);
set(gca,'YTick',0:not+1)
set(gca,'XTickLabel',{'Least Squares';'ELO';'ELO Scorebased';'Keener'})
set(gca,'YDir','reverse');
leg = legend('-DynamicLegend');
set(leg,'Location','NorthEastOut')

end

