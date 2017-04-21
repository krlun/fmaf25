function mk_norm = Qfunc(constants, t_data, x_data )
% Experimentering med A' = F*k_a*A/(k_a-lambda), B' = F*k_a*B/(k_a-mu)
    t = t_data;
    x = x_data;
%    F, k_a, A, lambda, B, mu

    A = constants(1);
    B = constants(2);
    k_a = constants(3);
    lambda = constants(4);
    mu = constants(5);
    
    xnew = A*(exp(-lambda*t) - exp(-k_a*t)) + B*(exp(-mu*t) - exp(-k_a*t));
    
    mk_norm = norm(xnew-x);

end

