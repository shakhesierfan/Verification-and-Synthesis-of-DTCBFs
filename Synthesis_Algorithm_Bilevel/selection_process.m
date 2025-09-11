function [k_sel, k_in_sel] = selection_process (node, L, L_in, L_p)
    k_in_sel = [];
    k_sel = [];
    
    temp_F = inf;
    temp_depth = inf;
    k_LB = [];
    for i = 1:size(L, 2)

        if node(L(i)).depth < temp_depth
                temp_F = node(L(i)).F_lb;
                temp_depth = node(L(i)).depth;
                k_LB = L(i);
        elseif node(L(i)).depth == temp_depth 
            if node(L(i)).F_lb < temp_F
                temp_F = node(L(i)).F_lb;
                k_LB = L(i);
            elseif node(L(i)).F_lb == temp_F
                k_LB = [L(i) k_LB];
            end

        end
    end
    k_LB = min(k_LB);
    [p] = find_p(L_p, k_LB);
    
    temp = inf;
    temp_f = inf;
    temp_inner = inf;
    temp_f_inner = inf;

    for i = 1:size(L_p, 2)
        for j = 1:size(L_p{p,i}, 2) 

            if isempty(intersect(L_p{p,i}(j), L)) == 0

                if node(L_p{p,i}(j)).depth < temp 
                    temp = node(L_p{p,i}(j)).depth;
                    temp_f = node(L_p{p,i}(j)).f1_ub + node(L_p{p,i}(j)).f2_ub;
                    k_sel = L_p{p,i}(j);
                elseif node(L_p{p,i}(j)).depth == temp 
                    if node(L_p{p,i}(j)).f1_ub + node(L_p{p,i}(j)).f2_ub < temp_f 
                        temp_f = node(L_p{p,i}(j)).f1_ub + node(L_p{p,i}(j)).f2_ub;
                        k_sel = L_p{p,i}(j);
                    end
                end

            end

            if isempty(intersect(L_p{p,i}(j), L_in)) == 0

                if node(L_p{p,i}(j)).depth < temp_inner
                    temp_inner = node(L_p{p,i}(j)).depth;
                    temp_f_inner = node(L_p{p,i}(j)).f1_ub + node(L_p{p,i}(j)).f2_ub;
                    k_in_sel = L_p{p,i}(j);
                elseif node(L_p{p,i}(j)).depth == temp_inner
                    if node(L_p{p,i}(j)).f1_ub + node(L_p{p,i}(j)).f2_ub < temp_f_inner
                        temp_f_inner = node(L_p{p,i}(j)).f1_ub + node(L_p{p,i}(j)).f2_ub;
                        k_in_sel = L_p{p,i}(j);
                    end
                end

            end

        end
    end 
end
