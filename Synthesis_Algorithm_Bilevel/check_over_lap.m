function [bool_lap] = check_over_lap (node, L_p, p, s, k, k_1)
    
    size_do_x = size(node(1).domain_x, 2)/2;
    bool_lap = 1;
    
    for i = 1:size(L_p{p, s}, 2)
        if L_p{p, s}(i) ~= k
            counter_lap = 0;
            for j = 1:size_do_x

                x_lb_k = node(k_1).domain_x(2*(j) - 1);
                x_ub_k = node(k_1).domain_x(2*(j));
    
                x_lb_1 = node(L_p{p, s}(i)).domain_x(2*(j) - 1);
                x_ub_1 = node(L_p{p, s}(i)).domain_x(2*(j));
    
                if x_ub_1 > x_lb_k && x_ub_k > x_lb_1
                    %bool_lap = 0;
                    %break;
                    counter_lap = counter_lap + 1;
                end
            end
            if (counter_lap < size_do_x)
                bool_lap = 0;
                break;
            end
        end
    end

end








