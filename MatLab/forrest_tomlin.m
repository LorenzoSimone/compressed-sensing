%function [L,U, sec, flops] = forrest_tomlin(Ab,Aq,q,refactor, L, U, P)
function forrest_tomlin(Ab,Aq,q,refactor, L, U, P)

tic
m = 5;
q = 2;
Ab = rand(m,m)

%New column
Aq = rand(m,1)

if(refactor)
    %New column
    [L,U,P] = lu(Ab);
end

L_inv = inv(L);
w = L_inv*(P*Aq)
Ab(:,q) = Aq;

U
disp('L^-1 Ab+')

%==============Ciclic permutations==============
L_inv_B_p = L_inv*(P*Ab)

%Row permuting
row = L_inv_B_p(q,:); 
L_inv_B_p = [L_inv_B_p(1:q-1,:);L_inv_B_p(q+1:end,:);row];

%Column permuting
col = L_inv_B_p(:,q);
L_inv_B_p = [L_inv_B_p(:,1:q-1),L_inv_B_p(:,q+1:end),col];


disp('Result')
disp(L_inv_B_p)

L_one = ones(size(L));
L_one(end,:) = [0,L(end,2:end-1),1];
U_one = L_inv_B_p;

%{

U_one(end,end) = Ab(end, end)/((L(end,2:end-1).*U(end,2:end-1)));

%==============Permutation Matrix==============
pi = 1:m;
pi = [pi(1:new_ind-1),pi(new_ind+1:end), pi(new_ind)];

P1 = eye(m);
P1 = P1([pi],:);

L_p = L*P1'*L_one;
U_p = U_one*P1;

L_p*U_p 
Ab
%}

end

%{
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
%}










