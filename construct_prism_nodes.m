function [num_free_nodes, free_nodes] = construct_prism_nodes(...
    poly_angle, twist_angle, r, num_bars)
    angle  = (0:num_bars-1)'*poly_angle;
    x_vals = r*cos(angle);
    y_vals = r*sin(angle);
    z_vals = zeros(num_bars,1);

    x_twisted = x_vals*cos(twist_angle) - y_vals*sin(twist_angle);
    y_twisted = x_vals*sin(twist_angle) + y_vals*cos(twist_angle);

    z_twisted = sqrt(r^2 ...
        - (x_twisted(1) - x_vals(1))^2 ...
        - (y_twisted(1) - y_vals(1))^2) ...
        *ones(num_bars, 1);

    % Compute nodes
    num_free_nodes = 2*num_bars;
    free_nodes = [...
        x_vals, y_vals, z_vals;
        x_twisted, y_twisted, z_twisted]';
end