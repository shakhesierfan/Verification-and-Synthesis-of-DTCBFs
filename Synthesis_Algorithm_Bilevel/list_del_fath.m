function [L_p, L_in] = list_del_fath(L, L_in, L_p, p, l_fath)

bool_list_del_1 = 1;
if isempty(l_fath) == 1
    initial_loop = 1;
    end_loop = size(L_p , 2);
else
    initial_loop = l_fath;
    end_loop = l_fath;
end

for l_fath_loop = initial_loop:end_loop
    
    bool_list_del_1 = 1;
    if isempty(intersect(L_p{p, l_fath_loop}, L)) == 1
        
        for i = 1:size(L_p, 2)
            if i ~= l_fath_loop && isempty(intersect(L_p{p, l_fath_loop}, L_p{p, i})) == 0
                
                bool_list_del_1 = 0;
    
            end
    
        end 
        if bool_list_del_1 == 1
            temp_nodes = L_p{p,l_fath_loop};
            %temp_size = size(L_p{p,l_fath_loop} , 2);
            for i = 1:size(temp_nodes, 2)
                index_inner = find( L_in == temp_nodes(i) );
                if isempty(index_inner) == 0
                    L_in(index_inner) = [];
                end
                for j = 1:size(L_p , 2)
                    index_p = find( L_p{p, j} == temp_nodes(i) ) ;
                    if isempty(index_p) == 0
                        L_p{p, j}(index_p) = [];
                    end
                end
            end
            L_p{p, l_fath_loop} = [];
        else
            L_p{p, l_fath_loop} = [];
        end
    end

end


end
