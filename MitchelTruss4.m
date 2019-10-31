close all
clc
clear

% We are generating a truss made of Michell Spirals of order 4 and lower
order = 4;

% Number of members (bars and strings)
num_bars    = (order + 1) * order / 2;
num_strings = num_bars;
num_members = num_bars + num_strings;

% Angles defining Michell Spiral
beta = pi/6;
phi  = pi/16;

r0=1;

% Compute nodes
[num_nodes, n_mag, n_phase]    = generate_nodes(order, beta, phi, r0);
[num_fixed_nodes, fixed_nodes] = locate_fixed_nodes(...
    order, ...
    n_mag, ...
    n_phase);
[num_free_nodes, free_nodes]  = locate_free_nodes(...
    order, ...
    n_mag, ...
    n_phase);

% Construct connectivity matrix for Michell Spiral and its reflection
% about horizontal axis
C = zeros(num_members, num_nodes);

% bars
C(1,1) = 1;
C(1,2) = -1;
C(2,2) = 1;
C(2,3) = -1;
C(3,3) = 1;
C(3,4) = -1;
C(4,5) = 1;
C(4,6) = -1;
C(5,6) = 1;
C(5,7) = -1;
C(6,8) = 1;
C(6,9) = -1;
C(7,4) = 1;
C(7,11) = -1;
C(8,7) = 1;
C(8,12) = -1;
C(9,9) = 1;
C(9,13) = -1;
C(10,10) = 1;
C(10,14) = -1;

% strings
C(11,1) = 1;
C(11,5) = -1;
C(12,5) = 1;
C(12,8) = -1;
C(13,8) = 1;
C(13,10) = -1;
C(14,10) = 1;
C(14,15) = -1;
C(15,2) = 1;
C(15,6) = -1;
C(16,6) = 1;
C(16,9) = -1;
C(17,9) = 1;
C(17,14) = -1;
C(18,3) = 1;
C(18,7) = -1;
C(19,7) = 1;
C(19,13) = -1;
C(20,4) = 1;
C(20,12) = -1;

% No forces on the free nodes by default
forces = zeros(2, num_free_nodes);
% uniform load
forces = zeros(2, num_free_nodes);
forces(2,:) = -1;
% downward tip load
forces = zeros(2, num_free_nodes);
forces(2,1) = -1;

% Analyze truss
[c_bars, t_strings, V] = tensegrity_statics(num_bars, num_strings, ...
    num_free_nodes, num_fixed_nodes, 2, free_nodes, fixed_nodes, C, ...
    forces);

% Verify connectivity matrix by visualizing truss
tensegrity_plot(free_nodes, fixed_nodes, C, num_bars, ...
    num_strings, forces, V)


% Expected Output

% For all four cases described, the output should be as follows
% (c_bars and t_strings results not included)

% Ase is not potentially inconsistent. Good.
% ...
% Ase is not underdetermined (thus, it is not tensionable). The above solution is unique.

% With zero load,
% Some strings not under tension. Needs different tensioning or external loads.

% With tip load of 1,
% The 10 strings are all under tension with tau_min=0.22527. Good.