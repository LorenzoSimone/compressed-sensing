m = 10; n = 100;
INTERVAL = [0,10];
PLOT_POINTS = 1000;
x = rand(n,1);

%Constructing matrix A,b,x
[A,b,x_m,y_m ] = buildSignal(m,n, INTERVAL);
vp = max(x,zeros(size(x)));
vm = max(-x,zeros(size(x)));
x = [vp;vm];
A = [A, -A];

bounds = zeros(size(x));
c = ones(size(x));

%Solving by linprog simplex original implementation
[sol, f_val] = linprog(c,[],[],A,b,bounds);
fprintf('Solving LP - function value: %f',f_val);
x_res = sol(1:n) - sol(n+1:end);

%Reconstruct the signal
[rec_x, rec_y] = reconstruct(x_res', PLOT_POINTS, INTERVAL);


%TODO Solving by dualsimplex our implementation
[ds_m, ds_n] = size(A);
c = ones(size(x));
M = 100;
ds_A = [A';eye(ds_m)];
ds_c = b';
ds_b = [c;ones(m,1)*M];
ds_B = linspace(ds_n+1, ds_m+ds_n, m);
[ds_x, ds_y] = dualsimplex(ds_A,ds_b,ds_c,ds_B,'',0);
ds_y = ds_y(:,1:ds_n)';
ds_res = ds_y(1:n) - ds_y(n+1:end);

%Reconstruct the signal
[ds_rec_x, ds_rec_y] = reconstruct(ds_res', PLOT_POINTS, INTERVAL);

%Plotting
x_point = linspace(INTERVAL(1),INTERVAL(end),PLOT_POINTS);
y_point = signal_function(x_point);

subplot(3,1,1);
plot(x_point,y_point);
legend('Original wave')
title('Signal f[x] = sin(30x)')

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

