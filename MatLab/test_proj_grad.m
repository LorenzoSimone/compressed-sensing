
m = 20; n = 100;
INTERVAL = [0,3];
PLOT_POINTS = 1000;

[A,x,b, x_n, y_n, x_m] = buildSignal(m,n, INTERVAL);

fprintf('Error at first -> %f \t ||x|| = %f', norm(A*x -b), norm(x,1));

%Solving the non-differentiability problem
vp = max(x,zeros(size(x)));
vm = max(-x,zeros(size(x)));
v = [vp;vm];

new_x = v;
new_A = [A, -A];

%{
%Splitting A Matrix in [P,Q]
P = new_A(:,1:m);
Q = new_A(:,m+1:end);

%Calculating the new x
xq = new_x(m+1:end);
xp = P\(b-Q*xq);
new_x = [xp; xq];
%}

%Uncomment to use our implementation
sol = projgrad(@math_fun,new_A,b,new_x);
sol = convert(new_A,sol,b);



%{
LINPROG MATLAB ORIGINAL IMPL. PGD/SIMPLEX
%Solving by linprog procedure
f = ones(size(new_x));
sol = linprog(f,[],[],new_A,b,zeros(size(new_x)));
sol = convert(new_A,sol,b);
%}

x_res = sol(1:n) - sol(n+1:end);

%Reconstructing the signal through the solution 'x'
[rec_x, rec_y] = reconstruct(x_res', PLOT_POINTS, INTERVAL);

fprintf('Loss Ax=b  -> %.15f \n Norm |x| -> %.15f',norm(A*x_res - b), norm(x_res(m+1:end),1));

subplot(2,1,1);
plot(x_n,y_n);
hold on
plot(x_m,b,'s','MarkerSize',10, 'MarkerFaceColor',[1 .6 .6]);

subplot(2,1,2);
plot(x_n,y_n);
hold on
plot(rec_x,rec_y);
hold on
plot(x_m,b,'s','MarkerSize',10, 'MarkerEdgeColor','red', 'MarkerFaceColor',[1 .6 .6]);

function [fun, grad] = math_fun(x)    
    fun = sum(x);
    grad = ones(size(x));
end




