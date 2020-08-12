%     Function File: [reduced_data] = reduce_data (data, p)
%     
%     A simple data reduction tool for plot. 
%
%     data is a matrix with x-values in the first column and y-values in 
%     subsequent columns.
%
%     p is the horizontal length of the plot in pixels
%     
%     reduce_data (last updated: 08/01/2019)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [reduced_data] = reduce_data (data,p)

% get size of data
[m, n] = size(data);

if m > p

  % preset reduced_data variable
  reduced_data = NaN(2*p,n);

  % create a vector of x-axis values for reduced data
  intvl = (max(data(:,1)) - min(data(:,1)))/(2*p-1);
  x = [min(data(:,1)) : intvl : max(data(:,1))]';
  reduced_data(:,1) = x;

  % perform data reduction on y-axis values
  for i=2:n
    for j=1:2:2*p
      idx = (data(:,1) >= x(j)) & (data(:,1) < x(min(j+2,2*p)));
      bindata = data(idx,i);
      reduced_data(j,i) = min(bindata);
      reduced_data(j+1,i) = max(bindata);
    end
  end

else
    
  reduced_data = data;
  
end