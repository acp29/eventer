%     Function File: [N, P, D] = fpeaks (t, y, p, s, L, V)
%
%     Searches the y vector for minima or maxima by searching for
%     zero crossings in the smoothed first derivative. The local
%     preceding baseline for each peak is determined and used to
%     calculate peak amplitides.
%
%     The input parameter 'p' specifies the number of points either
%     side of each xy-value center-point for smoothing.
%
%     The input parameter 's' specifies the sign of peak deflections:
%     '-' for negative deflections, '+' for positive deflections and
%     'auto' for automatic sign determination.
%
%     The input parameter 'L' specifies a threshold level expressed
%     as a fraction of the maximum peak in the trace. This can be a
%     scalar value or a vector.
%
%     The input parameter 'V' is optional but strongly recommended
%     if noise is present in the data. This option allows the user
%     to specify a threshold for the fractional magnitude of valleys.
%
%     The first output is the number of peaks detected.
%
%     The second output is a structure containing the following fields:
%
%     'tPeaks'
%              A column vector of times corresponding to peak positions.
%
%     'yPeaks'
%              A column vector of y-values at the peak positions.
%
%     'tBase'
%              A column vector of times corresponding to local baseline
%              positions.
%
%     'yBase'
%              A column vector of local baseline y-values.
%
%     'yAmpl'
%              A column vector of peak amplitudes
%
%     The third output is a data matrix of columns corresponding to 't',
%     the smoothed 'y', 'dydt' and 'd2ydt2' values and the 'L' values.
%
%     This script has the following dependencies: sma and ndiff.
%
%     The syntax in this function code is compatible with most recent
%     versions of Octave and Matlab.
%
%
%     fpeaks v1.5 (last updated: 16/09/2011)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [N, P, D] = fpeaks (t, y, p, s, L, V)


if nargin < 5
 error('Invalid number of input arguments');
end

if all(size(t) == 1) || ~any(size(t) == 1) || length(t) ~= length(y)
 error('t and y must be vectors of the same length');
end

if isinf(p) || ~all(size(p) == 1) || p<0 || p~=round(p)
 error('If nonzero, p must be a nonnegative integer');
end

if s~='+' && s~='-' && s~='auto'
 error('If set manually, the sign of the peaks has to be specified in + or - direction');
end

if  ~any(size(L) == 1)
 error('L must be scalar or a vector of threshold values');
end

if  any(isinf(L)) || any(L <= 0)
 error('L must be a fraction expressed as a decimal');
end

if  ~all(size(L) == 1)
 if  length(t) ~= length(L)
  error('The vector of threshold values L must be the same length as t and y');
 end
end

if exist('V')
 if isinf(V) || ~all(size(V) == 1) || V < 0 || V > 1
  error('V must be a fraction expressed as a decimal between 0 and 1');
 end
end


% Set all input vectors as column vectors where applicable
t=t(:); y=y(:); L=L(:);

% Filter y-values with box smoothing if applicable (no end-effect correction)
if p > 0
  [y, t]=sma(y,t,p,'mean','off');
elseif p == 0
end

% Calculation of first derivative
[dydt, y, t]=ndiff(y,t);

% Calculation of second derivative
[d2ydt2, dydt, t]=ndiff(dydt,t); y=y(2:end-1);

% Automatic sign determination of the peak deflections (if applicable)
if s == 'auto'
 if isempty(find(dydt/max(abs(dydt)) == -1))
  s='+';
 elseif isempty(find(dydt/max(abs(dydt)) == 1))
  s='-';
 end
end

% Create vector of constant threshold values if scalar input value is provided for L
l=length(t);
 if all(size(L) == 1)
 L=ones(l,1)*L;
  if s=='+'
   L=L*max(y);
  elseif s=='-'
   L=L*min(y);
  end
 else
  if s=='+'
   L=L(1+(p+2):end-(p+2))*max(y);
  elseif s=='-'
   L=L(1+(p+2):end-(p+2))*min(y);
  end
 end

% Construct peak detection matrix in which points with y(t) below threshold L(t) are excluded
M=ones(l,5);
 if s == '+'
  M(:,1)=(y > L);     % > for positive peak deflections
 elseif s == '-'
  M(:,1)=(y < L);     % < for negative peak deflections
 end
M(:,2)=y; M(:,3)=dydt; M(:,4)=d2ydt2; M(:,5)=M(:,1);
M(:,1)=M(:,1).*t;
M(find(M(:,5) == 0),:)=[];

% Search peak detection matrix for zero crossings of the first derivatve
M0=find(M(:,3)==0);
 if s=='+'
  MX=find(diff(sign(M(:,3))) < -1);
  M0=M0(find(M(M0,4) < 0));
 elseif s=='-'
  MX=find(diff(sign(M(:,3))) > 1);
  M0=M0(find(M(M0,4) > 0));
 end
MX=MX(:);
Mi=sort(vertcat(M0,MX));
Mt=[M(Mi,1) M(Mi+1,1)];
My=[M(Mi,2) M(Mi+1,2)];
Mdiff=diff(My,1,2);
 if s=='+'
  tPeaks=(Mt(:,1).*(Mdiff <= 0))+(Mt(:,2).*(Mdiff > 0));
  yPeaks=(My(:,1).*(Mdiff <= 0))+(My(:,2).*(Mdiff > 0));
 elseif s=='-'
  tPeaks=(Mt(:,1).*(Mdiff >= 0))+(Mt(:,2).*(Mdiff < 0));
  yPeaks=(My(:,1).*(Mdiff >= 0))+(My(:,2).*(Mdiff < 0));
 end


% Construct base detection matrix
 B=ones(l,3);
 B(:,1)=t; B(:,2)=y; B(:,3)=dydt;

% Search base detection matrix for candidate baseline points
 if s=='+'
  Bi=find(diff(sign(B(:,3))) > 0);
 elseif s=='-'
  Bi=find(diff(sign(B(:,3))) < 0);
 end
Bi=Bi(:);
Bt=[B(Bi,1) B(Bi+1,1)];
By=[B(Bi,2) B(Bi+1,2)];
Bdiff=diff(By,1,2);
 if s=='+'
  tBi=(Bt(:,1).*(Bdiff > 0))+(Bt(:,2).*(Bdiff <= 0));
  yBi=(By(:,1).*(Bdiff > 0))+(By(:,2).*(Bdiff <= 0));
 elseif s=='-'
  tBi=(Bt(:,1).*(Bdiff < 0))+(Bt(:,2).*(Bdiff >= 0));
  yBi=(By(:,1).*(Bdiff < 0))+(By(:,2).*(Bdiff >= 0));
 end

n=numel(yPeaks);
if n > 0
% Scan candidates for nearest baseline point preceding each peak
for m=1:length(yPeaks)
 if m == 1
  S=find(tBi < tPeaks(m));
 elseif m > 1
  S=find((tBi>tPeaks(m-1)).*(tBi < tPeaks(m)));
 end
 if isempty(S)
  tBase(m,:)=NaN;
  yBase(m,:)=NaN;
 else
  tBase(m,:)=tBi(max(S));
  yBase(m,:)=yBi(max(S));
 end
end
tPeaks(find(isnan(tBase)))=[]; yPeaks(find(isnan(tBase)))=[]; tBase(find(isnan(tBase)))=[]; yBase(find(isnan(yBase)))=[];

if exist('V') && (length(yPeaks) > 1)
 % Use baseline value from first peak to estimate constant offset and sutract from y-vector for valley screening
 offset=yBase(1);
 yBase=yBase-offset;
 yPeaks=yPeaks-offset;

 % Reject valleys that exceed the fraction defined by the valley threshold for the smallest neighbouring peak
 n=numel(yPeaks);
 ValleyPeaks(:,1)=yPeaks(1:n-1);
 ValleyPeaks(:,2)=yPeaks(2:n);
  if s=='+'
   Valleys=yBase(2:n)./min(ValleyPeaks,[],2);
  elseif s=='-'
   Valleys=yBase(2:n)./max(ValleyPeaks,[],2);
  end
 reject(2:n)=Valleys > V;
 idx=find(reject == 0);
 yBase=yBase(idx); tBase=tBase(idx);

 % Scan intervalley regions to refine peak positions
  idx=[idx n+1];
  for m=1:numel(idx)-1
   if s == '+'
      ridx=[idx(m):idx(m+1)-1]';
      tidx=tPeaks(ridx);
      tPeaks(idx(m))=tidx(find(yPeaks(ridx) == max(yPeaks(ridx))));
      yPeaks(idx(m))=max(yPeaks(ridx));
   elseif s == '-'
      ridx=[idx(m):idx(m+1)-1]';
      tidx=tPeaks(ridx);
      tPeaks(idx(m))=tidx(find(yPeaks(ridx) == min(yPeaks(ridx))));
      yPeaks(idx(m))=min(yPeaks(ridx));
   end
  clear ridx tidx;
  end
  idx(end)=[];
  yPeaks=yPeaks(idx); tPeaks=tPeaks(idx);

 % Restore offset
  yBase=yBase+offset;
  yPeaks=yPeaks+offset;

end
elseif n==0
 tPeaks=[];
 yPeaks=[];
 tBase=[];
 yBase=[];
 yAmpl=[];
end

% Calculation of signal amplitudes
yAmpl=yPeaks-yBase;

% Output
N=numel(yPeaks);
P.tPeaks=tPeaks;
P.yPeaks=yPeaks;
P.tBase=tBase;
P.yBase=yBase;
P.yAmpl=yAmpl;

D=[t y dydt d2ydt2 L];
