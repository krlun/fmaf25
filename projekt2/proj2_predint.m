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
%constants = [1.0 1.1 1.2 1.3 1.4 1.5];
%constants = [1.6289 0.5811 2.0543 0.4799 1.6500 0.0466];
constants = [2.1110 0.3971 4.6434 0.3105 0.6070 0.0278];
%options = optimset('MaxFunEvals', 500);
constants = fminsearch('Qfunc', constants, [], time, data_mean);
y = Qfunc2(constants, time);
figure
plot(time, data_mean, 'x-', time, y, 'o-')
legend('data', 'passning')
xlabel('tid')
ylabel('C(t)')


nor = 50;

constants = [1.0 1.1 1.2 1.3 1.4 1.5];
for i = 1:nor
    c = zeros(10, 6);
    for j = 1:n_patients
        c(j, :) = fminsearch('Qfunc', constants, [], time, data_array(j, :));
    end
    constants = sum(c)/n_patients;
end

%% Experimentering med A' = F*k_a*A/(k_a-lambda), B' = F*k_a*B/(k_a-mu)
% A', B', k_a, lambda, mu
nor = 100;

constants = [0.5 0.6 0.7 0.8 0.9];
for i = 1:nor
    c = zeros(10, 5);
    for j = 1:n_patients
        c(j, :) = fminsearch('Qfunc3', constants, [], time, data_array(j, :));
    end
    constants = sum(c)/n_patients;
end


y = Qfunc4(c(10, :), time);
figure
plot(time, data_array(10, :), 'x-', time, y, 'o-')
legend('data', 'passning')
xlabel('tid')
ylabel('C(t)')

%% PARAMETERSKATTNING 

cstd = std(c);              % Kolumnvis standardavvikelse. 
cmean = mean(c);            % Kolumnvist medelvärde

% Normalitetstest för A:
statistic = (c(:,1) - cmean(1)) / cstd(1)

jb = jbtest(c(:,1))         % = 0 --> kan inte förkasta normalfördelning
lillie = lillietest(c(:,1)) % = 0 --> kan inte förkasta normalfördelning
ks = kstest(statistic)      % Testa om normalfördelad med medelvärde cmean och standardavvikelse cstd.
                            % = 0 --> kan inte förkasta normalfördelning

normplot(c(:,1))            % Ser OK ut, förutom de två sista mätpunkterna

% -> Vi antar att parametern A' är normalfördelad bland patienterna

%% KONFIDENSINTERVALL

Astd = [1 0 0 0 0] .* cstd;

mean_response = Qfunc4(cmean, time);
upper_response = Qfunc4(cmean + norminv(0.95) * Astd, time);
lower_response = Qfunc4(cmean - norminv(0.95) * Astd, time);

figure;
plot(time, mean_response, 'b')
hold on
plot(time, upper_response, 'r--')
<<<<<<< HEAD
plot(time, lower_response, 'r--')

%% PREDIKTIONSINTERVALL
Astd = cstd(1);  % Standard deviation A
Bstd = cstd(2);  % Standard deviation B

ka = cmean(3)
lambda = cmean(4);
mu = cmean(5);

Afactor = @(t) exp(-lambda * t) - exp(-ka * t);
Bfactor = @(t) exp(-mu * t) - exp(-ka * t);

covAB = cov(c(:,1), c(:,2));
covAB = covAB(1,2);

fmean = Qfunc4(cmean, time);
fvar = Afactor(time).^2 * Astd^2 + Bfactor(time).^2 * Bstd^2 + 2 * Afactor(time) .* Bfactor(time) * covAB;
fstd = sqrt(fvar);

p = 0.9;
upper_bound = fmean + tinv(1 - (1-p)/2, n_patients) * fstd * sqrt(1 + 1/n_patients);
lower_bound = fmean - tinv(1 - (1-p)/2, n_patients) * fstd * sqrt(1 + 1/n_patients);

figure;
plot(time, upper_bound, 'r--')
hold on
plot(time, lower_bound, 'r--')
plot(time, mean_response)
title(['Prediktionsintervall ' num2str(p*100) '%'])
plot(time, lower_response, 'r--')
