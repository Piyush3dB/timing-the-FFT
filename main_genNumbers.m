close all;
clear;
clc;
format compact;


%%
% How to predict the computation time for an FFT of a
% given length, N, values of N in the neighborhood of 4096 (2^12).
%
% why padding to the next power of two wasn't always the fastest way to
% compute the FFT.
%
%
% It turns out that, in general, the time required to execute an N-point
% FFT is proportional to N*log(N). For any particular value of N, though,
% the execution time can be hard to predict and depends on the number of
% prime factors of N (very roughly speaking). The variation in time between
% two close values of N as much as an order of magnitude.
%
% Whenever I do FFT benchmarking, I find it very helpful to look at three
% sets of numbers:
%
% * Powers of 2
% * Composite numbers that are not powers of 2
% * Prime numbers
%
% Also, I have learned to look at plots that are log scale in N, which
% roughly the same number of test values within each octave (or doubling)
% of N.
%
% Constructing sets of N values along these lines takes a little thought.
% Here's some code.
%
% First, how many powers of 2 do we want to examine?
% I want to examine the range from 1024 (2^10) to 131072 (2^17).

low2  = 10;
high2 = 18;
n2 = 2.^(low2:high2);

%%
% Next, I want to pick 10 composite numbers and 10 prime numbers in each
% decade. I'd like to pick the numbers "randomly," but I also want my
% experiment to be repeatable. To satisfy these seemingly contradictory
% constraints, I'll reset the MATLAB random number generator before
% beginning.


rng('default');

% Initialize the vectors holding the prime N's and composite N's.
np = [];
nc = [];

%% Generate range of numbers
for m = low2:high2
    k = (2^m):(2^(m+1));
    kp = k(2:end-1);
    isp = isprime(kp);
    primes = kp(isp);
    composites = kp(~isp);
    
    % Use randperm to pick out 10 values from the vector of primes and 10
    % values from the vector of composites.
    new_np = primes(randperm(length(primes),10));
    new_nc = composites(randperm(length(composites),10));
    
    np = [np new_np];
    nc = [nc new_nc];
end

%% Generate Highly Composite numbers
nn = [];
for m = low2:high2
    k = (2^m):(2^(m+1));
    kp = k(2:end-1);
    
    kp = kp(randperm(length(kp)));
    nn_m = [];
    for q = 1:length(kp)
        if max(factor(kp(q))) <= 3
            nn_m = [nn_m kp(q)];
            
            if length(nn_m) >= 4
                % We've found enough in this part of the range.
                break
            end
        end
    end
    nn = [nn nn_m];
end

%% Save generated numbers
save('numbers.mat', 'n2', 'np', 'nc', 'nn');

