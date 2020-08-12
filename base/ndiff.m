%     Function File: [dydx, y, x] = ndiff (y, x)
%
%     Calculates the first derivative (dy/dx) at each point (p) by
%     numerical differentiation using the following equation:
%
%     y(p+1)-y(p-1) / x(p+1)-x(p-1)
%
%
%     ndiff v1.5 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [dydx, y, x] = ndiff (y, x)

if nargin ~= 2
 error('Invalid number of input arguments');
end

if all(size(x) == 1) || ~any(size(x) == 1) || length(x) ~= length(y)
 error('x and y must be vectors of the same size');
end

% Assess sampling characteristics of input with precision of 10e-9
isDiscrete=~any(round(diff(x)*10e9)-mean(round(diff(x)*10e9)));
 if isDiscrete == 0
  warning('non-discrete','Input must consist of data sampled at evenly spaced points');
 end

% Set all input vectors as column vectors where applicable
x=x(:); y=y(:);

% Create matrices for numerical differentiation
% These have column length l-2 since complete numerical differentiation cannot be calulated for values within 1 point from the start and end
l=length(x);
my=ones(l-2,3);mx=ones(l-2,3);
 for i=1:3
  my(:,i)=y(i:l-(3-i));
  mx(:,i)=x(i:l-(3-i));
 end

% Calculate first derivative
dx=mx(:,3)-mx(:,1);
dy=my(:,3)-my(:,1);
dydx=dy./dx;
x=mx(:,2);
y=my(:,2);


