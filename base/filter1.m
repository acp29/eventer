%     Function File: filter1
%
%         Usage: YF = filter1 (Y, t, HPF, LPF, method)
%
%            OR: filter1 (filename, ending, HPF, LPF, method, '-file')
%
%     This function combines high- and/or low-pass 1-D filtering at the
%     set -3 dB cut-off frequencies, which are defined in the parameters
%     HPF and LPF (units Hertz). To switch off the high-pass filter, enter
%     an HPF value of 0. To switch off the low-pass filter, enter an LPF
%     value of Inf. This function avoids end effects by using a bounce
%     algorithm.
%
%     Low pass filtering is achieved using a digital Gaussian filter at the
%     specified cut-off frequency LPF.
%
%     High pass filtering is achieved using a digital binomial filter
%     (default method='binomial'). If the method is specified as 'median',
%     then a median filtering method is used at the specified HPF cut-off
%     frequency and the resulting trace is subtracted from the input.
%     The filter rank is estimated from the desired cut-off value for the
%     analagous linear filter (boxcar). The median filter does not cause
%     the edge effects that linear filters are prone to, but is slower
%     Note that in the case of the median filter, the HPF value reported
%     is an estimate of the -3 dB cut-off for the initial low-pass
%     filtering prior to subtraction and not the -3 dB cutoff of the
%     resulting high-pass filter.
%
%     In the first example of the function usage, filtering is by default
%     applied to each data column in Y as a function of time (t) defined
%     by the first and second input arguments respectively. The output
%     arguments are the filtered data values (YF).
%
%     The second example of the function usage is defined by setting a
%     sixth input argument to '-file'. In this mode, the function instead
%     loads the data from the text file named in the first input argument
%     and saves the processed data with the filename appended with the
%     ending given in the second input argument. If the ending option is
%     left empty ('[]'), the function will overwrite the original file.
%     The used cut-off values are saved in a separate file with the new
%     filename appended with '_Fc'. The data is saved in the ephysIO hdf5-
%     based MATLAB format with the .mat filename extension.
%
%     When used to band-pass filter, this function performs operations in
%     the order: 1) High-pass, then 2) Low-pass.
%
%     This function requires the following functions and their dependencies:
%     'ephysIO', 'hpfilter', 'lpfilter', 'binomialf' and 'medianf'.
%
%     Bibliography:
%     Marchand & Marmet (1983) Rev Sci Instrum 54(8): 1034-1041
%     Moore & Jorgenson (1993) Anal Chem 65: 188-191
%
%     filter1 v1.3 (last updated: 21/02/2017)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function YF = filter1 (argin1, argin2, HPF, LPF, method, option)

  if nargin<4
    error('Invalid number of input arguments');
  end

  if isinf(HPF) || ~all(size(HPF) == 1) || HPF<0
    error('If non-zero, the HPF cut-off must be a nonnegative, finite value in unit Hz');
  end

  if ~all(size(LPF) == 1) || LPF<=0
    error('If finite, the LPF cut-off must be a nonnegative, non-zero value in unit Hz');
  end

  if nargin>4
    if isempty(method)
      method='binomial';
    end
  else
    method='binomial';
  end

  if nargin>5
    if ~strcmp(option,'-file')
      error('If option is specified, it must be set to '-file'');
    end
  else
    option=[];
  end

  % Load data
  if strcmp(option,'-file')
    cwd = pwd;
    if ~isempty(regexpi(argin1(end-2:end),'.gz'))
      [pathstr,filename,ext] = fileparts(argin1(end-2:end));
    elseif ~isempty(regexpi(argin1(end-3:end),'.zip'))
      [pathstr,filename,ext] = fileparts(argin1(end-3:end));
    else
      [pathstr,filename,ext] = fileparts(argin1);
    end
    if ~isempty(pathstr)
      chdir(pathstr);
    end
    [data,xdiff,xunit,yunit,names,notes] = ephysIO (strcat(filename,ext));
    t=data(:,1);
    Y=data; Y(:,1)=[];
  else
    Y=argin1;
    t=argin2;
    if any(diff(diff(t)) > 1.192093e-07)
      % Variable sampling interval
      xdiff = 0;
    else
      xdiff = t(2)-t(1);
    end
  end
  l=length(t);

  % Perform linear interpolation on non-evenly spaced datasets
  if xdiff == 0
    disp(sprintf('Input must consist of data sampled at evenly spaced time points.\nData will undergo linear interpolation.'));
    sample_rate=(l-1)/(max(t)-min(t));
    tl=linspace(min(t),max(t),l);
    tl=tl(:);
    for i=1:size(Y,2)
      state = warning('query');
      warning off %#ok<WNOFF>
      Yl(:,i)=interp1q(t,Y(:,i),tl);
      warning(state)
    end
  elseif xdiff > 0
    sample_rate=(l-1)/(max(t)-min(t));
    tl=t(:);
    Yl=Y;
  end

% Filter data traces
if strcmp(option,'-file')
 figure(2)
 clf
end
for i=1:size(Yl,2)
  yf = Yl(:,i);
  if ~isinf(LPF)
    yf = gaussianf (yf, tl, LPF,'on');
  end
  yref = yf;
  if HPF > 0
    if strcmp(method,'median')
     % Analogy to a linear, boxcar filter:
     % -3 dB cut-off: Fc  ~ 0.443 / p * sample_rate,
     % where the number of points in the sliding window:
     % p = 2 * r + 1 and Fc is HPF and r is the filter rank
     p = ((0.443*sample_rate)/HPF);
     r=round((p-1)/2);
     HPF = 0.443 / (2*r+1) * sample_rate;
     arch = computer('arch');
     try
       if strcmpi(arch,'maci64')
         % Code to run on Mac 64-bit platform
         [ybase, tbase] = medianf_mex_maci64 (yref, tl, r);  %#ok<*ASGLU>
       elseif strcmpi(arch,'glnxa64')
         % Code to run on Linux 64-bit platform
         [ybase, tbase] = medianf_mex_glnxa64 (yref, tl, r);
       elseif strcmpi(arch,'win64')
         % Code to run on Windows 64-bit platform
         [ybase, tbase] = medianf_mex_win64 (yref, tl, r);
       end
     catch
       warning(sprintf(['A suitable MEX file for medianf is not available or failed to execute.\n',...
                        'Falling back to Matlab file']));
       [ybase, tbase] = medianf (yref, tl, r);
     end
     yf=yref-ybase;
     if strcmp(option,'-file')
      y_autoscale=0.05*(max(yref)-min(yref)); y_maxlim=max(yref)+y_autoscale; y_minlim=min(yref)-y_autoscale; % Encoded y-axis autoscaling
      figure(2); hold on; plot(tl,yref,'-','color',[0.75,0.75,0.75]); plot(tl,ybase,'k'); hold off; xlim([min(tl),max(tl)]); ylim([y_minlim y_maxlim]); box('off');
     end
    elseif strcmp(method, 'binomial')
     yf = hpfilter (yref, tl, HPF);
     if strcmp(option,'-file')
      y_autoscale=0.05*(max(yref)-min(yref)); y_maxlim=max(yref)+y_autoscale; y_minlim=min(yref)-y_autoscale; % Encoded y-axis autoscaling
      figure(2); hold on; plot(tl,yref,'-','color',[0.75,0.75,0.75]); plot(tl,yref-yf,'k-'); hold off; xlim([min(tl),max(tl)]); ylim([y_minlim y_maxlim]); box('off');
     end
   end
  elseif HPF == 0
   figure(2)
   close(2)
  end
 YF(:,i)=yf;
end

% Output for filter1 function in '-file' mode
if strcmp(option,'-file')
 diary('on');
 cutoffs=strcat(argin1,argin2,'_Fc.txt');
 if exist(cutoffs,'file') ~= 0
  delete(cutoffs);
 end
 method %#ok<NOPRT>
 format short g
 if strcmp(method,'binomial')
  HPF %#ok<NOPRT>
 elseif strcmp(method,'median')
  HPF %#ok<NOPRT>
  r %#ok<NOPRT>
 end
 LPF %#ok<NOPRT>
 diary('off');
 figure(1);
 y_autoscale=0.05*(max(max(YF))-min(min(YF))); y_maxlim=max(max(YF))+y_autoscale; y_minlim=min(min(YF))-y_autoscale; % Encoded y-axis autoscaling
 plot(tl,YF,'k-'); xlim([min(tl),max(tl)]); ylim([y_minlim y_maxlim]); box('off');
 ylabel(strcat('y-axis (',yunit,')'));
 xlabel(strcat('x-axis (',xunit,')'));
 output_data=cat(2,tl,YF); %#ok<NASGU>
 newfilename=strcat(filename,argin2,'.mat');
 ephysIO(newfilename,output_data,xunit,yunit,names,notes);
 if exist('filter1.output','dir') == 0
  mkdir('filter1.output');
 end
 cd filter1.output
 newfilename=strtok(newfilename,'.');
 if exist(newfilename,'dir') == 0
  mkdir(newfilename);
 end
 cd(newfilename);
 print(1,'output.png','-dpng');
 print(1,'output.eps','-depsc');
 if HPF > 0
  print(2,'baseline.png','-dpng');
  print(2,'baseline.eps','-depsc');
 end
 movefile('../../diary',cutoffs);
 cd ../..
 clear YF tl
end
