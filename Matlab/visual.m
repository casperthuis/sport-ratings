function [] = visual(W, s, method, teams, round_length, team_names)
% if 3 arguments, display all teams with round length one
if nargin == 3,
    teams = 'all';
    round_length = 1;
end

% if round_length not set, set at 1
if nargin == 4,
    round_length = 1;
end

% get datamatrix for arguments
data = datamatrix(W, s, method, round_length);
nor = size(data,2);
not = size(data,1);

% display graph 
xlabel(['Round consisting of ' num2str(round_length) ' game(s)'])
ylabel('Rating')
title('Rating per Game')
xlim([1,nor])
set(gca, 'XTick', 1:nor);

if(strcmp(teams, 'all') == 1)
    for j = 1:not
		hold all
		plot(data(j,:))
    end
else
    for i = 1:size(teams,2)
        hold all
        plot(data(teams(i),:))
    end
end

x = 0:1:nor-1;
set(gca, 'XTickLabel', x);
if nargin == 6,
    l = team_names(1);
    for i = 2:length(team_names)
        l = [l; team_names(i)];
    end
    legend(l,'Location','NorthEastOutside')
end
grid on

end
