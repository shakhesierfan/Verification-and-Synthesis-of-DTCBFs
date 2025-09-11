function [p] = find_p(L_p, node_selected)
    
    p = [];
    
    for i = 1:size(L_p, 1)
        for j = 1:size(L_p, 2)
            if isempty(find(node_selected == L_p{i,j}, 1)) == 0
                p = i;
            end
        end
    end


end
