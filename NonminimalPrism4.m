close all
clc
clear

% We are generating a 4 bar nonminimal prism
% Number of members (bars and strings)
num_bars    = 4;
num_strings = 3*num_bars;
num_members = num_bars + num_strings;


% Make tension in diagonal strings equal to tension in vertical strings
% Eq. 3.66, Skelton
syms alfa
twist_angle = ...
    eval(...
        solve(...
            2 * cos(alfa) * cos(pi / num_bars) == ...
                -cos(alfa + pi / num_bars) ...
        ) ...
    );
twist_angle = real(twist_angle(2));
if pi / 2 - pi / num_bars > twist_angle || twist_angle > pi / 2
    error("twist_angle not okay!");
end

poly_angle  = 2*pi/num_bars;
poly_radius = 1;
bar_length  = 1.5*poly_radius;

[num_free_nodes, free_nodes] = construct_prism_nodes(...
    poly_angle, ...
    twist_angle, ...
    poly_radius, ...
    bar_length, ...
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

% nonminimal strings
num_strings = 16;
C(num_bars+13,1) = 1;
C(num_bars+13,8) = -1;
C(num_bars+14,2) = 1;
C(num_bars+14,5) = -1;
C(num_bars+15,3) = 1;
C(num_bars+15,6) = -1;
C(num_bars+16,4) = 1;
C(num_bars+16,7) = -1;

% No forces on the free nodes by default
forces = zeros(3, num_free_nodes);
twist_angle_deg =  twist_angle*180/pi

% Analyze truss
% num_strings = 1
[c_bars, t_strings, V] = tensegrity_statics(num_bars, num_strings, ...
    num_free_nodes, 0, 3, free_nodes, [], C, ...
    forces);

% Verify connectivity matrix by visualizing truss
tensegrity_plot(free_nodes, [], C, num_bars, ...
    num_strings, forces, V)


% Expected Output

% mhat =
% 
%     24
% 
% 
% nhat =
% 
%     20
% 
% 
% r =
% 
%     17
% 
% Warning: Ase is potentially inconsistent, implying the presence of soft modes,
% or instability!  More strings or fixed points should fix the problem.
%  
% Bar compressions and string tensions with loads as specified,
% least squares solution (i.e., NO pretensioning):
% u in column space of Ase, so at least one solution exists, with residual 0.
% 
% c_bars =
% 
%      0     0     0     0
% 
% No bars under tension.  Good.
% 
% t_strings =
% 
%      0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
% 
% Some strings not under tension. Needs different tensioning or external loads.
%  
% Ase is underdetermined with 3 DOF. Checking now to see if system is pretensionable,
% with tension >= 0.1 in all tethers for zero applied load.
%  
% Result with external load ZERO, pretensioned with given tau_min
% while minimizing the L1 norm of the tensions:
% 
% c_bars =
% 
%     0.4406    0.4406    0.4406    0.4406
% 
% No bars under tension.  Good.
% 
% t_strings =
% 
%   Columns 1 through 10
% 
%     0.2253    0.2253    0.2253    0.2253    0.2253    0.2253    0.2253    0.2253    0.1511    0.1511
% 
%   Columns 11 through 16
% 
%     0.1511    0.1511    0.1000    0.1000    0.1000    0.1000
% 
% The 16 strings are all under tension with tau_min=0.1. Good.
%  
% Pretensionable!
% Results with external forces u as specified and tensioned with given tau_min
% while minimizing the L1 norm of the tensions.
% 
% c_bars =
% 
%     0.4406    0.4406    0.4406    0.4406
% 
% No bars under tension.  Good.
% 
% t_strings =
% 
%   Columns 1 through 10
% 
%     0.2253    0.2253    0.2253    0.2253    0.2253    0.2253    0.2253    0.2253    0.1511    0.1511
% 
%   Columns 11 through 16
% 
%     0.1511    0.1511    0.1000    0.1000    0.1000    0.1000
% 
% The 16 strings are all under tension with tau_min=0.1. Good.
%  