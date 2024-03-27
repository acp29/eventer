%     Function File: [y, k] = bounce (y, n)
%
%     Extend each end of the y-vector by n number of points for
%     'bounce' (or mirror) end-effect correction. The output
%     includes the extended y-vector and the number of bounces (k).
%
%     bounce v1.0 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [y] = bounce (y, n)

if nargin ~= 2
 error('Invalid number of input arguments');
end

if all(size(y) == 1) || ~any(size(y) == 1)
 error('y must be a vector');
end

if isinf(n) || ~all(size(n) == 1) || n<=0 || n~=round(n)
 error('n must be a nonnegative integer');
end


% Set input vector as column vector if applicable
y=y(:); y_ref=y;

% Extend each end by n number of points for 'bounce' end-effect correction
N=numel(y);
k=0;
while (n > N)
 if (k == 0) || (k/2 == round(k/2))
  y=cat(1,flipud(y_ref),y,flipud(y_ref));
 else
  y=cat(1,y_ref,y,y_ref);
 end
 k=k+1;
 n=n-N;
end
if (k == 0) || (k/2 == round(k/2))
 y=cat(1,flipud(y_ref(1:n)),y,flipud(y_ref(end-n+1:end)));
else
 y=cat(1,y_ref(end-n+1:end),y,flipud(y_ref(1:n)));
end
