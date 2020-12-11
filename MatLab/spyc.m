dim = 20;
h = 10;
c = rand(dim,dim);

[L,U] = lu(c);
U(:,h) = ones(dim,1);

pi = linspace(1,dim,dim);
pi(h:end) = pi(h:end)+1;
pi(end) = pi(h)-1;

I = eye(dim);
I = I(pi,:);
pi
I

spy(I*U*I')
%spy(U)