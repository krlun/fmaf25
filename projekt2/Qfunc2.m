function [x] = Qfunc2(constants, t)
%QFUN2 Summary of this function goes here
%   Detailed explanation goes here
    F = constants(1);
    k_a = constants(2);
    A = constants(3);
    lambda = constants(4);
    B = constants(5);
    mu = constants(6);
    
    x = F*k_a*A/(k_a - lambda)*(exp(-lambda*t) - exp(-k_a*t)) + F*k_a*B/(k_a-mu)*(exp(-mu*t) - exp(-k_a*t));


end

