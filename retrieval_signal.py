import numpy as np
import random
import matplotlib.pyplot as plt
import scipy.optimize as opt

FUNCTION_STR = 'f(x) = np.sign(np.sin(x))'

def original_function(x):
    if hasattr(x, "__len__"):
        return [np.sin(i) + np.cos(i) + np.sin(7*i) for i in x]
    return np.sin(x) + np.cos(x) + np.sin(7*x)

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
m, n = 100, 200

#Time interval f(x)
I = [0,20]

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

#Compute learned function for new sampled points
x_t_lsq = sorted(random.sample(list(np.arange(*I, r)), 1000))
y_t_lsq = [sum_sines_function(x_lsq, i) for i in x_t_lsq]

#Compute learned function for new sampled points
x_t_ipm_l1 = sorted(random.sample(list(np.arange(*I, r)), 1000))
y_t_ipm_l1 = [sum_sines_function(x_ipm_l1, i) for i in x_t_ipm_l1]


#Plotting:

fig, axs = plt.subplots(2, 2)

fig.tight_layout(h_pad=2, w_pad=2)
axs[0,0].plot(time, amplitude)
axs[0,0].plot(x_t_lsq, y_t_lsq)
axs[0,0].scatter(x_d, y_d, s=1.5, color='#1c79fc')
axs[0,0].set_title(r'$(P_1)\:min\:|Ax - b|_2^2$')
axs[0,0].set_xlabel('Time')
axs[0,0].set_ylabel('Amplitude')
axs[0,0].grid(True, which='both')

axs[0,1].plot(time, amplitude)
axs[0,1].plot(x_t_ipm_l1, y_t_ipm_l1)
axs[0,1].scatter(x_d, y_d, s=1.5, color='#1c79fc')
axs[0,1].set_title(r'$(P_2)\:min_{s.t\:\:Ax = b}\:||x||_1$')
axs[0,1].set_xlabel('Time')
axs[0,1].set_ylabel('Amplitude')
axs[0,1].grid(True, which='both')

axs[1,0].bar(list(range(len(x_lsq))), np.abs(x_lsq))
axs[1,0].set_title(r'($P_1)\:Solution Coefficients$')
axs[1,0].grid(True, which='both')

axs[1,1].plot(list(range(len(x_ipm_l1))), np.abs(x_ipm_l1))
axs[1,1].set_title(r'$(P_2)\:Solution Coefficients$')
axs[1,1].grid(True, which='both')

plt.show()
