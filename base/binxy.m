%     Function File: [binMeanX binMeanY binSize] = binxy (x, y, n)
%                    [binMeanX binMeanY binSize] = binxy (x, y, binEdges)
%                    [binMeanX binMeanY binSize binStd] = binxy (...)
%
%     Divides the vector of x-values into n number of equal bins. The
%     function then takes the corresponding y values in each bin and
%     calculates the mean. Output vectors of the bin means for both x,
%     y, and the number of data points in each bin are returned.
%
%     binxy (last updated: 14/11/2009)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [binMeanX binMeanY binSize binStd] = binxy (x, y, argin)

if nargin < 3
 error('Invalid number of input arguments');
end

if all(size(x) == 1) || ~any(size(x) == 1) || length(x) ~= length(y)
 error('x and y must be vectors of the same length');
end
x=x(:); y=y(:);

if numel(argin)>1
 binEdges=argin;
 if ~isfloat(binEdges)
  error('binEdges must containing floating point numbers')
 end
 if min(size(binEdges))>1
  error('binEdges must be a vector')
 end
 numBins=numel(binEdges-1);
 botEdge=binEdges(1);
 topEdge=binEdges(end);

else
  numBins=argin;
  if isinf(numBins) || ~all(size(numBins) == 1) || numBins<=0 || numBins~=round(numBins)
   error('n must be a nonnegative integer')
  end
  botEdge=min(x);
  topEdge=max(x);
  binEdges=linspace(botEdge,topEdge,numBins+1);
end


[h,whichBin]=histc(x,binEdges);
whichBin(dsearchn(x,topEdge))=numBins; % Largest value is allocated to the top bin
for i=1:numBins
 flagBinMembers=(whichBin==i);
 if any(flagBinMembers)
  binMembersY=y(flagBinMembers);
  binMembersX=x(flagBinMembers);
  binMeanY(i,:)=mean(binMembersY);
  binMeanX(i,:)=mean(binMembersX);
  binSize(i,:)=numel(binMembersX);
  binStd(i,:)=std(binMembersY);
 else
  binMeanY(i,:)=NaN;
  binMeanX(i,:)=NaN;
  binSize(i,:)=0;
  binStd(i,:)=NaN;
 end
end



