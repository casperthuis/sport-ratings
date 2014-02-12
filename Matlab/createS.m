function [ S ] = createS( O )
% Create matrix S like on page 31

S = zeros(size(O));

for i = 1:size(O,1)
    for j = 1:size(O,2)
        S(i,j) = (O(i,j)+1)/(O(i,j)+O(j,i)+2);
    end
end

end

