%swap
i = 2;
m = 3;

A = rand(m,m)
col = A(:,i)
A = [A(:,1:i-1),A(:,i+1:end),col]
row = A(i,:)
disp(size(row))
A = [A(1:i-1,:);A(i+1:end,:);row]
