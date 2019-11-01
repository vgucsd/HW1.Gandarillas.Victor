function [num_free_nodes, Q] = locate_free_nodes(order, n_mag, n_phase)
    % Locations of free nodes
    num_free_nodes = (order + 1) * order / 2;
    Q              = zeros(2, num_free_nodes);
    k              = 1;
    for i=0:order-1
        for j=0:order-(i+1)
            Q(1,k) = n_mag(i+1, j+1)*cos(n_phase(i+1, j+1));
            Q(2,k) = n_mag(i+1, j+1)*sin(n_phase(i+1, j+1));
            k      = k + 1;
        end
    end
end