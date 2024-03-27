%     Function File: [yf, tf, n, HTF, Fs] = lpf (y, t, HTF)
%
%     Low-pass filter y-values at the given half-transmission frequency
%     (HTF, in Hz) using a binomial filter.
%
%     The filter order (n) for a given HTF is calculated from the following
%     equation:
%
%     n = 1 / log2 ((cos (pi * (2 * HTF / Fs) / 2) ^ -2));
%
%     Output vectors of the low-pass filtered y-values and of the
%     corresponding x-values are returned. The filter order (n), the
%     actual cut-off (HTF) and the sampling frequency (Fs) are also
%     reported.
%
%     This function uses the smoothing algorithm in 'binomialf.m'.
%
%     lpf v1.0 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [yf, tf, n, HTF, Fs] = lpf (y, t, HTF)

if nargin ~= 3
 error('Invalid number of input arguments');
end

if all(size(t) == 1) || ~any(size(t) == 1) || ~all(size(t) == size(y))
 error('t and y must be vectors of the same size');
end

if isinf(HTF) || ~all(size(HTF) == 1) || HTF<=0
 error('HTF must be a nonnegative, non-zero finite value in unit Hz');
end

% Assess sampling characteristics of the input
isDiscrete=all(abs(diff(diff(t)))<2*eps('single'));
if isDiscrete == 0
 warning('non-discrete','Input must consist of data sampled at evenly spaced points');
end
N=length(t);                          % Length of input vectors
Fs=(N-1)/(max(t)-min(t));             % Sampling frequency

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


