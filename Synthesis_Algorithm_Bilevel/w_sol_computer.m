function [w1_sol_min, w2_sol_min] = w_sol_computer (node, x_min, param)

optFilePath = 'couenne.opt';

% Open file in write mode — this clears existing content
fid = fopen(optFilePath, 'w');
fclose(fid);

fid = fopen(optFilePath, 'w');
%fprintf(fid, 'feasibility_bt no\n');
%fprintf(fid, 'redcost_bt no\n');
%fprintf(fid, 'aggressive_fbbt no\n');
%fprintf(fid, 'optimality_bt no\n');

fprintf(fid, 'bonmin.node_limit 5000\n');
fprintf(fid, 'bonmin.time_limit 40\n');
fprintf(fid, 'acceptable_constr_viol_tol 1e-8\n');
fprintf(fid, 'constr_viol_tol 1e-8\n');
fprintf(fid, 'acceptable_dual_inf_tol 1e-8\n');
fprintf(fid, 'acceptable_compl_inf_tol 1e-8\n');
fclose(fid);

dy = node(1).domain_y;
%% w1 -----

lb_vals = [dy(1:2:4)];
ub_vals = [dy(2:2:4)];

%=== Write data.dat ===
fid = fopen('w1_computed.dat', 'w');
fprintf(fid, 'param Ts := %g;\n', param.Ts);
fprintf(fid, 'param mc := %g;\n', param.mc);
fprintf(fid, 'param mp := %g;\n', param.mp);
fprintf(fid, 'param g  := %g;\n', param.g);
fprintf(fid, 'param L  := %g;\n\n', param.L);
fprintf(fid, 'param k1 := %g;\n\n', x_min(1));
fprintf(fid, 'param k2 := %g;\n\n', x_min(2));
fprintf(fid, 'param k3 := %g;\n\n', x_min(3));
fprintf(fid, 'param k4 := %g;\n\n', x_min(4));
fprintf(fid, 'param k5 := %g;\n\n', x_min(5));
fprintf(fid, 'param A := %g;\n\n', x_min(6));
fprintf(fid, 'param B := %g;\n\n', x_min(7));
fprintf(fid, 'param C := %g;\n\n', x_min(8));
fprintf(fid, 'param D := %g;\n\n', x_min(9));
fprintf(fid, 'param E := %g;\n\n', x_min(10));


% Write lb parameter values
fprintf(fid, 'param lb :=\n');
for i = 1:2
    fprintf(fid, ' %d %g\n', i, lb_vals(i));
end
fprintf(fid, ';\n\n');

% Write ub parameter values
fprintf(fid, 'param ub :=\n');
for i = 1:2
    fprintf(fid, ' %d %g\n', i, ub_vals(i));
end
fprintf(fid, ';\n');

fclose(fid);


ampl = AMPL();
ampl.read('w1_computed.mod');
ampl.readData('w1_computed.dat');
ampl.setOption('solver', 'couenne');
ampl.setOption('couenne_options', 'bonmin.time_limit=100');
ampl.setOption('log_file', 'w1_computed.log');
ampl.solve();

obj_val = ampl.getObjective('obj').value();
fprintf('Objective value: %.6f\n', obj_val);

lines = readlines('w1_computed.log');

% Find line containing 'Lower bound:'
idx = find(contains(lines, 'Lower bound:'), 1);


if ~isempty(idx)
    line = lines(idx);
    % Extract the numeric value after 'Lower bound:'
    tokens = regexp(line, 'Lower bound:\s*(-?[\d\.eE+-]+)', 'tokens');
    if ~isempty(tokens)
        lb_str = tokens{1}{1};
        w1_sol_min = str2double(lb_str);
        fprintf('Extracted lower bound: %g\n', w1_sol_min);
    else
        warning('Could not parse lower bound number.');
    end

else
    warning('Lower bound line not found in the log.');
end


%% w2 -----
if w1_sol_min < 0 
    w2_sol_min = inf;
else
    clear ampl fid
    
    lb_vals = [dy(5:2:8)];
    ub_vals = [dy(6:2:8)];
    
    %=== Write data.dat ===
    fid = fopen('w2_computed.dat', 'w');
    fprintf(fid, 'param Ts := 0.01;\n');
    fprintf(fid, 'param mc := 2;\n');
    fprintf(fid, 'param mp := 0.1;\n');
    fprintf(fid, 'param g := 9.81;\n');
    fprintf(fid, 'param L := 1;\n\n');
    fprintf(fid, 'param k1 := %g;\n\n', x_min(1));
    fprintf(fid, 'param k2 := %g;\n\n', x_min(2));
    fprintf(fid, 'param k3 := %g;\n\n', x_min(3));
    fprintf(fid, 'param k4 := %g;\n\n', x_min(4));
    fprintf(fid, 'param k5 := %g;\n\n', x_min(5));
    fprintf(fid, 'param A := %g;\n\n', x_min(6));
    fprintf(fid, 'param B := %g;\n\n', x_min(7));
    fprintf(fid, 'param C := %g;\n\n', x_min(8));
    fprintf(fid, 'param D := %g;\n\n', x_min(9));
    fprintf(fid, 'param E := %g;\n\n', x_min(10));
    
    
    % Write lb parameter values
    fprintf(fid, 'param lb :=\n');
    for i = 1:2
        fprintf(fid, ' %d %g\n', i, lb_vals(i));
    end
    fprintf(fid, ';\n\n');
    
    % Write ub parameter values
    fprintf(fid, 'param ub :=\n');
    for i = 1:2
        fprintf(fid, ' %d %g\n', i, ub_vals(i));
    end
    fprintf(fid, ';\n');
    
    fclose(fid);
    
    
    ampl = AMPL();
    ampl.read('w2_computed.mod');
    ampl.readData('w2_computed.dat');
    ampl.setOption('solver', 'couenne');
    ampl.setOption('couenne_options', 'bonmin.time_limit=10000');
    
    ampl.setOption('log_file', 'w2_computed.log');
    
    ampl.solve();
    
    obj_val = ampl.getObjective('obj').value();
    fprintf('Objective value: %.6f\n', obj_val);
    
    lines = readlines('w2_computed.log');
    
    % Find line containing 'Lower bound:'
    idx = find(contains(lines, 'Lower bound:'), 1);
    
    
    if ~isempty(idx)
        line = lines(idx);
        % Extract the numeric value after 'Lower bound:'
        tokens = regexp(line, 'Lower bound:\s*(-?[\d\.eE+-]+)', 'tokens');
        if ~isempty(tokens)
            lb_str = tokens{1}{1};
            w2_sol_min = str2double(lb_str);
            fprintf('Extracted lower bound: %g\n', w2_sol_min);
        else
            warning('Could not parse lower bound number.');
        end
    else
        warning('Lower bound line not found in the log.');
    end


end


end
