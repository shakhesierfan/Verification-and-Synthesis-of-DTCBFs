
clc; clear;


%% Initialization ---------------------------------------------------------

% Physical system parameters (cart-pole example)
param.Ts = 0.01; 
param.mc = 2; 
param.mp = 0.1; 
param.L = 1; 
param.g = 9.81;
param.u_max = 35;

% Initial domain for the outer problem of the root note
d_x = [-30 30 -30 30 -30 30 -30 30 -30 30 -5 -0.1 -5 -0.1 -2 -0.1 0.1 1 0.1 1];

% Initial domain for the inner problem of the root note
d_y = [-pi/4 pi/4 -pi/4 pi/4 -pi/4 pi/4 -pi/4 pi/4];


% Algorithm tolerances
epsilon_F   = 0.2;
epsilon_f   = 1e-5;

% Branching priority
% The variable 'priority_outer' determines the branching order between the 
% outer and inner domains. 
%   - If priority_outer = 1: the outer and inner domains are divided 
%     sequentially. 
%   - If priority_outer > 1: higher values assign more priority to dividing 
%     the outer domain into smaller subdomains.
priority_outer = 2;


% Disable computation of the inner lower bound 
% (too loose for some examples). Set to 1 = off, 0 = on.
deactiv_f_lb = 1;

%% Node structure definition ----------------------------------------------
% Each node stores information about a subdomain of the bilevel problem.
% As the branch-and-sandwich algorithm progresses, nodes are split and
% updated with tighter lower/upper bounds.

node(1) = struct('f_lb', [], 'f1_ub', [], 'f2_ub', [], 'F_lb', [], 'x', [], 'depth', 0, 'domain_x', d_x, 'domain_y', d_y);

%% List management --------------------------------------------------------

L = 1;       % List of open nodes
L_in = [];   % List of outer-fathomed nodes
L_p{1} = 1;  % Sublist for the root node
n_node = 1;  % Total number of nodes created

% Initialize the root node for both Outer and Inner problems

if deactiv_f_lb == 0
    [f_lb] = f_lb_computed (node, 1, param); % Computing Inner lower bounding problem for the root node
else
    f_lb = -100;
end
[f1_ub, f2_ub] = f_ub_computed (node, 1, param);  % Computing Inner upper bounding problem for the root node
[F_lb, x_min, y_min] = outer_F_lb_computed (f1_ub, f2_ub, node, 1, epsilon_f, param); % Computing Outer lower bounding problem for the root node

node(1) = struct('f_lb', f_lb, 'f1_ub', f1_ub, 'f2_ub', f2_ub, 'F_lb', F_lb, 'x', x_min, 'depth', 0, 'domain_x', d_x, 'domain_y', d_y);

if (isempty(x_min) == 0) && (x_min(1) ~= 0 || x_min(2) ~= 0 || x_min(3) ~= 0 || ...
     x_min(4) ~= 0 || x_min(5) ~= 0 || x_min(6) ~= 0)
    [w1_sol, w2_sol] = w_sol_computer (node, x_min, param); % DTCBF valid ⇔ w1_sol ≥ 0; policy admissible ⇔ -w2_sol ≤ u_max^2
    if w1_sol >= 0 && -w2_sol <= param.u_max^2
        solution_F_UB = F_lb;
        solution_x = x_min;
        fprintf('****A valid DTCBF with a corresponding control policy is found****\n');
        fprintf('DTCBF:  %.4f*omega^2 + %.4f*theta^2 + %.4f*theta*omega + %.4f*omega + %.4f*theta + 1 \n', x_min(6), x_min(7), x_min(8), x_min(9), x_min(10)');
        fprintf('Control Policy:  %.4f*omega^2 + %.4f*theta^2 + %.4f*theta*omega + %.4f*omega + %.4f*theta \n', x_min(1), x_min(2), x_min(3), x_min(4), x_min(5)')
        % Wait for user
        input('If you would like to continue and find a DTCBF with a larger zero-superlevel set, press Enter to continue...','s');    
    else
        solution_F_UB = inf;
    end
else
    solution_F_UB = inf;
end

iter = 0;


while(isempty(L) == 0)
    iter = iter + 1;


    [k_sel, k_in_sel] = selection_process (node, L, L_in, L_p); % Select one node from open list and one from outer-fathomed list

    if node(k_sel).F_lb < solution_F_UB - epsilon_F  % Checking Outer-fathoming rules
    
            index_k_sel = find(k_sel == L);
            L(index_k_sel) = [];
        
            if (isempty(k_in_sel) == 0)
                index_k_in_sel = find(k_in_sel == L_in);
                L_in(index_k_in_sel) = [];
                n_new = 4; % Number of newly generated nodes
            else
                n_new = 2; % Number of newly generated nodes
            end
            
            [L_p, node] = update_list(L_p, node, k_sel, k_in_sel, priority_outer); % Subdivision process and List management

            for l_outer = n_node+1:n_node + n_new
                if deactiv_f_lb == 0
                    [node(l_outer).f_lb] = f_lb_computed(node, l_outer, param);
                else
                    node(l_outer).f_lb = -100;
                end
        
                [p] = find_p(L_p, l_outer);
                if isempty(p) == 0
                    [new_best_f1_ub,new_best_f2_ub] = new_updating_f_ub_k(node, L_p, l_outer);
                    
                    if node(l_outer).f_lb <= new_best_f1_ub + new_best_f2_ub && node(l_outer).f_lb ~= inf % Checking Inner-fathoming rules
                        if l_outer <= n_node + 2
                            L = [L l_outer];
                        else
                            L_in = [L_in l_outer];
                        end            
                    end
                end
                if isempty(intersect(l_outer, L)) == 0 || isempty(intersect(l_outer, L_in)) == 0
                    [node(l_outer).f1_ub, node(l_outer).f2_ub] = f_ub_computed(node, l_outer, param);
                    
                end
            
            end
        
            for l_outer = n_node + 1:n_node + n_new
        
                [p] = find_p(L_p, l_outer);
                if isempty(p) == 0
                    [L, L_in, L_p] = inner_fathoming(node, l_outer, L, L_in, L_p);
                    [L_p, L_in] = list_del_fath(L, L_in, L_p, p, []);
                end
            end
            
            for l_outer = n_node+1:n_node + 2
        
                if isempty(intersect(l_outer, L)) == 0 
                        
                    [p] = find_p(L_p, l_outer);
                    [new_best_f1_ub,new_best_f2_ub] = new_updating_f_ub_k(node, L_p, l_outer);
                    
                    [F_lb, x_min, y_min] = outer_F_lb_computed (new_best_f1_ub, new_best_f2_ub, node, l_outer, epsilon_f, param);
        
                    if F_lb ~= inf && F_lb < solution_F_UB - epsilon_F  % Checking Outer-fathoming rules
                        node(l_outer).F_lb = F_lb;
                        node(l_outer).x = x_min;
                        bool_test = 0;
                    else
                        if F_lb >=  solution_F_UB - epsilon_F && isempty(x_min) == 0
                            bool_test = 1;
                            node(l_outer).x = x_min;
                        else
                            bool_test = 0;
                        end
                        index_l = find(L == l_outer);
                        L(index_l) = [];
                        L_in = [L_in l_outer];
                        [p] = find_p(L_p, l_outer);
                        [L_p, L_in] = list_del_fath(L, L_in, L_p, p, []);
                    end
                
                    if (isempty(x_min) == 0) && (x_min(1) ~= 0 || x_min(2) ~= 0 || x_min(3) ~= 0 || x_min(4) ~= 0 || x_min(5) ~= 0 || x_min(6) ~= 0)
            
                        [w1_sol, w2_sol] = w_sol_computer (node, node(l_outer).x, param);
    
                        if w1_sol >= 0 && -w2_sol <= param.u_max^2
                            
                            solution_F_UB = F_lb;
                            solution_x = x_min;
                            fprintf('****A valid DTCBF with a corresponding control policy is found****\n');
                            fprintf('DTCBF:  %.4f*omega^2 + %.4f*theta^2 + %.4f*theta*omega + %.4f*omega + %.4f*theta + 1 \n', x_min(6), x_min(7), x_min(8), x_min(9), x_min(10)');
                            fprintf('Control Policy:  %.4f*omega^2 + %.4f*theta^2 + %.4f*theta*omega + %.4f*omega + %.4f*theta \n', x_min(1), x_min(2), x_min(3), x_min(4), x_min(5)');
                            fprintf('Final Control Admissible set: [-%.4f, %.4f]\n', sqrt(-w2_sol), sqrt(-w2_sol)');
                            % Wait for user
                            input('If you would like to continue and find a DTCBF with a larger zero-superlevel set, press Enter to continue...','s');    
    
                        end
            
                    end

                end
            
            end
        
            
            n_node = n_node + n_new;
            [L_p] = removing_empty_cells(L_p);

    else
            index_l = find(L == k_sel);
            L(index_l) = [];
            L_in = [L_in k_sel];
            [p] = find_p(L_p, k_sel);
            [L_p, L_in] = list_del_fath(L, L_in, L_p, p, []);
    end
end
