function [domain_new_first, domain_new_second, number_selected] = dividing_process(domain, domain_initial, size_x, priority_outer)

    number_selected = 1;
    max_dividing = 0;
    
    for i = 1:1:size(domain, 1)/2           %size(domain, 1)/2   *********
        
        if i <= size_x/2
            coeff_priorty = 1;
        else
            coeff_priorty = priority_outer;
        end
            
        if (domain(2*i) - domain(2*i - 1)) /(domain_initial(2*i) - domain_initial(2*i - 1)) > max_dividing*coeff_priorty
            max_dividing = (domain(2*i) - domain(2*i - 1))/(domain_initial(2*i) - domain_initial(2*i - 1));
            number_selected = i;
        end
    
    end

    domain_new_first  = zeros(size(domain,1), 1);
    domain_new_second = zeros(size(domain,1), 1);

    for i = 1:size(domain, 1)/2

        if i == number_selected
            domain_new_first(2*i - 1)   = domain(2*i - 1);
            domain_new_first(2*i)       = (domain(2*i - 1) + domain(2*i))/2;

            domain_new_second(2*i - 1)   = (domain(2*i - 1) + domain(2*i))/2;
            domain_new_second(2*i)       = domain(2*i);

        else
            domain_new_first(2*i - 1)   = domain(2*i - 1);
            domain_new_first(2*i)       = domain(2*i);

            domain_new_second(2*i - 1)   = domain(2*i - 1);
            domain_new_second(2*i)       = domain(2*i);
        end

    end

end
