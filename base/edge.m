%     Function File: [slope, intervals, P] = edge (x, y, L, U)
%
%     Calculates the x and y intervals and slope of an edge between
%     the fractional lower and upper limits of y, which are referenced
%     to the first and final points of the y vector. Therefore, the
%     input must represent monotonically increasing y values.
%
%     The input parameters L and U specify the lower and upper limits
%     between which the xy-intervals are determined. These should be
%     fractions expressed as decimals between 0 and 1.
%
%     The first output is a scalar value for the slope of the line
%     connecting the points at the two user-defined limits of the
%     y-axis.
%
%     The second output is a vector containing the x and y intervals.
%
%     The third output is a 2 X 2 matrix containing the point limits
%     for x and y in order of increasing magnitude of x.
%
%     edge (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [slope, intervals, P] = edge (x, y, L, U)

if nargin < 4
 error('Invalid number of input arguments');
end

if all(size(x) == 1) || ~any(size(x) == 1) || length(x) ~= length(y)
 error('x and y must be vectors of the same length');
end

if isinf(L) || ~all(size(L) == 1) || L<0 || L>=1
 error('The lower limit (L) must be a decimal between 0 and 1');
end

if isinf(U) || ~all(size(U) == 1) || U<=0 || L>1
 error('The upper limit (U) must be a decimal between 0 and 1');
end

% Set all input vectors as column vectors where applicable
x=x(:); y=y(:);

yBase=y-y(1);
yNorm=yBase/yBase(end);
limits=[L U]';

for i=1:2
 clear X Y
 if L == limits(i)
  if L == 0
   idx=1;
  else
   idx=find(diff(yNorm >= L));
  end
 elseif U == limits(i)
  if U == 1
   idx=length(yNorm)-1;
  else
   idx=find(diff(yNorm <= U));
  end
 end
% The following loop is to accomodate for moderate levels of noise present in the y values
 n=numel(idx);
 for j=1:n
   clear M
   M(:,1)=[x(idx(j)) x(idx(j)+1)]';
   M(:,2)=[y(idx(j)) y(idx(j)+1)]';
   M(:,3)=[yNorm(idx(j)) yNorm(idx(j)+1)]';
   M=sortrows(M,3);
   X(j,1)=interp1(M(:,3),M(:,1),limits(i),'linear');
   Y(j,1)=interp1(M(:,3),M(:,2),limits(i),'linear');
 end
 %P(i,1)=mean(X);
 %P(i,2)=mean(Y);
 P(i,1)=X(1);
 P(i,2)=Y(1);
end
P=sortrows(P,1);
intervals(1)=diff(P(:,1));
intervals(2)=diff(P(:,2));
if ~all((intervals == 0) + (intervals == inf))
 slope=intervals(2)/intervals(1);
else
 slope=NaN;
end


