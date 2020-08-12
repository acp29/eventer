%     Function File: [Y] = sma (y, n, method, correction)
%
%     Calculates the Simple Moving Average (SMA) of y-values for 2n+1
%     number of points. The method variable must be specified as 'mean'
%     or 'median'. The algorithm uses a bounce end-effect correction,
%     which can be switched 'on' or 'off'. When end-correction is
%     switched off, the smoothed y vector is truncated at each end by
%     n number of points.
%
%     For example, n=2 will correspond to a 5-point moving average of
%     the y-values for 2 points either side of each y-value center-
%     point.
%
%     Note that for large values of n, the simple implementation of the
%     moving average filter may not work at all since it can exceed
%     memory capacity. In these instances, it is recommended to use the
%     'medianf' function.
%
%     This function requires the 'bounce' function.
%
%     sma v1.3 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [Y] = sma (y, n, method, correction)

if nargin ~= 4
 error('Invalid number of input arguments');
end

if isinf(n) || ~all(size(n) == 1) || n<=0 || n~=round(n)
 error('n must be a nonnegative integer');
end

if strcmp(method,'mean') && strcmp(method,'median')
 error('The averaging method must be specified');
end

% Set input vector as column vector
y=y(:);

% Calculate total number of y-points to average within sliding box
p=2*n+1;

% Bounce end-effect correction
if strcmp(correction,'on') == 1
 [y]=bounce(y,n);
end
l=length(y);

% Create matrix for calculation
M=zeros(l-(p-1),p);
 for i=1:p
  M(:,i)=y(i:l-(p-i));
 end

if strcmp(method,'mean')
 % Calculate value of coefficients and weight matrix
  b=1/p;
  M=M*b;
 % Perform calculation to create new y-values from simple moving average
  Y=sum(M,2);
elseif strcmp(method,'median')
 % Sort matrix and extract middle values
  M=sort(M,2);
  Y=M(:,n+1);
end


