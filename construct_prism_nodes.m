function [num_free_nodes, free_nodes] = construct_prism_nodes(...
    poly_angle, twist_angle, poly_radius, bar_length, num_bars)
    angle  = (0:num_bars-1)'*poly_angle;
    x_vals = poly_radius*cos(angle);
    y_vals = poly_radius*sin(angle);
    z_vals = zeros(num_bars,1);

    x_twisted = x_vals*cos(twist_angle) - y_vals*sin(twist_angle);
    y_twisted = x_vals*sin(twist_angle) + y_vals*cos(twist_angle);
    
    % From Equation 1.2 of Skelton
    s = bar_length^2 - 2*poly_radius^2 * (1 - cos(twist_angle + 2*pi));
    if s < 0
        error("Bars are too short!");
    end

    h = sqrt( ...
        s ...
        );
    z_twisted = h ...
        *ones(num_bars, 1);

    % Compute nodes
    num_free_nodes = 2*num_bars;
    free_nodes = [...
        x_vals, y_vals, z_vals;
        x_twisted, y_twisted, z_twisted]';
end