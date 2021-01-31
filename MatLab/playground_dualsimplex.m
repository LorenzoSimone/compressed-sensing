m = 30; n = 1000;
INTERVAL = [0,30];
PLOT_POINTS = 1000;
x = rand(n,1);

%signals = [@signal_square, @signal_triangle, @signal_sawtooth];
signal = @(x) cos(5*x) + cos(100*x);
signal = @cos;

%Constructing matrix A,b,x
[A,b] = buildSignal(m,n,signal, INTERVAL);
vp = max(x,zeros(size(x)));
vm = max(-x,zeros(size(x)));
x = [vp;vm];
A = [A, -A];

bounds = zeros(size(x));
upper_bounds = ones(size(x))*1000;
c = ones(size(x));

%Solving by linprog simplex original implementation
tic
options = optimoptions('linprog','Algorithm','interior-point');
[sol, f_val, exit_flag, output] = linprog(c,[],[],A,b,bounds,upper_bounds,options);
toc
%[sol, f_val, exit_flag, output] = linprog(c,[],[],A,b,bounds);

fprintf('Solving LP - function value: %f',f_val);
x_res = sol(1:n) - sol(n+1:end);

%Reconstruct the signal
[rec_x, rec_y] = reconstruct(x_res', PLOT_POINTS, INTERVAL);

%TODO Solving by dualsimplex our implementation
[ds_m, ds_n] = size(A);
c = ones(size(x));
M = 10000;
ds_A = [A';eye(ds_m)];
ds_c = b;
ds_b = [c;ones(m,1)*M];
ds_B = linspace(ds_n+1, ds_m+ds_n, m);

[ds_x, ds_y] = dualsimplex(ds_A,ds_b,ds_c,ds_B,10,'',0);
ds_y = ds_y(:,1:2*n)';
ds_res = ds_y(1:n) - ds_y(n+1:end);

%Reconstruct the signal
[ds_rec_x, ds_rec_y] = reconstruct(ds_res', PLOT_POINTS, INTERVAL);
    
%Plotting
fprintf('Size A %dx%d\n', size(ds_A,1),size(ds_A,2));
fprintf('Size b %dx%d', size(ds_b,1),size(ds_b,2));

x_point = linspace(INTERVAL(1),INTERVAL(end),PLOT_POINTS);
y_point = signal(x_point);

subplot(3,1,1);
plot(x_point,y_point);
hold on
legend('Original wave')
title('Signal f[x] = sin(x)')

subplot(3,1,2);
plot(x_point,y_point);
hold on
plot(rec_x,rec_y);
legend('Original wave', 'Reconstructed wave')
title('MATLAB Implementation')

subplot(3,1,3);
plot(x_point,y_point);
hold on
plot(ds_rec_x,ds_rec_y);
legend('Original wave', 'Reconstructed wave')
title('Dual Simplex Implementation')

figure(2)
x0=10;
y0=10;
width = 600;
height = 250;
set(gcf,'position',[x0,y0,width,height])
plot(x_point,y_point);
hold on
grid ON
plot(rec_x,rec_y);
legend('Original wave', 'Reconstructed wave')

figure(3)
x0=10;
y0=10;
width = 600;
height = 250;
set(gcf,'position',[x0,y0,width,height])
grid ON
bar(sol(1:200))

%Error ||Ax - b||_2
err = norm(A*sol-b');

%Objective function value ||x||_1
fun_val = norm(x_res, 1);

%Computing MSE, Correlation Coefficient
[mse, corr] = metrics(rec_y, y_point);

headers = {'n','m','err','f_val', 'MSE', 'CORR'};
R = [n,m,err, fun_val, mse, corr];

fprintf('\n');
fprintf('|%20s|', headers{1:end});
fprintf('\n');
fprintf('|%20d||%20d||%20e||%20e||%20e||%20f|',R(1),R(2),R(3),R(4),R(5),R(6));
