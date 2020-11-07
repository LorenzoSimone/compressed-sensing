import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt

def prepare_system(A,b):

    m,n = A.shape

    # v+ = max(v, 0)
    # v- = max(-v, 0)
    # x  = v+ - v-
    # v  = [v+ v-]
    """
    A, b = np.array(A), np.array(b)
    r, c = A.shape
    
    cF = np.ones(c*2)
    A_eq = np.concatenate((A, -A), axis = 1)
    b_eq = b

    x = opt.linprog(cF, A_eq = A_eq, b_eq = b_eq, bounds = (0, None))['x']

    return x[:c] - x[c:]
    """

    c = np.concatenate( (np.zeros((n*2,1)),(np.ones((m, 1))) ), axis = 0)

    Aeq = np.concatenate( (A,-A, np.ones((m,m))), axis = 1)
    sol = opt.linprog(c, A_eq = Aeq, b_eq = b, bounds = (0, None))['x']
    xp, xn, y = sol[:n], sol[n:2*n], sol[-m:]
    xret = np.concatenate((xp,xn), axis = 0)
    xret = np.reshape(xret, (xret.shape[0],1))

    return (xp, xn, y , xret)

"""
m, n = 400, 4000
A = np.random.uniform(2,200, (m,n))
b = np.random.uniform(9,100, (m))

v_pos, v_neg, y = prepare_system(A,b)
x = v_pos - v_neg

print('|| Ax - b || = ', np.linalg.norm(np.matmul(A,x) + y - b))
print('|| Y ||', np.linalg.norm(y))
"""