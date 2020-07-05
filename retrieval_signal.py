import numpy as np
import random
import matplotlib.pyplot as plt

FUNCTION_STR = 'f(x) = np.sign(np.sin(x))'

def original_function(x):
    if hasattr(x, "__len__"):
        return [np.sign(np.sin(i)) for i in x]
    return np.sign(np.sin(x))

def sum_sines_function(a, x):
        y = 0
        for k in range(len(a)):
            y += a[k] * np.sin((k+1)*x)
        return y

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
        A.append([np.sin(j*x_d[i]) for j in range(1,n)])
    
    return A, b

#Number of samples
m, n = 1000, 20

#Time interval f(x)
I = [0,20]

#Rate of sampling
r = 0.01

#Sinusoidal original function
time = np.arange(*I, r)
amplitude = original_function(time)

#Random sampling n timestamps
x_d = random.sample(list(np.arange(*I, r)), m)
y_d = [original_function(i) for i in x_d]

#Calculating A, b matrices
A, b = build_solver(x_d, y_d, n)

#Finding the LSS over the sum of sines approximation problem
x = np.linalg.lstsq(A, b, 1)[0]

#Compute learned function for new sampled points
x_t = sorted(random.sample(list(np.arange(*I, r)), m))
y_t = [sum_sines_function(x, i) for i in x_t]


"""
Plotting:
-Target Function
-Learned sum of sines
-Sampling points from target function
"""
plt.figure()
plt.plot(time, amplitude)
plt.plot(x_t, y_t)
plt.plot(x_d, y_d, '.', color='#1c79fc')
plt.title('{}  m = {} , n = {}'.format(FUNCTION_STR, m,n))
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.grid(True, which='both')
plt.show()
