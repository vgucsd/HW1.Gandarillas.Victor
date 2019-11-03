close all
clc
clear

% We are generating a 4 bar nonminimal prism
% Number of members (bars and strings)
num_bars    = 4;
num_strings = 3*num_bars;
num_members = num_bars + num_strings;

twist_angle = pi/2-pi/num_bars;

poly_angle  = 2*pi/num_bars;
r           = 1;
l           = 1.5*r;

[num_free_nodes, free_nodes] = construct_prism_nodes(...
    poly_angle, ...
    twist_angle, ...
    r, ...
    l, ...
    num_bars);

% Construct connectivity matrix for Nonminimal Prism
C = zeros(num_members, num_free_nodes);

% bars
C(1,1) = 1;
C(1,6) = -1;
C(2,2) = 1;
C(2,7) = -1;
C(3,3) = 1;
C(3,8) = -1;
C(4,4) = 1;
C(4,5) = -1;

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
C(num_bars+9,1) = 1;
C(num_bars+9,5) = -1;
C(num_bars+10,2) = 1;
C(num_bars+10,6) = -1;
C(num_bars+11,3) = 1;
C(num_bars+11,7) = -1;
C(num_bars+12,4) = 1;
C(num_bars+12,8) = -1;

twist_angle_deg = twist_angle*180/pi

% No forces on the free nodes by default
forces = zeros(3, num_free_nodes);

% Analyze truss
% num_strings = 1
[c_bars, t_strings, V] = tensegrity_statics(num_bars, num_strings, ...
    num_free_nodes, 0, 3, free_nodes, [], C, ...
    forces);

% Verify connectivity matrix by visualizing truss
figure;
tensegrity_plot(free_nodes, [], C, num_bars, ...
    num_strings, forces, V)