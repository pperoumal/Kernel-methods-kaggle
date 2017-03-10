function Mout = selectNlines(Min,N)

% Min  : input matrice to sample lines from
% N    : number of lines to sample
% Mout : output matrice with N random lines from Min

NN  = size(Min,1);
selected_lines  = false(1,NN);
remaining_lines = true(1,NN);

for i = 0:N-1
   
   % sample uniformly an integer
   j = randsample(NN-i);
   
   % indices of remaining lines
   tab = find(remaining_lines);
   
   % indice sampled
   ind = tab(j);
   
   % set this line as selected
   selected_lines(ind) = true;
   
   % remove this line from the selectable ones
   remaining_lines(ind) = false;
    
end

Mout = Min(selected_lines,:);

end