def projgrad(objfun, A,b,x0):
    """
    solve with PGD
    minimize f(x)
    s.t.     Ax <= b
    objfun is function handle defining the objective, must return function
    value f(x) and gradient df(x)
    %
    Algorithm
    given x0
    1) xk = Pr(x0)               : Project x0 on to set Ax <= b 
    2) dk = Pr(xk-grad(xk)) - xk : project search direction onto feasible set
    3) xk = xk + tk*dk  : tk is step size - armijo backtrack linesearch
    4) repeat.
    """

    # Parameters
    MAXITER   = 100
    tol       = 1e-2
    alpha_tol = 1e-6
    c         = 0.5

    # save iterate information
    data    = {}
    data["x0"] = x0
    data["x"]  = [] # iterates
    data["d"]  = [] # search directions
    data["g"]  = [] # gradients

    # initial iterate should be feasible
    xk = pg(x0,A,b)
    nx = x0.shape[0]

    for k in range(1,MAXITER+1):
        
        # compute function and gradient
        f_k,g_k = objfun(xk)

        # compute search direction (projected steepest descent)
        d_k = pg(xk-g_k,A,b)-xk
        
        # terminate if this is an ascent direction
        if np.dot(g_k,d_k)[0][0] > 0

            data["x"]  = [data.x,xk]
            data["d"]  = [data.d,d_k]
            data["g"]  = [data.g,g_k]

            print(k, f_k, norm(g_k), norm(d_k), g_k.T*d_k, 1)
            print('\nExiting: step direction is not descent direction\n\n')
            break
        
        # step size
        alpha_k = 1

        # linesearch by armijo backtracking
        xk1 = xk+alpha_k*d_k
        f_k1 = objfun(xk1)
        while (f_k1 > f_k + c*alpha_k*g_k.T*d_k and alpha_k > alpha_tol):
            # backstep alpha_k
            alpha_k = 0.5 * alpha_k

            # evaluate function at new iterate
            xk1 = xk + alpha_k * d_k
            f_k1 = objfun(xk1)

        # record the iterates
        data["x"]  = [data.x,xk]
        data["d"]  = [data.d,d_k]
        data["g"]  = [data.g,g_k]

        # update iterate
        xk = xk1
        
        # print progress
        print(k, f_k, norm(g_k), norm(d_k), g_k.T*d_k, alpha_k, toc)
        
        # stopping criteria
        if np.linalg.norm(d_k) < tol
            print('\nExiting: step direction smaller than tolerance tol = # .4e\n\n',tol)
            break
        
        if alpha_k < alpha_tol
            print('\nExiting: step size smaller than tolerance tol = # .4e\n\n',alpha_tol)
            break

    return xk

def pg(y,A,b):
# project y onto the feasible set Ax <= b, i.e. nearest feasible point x to y
# minimize 0.5||x-y||^2
# s.t.     Ax <= b   

# equivalent to
# min J   = 0.5 x'x - x'y + 0.5 y'y
# st. Ax <= b

n = length(y)
H = np.identity(n)
x0 = y
options = optimset('Display','off')
x = quadprog(H,-y,A,b,[],[],[],[],x0,options)




function printIter(iter, f_k, g_k_norm, d_k_norm, D_k, alpha_k, CPUtime)
# print the iteration progress

if nargin==0
# Store output header and footer strings as persistent variables
out_line = '================================================================================'
out_data = '  k        f          ||g||        ||d||        g^T*d        alpha       CPU (s)'

# print algorithm output header
print('\nBeginning projected gradient descent ...\n')
print('%s\n%s\n%s\n', out_line, out_data, out_line)
return


# Print iterate information
print('# 4d  # .4e  # .4e  # .4e  # .4e  # .4e   # .5f\n',iter, f_k, g_k_norm, d_k_norm, D_k, alpha_k, CPUtime)



