import numpy as np

def search_max(A, b, x, tol):
    m, n = A.shape
    B = []

    for i in range(m):
        row = np.abs( np.matmul(A[i][:],x) - b[i] )
        if( row <= tol ):
            B.append(i)

    print(('B Index result [{}/{}] active constraints').format(len(B), m))

    return B
