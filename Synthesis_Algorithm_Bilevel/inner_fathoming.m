function [L, L_in, L_p] = inner_fathoming(node, k, L, L_in, L_p)

    
    [p] = find_p(L_p, k);
    

    %if isempty(p) == 0
    [new_best_f_ub] = new_updating_f_ub_k(node, L_p, k);
    if node(k).f_lb == inf || node(k).f_lb > new_best_f_ub

        [index_L] = find (L == k);
        if isempty(index_L) == 0
            L(index_L) = [];
        end
        
        [index_L_in] = find (L_in == k);
        if isempty(index_L_in) == 0
            L_in(index_L_in) = [];
        end
        
        for i = 1:size(L_p, 2)
            [index_p] = find (L_p{p,i} == k);
            if isempty(index_p) == 0
                %disp('erfan');
                L_p{p,i}(index_p) = [];
            %[L_p, L_in] = list_del_fath(L, L_in, L_p, p, i);
            end
        end

    end
        
    %end
end
