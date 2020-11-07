
m = 10; n = 100;

A = rand(m,n);
x = rand(n,1);
b = rand(m,1);

%{  Sine Function implementation Reporte (1) Problem
    %Initializing A matrix according to sin(j*x_i)
    %{
    x_points = linspace(-3,3,m);
    for i = 1:m
        for j = 1:n
            A(i,j) = sin(j*x_points(i));
        end
    end
    %}

    %{
    %Initializing b as fun(x_i) observations
    b = sin(x_points);
    %}
%}

vp = max(x,zeros(size(x)));
vm = max(-x,zeros(size(x)));


v = [vp;vm];
A1 = [A, -A; -A, A];
b1 = [b;-b];


a = projgrad(@math_fun,A1,b1,v);
x = a(1:n)-a(n+1:end);

fprintf('Loss Ax=b  -> %.15f \n Norm |x| -> %.15f',norm(A*x - b),norm(x,1));
bar([x;a(1:n);-a(n+1:end)])

%{
% Converting to equality case by using naive approach
A = [A;-A];
b = [b,-b];

[sol,data] = projgrad(@math_fun,A,b,x);

fprintf('==============================================\n');
fprintf('  f(x)                      |Ax-b|\n');

fprintf('  %.15f        %.15f', sum(sol), norm(A(1:m,:)*sol-b(1:m),2));
%}

function [fun, grad] = math_fun(x)    
    fun = sum(x);
    grad = ones(size(x));
end




