% example taken from: https://www.mathworks.com/help/dsp/ref/dsp.filteredxlmsfilter-system-object.html
%
% Usage: [e, y] = getRLS(d, x)
%
% Inputs:
% d  - the vector of desired signal samples of size Ns, Reference Signal
% x  - the vector of input signal, recorded signal
% n  - noisy signal
%
% Outputs:
% e - the output error vector of size Ns
% y - output coefficients
%
% ------------------------------------------------------------------------
function [y,e] = getFXLMS(x, n)
%x  = randn(1000,1); %RECORDED AUDIO
g  = fir1(47,0.4);
%n  = 0.1*randn(1000,1); %NOISY SIGNAL
d  = filter(g,1,x) + n;
b  = fir1(31,0.5);

mu = 0.008;
fxlms = dsp.FilteredXLMSFilter(32, 'StepSize', mu, 'LeakageFactor', ...
     1, 'SecondaryPathCoefficients', b);
[y,e] = fxlms(x,d);

end