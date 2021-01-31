m = 2000; 
new_ind = 3;

B = rand(m,m);
[L,U,P] = lu(B);
tic
new_row = rand(m,1);
Bcol = B;
Bcol(:,new_ind) = new_row;

%disp('L^-1 * B')
%inv(L)*(P*B);

%spy(inv(L)*(P*B))

%disp('L^-1 * B+')
%inv(L)*(P*Bcol);

%%disp('P_1 L^-1 * B+ * P_1T')

%Perform cycling operations

pi = 1:m;
pi = [pi(1:new_ind-1),pi(new_ind+1:end), pi(new_ind)];

P1 = eye(m);
P1 = P1([pi],:);


L_inv = inv(L);

%P1*(inv(L)*(P*Bcol))*P1';

f = L_inv*(P*Bcol);
%f(pi,pi)-P1*(inv(L)*(P*Bcol))*P1';

prod = P1*(L_inv*(P*Bcol))*P1';

[L1,U1] = lu(prod);

L_p = L*P1'*L1;
U_p = U1*P1;
toc










