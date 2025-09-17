function [f1_ub, f2_ub] = f_ub_computed (node, k, param)

f1_ub = node(k).f1_ub;
f2_ub = node(k).f2_ub;
optFilePath = 'couenne.opt';

% Open file in write mode — this clears existing content
fid = fopen(optFilePath, 'w');
fclose(fid);

fid = fopen(optFilePath, 'w');
fprintf(fid, 'feasibility_bt no\n');
fprintf(fid, 'redcost_bt no\n');
fprintf(fid, 'aggressive_fbbt no\n');
fprintf(fid, 'optimality_bt no\n');
fprintf(fid, 'bonmin.node_limit 200\n');
fprintf(fid, 'bonmin.time_limit 8\n');
fclose(fid);

dx = node(k).domain_x;
dy = node(k).domain_y;
%% f1_ub

lb_vals = [dx(1:2:20), dy(1:2:4), zeros(1, 5), -1e3];
ub_vals = [dx(2:2:20), dy(2:2:4), 1e3*ones(1, 5), 1e3];

%=== Write data.dat ===
fid = fopen('f1_ub_computed.dat', 'w');
fprintf(fid, 'param Ts := %g;\n', param.Ts);
fprintf(fid, 'param mc := %g;\n', param.mc);
fprintf(fid, 'param mp := %g;\n', param.mp);
fprintf(fid, 'param g  := %g;\n', param.g);
fprintf(fid, 'param L  := %g;\n\n', param.L);

% Write lb parameter values
fprintf(fid, 'param lb :=\n');
for i = 1:18
    fprintf(fid, ' %d %g\n', i, lb_vals(i));
end
fprintf(fid, ';\n\n');

% Write ub parameter values
fprintf(fid, 'param ub :=\n');
for i = 1:18
    fprintf(fid, ' %d %g\n', i, ub_vals(i));
end
fprintf(fid, ';\n');

fclose(fid);


ampl = AMPL();
ampl.read('f1_ub_computed.mod');
ampl.readData('f1_ub_computed.dat');
ampl.setOption('solver', 'couenne');
%ampl.setOption('couenne_options', 'bonmin.time_limit=100');
ampl.setOption('log_file', 'f1_ub_log.log');
ampl.solve();
stat = ampl.getValue("solve_result");

if stat == "infeasible"
    f1_ub = node(k).f1_ub;
else

    obj_val = ampl.getObjective('obj').value();
    fprintf('Objective value: %.6f\n', obj_val);
    
    lines = readlines('f1_ub_log.log');
    
    % Find line containing 'Lower bound:'
    idx = find(contains(lines, 'Lower bound:'), 1);
    
    
    if ~isempty(idx)
        line = lines(idx);
        % Extract the numeric value after 'Lower bound:'
        tokens = regexp(line, 'Lower bound:\s*(-?[\d\.eE+-]+)', 'tokens');
        if ~isempty(tokens)
            lb_str = tokens{1}{1};
            f1_ub = -str2double(lb_str);
            fprintf('Extracted lower bound: %g\n', f1_ub);
        else
            warning('Could not parse lower bound number.');
        end
    else
        warning('Lower bound line not found in the log.');
    end
end
%% f2_ub
clear ampl fid

lb_vals = [dx(1:2:20), dy(5:2:8), zeros(1, 5), -1e2];
ub_vals = [dx(2:2:20), dy(6:2:8), 1e2*ones(1, 5), 1e2];

%=== Write data.dat ===
fid = fopen('f2_ub_computed.dat', 'w');
fprintf(fid, 'param Ts := %g;\n', param.Ts);
fprintf(fid, 'param mc := %g;\n', param.mc);
fprintf(fid, 'param mp := %g;\n', param.mp);
fprintf(fid, 'param g  := %g;\n', param.g);
fprintf(fid, 'param L  := %g;\n\n', param.L);

% Write lb parameter values
fprintf(fid, 'param lb :=\n');
for i = 1:18
    fprintf(fid, ' %d %g\n', i, lb_vals(i));
end
fprintf(fid, ';\n\n');

% Write ub parameter values
fprintf(fid, 'param ub :=\n');
for i = 1:18
    fprintf(fid, ' %d %g\n', i, ub_vals(i));
end
fprintf(fid, ';\n');

fclose(fid);


ampl = AMPL();
ampl.read('f2_ub_computed.mod');
ampl.readData('f2_ub_computed.dat');
ampl.setOption('solver', 'couenne');
%ampl.setOption('couenne_options', 'bonmin.time_limit=10000');

ampl.setOption('log_file', 'f2_ub_log.log');

ampl.solve();
stat = ampl.getValue("solve_result");


if stat == "infeasible"
    f2_ub = node(k).f2_ub;
else

    obj_val = ampl.getObjective('obj').value();
    fprintf('Objective value: %.6f\n', obj_val);
    
    lines = readlines('f2_ub_log.log');
    
    % Find line containing 'Lower bound:'
    idx = find(contains(lines, 'Lower bound:'), 1);
    
    
    if ~isempty(idx)
        line = lines(idx);
        % Extract the numeric value after 'Lower bound:'
        tokens = regexp(line, 'Lower bound:\s*(-?[\d\.eE+-]+)', 'tokens');
        if ~isempty(tokens)
            lb_str = tokens{1}{1};
            f2_ub = -str2double(lb_str);
            fprintf('Extracted lower bound: %g\n', f2_ub);
        else
            warning('Could not parse lower bound number.');
        end
    else
        warning('Lower bound line not found in the log.');
    end

end

end
