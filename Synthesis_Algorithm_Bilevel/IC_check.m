function [L_p] = IC_check(L_p, p)
    
    pot_1 = [];
    pot_2 = [];
    I_indices = [];
    J_indices = [];
    bool_impossible = 0;

    for i = 1:size(L_p, 2)
        if isempty(L_p{p,i}) == 0
            pot_1 = L_p{p,i};
            I_indices = i;
            initial_loop = i;
            break;
        end
    end

    for i = initial_loop+1:size(L_p, 2)

            if isempty(intersect(pot_1, L_p{p,i})) == 0
                if isempty(L_p{p,i}) == 0
                    pot_1 = [pot_1 L_p{p,i}];
                    I_indices = [I_indices i];
                end
                if isempty(intersect(pot_2, L_p{p,i})) == 0
                    pot_2 = [];
                    temp_size = size(J_indices, 2);
                    temp_J    = J_indices;
                    for j = 1:temp_size
                        if isempty( intersect(L_p{p, temp_J(j)}, L_p{p,i}) ) == 0
                            %L_p{p, J_indices(j)} = [];
                            [index_del] = find(J_indices == temp_J(j));
                            J_indices(index_del) = [];
                        else
                            pot_2 = [pot_2 L_p{p,j}];
                        end
                    end
                end
            %elseif isempty(intersect(pot_2, L_p{p,i})) == 1
            else
                if isempty(L_p{p,i}) == 0
                    pot_2 = [pot_2 L_p{p,i}];
                    J_indices = [J_indices i];
                end
            %else
            %    bool_impossible = 1;
            %    break;
            end

    end
    
    temp = size(L_p, 1) + 1;
    if isempty(pot_2) == 0
        for i = 1:size(L_p, 2)
            if i <= size(I_indices,2)
                L_p{p, i} = L_p{p, I_indices(i)};
            else
                L_p{p,i} = [];
            end

            if i <= size(J_indices,2)
                L_p{temp, i} = L_p{p, J_indices(i)};
            else
                L_p{temp, i} = [];
            end
        end
        %for i = 1:size(I_indices)
        %    L_p{p, i} = L_p{p,i};
        %end
        %L_p{p, :} = pot_1;
        %L_p{size(L_p, 2)+1, :} = pot_2;
    end

end
