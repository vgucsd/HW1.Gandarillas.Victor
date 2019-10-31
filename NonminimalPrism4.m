close all
clc
clear

% We are generating a 4 bar nonminimal prism
% Number of members (bars and strings)
num_bars    = 4;
num_strings = 3*num_bars;
num_members = num_bars + num_strings;

% Define prism
twist_angle = pi/2-pi/num_bars;
poly_angle  = 2*pi/num_bars;
r           = 1;

[num_free_nodes, free_nodes] = construct_prism_nodes(...
    poly_angle, ...
    twist_angle, ...
    r, ...
    num_bars);

% Construct connectivity matrix for Nonminimal Prism
C = zeros(num_members, num_free_nodes);

% bars
C(1,1) = 1;
C(1,5) = -1;
C(2,2) = 1;
C(2,6) = -1;
C(3,3) = 1;
C(3,7) = -1;
C(4,4) = 1;
C(4,8) = -1;

% strings
C(num_bars+1,1) = 1;
C(num_bars+1,2) = -1;
C(num_bars+2,2) = 1;
C(num_bars+2,3) = -1;
C(num_bars+3,3) = 1;
C(num_bars+3,4) = -1;
C(num_bars+4,4) = 1;
C(num_bars+4,1) = -1;
C(num_bars+5,5) = 1;
C(num_bars+5,6) = -1;
C(num_bars+6,6) = 1;
C(num_bars+6,7) = -1;
C(num_bars+7,7) = 1;
C(num_bars+7,8) = -1;
C(num_bars+8,8) = 1;
C(num_bars+8,5) = -1;
C(num_bars+9,2) = 1;
C(num_bars+9,5) = -1;
C(num_bars+10,3) = 1;
C(num_bars+10,6) = -1;
C(num_bars+11,4) = 1;
C(num_bars+11,7) = -1;
C(num_bars+12,1) = 1;
C(num_bars+12,8) = -1;

% nonminimal strings
% num_strings      = 20;
% C(num_bars+13,2) = 1;
% C(num_bars+13,7) = -1;
% C(num_bars+14,3) = 1;
% C(num_bars+14,8) = -1;
% C(num_bars+15,4) = 1;
% C(num_bars+15,5) = -1;
% C(num_bars+16,1) = 1;
% C(num_bars+16,6) = -1;
% C(num_bars+17,1) = 1;
% C(num_bars+17,7) = -1;
% C(num_bars+18,2) = 1;
% C(num_bars+18,8) = -1;
% C(num_bars+19,3) = 1;
% C(num_bars+19,5) = -1;
% C(num_bars+20,4) = 1;
% C(num_bars+20,6) = -1;


% C(num_bars+13,2) = 1;
% C(num_bars+13,4) = -1;
% C(num_bars+14,3) = 1;
% C(num_bars+14,1) = -1;
% C(num_bars+15,6) = 1;
% C(num_bars+15,8) = -1;
% C(num_bars+16,5) = 1;
% C(num_bars+16,7) = -1;


% No forces on the free nodes by default
forces = zeros(3, num_free_nodes);
% forces(3,1:num_bars) = 1;
% forces(3,num_bars+1:2*num_bars) = -1;

% Analyze truss
% num_strings = 1
[c_bars, t_strings, V] = tensegrity_statics(num_bars, num_strings, ...
    num_free_nodes, 0, 3, free_nodes, [], C, ...
    forces);

% Verify connectivity matrix by visualizing truss
tensegrity_plot(free_nodes, [], C, num_bars, ...
    num_strings, forces, V)


% Expected Output
