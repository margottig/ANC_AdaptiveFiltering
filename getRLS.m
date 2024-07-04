% getRLS.m - least mean squares algorithm using dsp.RLSFilter
%
% Usage: [e, y, w] = getRLS(d, x, lamda, M)
%
% Inputs:
% d  - the vector of desired signal samples of size Ns, Reference Signal
% x  - the vector of input signal samples of size Ns, Input signal
% lamda - the weight parameter, Weight
% M  - the number of taps. Filter order
%
% Outputs:
% e - the output error vector of size Ns
% y - output coefficients
% w - filter parameters
%
% ------------------------------------------------------------------------
function [e, y, w] = getRLS(d, x, lamda, M)

    Ns = length(d);
    if (Ns <= M)
        error('error: The signal length is less than the filter order.！');
    end
    if (Ns ~= length(x))
        error('error: The input signal and the reference signal are of different lengths！');
    end
    
    % Create the dsp.RLSFilter object
    rls = dsp.RLSFilter('Length', M, 'ForgettingFactor', lamda);
    
    % Preallocate output arrays
    y = zeros(Ns, 1);
    e = zeros(Ns, 1);
    w = zeros(M, Ns);
    
    % Process the signals using the RLS filter
    for n = 1:Ns
        [y(n), e(n)] = rls(x(n), d(n));
        w(:, n) = rls.Coefficients;
    end
end
