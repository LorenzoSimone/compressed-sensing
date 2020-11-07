function [J,dJ] = objective(x,Q,f)

J = norm(x,1);

if nargout > 1
dJ = ones(size(x));
end