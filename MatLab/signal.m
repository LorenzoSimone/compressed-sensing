
m = 100; n = 1000;

f = 1/pi;
I = [0, 8];

a = 50;
b = 100;
time = sort((I(2)-I(1)).*rand(n,1) + I(1));
amplitude = sin(time);

x_d = randperm(length(time),m);
y_d = sin(x_d);

A = [];
b = y_d;

for i = 1:length(x_d)
    row = [];
    for j = 1:n
        row(end+1) = sin(j*x_d(i));
    end
    A = [A;row];
end


x_t = sort((I(2)-I(1)).*rand(n,1) + I(1));
y = [];

for i = 1:length(x_t)
    c = 0;
    for j = 1:n
        c = c + A(i,j) * sin(j*x_t(i));
    end
    y = [y;c];
end


%{
#Random sampling m timestamps
x_d = random.sample(list(time), m)
y_d = fun.sawtooth_wave(f,x_d)

#Calculating A, b matrices
A, b = build_solver(x_d, y_d, n)

#Compute learned function for new sampled points

x_t_ipm_l1 = np.sort(np.random.uniform(*I, 1000))
y_t_ipm_l1 = [sum_sines_function(x_ipm_l1, i) for i in x_t_ipm_l1]

#Plotting
fig, axs = plt.subplots(2,2)
fig.tight_layout(h_pad=3.5, w_pad=2)
%}

%{
A = rand(m,n);
x = rand(n,1);
b = rand(m,1);

vp = max(x,zeros(size(x)));
vm = max(-x,zeros(size(x)));
v = [vp;vm];
v
A1 = [A, -A; -A, A];
b1 = [b;-b];

a = projgrad(@obj_linear,A1,b1,v);
x = a(1:n)-a(n+1:end);
fprintf('Loss Ax=b  -> %.15f \n Norm |x| -> %.15f',norm(A*x - b),norm(x,1));
bar([x;a(1:n);-a(n+1:end)])
%}




