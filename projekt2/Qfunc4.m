function [x] = Qfunc2(constants, t)
%QFUN2 Summary of this function goes here
%   Detailed explanation goes here
    A = constants(1);
    B = constants(2);
    k_a = constants(3);
    lambda = constants(4);
    mu = constants(5);
    
    x = A*(exp(-lambda*t) - exp(-k_a*t)) + B*(exp(-mu*t) - exp(-k_a*t));


end

