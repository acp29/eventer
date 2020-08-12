%     Function File: [yf, tf, F] = gaussianf (y, t, Fc, correction)
%
%     Application of a Gaussian smoothing filter to the y-vector.
%     The cutoff of the low pass filter is at frequency Fc (in Hz)
%     Requires the Matlab Signal Processing toolbox.
%
%     Output vectors of the smoothed y-values and of the corresponding
%     time (t) values are returned.
%
%     gaussianf v1.0 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [yf, tf, F] = gaussianf (y, t, Fc, correction)

if nargin ~= 4
 error('Invalid number of input arguments');
end

if all(size(t) == 1) || ~any(size(t) == 1) || any(size(t)~=size(y))
 error('t and y must be vectors of the same size');
end

if isinf(Fc) || isnan(Fc) || ~all(size(Fc) == 1) || Fc<=0
 error('Fc must be a finite nonnegative number');
end

% Set all input vectors as column vectors
t=t(:); y=y(:);

% Calculate sampling frequency
N = numel(t);
Fs = (N-1)/(max(t)-min(t));

% Calculate the standard deviation of the Gaussian envelope in points
sigma = Fs*0.132505/Fc;

% Calculate Filter coefficients
if sigma < 0.62
  n = 1;
  b = sigma^2/2;
  F(1) = b;
  F(2) = 1-2*b;
  F(3) = b;
else
  p = 2*round(4*sigma)+1;
  n = (p-1)/2;
  b = -1/(2*sigma^2);
  i = (p-1)/2+1;
  F = zeros(1,p);
  for j=1:p
    F(j)=exp(b*(j-i)^2); 
  end
end

% Normalize coefficients
F = F/trapz(F);

% Bounce end-effect correction
if strcmp(correction,'on') == 1
 [y] = bounce(y,n);
 tf = t;
elseif strcmp(correction,'off') == 1
 tf = t(1+n:N-n);
end

% Gaussian smoothing filter
yf = filter(F,1,y);
yf(1:2*n)=[]; % The assymmetric point deletion compensates for the group delay
