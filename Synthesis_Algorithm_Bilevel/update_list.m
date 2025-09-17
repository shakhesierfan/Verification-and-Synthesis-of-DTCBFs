function [L_p, node] = update_list(L_p, node, k_sel, k_in_sel, priority_outer)
    
    p_stored = zeros(2, 1);
    size_x = size(node(1).domain_x, 2);
    %size_y = size(node(1).domain_y, 2);
    
    for m = 1:2
        if m == 1
            num_node_sel = k_sel;
        else
            if isempty(k_in_sel) == 0
                num_node_sel = k_in_sel;
            else
                break;
            end
        end
        [do_1, do_2, num_var_sel] = dividing_process([node(num_node_sel).domain_x node(num_node_sel).domain_y]', ...
                                                    [node(1).domain_x node(1).domain_y]', size_x, priority_outer);
        counter_node = size(node, 2);
        if m == 1
            node(counter_node + 1) = struct('f_lb', node(num_node_sel).f_lb, 'f1_ub', node(num_node_sel).f1_ub, 'f2_ub', node(num_node_sel).f2_ub, 'F_lb', ...
                node(num_node_sel).F_lb, 'x', node(num_node_sel).x, 'depth', node(num_node_sel).depth + 1, 'domain_x', do_1(1:size_x)', 'domain_y', do_1(size_x+1:end)');
    
            node(counter_node + 2) = struct('f_lb', node(num_node_sel).f_lb, 'f1_ub', node(num_node_sel).f1_ub, 'f2_ub', node(num_node_sel).f2_ub, 'F_lb', ...
                node(num_node_sel).F_lb, 'x', node(num_node_sel).x, 'depth', node(num_node_sel).depth + 1, 'domain_x', do_2(1:size_x)', 'domain_y', do_2(size_x+1:end)');
        else
            node(counter_node + 1) = struct('f_lb', node(num_node_sel).f_lb, 'f1_ub', node(num_node_sel).f1_ub, 'f2_ub', node(num_node_sel).f2_ub, 'F_lb', ...
                [], 'x', [], 'depth', node(num_node_sel).depth + 1, 'domain_x', do_1(1:size_x)', 'domain_y', do_1(size_x+1:end)');
    
            node(counter_node + 2) = struct('f_lb', node(num_node_sel).f_lb, 'f1_ub', node(num_node_sel).f1_ub, 'f2_ub', node(num_node_sel).f2_ub, 'F_lb', ...
                [], 'x', [], 'depth', node(num_node_sel).depth + 1, 'domain_x', do_2(1:size_x)', 'domain_y', do_2(size_x+1:end)');
        end
    
        [p] = find_p(L_p, num_node_sel);
        p_stored(m) = p;
        if (num_var_sel > size_x/2)
    
            for i = 1:size(L_p, 2)
                
                 index_node = find( L_p{p,i} == num_node_sel);
                 if (isempty(index_node) == 0)
                    L_p{p,i}(index_node) = [];
                    L_p{p,i} = [L_p{p,i} counter_node+1 counter_node+2];
                 end
    
            end
    
        else
            size_temp = size(L_p, 2);
            for i = 1:size_temp
                if isempty(intersect(L_p{p, i}, num_node_sel)) == 0

                    temp = L_p{p, i};
                    index_node_sel = find(temp == num_node_sel);
                    temp(index_node_sel) = [];

                    if isempty(temp) == 0
                        [bool_lap_1] = check_over_lap (node, L_p, p, i, num_node_sel, counter_node + 1);
                        [bool_lap_2] = check_over_lap (node, L_p, p, i, num_node_sel, counter_node + 2);
                    else
                        bool_lap_1 = 1;
                        bool_lap_2 = 1;
                    end
                
                    %if bool_lap_1 == 1
                    %    L_p{p,i} = [temp counter_node + 1];
                    %elseif (counter_bool == 2)
                    %    L_p{p,size(L_p, 2) + 1} = [temp counter_node + 2];
                    %end
                    
                    if bool_lap_1 == 1
                        L_p{p,i} = [temp counter_node + 1];
                        if bool_lap_2 == 1
                            L_p{p,size(L_p, 2) + 1} = [temp counter_node + 2];
                        end
                    elseif bool_lap_2 == 1
                        L_p{p,i} = [temp counter_node + 2];
                    end

                end

            end
    
        end


        
    end

    [L_p] = IC_check(L_p, p_stored(1));
    %[best_f_ub] = updating_f_ub(node, L_p, size(L_p, 1), best_f_ub);
    if p_stored(2) ~= 0 && p_stored(1) ~= p_stored(2)
        [L_p] = IC_check(L_p, p_stored(2));
        %[best_f_ub] = updating_f_ub(node, L_p, size(L_p, 1), best_f_ub);
    end
    
end
