%% getFXLMS.m - Implements the Filtered-X Least Mean Squares (FXLMS) algorithm
%
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024
%
% Example taken from: https://www.mathworks.com/help/dsp
%
% using MATLAB's dsp.FilteredXLMSFilter System object.
% Commonly used for adaptive noise cancellation.
%
% Usage: [y, e] = getFXLMS(x, n)
%
% Inputs:
% x  - the vector of input signal, recorded signal of size Ns
% n  - the vector of noise signal of size Ns
%
% Outputs:
% y - the filtered output signal of size Ns
% e - the output error vector of size Ns
%
% ------------------------------------------------------------------------
function [y, e] = getFXLMS(x, n)

% Design a FIR filter to simulate a secondary path (e.g., the path from 
% the noise source to the sensor)
g = fir1(47, 0.4);

% Generate the desired signal 'd' by filtering the input signal 'x' with
% the secondary path filter 'g' and adding noise 'n'
d = filter(g, 1, x) + n;

% Design another FIR filter to simulate the estimated secondary path
% (e.g., from the actuator to the sensor)
b = fir1(31, 0.5);

% Define the step size for the FXLMS algorithm
mu = 0.008;

% Create the dsp.FilteredXLMSFilter object with the specified parameters
% Length: Length of the adaptive filter (number of taps)
% StepSize: Step size for the LMS algorithm
% LeakageFactor: Leakage factor for the LMS algorithm (1 means no leakage)
% SecondaryPathCoefficients: Coefficients of the estimated secondary path
fxlms = dsp.FilteredXLMSFilter('Length', 32, 'StepSize', mu, ...
    'LeakageFactor', 1, 'SecondaryPathCoefficients', b);

% Apply the FXLMS filter to the input signal 'x' and the desired signal 'd'
% The output 'y' is the filtered signal, and 'e' is the error signal
[y, e] = fxlms(x, d);

end
