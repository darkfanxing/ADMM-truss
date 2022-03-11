%% Initial Setting
N_X = 5;                    % X-axis grid number
N_Y = 2;                    % Y-axis grid number
V = 2 * N_X * N_Y * 10^5;   % Volume Fraction, Unit: mm^3
E = 20 * 10^9;              % Young's Modulus, Unit: Pa
n = 4;                      % Upper bound of number of free nodes
M = 10^5;                   % Unit: m

% define load value and position
node_number = (N_X + 1) * (N_Y + 1);
f = zeros(2 * node_number, 1);
f(end) = 100 * 10^3;        % Force, Unit: N

mu = 1.5;                   % Control Augmented Lagrangian Method's penalty
rho = 1;                    % Initialize Penalty parameter in augmented Lagrangian
v = 0;                      % Initialize v
epsilon = 0.1;              % Parameter about the stop criteria

%% Parameter That Optimization Problem Used

m = int64(node_number * (node_number - 1) / 2); % members connected between nodes
Z = initialize_Z(node_number, m); % Z of z = Zx
coordinates = get_node_coordinates(N_X, N_Y);
[c, b] = get_truss_properties(Z, coordinates); % predefine and get truss length (c) and stiffness matrix (K)

cvx_begin
    variable w(m)
    variable t
    variable x(m)
    variable u(m)
    
    % Objective Function
    sum_w = 0
    for i = 1:m
        sum_w = sum_w + w(i)
    end
    
    minimize(sum_w + 0.5*rho*t)
    
    subject to
        temp_f = 0
        for i = 1:m
            w(i) + x(i) >= norm([w(i)-x(i); 2*sqrt(c(i)/E)*(E*x(i)) / c(i)*b(i).'*u(i)], 2) % problem (22c)
            temp_f = temp_f + (E*x(i)/c(i))*b(i).'*u(i)*b(i)
        end
        temp_f == f % problem (22d)
        c.'*x <= V % probelm (22e)
        t+1 >= norm([t-1; 2*(Z*x - z + v)]) % problem (22b)
cvx_end