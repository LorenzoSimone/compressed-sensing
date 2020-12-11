clc
B = rand(5,5);
[L,U,P] = lu(B);

Bcol = B;
Bcol(:,2) = [1;2;3;4;5];

disp('L^-1 * B')
inv(L)*(P*B)
spy(inv(L)*(P*B))
disp('L^-1 * B+')
inv(L)*(P*Bcol)

disp('P_1 L^-1 * B+ * P_1T')

%Perform cycling operations
pi = [1,3,4,5,2];
P1 = eye(5);
P1 = P1([pi],:);

P1*(inv(L)*(P*Bcol))*P1'

disp('Correct');
f = inv(L)*(P*Bcol);
f(pi,pi)-P1*(inv(L)*(P*Bcol))*P1'

[L1,U1] = lu(P1*(inv(L)*(P*Bcol))*P1')
L1
U1
P1*(inv(L)*(P*Bcol))*P1'

L_p = L*P1'*L1;
U_p = U1*P1;

L_p * U_p
Bcol
%[]



%}









