function dualsimplex(A,b,c,B,state)

[m, n] = size(A);
ROWS = linspace(1,m,m);
iteration  = 1;

%Default basis if it is not provided
if ~length(B)  
    B = ROWS(1:n);  
    disp('non me lo dai');
end

N = setdiff(ROWS, B);

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
        %[DEBUG] Exercise 2.33 Printing variables 
        A_nx
        b_N
        eta_b
        c*x
        k
        state = "P.empty";
        break
    end
    
    %Finding the exiting variable
    theta = y(B)./eta_b;

    [v, i] = min(theta(eta_b>0));
    i = find(theta == v & eta_b > 0);
    h = B(i);
    
    %[DEBUG] Printing variables as in the order of Exercise 2.31
    B
    x
    A_nx
    b_N
    y
    k
    eta_b
    h
    
    %Recalculating Basic and Non-Basic index vectors
    B(B==h)=k;
    N = setdiff(ROWS, B);
    iteration = iteration+1;
end