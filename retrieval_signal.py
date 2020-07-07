import numpy as np
import random
import matplotlib.pyplot as plt
import scipy.optimize as opt

FUNCTION_STR = 'f(x) = np.sign(np.sin(x))'

def original_function(x):
    if hasattr(x, "__len__"):
        return [np.sin(i)**2 + np.cos(i)**2 for i in x]
    return np.sin(x)**2 + np.cos(x)**2

def sum_sines_function(a, x):
        y = 0
        for k in range(len(a)):
            y += a[k] * np.sin((k+1)*x)
        return y

def ipm_lin_solve(A,b):
    
    A, b = np.array(A), np.array(b)
    r, c = A.shape
    
    cF = np.ones(c*2)
    A_eq = np.concatenate((A, -A), axis = 1)
    b_eq = b

    x = opt.linprog(cF, A_eq = A_eq, b_eq = b_eq, bounds = (0, None))['x']

    return x[:c] - x[c:]
    
def build_solver(x_d,y_d, n):

    m = len(x_d)
    A = []
    b = y_d

    """
    Defining A matrix R^{m,n}
    Content of each row per m samples = sin(k*x_i) 
    with k ranging from 1 to n
    """
    for i in range(m):
        A.append([np.sin(j*x_d[i]) for j in range(1,n+1)])
    
    return A, b

#Number of samples
m, n = 1000, 1000

#Time interval f(x)
I = [0,3]

#Rate of sampling
r = 0.001

#Sinusoidal original function
time = np.arange(*I, r)
amplitude = original_function(time)

#Random sampling n timestamps
x_d = random.sample(list(np.arange(*I, r)), m)
y_d = [original_function(i) for i in x_d]



#Calculating A, b matrices
A, b = build_solver(x_d, y_d, n)

#Finding the LSS over the sum of sines approximation problem
#x = ipm_lin_solve(A,b)
x_lsq = np.linalg.lstsq(A, b, 1)[0]
x_ipm_l1 = ipm_lin_solve(A,b)

print('Solution for LSQ', x_lsq, '\n')
print('Solution for IPM-L1 min', x_ipm_l1, '\n')

#Compute learned function for new sampled points
x_t_lsq = sorted(random.sample(list(np.arange(*I, r)), 1000))
y_t_lsq = [sum_sines_function(x_lsq, i) for i in x_t_lsq]

#Compute learned function for new sampled points
x_t_ipm_l1 = sorted(random.sample(list(np.arange(*I, r)), 1000))
y_t_ipm_l1 = [sum_sines_function(x_ipm_l1, i) for i in x_t_ipm_l1]


"""
Plotting:
-Target Function
-Learned sum of sines
-Sampling points from target function
"""
plt.figure()
plt.plot(time, amplitude)
plt.plot(x_t_lsq, y_t_lsq)
plt.plot(x_d, y_d, '.', color='#1c79fc')
plt.title('Least Squares {}  m = {} , n = {}'.format(FUNCTION_STR, m,n))
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.grid(True, which='both')

plt.figure()
plt.plot(time, amplitude)
plt.plot(x_t_ipm_l1, y_t_ipm_l1)
plt.plot(x_d, y_d, '.', color='#1c79fc')
plt.title('L1 Min {}  m = {} , n = {}'.format(FUNCTION_STR, m,n))
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.grid(True, which='both')
plt.show()
