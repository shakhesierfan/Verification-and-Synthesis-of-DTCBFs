function lb = f_lb_computed(node, k, param)
optFilePath = 'couenne.opt';

% Open file in write mode — this clears existing content
fid = fopen(optFilePath, 'w');
fclose(fid);

fid = fopen(optFilePath, 'w');
fprintf(fid, 'feasibility_bt no\n');
fprintf(fid, 'redcost_bt no\n');
fprintf(fid, 'aggressive_fbbt no\n');
fprintf(fid, 'optimality_bt no\n');
fprintf(fid, 'bonmin.node_limit 100\n');
fprintf(fid, 'bonmin.time_limit 1\n');
fclose(fid);


dx = node(k).domain_x;
dy = node(k).domain_y;
lb_vals = [dx(1:2:20), dy(1:2:8)];
ub_vals = [dx(2:2:20), dy(2:2:8)];

%=== Write data.dat ===
fid = fopen('f_lb_computed.dat', 'w');
fprintf(fid, 'param Ts := %g;\n', param.Ts);
fprintf(fid, 'param mc := %g;\n', param.mc);
fprintf(fid, 'param mp := %g;\n', param.mp);
fprintf(fid, 'param g  := %g;\n', param.g);
fprintf(fid, 'param L  := %g;\n\n', param.L);

% Write lb parameter values
fprintf(fid, 'param lb :=\n');
for i = 1:14
    fprintf(fid, ' %d %g\n', i, lb_vals(i));
end
fprintf(fid, ';\n\n');

% Write ub parameter values
fprintf(fid, 'param ub :=\n');
for i = 1:14
    fprintf(fid, ' %d %g\n', i, ub_vals(i));
end
fprintf(fid, ';\n');

fclose(fid);


ampl = AMPL();
ampl.read('f_lb_computed.mod');
ampl.readData('f_lb_computed.dat');
ampl.setOption('solver', 'couenne');
ampl.setOption('log_file', 'f_lb_log.log');
ampl.solve();

obj_val = ampl.getObjective('obj').value();
stat = ampl.getValue("solve_result");
fprintf('Objective value: %.6f\n', obj_val);

lines = readlines('f_lb_log.log');

% Find line containing 'Lower bound:'
idx = find(contains(lines, 'Lower bound:'), 1);

if stat == "infeasible"
    fprint("wow")
    lb = node(k).f_lb;
else

    if ~isempty(idx)
        line = lines(idx);
        % Extract the numeric value after 'Lower bound:'
        tokens = regexp(line, 'Lower bound:\s*(-?[\d\.eE+-]+)', 'tokens');
        if ~isempty(tokens)
            lb_str = tokens{1}{1};
            lb = str2double(lb_str);
            fprintf('Extracted lower bound: %g\n', lb);
        else
            warning('Could not parse lower bound number.');
        end
    else
        warning('Lower bound line not found in the log.');
    end
end

end
