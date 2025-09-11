function [F_lb, x_min, y_min] = outer_F_lb_computed (f1_ub_value, f2_ub_value, node, k, epsilon_f, param)

optFilePath = 'couenne.opt';

% Open file in write mode — this clears existing content
fid = fopen(optFilePath, 'w');
fclose(fid);

fid = fopen(optFilePath, 'w');
%fprintf(fid, 'feasibility_bt no\n');
%fprintf(fid, 'acceptable_constr_viol_tol 1e-10\n');
fprintf(fid, 'bonmin.node_limit 1000\n');
fprintf(fid, 'bonmin.time_limit 10\n');
fclose(fid);

initial_dy = node(1).domain_y;

init_lb_vals = [initial_dy(1:2:8)];
init_ub_vals = [initial_dy(2:2:8)];

dx = node(k).domain_x;
dy = node(k).domain_y;

lb_vals = [dx(1:2:20), dy(1:2:8), zeros(1, 10)];
ub_vals = [dx(2:2:20), dy(2:2:8), 1e3*ones(1, 10)];

%=== Write data.dat ===
fid = fopen('outer_F_lb_computed.dat', 'w');
fprintf(fid, 'param Ts := %g;\n', param.Ts);
fprintf(fid, 'param mc := %g;\n', param.mc);
fprintf(fid, 'param mp := %g;\n', param.mp);
fprintf(fid, 'param g  := %g;\n', param.g);
fprintf(fid, 'param L  := %g;\n\n', param.L);
fprintf(fid, 'param u_max := %g;\n\n', param.u_max);
fprintf(fid, 'param f1_ub := %g;\n\n', f1_ub_value);
fprintf(fid, 'param f2_ub := %g;\n\n', f2_ub_value);
fprintf(fid, 'param epsilon_f := %g;\n\n', epsilon_f);

% Write lb parameter values
fprintf(fid, 'param lb :=\n');
for i = 1:24
    fprintf(fid, ' %d %g\n', i, lb_vals(i));
end
fprintf(fid, ';\n\n');

% Write ub parameter values
fprintf(fid, 'param ub :=\n');
for i = 1:24
    fprintf(fid, ' %d %g\n', i, ub_vals(i));
end
fprintf(fid, ';\n');

fprintf(fid, 'param initial_lb :=\n');
for i = 1:4
    fprintf(fid, ' %d %g\n', i, init_lb_vals(i));
end
fprintf(fid, ';\n');

fprintf(fid, 'param initial_ub :=\n');
for i = 1:4
    fprintf(fid, ' %d %g\n', i, init_ub_vals(i));
end
fprintf(fid, ';\n');

fclose(fid);




ampl = AMPL();
ampl.read('outer_F_lb_computed.mod');
ampl.readData('outer_F_lb_computed.dat');
ampl.setOption('solver', 'couenne');
ampl.setOption('log_file', 'outer_F_lb_log.log');
ampl.solve();

obj_val = ampl.getObjective('obj').value();
fprintf('Objective value: %.6f\n', obj_val);
stat = ampl.getValue("solve_result");


lines = readlines('outer_F_lb_log.log');

% Find line containing 'Lower bound:'

idx = find(contains(lines, 'Lower bound:'), 1);


if stat == "infeasible"
    F_lb = inf;
    x_min =[];
    y_min = [];
else
    F_lb = -obj_val;
    x_var = ampl.getVariable('x');
    x_values = x_var.getValues();    
    x_min = [];
    for i = 1:10
        temp = x_values(i);
        size_temp = size(temp);
        x_min = [x_min temp{size_temp(1)}{2}];
    end
    y_min = [];

end


end
