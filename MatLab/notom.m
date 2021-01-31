tic
m = 1000; 

A = inv(rand(m,m));
b = rand(m,1);

a = rand(m,m)*b;
b = rand(m,m)*b;
c = rand(m,m)*b;
toc