%     Function File: [yf, t] = medianf (y, x, r)
%
%     Calculates the median over a sliding window of y-values of 2r+1
%     number of points, where r is the filter rank. This filter is
%     particularly useful to subtract background [1,2]. For this
%     application where the filter rank used is typically large, the
%     median is computed using the very fast binapprox algorithm [3].
%
%     This bounce end treatment requires the 'bounce' function.
%
%
%     Bibliography:
%     Moore and Jorgenson (1993) Anal Chem 6: 188-191
%     Friedrichs (1995) J Biomol NMR 5: 147-153
%     Tibshirani (2009) arXiv preprint arXiv:0806.3301
%
%     medianf v1.2 (last updated: 05/04/2012)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [yf, x] = medianf (y, x, r)

if nargin ~= 3
 error('Invalid number of input arguments');
end

if all(size(x) == 1) || ~any(size(x) == 1) || any(size(x)~=size(y))
 error('x and y must be vectors of the same size');
end

if isinf(r) || ~all(size(r) == 1) || r<=0 || r~=round(r)
 error('r must be a nonnegative integer');
end

% Set all input vectors as column vectors and calculate vector size
x=x(:); y=y(:);
m = length(y);

% Calculate total number of y-points to average within sliding box
P=2*r+1;

% Treatment of the ends of the data
y = bounce(y,r);

% Implement median smoothing filter
if r < 250

  % Fast algorithm for small filter rank
  l = length(y);
  Y = zeros(l-(P-1),P);
  for i=1:P
   Y(:,i)=y(i:l-(P-i));
  end
  Y=sort(Y,2);
  yf=Y(:,r+1);

else

  % Fast algorithm for large filter rank
  % Calculate running mean and variance. Algorithm from:
  %  J.E. Hadstate (2008) Efficient Moving Average and Moving Variance Calculations
  %  https://www.dsprelated.com/showthread/comp.dsp/97276-1.php
  M = zeros(m,1);
  mu = M;
  V = zeros(m,1);
  v  = V;
  SX1 = sum(y(1:P));
  SX2 = sum(y(1:P).^2);
  X1 = 0;
  X2 = 0;
  Y1 = 0;
  Y2 = 0;
  M(1) = SX1/P;
  V(1) = (P*SX2-(SX1*SX1))/(P*(P-1));
  for k=2:m
    Y1 = y(k-1);
    Y2 = Y1^2;
    X1 = y(P+k-1);
    X2 = X1^2;
    SX1 = SX1 + X1 - Y1;
    SX2 = SX2 + X2 - Y2;
    M(k) = SX1/P;
    V(k) = (P*SX2-(SX1*SX1))/(P*(P-1));
  end

  % Use the mean and standard deviation of the window centered around first point to
  % choose initial bin edges then bin the data from that window. Note that the ends
  % of the data have already been padded with r points using the bounce function
  B = 1000;
  edges = [-inf,linspace(min(M(1)-sqrt(V(1))),max(M(1)+sqrt(V(1))),B),inf];
  [N] =  histc(y(1:P),edges);

  % Compute the running median based on use of Tibshirani's binapprox
  % algorithm with the update problem. This algorithm scales extremely
  % well with increasing filter rank.
  yf = zeros(m,1);
  a = sum(edges <= y(1));
  j = 0;
  for i=1:m
    exitflag = 0;
    while exitflag < 1
      % Find bin containing the median
      j = 0;
      n = 0;
      while n <= r+1
        j = j+1;
        n = n + N(j);
      end
      % If the median lies outside of the existing bins, calculate new bin edges
      if any(j==[1 B+1])
        edges = [-inf,linspace(min(M(i)-sqrt(V(i))),max(M(i)+sqrt(V(i))),B),inf];
        [N] =  histc(y(i:P+i-1),edges);
        exitflag = 0;
      else
        exitflag = 1;
      end
    end
    % Allocate the bin center to yf
    yf(i) = (edges(j)+edges(j+1))/2;
    % Update bin counts after sliding the window
    N(a) = N(a) - 1;
    a = sum(edges <= y(i+1));
    if i < m
      b = sum(edges <= y(P+i));
      N(b) = N(b) + 1;
    end
  end

end
