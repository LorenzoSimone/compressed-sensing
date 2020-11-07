import numpy as np
from search import search_max
from feasibility import prepare_system
from scipy.optimize import line_search

def objective_f(x):
    return np.sum(x)
def gradient_f(x):
    return np.ones_like(x)

def pgm(f, f_grad, A, b, x, eps):
    
    m,n = A.shape

    #Constraints preparation
    row_1 = np.concatenate((A, -A), axis = 1)
    row_2 = np.concatenate((-A, A), axis = 1) 
    row_3 = np.eye(2*n)
    A_lt = np.concatenate((row_1, row_2, row_3), axis = 0)

    b_lt = np.concatenate((b, -b, np.zeros((2*n,))), axis = 0)

    grad = f_grad(x)
    mu = np.zeros((2*m+2*n,1))
    c = 0

    while(True):
        
        B = search_max(A_lt,b_lt,x, eps)
        
        while(True):
            c+=1
            print(('\nIteration {}\nError: {}').format(c,np.linalg.norm(np.matmul(A_lt,x) - b_lt)))
            # d = [(nxn) - (nxm)[(mxn)(nxm)](mxn) [(nx1)] = (nx1)
            # d = I - AbT x [Ab x AbT]^-1 x Ab (-\delta f(x) )
            
            #TODO INVERSE NOT WORKING SINGULAR MATRIX 
            inv = np.linalg.pinv(np.matmul(A_lt[B], A_lt[B].T)) #2m2n x 2n * 2n x 2m2n = 2m2n x 2m2n
            left = np.matmul(A_lt[B].T, inv) # 2n x 2m2n * 2m2n x 2m2n = 2n x 2m2n
            right = np.matmul(left, A_lt[B]) # 2n x 2m2n * 2m2n x 2n = 2n x 2n
            d = np.matmul(np.eye(2*n) - right, -grad)

            """
            print('I',np.eye(n))
            print('MOL', np.matmul(np.matmul(A_lt[B].T, inv), A_lt[B] ))
            print('SUB', np.eye(n) - np.matmul(np.matmul(A_lt[B].T, inv), A_lt[B] ))
            print('SUM 1', np.sum((np.eye(n) - np.matmul(np.matmul(A_lt[B].T, inv), A_lt[B] ))[0]))
            print('SUM 2', np.sum((np.eye(n) - np.matmul(np.matmul(A_lt[B].T, inv), A_lt[B] ))[1]))
            print('SUM 3', np.sum((np.eye(n) - np.matmul(np.matmul(A_lt[B].T, inv), A_lt[B] ))[2]))
            print('SUM 4', np.sum((np.eye(n) - np.matmul(np.matmul(A_lt[B].T, inv), A_lt[B] ))[3]))
            """
            
            dir_derivative = np.matmul(grad.T, d)
            
            if(dir_derivative <= eps):
                print('Negative directional derivative ->', dir_derivative)
                print(B)
                mu[B] = np.matmul(np.matmul(-inv, A_lt[B]), grad)
                
                #Setting active constraints mu -> 0
                for con in list(set(range(m)) - set(B)):
                    mu[con] = 0
                
                if( (mu[B] >= 0).all()):
                    #print('Mu positives')
                    return x
                
                #Remove unsatisfied constraints from B
                h = np.min(np.nonzero(mu<0)[0])
                print('Eliminating ',h)
                print('B Before', B)
                B = np.setdiff1d(B,h)                 
                print('B After', B)
                continue
            
            alpha = []
            k = []
            for i in range(m):
                if(i not in B and np.matmul(A_lt[i],d)[0][0] > 0 ):
                    if (dist == 0):
                        k.append(i)
                    dist = ( b_lt[i] - np.matmul(A_lt[i],x)[0][0] ) / np.matmul(A_lt[i],d)[0][0]
                    alpha.append(dist)

            alpha_bar = np.min(alpha) if len(alpha) else 100
            if(alpha_bar > 0):
                break
        
            if(len(k)):
                np.append(B, k[0])
        
        d = d.reshape((d.shape[0],))
        alpha = line_search(objective_f, gradient_f, list(x), d)[0]
        x = x + alpha*d
    
    print('Failed')

m, n = 3, 4
A = np.random.uniform(-2,4, (m,n))
b = np.random.uniform(-3,5, (m))

v_pos, v_neg, y, x = prepare_system(A,b)

sol = pgm(objective_f, gradient_f, A, b, x, 1e-9)

print('\n-----------------Solution PGM-----------------')
print('\nL1 Norm:', np.linalg.norm(sol[:n]-sol[n:n*2],1))
print('Error:', np.linalg.norm(np.matmul(A,sol[:n]-sol[n:n*2]) - b))


            
