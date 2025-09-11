function [new_best_f1_ub, new_best_f2_ub] = new_updating_f_ub_k(node,L_p, k)

    [p] = find_p(L_p, k);
    min1_inner = inf*ones(size(L_p, 2), 1);
    min2_inner = inf*ones(size(L_p, 2), 1);
    temp1_best = -inf;
    temp2_best = -inf;
    new_best_f1_ub = inf;
    new_best_f2_ub = inf;

    if isempty(p) == 0

        for i = 1:size(L_p, 2)
    
            if isempty(L_p{p,i}) == 0 && isempty(intersect(L_p{p,i}, k)) == 0
                for j = 1:size(L_p{p,i}, 2)
                    
                    if node(L_p{p, i}(j)).f1_ub <= min1_inner(i) 
                        min1_inner(i) = node(L_p{p, i}(j)).f1_ub;
                    end

                    if node(L_p{p, i}(j)).f2_ub <= min2_inner(i) 
                        min2_inner(i) = node(L_p{p, i}(j)).f2_ub;
                    end
                    
                end
                if min1_inner(i) >= temp1_best 
                    temp1_best = min1_inner(i);
                end

                if min2_inner(i) >= temp2_best 
                    temp2_best = min2_inner(i);
                end
            end
        end
        new_best_f1_ub = temp1_best;
        new_best_f2_ub = temp2_best;
        
    end

end
