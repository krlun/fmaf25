function [ y_sum ] = superposition(y, time, dosage_times)
%SUPERPOSITION

    n = length(time);
    y_sum = zeros(1, n);

    for i = 1:length(dosage_times)
        nn = nnz(time < dosage_times(i));
        y_sum = y_sum + [zeros(1, nn) y(1:(n-nn))];
    end

end

