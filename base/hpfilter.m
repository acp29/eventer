%     Function File: yf = hpfilter (y, t, Fc)
%
%     Fast algorithm to high-pass filter y-values at the specified -3 dB
%     filter cut-off (Fc) using binomial filters.
%
%     This algorithm executes cycles of anti-alias filtering and data
%     reduction for improved speed. The net result following sequential
%     low pass filtering is determined by the approximate addition of
%     filters (Ogden, 1994). The original sampling is restored by cubic
%     spline interpolation and the high-pass filtered trace is obtained by
%     by subtracting this from the original data (Marchand & Marmet, 1983).
%
%     Output vector is the high-pass filtered y-values.
%
%     This function uses the smoothing algorithm in 'binomialf.m'.
%
%     Bibliography:
%     Marchand & Marmet (1983) Rev Sci Instrum 54(8): 1034-1041
%     Ogden (1994) Microelectrode electronics. In: Ogden ed. Microelectrode
%      Techniques: The Plymouth Workshop Handbook. The Company of Biologists
%      Limited, Cambridge.
%
%     hpfilter v1.0 (last updated: 05/04/2012)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function yf = hpfilter (y, t, Fc)

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

% Set all input vectors as column vectors where applicable
t=t(:); y=y(:);
N=length(t);                          % Length of input vectors
Fs=(N-1)/(max(t)-min(t));             % Sampling frequency

% Calculation of the HTF to implement a binomial high pass filter at the -3 dB cut-off (Fc):
HTF = Fc / 1.32;

if HTF > Fs/4
 error(sprintf(['The specified filter cutoff exceeds cutoff upper limit.\n'...
                'Maximum cutoff frequency is %g Hz'],Fs*1.32/4));
end

% Fast hpf implementation by cycles of anti-alias filtering and data reduction
n=1/log2((cos(pi*(2*HTF/Fs)/2)^-2));                          % Calculate binomial filter order to achieve input HTF at current sampling rate
n=round(n);                                                   % Round filter order to be an integer
HTF_goal=(Fs/pi)*acos(0.5^(0.5/n));                           % Calculate the goal HTF for the binomial filter
Fs_ref=Fs;                                                    % Store original sampling frequency
HTF_current=inf;                                              % Since data filtering history is unknown current HTF is set to infinity
yf=y; tf=t;
loop=0;                                                       % Initialise loop counter
 while n > 702                                                % Continue looping while the filter order exceeds 702
  HTF_antialias=(Fs/pi)*acos(0.5^(0.5/112));                  % Calculate HTF of the anti-aliasing binomial filter
  yf = binomialf (yf, tf, 112, 'on');                         % Execute binomial filter
  tf=tf(1:10:end); yf=yf(1:10:end);                           % Downsample data by 1 log
  Fs=Fs/10;                                                   % Record new sampling rate
  HTF_current=sqrt(1/(1/HTF_current^2+1/HTF_antialias^2));    % Recalculate current HTF resulting from sequential low-pass filtering                               %
  HTF_adjusted=sqrt(1/(1/HTF_goal^2-1/HTF_current^2));        % Calculate adjusted HTF of the LPF filter required to achieve goal HTF
  n=1/log2((cos(pi*(2*HTF_adjusted/Fs)/2)^-2));               % Recalculate binomial filter order to achieve goal HTF at current sampling rate
  n=round(n);                                                 % Round filter order to be an integer
  loop=loop+1;
 end
[yf, tf, HTF] = binomialf (yf, tf, n, 'on');                  % Execute binomial filter to achieve goal HTF
if loop > 0
 HTF=sqrt(1/(1/HTF_current^2+1/HTF_adjusted^2));              % Recalculate current HTF resulting from sequential low-pass filtering
 yf=spline(tf,yf,t);                                          % Restore original sampling by cubic spline interpolation
 Fs=Fs_ref;
end
%
tf=t;
yf=y-yf;                                                      % Calculate high-pass by subtraction
