function [x,f_val, err] = solvesimplex(A,b)

    [m,n] = size(A);
    x = rand(n,1);
    vp = max(x,zeros(size(x)));
    vm = max(-x,zeros(size(x)));
    x = [vp;vm];
    A = [A, -A];
    bounds = zeros(size(x));
    c = ones(size(x));
    
    %Solving by linprog simplex original implementation
    [sol, f_val] = linprog(c,[],[],A,b,bounds);
    fprintf('Solving LP - function value: %f',norm(sol,1));
    x = sol(1:n) - sol(n+1:end);
    err = norm(A(:, 1:n)*x-b);
    fprintf('\nAx-b = %f',err);
    
end