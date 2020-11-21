function dualsimplex(A,b,c,state)

%Finding a good basis
[m, n] = size(A);
ROWS = linspace(1,m,m);
B = ROWS(1:n);
N = ROWS(n+1:m);
iteration  = 1;

while(state == "")
    
    fprintf('||--------Iteration [%d]--------||\n', iteration);
    A_b = A(B,:); A_N = A(N,:);
    b_b = b(B); b_N = b(N);
    B
    A_b
    A_b_inv = inv(A_b);

    %Initialization of x_ and y_
    x =  A_b_inv*b_b;    
    y = zeros(1,m);
    y(B) = c*A_b_inv;
    
    %Checking optimal condition
    A_nx = A_N * x;
    if all(A_nx <= b_N)
        fprintf('||--------End [%d]--------||\n', iteration);
        fprintf('||--------Optimal solution found--------||\n');
        state = "optimal";
        break
    end
    
    %Finding the entering variable
    min_k = find(A_nx > b_N, 1, 'first');
    
    k = N(min_k);

    eta_b = A(k,:)* A_b_inv;
        
    %Primal empty check
    if all(eta_b <= zeros(size(eta_b)))
        fprintf('||--------End [%d]--------||\n', iteration);
        fprintf('||--------Primal set is empty--------||\n');
        state = "P.empty";
        break
    end
    
    %Finding the exiting variable
    pos_eta = find(eta_b > 0);
    y_b = y(B);
    
    [theta, h] = min(y_b(pos_eta)./(eta_b(pos_eta)));
    k
    h = B(h);

    %Recalculating Basic and Non-Basic index vectors
    B = union(setdiff(B, h), k);
    N = setdiff(ROWS, B);
    iteration = iteration+1;
    
    %[DEBUG] Printing variables as in the order of Exercise 2.31
    %{
    x
    A_nx
    b_N
    y
    k
    eta_b
    h
    %}
    
end