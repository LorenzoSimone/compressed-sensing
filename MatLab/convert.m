function xnew = convert(A,x,b)
    [m,n] = size(A);
    P = A(:,1:m);
    Q = A(:,m+1:n);

    xq = x(m+1:end);
    xp = P\(b-Q*xq);
    xnew = x;
end
