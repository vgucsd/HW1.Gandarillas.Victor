function [num_nodes, n_mag, n_phase] = generate_nodes(order, beta, phi, r0)
    % Scale factors for node radial positions and member lengths
    % TODO: test a = 1; expect to generate secants
    a         = sin(beta)/sin(beta+phi);

    % Generate node radial positions and member lengths
    radii          = zeros(order,1);
    radii(1)       = r0;
    for l=1:order
        radii(l+1) = a*radii(l);
    end

    % Set up magnitudes and phases of members of a Mitchell Spiral
    n_mag   = zeros(order+1, order+1);
    n_phase = zeros(order+1, order+1);
    k_max   = order;
    for i=0:order
        for k=0:k_max
            n_mag(i+1, k+1)   = radii(i+k+1);
            n_phase(i+1, k+1) = (i-k)*phi;
        end
        k_max = k_max - 1;
    end
    
    num_nodes = (order + 2) * (order + 1) / 2;
end