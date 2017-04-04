function mk_norm = Qfunc(constants, t_data, x_data )
%QFUNC Summary of this function goes here
%   Detailed explanation goes here
    t = t_data;
    x = x_data;
%    F, k_a, A, lambda, B, mu
    F = constants(1);
    k_a = constants(2);
    A = constants(3);
    lambda = constants(4);
    B = constants(5);
    mu = constants(6);
    
    xnew = F*k_a*A/(k_a - lambda)*(exp(-lambda*t) - exp(-k_a*t)) + F*k_a*B/(k_a-mu)*(exp(-mu*t) - exp(-k_a*t));
    
    mk_norm = norm(xnew-x);

end

