close all;
clc
clear;
load('numbers.mat');

%% Time powers of 2
t2 = zeros(size(n2));
for k = 1:length(n2)
    x = rand(n2(k),1);
    t2(k) = timeit(@() fft(x));
end

%% Time prime numbers
tp = zeros(size(np));
for k = 1:length(np)
    x = rand(np(k),1);
    tp(k) = timeit(@() fft(x));
end

%% Time composite numbers
tc = zeros(size(np));
for k = 1:length(nc)
    x = rand(nc(k),1);
    tc(k) = timeit(@() fft(x));
end

%% Time highly composite numbers.
tn = zeros(length(nn),1);
for k = 1:length(nn)
    x = rand(nn(k),1);
    tn(k) = timeit(@() fft(x));
end

%%
% Add the times to the plot.
figure(1);

% Powers of 2
loglog(n2,t2,'o')
hold on

% Composite numbers
loglog(nc,tc,'+')

% Prime numbers
loglog(np,tp,'*')

% Highly composite numbers
loglog(nn,tn,'d')

hold off

set(gca,'xtick',2.^(10:17))
xlim([2^10 2^17])
%ylim([10e-5 10e-1])

legend({'Powers of 2','Composite numbers','Prime numbers', ...
    'Highly composite numbers'},'Location','NorthWest')
xlabel('N')
ylabel('Execution time (s)')
title('FFT execution time as a function of N')

