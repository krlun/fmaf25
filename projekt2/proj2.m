data = xlsread('pk', 1);
[n, ~] = size(data);
n_samples = 10; % # of samples per patient
n_patients = n/n_samples; % # of patients, assuming same number of samples per patient

data_array = zeros(n_patients, n_samples); % dividing up the data, row is patient number
time = data(1:10, 2);

for i = 1:n_patients
    data_array(i, 1:end) = data(((i-1)*10+1):(i*10), 3);
end

plot(time, data_array)