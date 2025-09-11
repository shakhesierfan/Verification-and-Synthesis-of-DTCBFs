function [L_p] =  removing_empty_cells(L_p)

counter_i = 1;
temp_L_p = [];
for i = 1:size(L_p, 1)
     
    counter_j = 1;

    for j = 1:size(L_p, 2)
        
        if isempty(L_p{i,j}) == 0
            temp_L_p{counter_i, counter_j} = L_p{i,j};
            counter_j = counter_j + 1;
        end

    end

    if counter_j > 1
        counter_i = counter_i + 1;
    end
end

L_p = temp_L_p;

end
