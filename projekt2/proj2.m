data = xlsread('pk', 1);

[n, m] = size(data); 
n_samples = 10; % Antal samples per patient
n_patients = 10; % Antal patienter

data_array = zeros(n_patients, n_samples); % array for dividing up the data, row is patient number
time = data(1:10, 2);

for i = 1:n_patients
    data_array(i, 1:end) = data(((i-1)*10+1):(i*10), 3); % Radvis plasmakoncentration för patient 101..110
end

data_mean = mean(data_array'); % Medelvärde taget över varje tidpunkt
data_std = std(data_array'); % Standardavvikelse taget över varje tidpunkt
data_var = data_std.^2; % Varians taget över varje tidpunkt

subplot(2,1,1)
plot(time, data_array, 'xb')
xlabel('Tid (h)')
ylabel('Plasmakoncentration')
title('Uppmätt data')

subplot(2,1,2)
plot(time, data_mean, 'b') 
hold on;
plot(time, data_mean + 1.96*data_std, 'r--');
plot(time, data_mean - 1.96*data_std, 'r--');
xlabel('Tid (h)')
ylabel('Plasmakoncentration')
title('Medelvärde och 95% CI')
