function [num_fixed_nodes, fixed_nodes] = locate_fixed_nodes(order, n_mag, n_phase)
    % Locations of fixed nodes
    num_fixed_nodes = order + 1;
    fixed_nodes               = zeros(2, num_fixed_nodes);
    k               = 1;
    for i=0:order
        j=order-i;
        fixed_nodes(1,k) = n_mag(i+1, j+1)*cos(n_phase(i+1, j+1));
        fixed_nodes(2,k) = n_mag(i+1, j+1)*sin(n_phase(i+1, j+1));
        k      = k + 1;
    end
end