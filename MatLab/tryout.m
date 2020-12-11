h = 12;
A = triu(rand(10,10),1);
A(:,7) = ones(10,1);


spy(A,'k')

x=get(gca,'children')
set(x(1),'color',[0 0 0])
set(x(2),'color',[0.5 0.5 0])
set(x(3),'color',[0 0 1])

A==10

