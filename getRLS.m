%% getRLS.m - least mean squares algorithm using dsp.RLSFilter
%
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024
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

% ------------------------------------------------------------------------
%% RLS Filter
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
        
    % Process the signals using the RLS filter
        [y, e] = rls(x, d);
        w = rls.Coefficients;
end
