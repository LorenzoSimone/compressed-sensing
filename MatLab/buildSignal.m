%Sine Function implementation Report (1) Problem
function [A,x,b, x_n, y_n, x_m] = buildSignal(m,n, interval)  
    
    x_n = linspace(interval(1),interval(end),n);
    y_n = signal_function(x_n)';
    
    perm = randperm(length(x_n),m);
    x_m = x_n(perm);
    
    A = rand(m,n);
    x = rand(n,1);
    b = signal_function(x_m)';

    %Initializing A matrix according to sin(j*x_i)
    for i = 1:m
        for j = 1:n
            A(i,j) = sin(j*x_m(i));
        end
    end
end