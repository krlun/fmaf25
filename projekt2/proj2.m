data = xlsread('pk', 1);

[n, m] = size(data); 
n_samples = 10; % Antal samples per patient
n_patients = 10; % Antal patienter

data_array = zeros(n_patients, n_samples); % array for dividing up the data, row is patient number
time = data(1:10, 2)';

figure
hold on
for i = 1:n_patients
    data_array(i, 1:end) = data(((i-1)*10+1):(i*10), 3); % Radvis plasmakoncentration for patient 101..110
    plot(time, data_array(i, :));
end

data_mean = mean(data_array); % Medelvarde taget over varje tidpunkt
data_std = std(data_array); % Standardavvikelse taget over varje tidpunkt
data_var = data_std.^2; % Varians taget over varje tidpunkt

figure
subplot(2,1,1)
plot(time, data_array', 'b')
xlabel('Tid (h)')
ylabel('Plasmakoncentration')
title('Uppmatt data')

subplot(2,1,2)
plot(time, data_mean, 'b') 
hold on;
plot(time, data_mean + norminv(0.975)*data_std, 'r--');
plot(time, data_mean - norminv(0.975)*data_std, 'r--');
xlabel('Tid (h)')
ylabel('Plasmakoncentration')
title('Medelvarde och 95% CI')

% constants: F, k_a, A, lambda, B, mu
%constants = rand(1, 6); % initial gissning av konstanter
constants = [1.0 1.1 1.2 1.3 1.4 1.5];
%options = optimset('MaxFunEvals', 500);
constants = fminsearch('Qfunc', constants, [], time, data_mean);
y = Qfunc2(constants, time);
figure
plot(time, data_mean, 'x-', time, y, 'o-')
legend('data', 'passning')
xlabel('tid')
ylabel('C(t)')
