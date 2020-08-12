%     Function File: yf = lpfilter (y, t, Fc)
%
%     Low-pass filter y-values at the specified -3 dB filter cut-off (Fc)
%     using binomial filters.
%
%     Output vector is the low-pass filtered y-values.
%
%     This function uses the smoothing algorithm in 'binomialf.m'.
%
%     Bibliography:
%     Marchand & Marmet (1983) Rev Sci Instrum 54(8): 1034-1041
%
%     lpfilter v1.0 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/

function yf = lpfilter (y, t, Fc)

if nargin ~= 3
 error('Invalid number of input arguments');
end

if all(size(t) == 1) || ~any(size(t) == 1) || ~all(size(t) == size(y))
 error('t and y must be vectors of the same size');
end

if isinf(Fc) || ~all(size(Fc) == 1) || Fc<=0
 error('HTF must be a nonnegative, non-zero finite value in unit Hz');
end

% Assess sampling characteristics of the input
isDiscrete=all(abs(diff(diff(t)))<2*eps('single'));
if isDiscrete == 0
 warning('non-discrete','Input must consist of data sampled at evenly spaced points');
end
N=length(t);                          % Length of input vectors
Fs=(N-1)/(max(t)-min(t));             % Sampling frequency

% Calculation of the HTF to implement a binomial low pass filter at the -3 dB cut-off (Fc):
HTF = Fc / 0.71;

if HTF > Fs/4
 error('The highest possibe HTF is half the Nyquist frequency (Fs/4)');
end

% Set all input vectors as column vectors where applicable
t=t(:); y=y(:);

% Calculate the required filter order for given half-transmission frequency
n=1/log2((cos(pi*(2*HTF/Fs)/2)^-2));
n=round(n);

% Execute binomial filter with bounce end effect
[yf, tf, HTF] = binomialf (y, t, n, 'on');


