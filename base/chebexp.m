%    Function File: [fit S] = chebexp (x, y, n, Tn)
%
%     Returns the least-squares unconstrained fit of n exponential
%     components with constant offset to XY data using the Chebyshev
%     algorithm [1]. The interval in the x dimension must be constant.
%
%     This function is effective in finding a solution very closely
%     approximating the global minimum of the squared-error landscape.
%
%     The input parameter 'n' specifies the number of components.
%
%     The output is a structure containing the following fields:
%
%     'tau'
%              A column vector of the individual exponent constants.
%              When the x dimension is time, tau are time constants.
%
%     'a'
%              A column vector of the corresponding amplitudes of tau.
%
%     'offset'
%              The offset of the exponential.
%
%     'dF'
%              The degrees of freedom.
%
%     'normr'  The norm of the residuals.
%
%     Complex solutions for the fit parameters indicate that the fit
%     included harmonic components.
%
%     References:
%     [1] Malachowski, Clegg and Redford (2007) J Microsc 228(3): 282-95
%
%
%     chebexp v1 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/



function [fit S] = chebexp (t, y, n, Tn)


if nargin < 3
 error('Invalid number of input arguments');
end

if all(size(t) == 1) || ~any(size(t) == 1) || length(t) ~= length(y)
 error('x and y must be vectors of the same length');
end

if isinf(n) || ~all(size(n) == 1) || n<=0 || n~=round(n)
 error('n must be a nonnegative integer');
end

if nargin < 4
 Tn = 20;
end

% Evaluate the input arguments
n = double(n);
t = double(t(:));
y = double(y(:));
if diff(diff(t)) > 1.1921e-07
 error('Input must consist of data sampled at evenly spaced time points');
end
delta = t(2)-t(1);
l = numel(t);

% Recalculate the x (or t) dimension
N = l-1;
t = [0:N]';

% Calculate the maximum order Chebyshev polynomials to generate
if l > Tn
 % Do nothing. Keep current value of Tn
else
 Tn = N;
end

% Generate the polynomials T and coefficients d
T0 = ones(l,1);
R0 = sum(T0.^2);
d0 = sum((T0.*y)/R0);
T = zeros(l,Tn);
T(:,1) = 1-2*t/N;
T(:,2) = 1-6*t/(N-1)+6*t.^2/(N*(N-1));
for j = 1:Tn
 if j > 2
  A(j) = j*(N-j+1);
  B(j) = 2*j-1;
  C(j) = (j-1)*(N+j);
  T(:,j) = (B(j)*(N-2*t).*T(:,j-1)-C(j).*T(:,j-2))/A(j);
 end
 R(j) = sum(T(:,j).^2);
 d(j) = sum(T(:,j).*y/R(j));
end

% Generate additional coefficients dn that describe the relationship
% between the Chebyshev coefficients d and the constant k, which is
% directly related to the exponent time constant
dn = zeros(n,Tn);
for i = 1:n
 for j = 1+i:Tn-i
  if i == 1
   dn(i,j) = (((N+j+2)*d(j+1)/(2*j+3))-d(j)...
             -((N-j+1)*d(j-1)/(2*j-1)))/2;
  else
   dn(i,j) = (((N+j+2)*dn(i-1,j+1)/(2*j+3))-dn(i-1,j)...
             -((N-j+1)*dn(i-1,j-1)/(2*j-1)))/2;
  end
 end
end
for i = 1:n
 dn(i,:) = dn(i,:).*double(all(dn,1));
end

% Form the regression model to find the time constants of
% each exponent
Mn = zeros(n);
b = zeros(n,1);
for i = 1:n
 b(i) = sum(d.*dn(i,:));
 for m = 1:n
  Mn(i,m) = -sum(dn(i,:).*dn(m,:));
 end
end

% Solve the linear problem by QR decomposition
[q,r] = qr(Mn,0);
x = r\(q'*b);
k = roots([1 x(:,1)']);
tau = -1./log(1+k);

% Generate the Chebyshev coefficients df for each exponent
df = zeros(n,Tn);
for i = 1:n
 for j = 1:Tn
  df(i,j) = sum(exp(-t/tau(i)).*T(:,j)/R(j));
 end
 df0(i) = sum(exp(-t/tau(i)).*T0/R0);
end

% Form the regression model to find the amplitude of
% each exponent
Mf = zeros(n);
b = zeros(n,1);
for i = 1:n;
 b(i) = sum(d.*df(i,:));
 for m=1:n
  Mf(i,m) = sum(df(i,:).*df(m,:));
 end
end

% Solve the linear problem by QR decomposition
[q,r] = qr(Mf,0);
a = r\(q'*b);

% Calculate the offset for the fit
offset = d0-sum(df0.*transpose(a));

% Regenerate the fit from the fit parameters
yf = zeros(l,n);
for i = 1:n
 yf(:,i) = a(i)*exp(-t/tau(i));
end
fit = real(offset+sum(yf,2));

% Assign fit parameters to structure output
S.tau = delta*tau;
S.a = a;
S.offset = offset;
S.dF = l-(2*n)+1;
S.normr = norm(y-fit);
