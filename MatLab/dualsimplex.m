function dualsimplex(A,b,c,state)

[m, n] = size(A);
ROWS = linspace(1,m,m);
B = ROWS(1:n);
N = ROWS(n+1:m);
iteration  = 1;

while(state == "")
    
    fprintf('||--------Iteration [%d]--------||\n', iteration);
    A_b = A(B,:); A_N = A(N,:);
    b_b = b(B); b_N = b(N);
    
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
    
    %Debug eta_b
   
    
    %Finding the exiting variable
    [theta, h] = min(eta_b.*(y(B).^(-1))');
  
    
    %Recalculating Basic and Non-Basic index vectors
    B = sort(setdiff(union(B,k),h));
    N = setdiff(ROWS, B);
    iteration = iteration+1;
    
    %[DEBUG] Printing variables as in the order of Exercise 2.31
    x
    A_nx
    b_N
    y
    k
    eta_b
    h
    B 
end