function new_x = convert(A,x,b) 
    m = size(A,1);
    
    P = A(:,1:m);
    xq = x(m+1:end);
    Q = A(:,m+1:end);
    xp = P\(b-Q*xq);
    
    new_x = [xp; xq];
end

