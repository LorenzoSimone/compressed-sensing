function [fun, grad] = obj_linear(x)    
    fun = sum(x);
    grad = ones(size(x));
end
