%     Function File: [yf, tf, HTF] = binomialf (y, t, n, correction)
%
%     Application of a binomial smoothing filter of order n to the y-vector.
%
%     For filter orders upto 50, filtering is achieved by application of a
%     sliding (2n+1)-point box weighted with normalised binomial coefficients.
%     For higher filter orders and for data sets containing > 1e+6 points,
%     binomial filtering is achieved by application of the binomial filter
%     transfer function to the data following Fast Fourier Transform (FFT).
%     The algorithms use a bounce end-effect correction, which can be switched
%     'on' or 'off'. When end-correction is switched off, the returned x and
%     smoothed y vectors are truncated by n number of points.
%
%     One property of binomial coefficients is that as the filter order
%     increases, the coefficients tend rapidly towards a gaussian shape.
%     Therefore, a binomial filter approximates gaussian filter.
%
%     Some properties of the binomial filter:
%
%     H = (1 - (1 - cos (pi * 2 * F/Fs)) / 2) . ^ n
%         where H is the transfer function
%           and F is the frequency
%           and Fs is the sampling frequency
%
%     HTF = (Fs / pi) * acos(0.5 ^ (0.5 / n))
%         where HTF is the half-transmission frequency (-6 dB cut-off)
%
%     Slope = - pi * n * (2 * n) ^ 0.5 * (1 - 0.5 / n) ^ (n - 0.5)
%         where Slope is the maximum cut-off slope for a given filter order
%
%     Output vectors of the smoothed y-values and of the corresponding
%     x-values are returned. The HTF is reported in unit Hz.
%
%     Bibliography:
%     Marchand & Marmet (1983) Rev Sci Instrum 54(8): 1034-1041
%     Marchand & Veillette (1976) Can J Phys 54(13): 1309-1312
%     IGOR Pro Version 5, Manual, 2004. WaveMetrics, Inc.
%
%     binomialf v1.0 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [yf, tf, HTF] = binomialf (y, t, n, correction)

if nargin ~= 4
 error('Invalid number of input arguments');
end

if all(size(t) == 1) || ~any(size(t) == 1) || any(size(t)~=size(y))
 error('t and y must be vectors of the same size');
end

if isinf(n) || ~all(size(n) == 1) || n<=0 || n~=round(n)
 error('n must be a nonnegative integer');
end

% Assess sampling characteristics of input with precision of 10e-6
isDiscrete=~any(round(diff(t)*10e6)-mean(round(diff(t)*10e6)));
if isDiscrete == 0
 warning('non-discrete',...
         'Input must consist of data sampled at evenly spaced points');
end
N=numel(t);
Fs=(N-1)/(max(t)-min(t));

% Set all input vectors as column vectors
t=t(:); y=y(:);

% Bounce end-effect correction
if strcmp(correction,'on') == 1
 [y]=bounce(y,n);
 tf=t;
elseif strcmp(correction,'off') == 1
 tf=t(1+n:N-n);
end
l=length(y);

% Calculate half-transmission frequency
HTF=(Fs/pi)*acos(0.5^(0.5/n));

if (n <= 50) && (N < 1e+6)
 % Application of sliding 2n+1-point binomial filter, see Marchand & Marmet
 % (1983) A sliding filter order of 50 is the highest used for filtering in
 % the time domain.
 b0=[0.25 0.5 0.25]';
 b=1;
  % Calculate normalised binomial coefficients by convolution
  for i=1:n
   b=conv(b,b0);
  end
 p=2*n+1; % Calculate the total number of points in sliding filter
 M=zeros(l-(p-1),p);
 for i=1:p
  M(:,i)=y(i:l-(p-i))*b(i);
 end
 yf=sum(M,2);
else
 % Application of the binomial filter transfer function to the data
 % following Fast Fourier Transform (FFT) into the frequency domain
 % The FFT method is used when the filter order exceeds 50 or when the
 % data is very long, see Marchand & Marmet (1983)
 Y=fft(y);
 j=0:l-1; j=j(:);
 H=(cos(pi*j/l)).^(2*n);
 Yf=H.*Y;
 yf=real(ifft(Yf));
 yf=yf(1:l); yf(1:n)=[]; yf(end-n+1:end)=[];
end
