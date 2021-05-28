%  Function File: eventer
%
%  peak = eventer(file,TC,s,SF)
%  peak = eventer(file,TC,s,SF,...,'method',method)
%  peak = eventer(file,TC,s,SF,...,'exclude',exclude)
%  peak = eventer(file,TC,s,SF,...,'criterion',criterion)
%  peak = eventer(file,TC,s,SF,...,'rmin',rmin)
%  peak = eventer(file,TC,s,SF,...,'hpf',hpf)
%  peak = eventer(file,TC,s,SF,...,'lpf',lpf)
%  peak = eventer(file,TC,s,SF,...,'taus',taus)
%  peak = eventer(file,TC,s,SF,...,'baseline',baseline)
%  peak = eventer(file,TC,s,SF,...,'win',win)
%  peak = eventer(file,TC,s,SF,...,'lambda',lambda)
%  peak = eventer(file,TC,s,SF,...,'config',config)
%  peak = eventer(file,TC,s,SF,...,'average',average)
%  peak = eventer(file,TC,s,SF,...,'export',format)
%  peak = eventer(file,TC,s,SF,...,'channel',channel)
%  peak = eventer(file,TC,s,SF,...,'wave',wave)
%  peak = eventer(file,TC,s,SF,...,'exmode',wave)
%  peak = eventer(file,TC,s,SF,...,'figure',format)
%  peak = eventer(file,TC,s,SF,...,'globvar',globvar)
%  [peak,IEI] = eventer(...)
%
%  peak = eventer(file,TC,s,SF) returns the amplitudes of spontaneous EPSC-
%    or EPSP-like waveforms, detected either from the first derivative or by
%    FFT-based deconvolution [1]. In both cases, a template modeled by the
%    sum of two exponentials is required, whose time constants must be
%    provided in units seconds as a vector (TC). The sign (s) of the event
%    peak deflections in the wave file must be specified as '-' or '+'.
%    Event times are then defined where there are maxima of delta-like waves
%    exceeding a threshold, which is set to the standard deviation of the
%    noise of the first derivative (or deconvoluted wave) multiplied by a
%    scale factor (SF). Events are then extracted as episodic data and the
%    factor parameter of least-squares fits with the template define the
%    peak amplitudes. See the associated input-output function ephysIO for
%    details of supported input file formats. The file extension must be
%    included in the filename of the file input argument. The template
%    kinetics is modeled by the difference of 2 exponentials:
%      f(t) = exp ( - t / tau_decay ) - exp ( - t / tau_rise )
%
%  peak = eventer(file,TC,s,SF,...,'method',method) sets the detection
%    method of eventer. The options available are 'deconvolution' (default)
%    or 'derivative'. At very low sampling frequencies, the derivative
%    method is preferable, in which case the template is only used for
%    refitting events and applying the criterion for event screening.
%
%  peak = eventer(file,TC,s,SF,...,'exclude',exclude) sets exclusion zones,
%    which must be specified as a 2-column matrix, where the first and
%    second columns define the start and end times of the excluded zones
%    (in seconds). Events detected in these regions are discarded. By
%    default, there are no exclusion zones.
%
%  peak = eventer(file,TC,s,SF,...,'criterion',criterion) sets the type of
%    correlation coefficient used when comparing the fitted model template
%    with each event. Options are 'Pearson', 'Spearman' or 'Kendall', or
%    at an object of class TreeBagger for event classification (machine
%    learning).
%
%  peak = eventer(file,TC,s,SF,...,'rmin',rmin) sets the correlation
%    coefficient for fitted model template and the event. Events with a
%    correlation coefficient (r) less than the value defined in rmin are
%    discarded [2]. The default rmin is 0.4, where r < 0.4 is considered
%    a very weak correlation.
%
%  peak = eventer(file,TC,s,SF,...,'hpf',hpf) sets the -3 dB cut-off (in
%    Hz) of the low-pass median filter applied to the deconvoluted wave,
%    where the filtered wave is then subtracted from the deconvoluted
%    wave. Thus, this is essentially a high-pass filter. The algorithm
%    implements a bounce correction to avoid end effects. The default
%    cut-off is 1 Hz.
%
%  peak = eventer(file,TC,s,SF,...,'lpf',lpf) sets the -3 dB cut-off (in
%    Hz) of the low-pass binomial filter applied to the deconvoluted wave.
%    The default cut-off is 200 Hz.
%
%  peak = eventer(file,TC,s,SF,...,'taus',taus) sets the number of time
%    constants after the peak of the template to use when fitting the
%    template to the detected events. The default is 0.4, which corresponds
%    to the time for the template to decay by 25 % of the peak. This
%    limited fit ensures that peak measurements are not compromised at high
%    event frequencies where there is event overlap.
%
%  peak = eventer(file,TC,s,SF,...,'baseline',baseline) sets the length
%    of time to use as the pre-event baseline for the template fit in
%    seconds.
%
%  peak = eventer(file,TC,s,SF,...,'win',win) sets the event window limits
%    in seconds for the conversion of the continuous wave to episodic
%    data. By default the limits are set at [-0.01 0.04].
%
%  peak = eventer(file,TC,s,SF,...,'lambda',lambda) sets the damping
%    factor used in the Levenberg-Marquardt ordinary non-linear least-
%    squares fitting procedures. The default is 1. The higher the value
%    of lambda, the more robust the fitting procedure is to the initial
%    values but the greater the number of iterations it will use.
%
%  peak = eventer(file,TC,s,SF,...,'config',config) sets the configuration
%    of the recording wave to either 'VC' (for voltage clamp) or 'CC'
%    (for current-clamp).The default is 'VC'.
%
%  peak = eventer(file,TC,s,SF,...,'average',average) sets eventer to
%    compute either the ensemble 'mean' or 'median' of the merged event
%    data. The default is 'mean'.
%
%  peak = eventer(file,TC,s,SF,...,'export',format) sets eventer to
%    export the episodic wave data of all detected events in the
%    specified format.
%
%  peak = eventer(file,TC,s,SF,...,'channel',channel) sets eventer to
%    select the recording channel from the file. If none is specified,
%    eventer analyses channel number 1. This argument is ignored for
%    loaded filetypes that do not support multiple recording channels.
%
%  peak = eventer(file,TC,s,SF,...,'wave',wave) sets eventer to select
%    the wave number from the file. If none is specified, eventer analyses
%    the first wave.
%
%  peak = eventer(file,TC,s,SF,...,'exmode',exmode) tells eventer what to
%    do with the first event proceeding each exclusion zone. For mode = 1
%    (default) IEIs are calculated for these events from the last event
%    preceeding the exclusion zone under the assumption that no events
%    occurred during the exclusion zone. For mode = 2, these events are
%    assigned an IEI of NaN. Note that events with NaN values are excluded
%    during the merge (i.e. that are in the ALL_events output directory).
%
%  peak = eventer(file,TC,s,SF,...,'figure',format) tells eventer what
%    format to use when saving figures. Bitmap images are saved at 300 dpi
%    resolution. Accepted formats are: 'fig', 'tiff', 'tiffn', 'png', 'bmp',
%    'eps', 'pdf', 'svg' and 'emf'. By default, 'tiff' will save images with
%    compression. To save files without compression use format 'tiffn'. On
%    windows platforms, images can also be saved as enhanced meta files
%    ('emf') for easy import into Microsoft applications.
%
%  peak = eventer(file,TC,s,SF,...,'globvar',globvar) tells eventer how to
%    load the data. Set globvar to 0 to force eventer to load the data from
%    the specified file. Set globvar to 1 to force eventer to use the data
%    already loaded into the workspace by ephysIO.
%
%  [peak,IEI] = eventer(...) returns the interevent intervals preceding
%    each peak event. The first event from the start of the wave is assigned
%    an IEI of NaN.
%
%  See the example distributed with this function.
%
%  Dependencies: sinv, binomialf, bounce, hpfilter, lpfilter, lsqfit and
%                ephysIO.
%
%  References:
%   [1] Pernia-Andrade AJ, Goswami SP, Stickler Y, Frobe U, Schlogl A,
%    Jonas P. (2012) A deconvolution-based method with high sensitivity
%    and temporal resolution for detection of spontaneous synaptic currents
%    in vitro and in vivo. Biophys J. 103(7):1429-39.
%   [2] Jonas P, Major G and Sakmann (1993) Quantal components of unitary
%    EPSCs at the mossy fibre synapse on CA3 pyramidal cells of the rat
%    hippocampus. J Physiol. 472:615-663.
%
%  eventer v1.6 (last updated: 18/12/2020)
%  Author: Andrew Charles Penn
%  https://www.researchgate.net/profile/Andrew_Penn/


function [peak,IEI,features] = eventer(arg1,TC,s,SF,varargin)

  if nargin<2 || sum(size(TC))>3
    error('A vector defining the time constants of the template has to be specified');
  else
    if sum(sign(TC))~=2
      error('The time constants must be non-zero and non-negative');
    end
    if TC(1)>=TC(2)
      error('The first time constant (rise) must be smaller than the second time constant (decay)');
    end
  end

  if nargin<3
    error('The sign of the peaks has to be specified');
  end

  if s~='+' && s~='-'
    error('The sign of the peaks has to be specified in the + or - direction');
  end

  if nargin<4
    error('The factor of standard deviations has to be specified to set the detection threshold');
  else
    if isempty(SF)
      SF = 4;
    end
  end

  % Set additional options
  options = varargin;
  method = 1+find(strcmp('method',options));
  excl = 1+find(strcmp('exclude',options));
  rmin = 1+find(strcmp('rmin',options));
  criterion = 1+find(strcmp('criterion',options));
  hpf = 1+find(strcmp('hpf',options));
  lpf = 1+find(strcmp('lpf',options));
  taus = 1+find(strcmp('taus',options));
  base = 1+find(strcmp('baseline',options));
  win = 1+find(strcmp('win',options));
  config = 1+find(strcmp('config',options));
  lambda = 1+find(strcmp('lambda',options));
  average = 1+find(strcmp('average',options));
  export = 1+find(strcmp('export',options));
  channel = 1+find(strcmp('channel',options));
  wave = 1+find(strcmp('wave',options));
  exmode = 1+find(strcmp('exmode',options));
  figform = 1+find(strcmp('figure',options));
  globvar = 1+find(strcmp('globvar',options));
  merge = 1+find(strcmp('merge',options));
  showfig = 1+find(strcmp('showfig',options));
  absT = 1+find(strcmp('threshold',options));
  if ~isempty(method)
    try
      method = options{method};
    catch
      method = 'Deconvolution';
    end
  else
    method = 'Deconvolution';
  end
  if ~isempty(excl)
    try
      excl = options{excl};
    catch
      excl = [];
    end
  else
    excl = [];
  end
  if ~isempty(rmin)
    try
      rmin = options{rmin};
    catch
      rmin = 0.4;
    end
  else
    rmin = 0.4;
  end
  if ~isempty(criterion)
    try
      criterion = options{criterion};
    catch
      criterion = 'Pearson';
    end
  else
    criterion = 'Pearson';
  end
  if strcmpi(class(criterion),'TreeBagger')
    coeff = 'Pearson';
    rmin = -1;
  else
    coeff = criterion;
  end
  % Default value of 0.4 corresponds to the time for the event to decay by 25% of the peak
  if ~isempty(taus)
    try
      taus = options{taus};
    catch
      taus = 0.4;
    end
  else
    taus = 0.4;
  end
  if ~isempty(hpf)
    try
      hpf = options{hpf};
    catch
      hpf = 1;
    end
  else
    hpf = 1;
  end
  if ~isempty(lpf)
    try
      lpf = options{lpf};
    catch
      lpf = 200;
    end
  else
    lpf = 200;
  end
  if ~isempty(base)
    try
      base = abs(options{base});
    catch
      base = 1e-03;
    end
  else
    base = 1e-03;
  end
  if ~isempty(win)
    try
      win = options{win};
    catch
      win = [-0.01 0.04];
    end
  else
    win = [-0.01 0.04];
  end
  if ~isempty(config)
    try
      config = options{config};
    catch
      config = '';
    end
  else
    config = '';
  end
  if ~isempty(lambda)
    try
      lambda = options{lambda};
    catch
      lambda = 1;
    end
  else
    lambda = 1;
  end
  if ~isempty(average)
    try
      average = options{average};
    catch
      average = 'mean';
    end
  else
    average = 'mean';
  end
  if ~isempty(export)
    try
      export = options{export};
    catch
      export = 'none';
    end
  else
    export = 'none';
  end
  if ~isempty(channel)
    try
      channel = options{channel};
    catch
      channel = 'none';
    end
  else
    channel = 1;
  end
  if ~isempty(wave)
    try
      wave = options{wave};
    catch
      wave = 1;
    end
  else
    wave = 1;
  end
  wave = wave+1; % Add 1 since first column in data matrix is time
  if ~isempty(exmode)
    try
      exmode = options{exmode};
    catch
      exmode = 1;
    end
  else
    exmode = 1;
  end
  if ~isempty(figform)
    try
      figform = options{figform};
    catch
      figform = 'fig';
    end
  else
    figform = 'fig';
  end
  if strcmpi(figform,'eps')
    figform = 'epsc';
  end
  if strcmpi(figform,'emf')
    if ~ispc
      error('the enhanced meta file format is only supported on windows platforms');
    end
    figform = 'meta';
  end
  if ~isempty(globvar)
    try
      globvar = options{globvar};
    catch
      globvar = 0;
    end
  else
    globvar = 0;
  end
  if ~isempty(merge)
    try
      merge = options{merge};
    catch
      merge = 1;
    end
  else
    merge = 1;
  end
  if ~isempty(showfig)
    try
      showfig = options{showfig};
    catch
      showfig = 'on';
    end
  else
    showfig = 'on';
  end
  if ~isempty(absT)
    try
      absT = options{absT};
    catch
      absT = 0;
    end
  else
    absT = 0;
  end

  % Error checking
  if size(win,1)~=1 && size(win,2)~=2
      error('win must be a vector defining the limits of the event window');
  end

  % Close existing figures
  if ishandle(1)
    close(1)
  end
  if ishandle(2)
    close(2)
  end
  if ishandle(3)
    close(3)
  end
  if ishandle(4)
    close(4)
  end
  if ishandle(5)
    close(5)
  end
  if ishandle(6)
    close(6)
  end

  % Load data
  cwd = pwd;
  if isstruct(arg1)
    file = 'Data'; %#ok<*NASGU>
    pathstr = '';
    filename = 'Data';
    ext = '';
    data  = arg1.array;
    xdiff = arg1.xdiff; %#ok<*GPFST>
    xunit = arg1.xunit;
    yunit = arg1.yunit;
    names = arg1.names;
    notes = arg1.notes;
  elseif ischar(arg1)
    file = arg1;
    if ~isempty(regexpi(file(end-2:end),'.gz'))
      [pathstr,filename,ext] = fileparts(file(end-2:end));
    elseif ~isempty(regexpi(file(end-3:end),'.zip'))
      [pathstr,filename,ext] = fileparts(file(end-3:end));
    else
      [pathstr,filename,ext] = fileparts(file);
    end
    if ~isempty(pathstr)
      chdir(pathstr);
    end
    if globvar == 0
      [data,xdiff,xunit,yunit,names,notes] = ephysIO ({strcat(filename,ext),channel});
    elseif globvar == 1
       global array %#ok<*TLEV>
       data = array;
       global xdiff
       global xunit
       global yunit
       global names
       global notes
    end
  end

  if wave > size(data,2)
    error('wave number exceeds data dimensions')
  end
  filewave = sprintf('%s_ch%d_%s',filename,channel,names{wave});
  if isempty(xunit)
    warning('xunit is undefined. X dimenion units assumed to be seconds.')
    xunit = 's';
  elseif ~strcmp(xunit,'s')
    error('expected xunit to be seconds (s)')
  end
  % Overide data units with configurationn argument
  if strcmpi(config,'CC')
    yunit = 'V';
  elseif strcmp(config,'VC')
    yunit = 'A';
  elseif strcmp(config,'')
    yunit = '';
  end
  try
    if xdiff == 0
      warning('data array must have a constant sampling interval');
    end
  catch
    if strcmp(xdiff,'variable')
      warning('data array must have a constant sampling interval');
    end
  end

  % Assign variables from data
  N = size(data,1);
  RecordTime = range(data(:,1));
  sample_rate = round((N-1)/RecordTime);
  tau_rise = TC(1);
  tau_decay = TC(2);
  % Concatenate traces
  numwave = numel(wave);
  if numel(wave) > 1
    Trace = reshape(data(:,wave),numwave*N,1);
    T = (0:numwave*N-1)'*1/sample_rate;
    t = T;
  else
    Trace = data(:,wave);
    T = (0:N-1)'*1/sample_rate;
    t = data(:,1);
  end
  clear data

  % Create model template event
  Template = -exp(-T/tau_rise)+exp(-T/tau_decay);
  TemplatePeak = max(Template);
  Template = Template/TemplatePeak;
  time2peak = tau_decay*tau_rise/(tau_decay-tau_rise)*log(tau_decay/tau_rise);
  if s=='-'
    Template = Template*-1;
  end

  if strcmpi(method, 'Deconvolution')
    % Perform fourier transform-based deconvolution (pad ends to mask end effects)
    Template_FFT = fft(cat(1,Template,zeros(2*sample_rate,1)));
    Trace_FFT = fft(bounce(Trace,sample_rate));
    DEC = real(ifft(Trace_FFT./Template_FFT));
    clear Trace_FFT Template_FFT
    DEC(1:sample_rate) = [];
    DEC(end-sample_rate+1:end) = [];
  elseif strcmpi(method, 'Derivative')
    DEC = [diff(Trace);0];
  end

  % Band-pass filter the deconvoluted trace (default is 1-200 Hz)
  DEC = filter1 (DEC, t, hpf, lpf, 'median');

  % Assign NaN to deconvoluted waves for values inside user-defined exclusion zones
  % Calculate actual recording time analysed (not including exclusion zones)
  if ~isempty(excl)
    excl_idx(:,1) = dsearchn(t,excl(:,1));
    excl_idx(:,2) = dsearchn(t,excl(:,2));
  end
  for i=1:size(excl,1)
    DEC(excl_idx(i,1):excl_idx(i,2)) = NaN;
  end
  AnalysedTime = (sum(~isnan(DEC))-1)/sample_rate;

  % Create all-point histogram with optimal bin width determined by modified Silverman's
  % rule of thumb on the putative noise component based on robust statistics.
  % References:
  % -Hardle, W. SMOOTHING TECHNIQUES, with implementations in S. Springer, New York. 1991
  % -Silverman, B.W. DENSITY ESTIMATION FOR STATISTICS AND DATA ANALYSIS.
  %  Monographs on Statistics and Applied Probability, London: Chapman and Hall, 1986.
  noise = DEC(~isnan(DEC));
  lim = abs(min(noise));
  noise(noise>lim) = [];
  Q2 = median(noise);
  Q1 = median(noise(noise<Q2));
  Q3 = median(noise(noise>Q2));
  IQR = abs(Q1-Q3);
  if IQR < eps
    error('the distribution of the noise has zero standard deviation')
  end
  h = 0.79*IQR*numel(noise)^(-1/5);
  binwidth = 2*h;
  bins = ceil(range(DEC)/binwidth);
  try
    [counts,x] = hist(DEC,bins);
  catch
    error('hist returned an error. Try alterative filter settings')
  end

  % Find the center of the noise peak
  peak_count = max(counts);
  mu = mean(x(counts==max(counts)));

  % Use linear interpolation between histogram bins to find half-maximum and
  % extrapolate the FWHM from the bottom half of the noise peak. Use this to
  % approximate the standard deviation of the noise peak.
  top = x(counts>max(counts)/2);
  idx = ones(1,2)*find(x==top(1));
  idx(1) = idx(1)-1;
  LL = interp1(counts(idx),x(idx),peak_count/2,'linear','extrap');
  FWHM = abs((LL-mu))*2;
  sigma = FWHM/(2*sqrt(2*log(2)));

  % Center and scale the noise component of the deconvoluted data using initial estimates
  DEC = (DEC-mu)/sigma;
  x = (x-mu)/sigma;

  % Least-squares Gaussian fitting of the noise peak using Levenberg-Marquardt
  % algorithm with the initial estimates for the fit parameters (data is scaled
  % for best performance)
  xdata = x((x>-4)&(x<1))';
  ydata = counts((x>-4)&(x<1))'/max(counts);
  fun1 = @(p,xdata)p(1)*p(3)*sqrt(2*pi)*normpdf(xdata,p(2),p(3));
  p0 = [1;0;1];
  optimoptions = struct;
  optimoptions.Algorithm = {'levenberg-marquardt',lambda};
  optimoptions.TolX = eps;
  optimoptions.TolFun = eps;
  [p,resnorm,residual,exitflag] = lsqfit(fun1,p0,xdata,ydata,[],[],optimoptions);
  clear xdata ydata
  if exitflag<1
    error('Noise peak fitting failed to reach tolerance. Try a higher lambda value.')
  end

  % Recenter and scale the noise component of the deconvoluted data using the
  % optimization result
  DEC = (DEC-p(2))/p(3);
  x = (x-p(2))/p(3);
  
  % Absolute threshold provided. Overide scale factor setting.
  noiseSD = sigma*p(3);
  if absT > 0
    SF = absT/noiseSD;
  end
  
  % Scan superthreshold deconvoluted wave for local maxima (vectorized)
  N = numel(Trace); % Number of sample points in cropped wave
  npeaks = sum(diff(sign(diff(DEC)))==-2); % Total number of peaks without threshold
  Event = zeros(N,1);
  y = DEC.*(DEC>SF);
  Event(2:N-1) = diff(sign(diff(y)))==-2;

  % Create episodic data
  samples_pre = round(abs(win(1))*sample_rate);
  samples_post = round(win(2)*sample_rate);
  Event_idx = find(Event);
  idx_pre = Event_idx-samples_pre;
  idx_post = Event_idx+samples_post;
  n = sum(Event);
  %t_events(:,1) = win(1):1/sample_rate:win(2);
  t_events(:,1) = [-samples_pre:+samples_post]/sample_rate; % more robust
  y_events = NaN(length(t_events),n); % preallocation
  idx = cell(n,1);
  if n > 0
    for i=1:n
      if idx_pre(i) < 1
        % Event close to start of trace
        y_events(:,i) = Trace(1);
        idx{i} = transpose(1:idx_post(i));
        y_events(length(t_events)-idx_post(i)+1:end,i) = Trace(idx{i});
      elseif idx_post(i) > N
        % Event close to end of trace
        y_events(:,i) = Trace(end);
        idx{i} = transpose(idx_pre(i):N);
        y_events(1:numel(idx{i}),i) = Trace(idx{i});
      else
        idx{i} = transpose(idx_pre(i):idx_post(i));
        y_events(:,i) = Trace(idx{i});
      end
    end
  end
  clear idx
  Event_time = t(Event_idx);

  % Initialize output arguments
  peak = [];
  IEI = [];
  features = [];

  if n > 0
    % Fit template onto events using linear least squares
    SCALE = ones(1,n);
    OFFSET = zeros(1,n);
    % Time-to-peak = -log(tau_decay/tau_rise)/(1/tau_decay-1/tau_rise)
    if s=='+'
      idx = find(Template==max(Template));
    elseif s=='-'
      idx = find(Template==min(Template));
    end
    templateTime = idx+round(sample_rate*tau_decay*taus);
	if templateTime > samples_post
	  error('Event window size is to small for the events')
	end
    numelBase = round(base*sample_rate);
    A = [zeros(numelBase,1); Template(1:templateTime)];
    l = length(A);
    A = [ones(l,1),A];
    start = dsearchn(t_events,base*-1);
    t_fit = t_events(start:start+numelBase+templateTime-1);
    y_fit = y_events(start:start+numelBase+templateTime-1,:);
    y_template = NaN(size(y_fit)); % preallocation
    tpeak = NaN(n,1);  % preallocation
    t50 = NaN(n,1);    % preallocation
    tdecay = NaN(n,1); % preallocation
    auc = NaN(n,1);    % preallocation
    skew = NaN(n,1);   % preallocation
    rstdev = NaN(n,1); % preallocation
    rskew = NaN(n,1);  % preallocation
    r = NaN(n,1);      % preallocation
    before = NaN(n,1); % preallocation
    after = NaN(n,1);  % preallocation
    tzero = dsearchn(t_fit,0);
    for i=1:n
      % For fitting discard any region of overlap with next event
      if i < n
        k = min(Event_idx(i)+templateTime,Event_idx(i+1))-Event_idx(i)+numelBase;
      else
        k = min(Event_idx(i)+templateTime,N)-Event_idx(i)+numelBase;
      end
      % Perform linear least-squares fit using singular value decomposition on events
      kmin = sinv(A(1:k,:)'*A(1:k,:))*A(1:k,:)'*y_fit(1:k,i);
      OFFSET(i) = kmin(1);
      SCALE(i) = abs(kmin(2)); % Absolute value constraint: The template cannot be inverted
      y_template(:,i) = SCALE(i)*A(:,2)+OFFSET(i);
      r(i) = corr(y_template(1:k,i),y_fit(1:k,i),'type',coeff);
      residuals = y_fit(1:k,i) - y_template(1:k,i);
      [tpeak(i), t50(i), tdecay(i), auc(i), skew(i)] = shape(t_fit(1:k),y_fit(1:k,i),OFFSET(i),sample_rate,s,base);
      rstdev(i) = std(residuals);
      rskew(i) = skewness(residuals);
      after(i) = (k - numelBase)/sample_rate; % Truncated time to next event
      % Time-to-peak dead time. Discard events that are proceeded by another event
      % before the initial event reaches it's peaks
      if k < numelBase+idx
        r(i) = -inf;
      end
    end
    y_events = y_events-ones(length(t_events),1)*OFFSET;

    % Create feature matrix
    before = circshift(after,1); before(1) = templateTime / sample_rate;
    ampl = SCALE';
    features = [tpeak t50 tdecay auc skew ampl r rstdev before after];
    % Description of features
    %  1)  tpeak: time-to-peak
    %  2)  t50: duration of event above half-maximum amplitude (approximates FWHM)
    %  3)  tdecay: duration of event post-peak above half-maximum amplitude (approximates decay half-life)
    %  4)  auc: area-under-curve of the event
    %  5)  skew: skewness metric for the distribution of the event sample points around the baseline
    %  6)  ampl: event amplitude calculated from template fitting
    %  7)  r: correlation coefficient of the template fitting
    %  8)  rstdev: standard deviation of residuals from the fit
    %  9)  before: time from preceding event (truncated)
    %  10) after: time to next event (truncated)

    % Discard events that are poorly correlated with the fitted template (r < rmin)
    if strcmpi(class(criterion),'TreeBagger')
      out = predict(criterion,features);
      ridx = find(cell2mat(out)=='0');
      criterion = 'Machine Learning';
    else
      ridx = find(r<rmin);
    end
    Event(ridx) = 0; % Keep in case required for diagnostic tests
    Event_idx(ridx') = [];
    Event_time(ridx') = [];
    SCALE(ridx) = [];
    OFFSET(ridx) = []; % Keep in case required for diagnostic tests
    tpeak(ridx) = [];
    t50(ridx) = [];
    tdecay(ridx) = [];
    auc(ridx) = [];
    skew(ridx) = [];
    rstdev(ridx) = [];
    rskew(ridx) = [];
    r(ridx) = [];
    ampl(ridx) = [];
    before(ridx) = [];
    after(ridx) = [];
    y_events(:,ridx) = [];
    y_fit(:,ridx) = [];
    y_template(:,ridx) = [];
    features(ridx,:) = [];
    n = numel(Event_idx);
    y_avg = mean(y_fit,2);
    peak = SCALE';

    % Create wave of fitted templates to overlay onto the event wave
    % Note that the baseline period is not plotted
    FITtrace = nan(N,1);
    l = length(t_fit(tzero:end));
    for i=1:n
      k = min(Event_idx(i)+(l-1),N);
      FITtrace(Event_idx(i):k) = y_template(tzero:tzero+k-Event_idx(i),i);
      FITtrace(Event_idx(i)-1) = NaN;
    end
  end

  % Get screen size and set figure sizes
  set(0,'units','pixels');
  scn_sz = get(0,'screensize');
  sw = scn_sz(3);
  sh = scn_sz(4);
  fw = sw/3;
  fh = sh/2;

  % Figures
  vector = 'pdf eps epsc eps2 epsc2 meta svg ps psc ps2 psc2';
  bitmap = 'jpeg png tiff tiffn bmpmono bmp bmp16m bmp256 hdf pbm pbmraw pcxmono pcx24b pcx256 pcx16 pgm pgmraw ppm ppmraw';

  % Figure 1: All-points histogram of the deconvoluted data points
  clear h
  h1 = figure(1);set(h1,'visible',showfig);set(h1,'OuterPosition',[0 sh-fh fw fh]);
  addToolbarExplorationButtons(gcf);
  bar(x,counts,1,'EdgeColor','b','Facecolor','b');
  ax = gca;
  ax.Toolbar.Visible = 'off';
  hold on; plot(x,max(counts)*fun1([p(1);0;1],x),'r','linewidth',3);
  ylimits=ylim;
  plot(SF*ones(1,2),ylimits,'g','linewidth',2)
  hold off;
  ylim(ylimits); xlim([min(DEC),max(DEC)]);
  box('off'); grid('off');
  title('Histogram of the deconvoluted wave');
  xlabel('Deconvoluted wave (SD)');
  ylabel('Number of points');
  xlim([-5,20]);  % Set x-axis limits to -5 and +20 SD of the baseline noise for clarity

  % Figure 2: Filtered deconvoluted wave (blue) and detection threshold (green)
  h2 = figure(2);set(h2,'visible',showfig);set(h2,'OuterPosition',[fw sh-fh fw fh]);
  addToolbarExplorationButtons(gcf);
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t,DEC,'b','linewidth',1.25);
    catch
      plot(t,DEC,'b');
    end
  else
    plot(t,DEC,'b');
  end
  ax = gca;
  ax.Toolbar.Visible = 'off';
  hold on;
  plot([t(1),t(end)],SF*ones(1,2),'g','linewidth',2);
  p2 = get(gca);
  EventPoints = p2.YLim(2)*Event;
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t(Event>0),EventPoints(Event>0),'r.','markersize',5);
    catch
      plot(t(Event>0),EventPoints(Event>0),'r.','markersize',5);
    end
  else
    plot(t(Event>0),EventPoints(Event>0),'r.','markersize',5);
  end
  hold off;
  xlim([min(t),max(t)]);
  grid('off'); box('off');
  title('Deconvoluted wave (before applying event criterion)');
  ylabel('Deconvoluted wave (SD)');
  xlabel('Time (s)');

  % Print result summary and escape from the function if no events were detected
  if n == 0
    if strcmpi(class(criterion),'TreeBagger')
      criterion = 'Machine Learning';
    end

    % Print basic information
    %fprintf(fid,...
    %        ['--------------------------EVENTER---------------------------\n',...
    %         ' Automatic PSC/PSP detection using FFT-based deconvolution\n',...
    %         ' and event peak analysis by least-squares template fitting\n',...
    %         ' Version v1.0 Copyright 2014 Andrew Charles Penn                \n\n'])
    fid=fopen(filewave,'w+t');
    fprintf(fid,'Filename: %s\n',filename);
    fprintf(fid,'Channel: %d\n',channel);
    fprintf(fid,'Wave number: %d\n',wave-1);
    fprintf(fid,'Wave name: %s\n',names{wave});
    fprintf(fid,'Total number of events detected: %d\n',n);
    fprintf(fid,'Duration of recording analysed (in s): %.1f\n',AnalysedTime);
    fprintf(fid,'High-pass filter cut-off on deconvoluted wave (at -3 dB, in Hz): %.3g\n',hpf);
    fprintf(fid,'Low-pass filter cut-off on deconvoluted wave (at -3 dB, in Hz): %.3g\n',lpf);
    fprintf(fid,'Vector of model template time constants (in s): [%.3g,%.3g]\n',TC*1e3);
    fprintf(fid,'Standard deviation of the noise of the deconvoluted wave (a.u.): %.3g\n',noiseSD);
    fprintf(fid,'Scale factor of noise standard deviations for threshold setting: %.3g\n',SF);
    fprintf(fid,'Theoretical false positive detection rate before applying event criterion (in Hz): %.3g\n',(1-normcdf(SF))*sample_rate);
    fprintf(fid,'Sign of the event peaks: %s\n',s);
    fprintf(fid,'Criterion used for event screening: %s\n',criterion);
    fprintf(fid,'Maximum time after peak (expressed in time constants) used for template fit: %.3g\n',taus);
    fprintf(fid,'Dead time from event start required for template fit (ms): %.3g\n',time2peak*1e3);
    fprintf(fid,'Minimum acceptable correlation coefficient for the template fit: %.3g\n',rmin);
    fprintf(fid,'Sample rate of the recording (in kHz): %d\n',sample_rate*1e-03);
    fprintf(fid,'lsqfit exitflag for fitting the noise peak: %d\n',exitflag);
    fprintf(fid,'Exclusion zones:\n');
    for i=1:size(excl,1)
      fprintf(fid,'%.6f\t%.6f\n',[excl(i,1) excl(i,2)]);
    end
    fclose(fid);

    % Save episodic data waves to file
    if exist('eventer.output','dir')==0
      mkdir('eventer.output');
    end
    cd eventer.output
    if exist(filewave,'dir')==0
      mkdir(filewave);
    end
    chdir(filewave);

    % Save detection parameters and event amplitudes and times to text file
    dlmwrite('_parameters',[TC';noiseSD;AnalysedTime;sample_rate;npeaks],'newline','pc')
    dlmwrite('_offset',win(1),'newline','pc');
    if exist('summary.txt','file')~=0
      delete('summary.txt');
    end
    movefile(['../../' filewave],'summary.txt');
    cd ../..

    if merge == 1
      merge_data(average,s,win,export,optimoptions,cwd,figform,config,taus);
    end

    return

  end

  % Calculate axes autoscaling for figure 3
  y_autoscale = 0.1*max(range(y_events));
  y_maxlim = max(max(y_events))+y_autoscale;
  y_minlim = min(min(y_events))-y_autoscale;
  % Figure 3: Identified events (black) aligned and overlayed with the mean event (red)
  h3 = figure(3);set(h3,'visible',showfig);set(h3,'OuterPosition',[fw*2 sh-fh fw fh]);
  addToolbarExplorationButtons(gcf);
  ylimits = [y_minlim,y_maxlim]; % Encoded y-axis autoscaling
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t_events,y_events,'color',[0.85,0.85,0.85]);
    catch
      plot(t_events,y_events,'color',[0.85,0.85,0.85]);
    end
  else
    plot(t_events,y_events,'color',[0.85,0.85,0.85]);
  end
  ax = gca;
  ax.Toolbar.Visible = 'off';
  hold on;
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t_events,mean(y_events,2),'-b');
    catch
      plot(t_events,mean(y_events,2),'-b');
    end
  else
    plot(t_events,mean(y_events,2),'-b');
  end
  hold off;
  xlim(win);
  ylim([ylimits(1),ylimits(2)]);
  title('Events');
  xlabel('Time (s)');
  if strcmp(yunit,'A')
    ylabel('Current (A)');
  elseif strcmp(yunit,'V')
    ylabel('Voltage (V)');
  else
    ylabel('Amplitude');
  end
  box('off'); grid('off');

  % Figure 4: Overlay of model template (green) and mean event (red)
  h4 = figure(4);set(h4,'visible',showfig);set(h4,'OuterPosition',[0 0 fw fh]);
  addToolbarExplorationButtons(gcf);
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t_fit,y_avg,'-g','linewidth',3);
    catch
      plot(t_fit,y_avg,'-g','linewidth',3);
    end
  else
    plot(t_fit,y_avg,'-g','linewidth',3);
  end
  ax = gca;
  ax.Toolbar.Visible = 'off';
  hold on;
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t_fit,mean(y_template,2),'-r','linewidth',2);
    catch
      plot(t_fit,mean(y_template,2),'-r','linewidth',2);
    end
  else
    plot(t_fit,mean(y_template,2),'-r','linewidth',2);
  end
  hold off;
  xlim([t_fit(1) t_fit(end)]);
  ylim([min(y_avg)-range(y_avg)*0.1 max(y_avg)+range(y_avg)*0.1]);
  xlabel('Time (s)');
  if strcmp(yunit,'A')
    ylabel('Current (A)');
  elseif strcmp(yunit,'V')
    ylabel('Voltage (V)');
  else
    ylabel('Amplitude');
  end
  grid('off'); box('off');
  title('Template and Mean Event Overlay')

  % Calculate axes autoscaling for figure 5
  y_autoscale = 0.1*range(Trace);
  y_maxlim = max(Trace)+y_autoscale;
  y_minlim = min(Trace)-y_autoscale;
  % Figure 5: Event wave overlaid with template fits
  h5 = figure(5);set(h5,'visible',showfig);set(h5,'OuterPosition',[fw 0 fw fh]);
  addToolbarExplorationButtons(gcf);
  ylimits = [y_minlim y_maxlim]; % Encoded y-axis autoscaling
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t,Trace,'-','color',[0.85,0.85,0.85],'linewidth',1.25);
    catch
      plot(t,Trace,'-','color',[0.85,0.85,0.85]);
    end
  else
    plot(t,Trace,'-','color',[0.85,0.85,0.85]);
  end
  ax = gca;
  ax.Toolbar.Visible = 'off';
  hold on;
  if ~isempty(regexpi(vector,figform))
    try
      reduce_plot(t,FITtrace,'-r');
    catch
      plot(t,FITtrace,'-r');
    end
  else
    plot(t,FITtrace,'-r');
  end
  hold off;
  xlim([min(t),max(t)]);
  ylim([ylimits(1), ylimits(2)]);
  grid('off'); box('off');
  title('Wave and events (after applying event criterion)');
  xlabel('Time (s)');
  if strcmp(yunit,'A')
    ylabel('Current (A)');
  elseif strcmp(yunit,'V')
    ylabel('Voltage (V)');
  else
    ylabel('Amplitude');
  end

  % Calculate statistics
  ET = Event_time;
  IEI = [NaN; diff(ET)];
  if exmode==1
    % Do nothing
  elseif exmode==2
    % Convert interevent intervals corresponding to events spanning exclusion zones to NaN
    if ~isempty(excl)
      for i=1:size(excl,1)
        temp = find(ET>=excl(i,2));
        if ~isempty(temp)
          IEI(temp(1)) = NaN;
        end
      end
    end
  else
    error('exclusion method not recognised')
  end
  Amplitude = mean(SCALE);

  % Print basic information
  %fprintf(['--------------------------EVENTER---------------------------\n',...
  %         ' Automatic PSC/PSP detection using FFT-based deconvolution\n',...
  %         ' and event peak analysis by least-squares template fitting\n',...
  %         ' Version v1.0 Copyright 2014 Andrew Charles Penn                \n\n']);
  fid = fopen(filewave,'w+t');
  fprintf(fid,'Filename: %s\n',filename);
  fprintf(fid,'Channel: %d\n',channel);
  fprintf(fid,'Wave number: %d\n',wave-1);
  fprintf(fid,'Wave name: %s\n',names{wave});
  fprintf(fid,'Total number of events detected: %d\n',n);
  fprintf(fid,'Duration of recording analysed (in s): %.1f\n',AnalysedTime);
  if strcmp(yunit,'A')
    fprintf(fid,'Mean event amplitude (pA): %.3g\n',Amplitude*1e+12);
  elseif strcmp(yunit,'A')
    fprintf(fid,'Mean event amplitude (mV): %.3g\n',Amplitude*1e+3);
  else
    fprintf(fid,'Mean event amplitude: %.3g\n',Amplitude);
  end
  fprintf(fid,'Event frequency (in Hz): %.3g\n',n/AnalysedTime);
  fprintf(fid,'High-pass filter cut-off on deconvoluted wave (at -3 dB, in Hz): %.3g\n',hpf);
  fprintf(fid,'Low-pass filter cut-off on deconvoluted wave (at -3 dB, in Hz): %.3g\n',lpf);
  fprintf(fid,'Vector of model template time constants (in ms): [%.3g,%.3g]\n',TC*1e3);
  fprintf(fid,'Standard deviation of the noise of the deconvoluted wave (a.u.): %.3g\n',noiseSD);
  fprintf(fid,'Scale factor of noise standard deviations for threshold setting: %.3g\n',SF);
  fprintf(fid,'Theoretical false positive detection rate before applying event criterion (in Hz): %.3g\n',(1-normcdf(SF))*sample_rate);
  fprintf(fid,'Sign of the event peaks: %s\n',s);
  fprintf(fid,'Criterion used for event screening: %s\n',criterion);
  fprintf(fid,'Maximum time after peak (expressed in time constants) used for template fit: %.3g\n',taus);
  fprintf(fid,'Dead time from event start required for template fit (ms): %.3g\n',time2peak*1e3);
  fprintf(fid,'Minimum acceptable correlation coefficient for the template fit: %.3g\n',rmin);
  fprintf(fid,'Episodic data window limits centred around each event: [%.3g,%.3g]\n',win);
  fprintf(fid,'Sample rate of the recording (in kHz): %d\n',sample_rate*1e-03);
  fprintf(fid,'lsqfit exitflag for fitting the noise peak: %d\n',exitflag);
  fprintf(fid,'Exclusion zones:\n');
  for i=1:size(excl,1)
      fprintf(fid,'%.6f\t%.6f\n',[excl(i,1) excl(i,2)]);
  end
  fclose(fid);

  % Save episodic data waves to file
  event_data = cat(2,sample_rate^-1*[0:size(y_events,1)-1]',y_events);
  ensemble_mean = [sample_rate^-1*[0:size(y_events,1)-1]',mean(y_events,2)];
  if exist('eventer.output','dir')==0
    mkdir('eventer.output');
  end
  cd eventer.output
  if exist(filewave,'dir')==0
    mkdir(filewave);
  end
  chdir(filewave);
  ephysIO ('event_data.phy',event_data,xunit,yunit);
  ephysIO ('ensemble_mean.phy',ensemble_mean,xunit,yunit);
  if ~strcmpi(export,'none')
    ephysIO (sprintf('event_data.%s',export),event_data,xunit,yunit);
    ephysIO (sprintf('ensemble_mean.%s',export),ensemble_mean,xunit,yunit);
  end

  % Save detection parameters and event amplitudes and times to text file
  dlmwrite('_parameters',[TC';noiseSD;AnalysedTime;sample_rate;npeaks],'newline','pc')
  dlmwrite('_offset',win(1),'newline','pc');
  if exist('summary.txt','file')~=0
    delete('summary.txt');
  end
  movefile(['../../' filewave],'summary.txt');
  if exist('txt','dir')==0
    mkdir('txt');
  end
  chdir('txt');
  dlmwrite('times.txt',Event_time,'delimiter','\t','newline','pc');
  peak = SCALE';
  dlmwrite('peak.txt',SCALE','delimiter','\t','newline','pc');
  dlmwrite('IEI.txt',IEI,'delimiter','\t','newline','pc');
  dlmwrite('features.txt',features,'delimiter','\t','newline','pc');
  cd ..

  % Save figures and images
  if exist('img','dir')==0
    mkdir('img');
  end
  chdir('img');
  len = numel(figform);
  if strcmpi(figform,'fig')
    set(h1, 'CreateFcn', 'set(gcbo,''Visible'',''on'')');
    set(h2, 'CreateFcn', 'set(gcbo,''Visible'',''on'')');
    set(h3, 'CreateFcn', 'set(gcbo,''Visible'',''on'')');
    set(h4, 'CreateFcn', 'set(gcbo,''Visible'',''on'')');
    set(h5, 'CreateFcn', 'set(gcbo,''Visible'',''on'')');
    savefig(h1,'output_histogram.fig','compact');
    savefig(h2,'output_decon.fig','compact');
    savefig(h3,'output_avg.fig','compact');
    savefig(h4,'output_template.fig','compact');
    savefig(h5,'output_wave.fig','compact');
  elseif ~isempty(regexpi(bitmap,figform))
    print(h1,sprintf('output_histogram.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-r300','-opengl');
    print(h2,sprintf('output_decon.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-r300','-opengl');
    print(h3,sprintf('output_avg.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-r300','-opengl');
    print(h4,sprintf('output_template.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-r300','-opengl');
    print(h5,sprintf('output_wave.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-r300','-opengl');
    if strcmpi(figform,'jpeg')
      movefile('output_histogram.jpe','output_histogram.jpg');
      movefile('output_decon.jpe','output_decon.jpg');
      movefile('output_avg.jpe','output_avg.jpg');
      movefile('output_template.jpe','output_template.jpg');
      movefile('output_wave.jpe','output_wave.jpg');
    end
  elseif ~isempty(regexpi(vector,figform))
    print(h1,sprintf('output_histogram.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-painters');
    print(h2,sprintf('output_decon.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-painters');
    print(h3,sprintf('output_avg.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-painters');
    print(h4,sprintf('output_template.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-painters');
    print(h5,sprintf('output_wave.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-painters');
    if strcmpi(figform(1:2),'ps')
      movefile('output_histogram.ps*','output_histogram.ps');
      movefile('output_decon.ps*','output_decon.ps');
      movefile('output_avg.ps*','output_avg.ps');
      movefile('output_template.ps*','output_template.ps');
      movefile('output_wave.ps*','output_wave.ps');
    elseif strcmpi(figform,'meta')
      movefile('output_histogram.met','output_histogram.emf');
      movefile('output_decon.met','output_decon.emf');
      movefile('output_avg.met','output_avg.emf');
      movefile('output_template.met','output_template.emf');
      movefile('output_wave.met','output_wave.emf');
    end
  end
  cd ../../..

  if merge == 1
    merge_data(average,s,win,export,optimoptions,cwd,figform,config,taus);
  end

end

%----------------------------------------------------------------------

function [tpeak, t50, tdecay, auc, skew] = shape (t, y, offset, Fs, s, base)

  % Calculate quick and dirty estimate of full-width half-maximum (t50)
  % and time-to-peak (tpeak) for the event

  % Calculate data size
  n = numel(y);

  % Subtract baseline
  y = y-offset;
  if s=='-'
    y = y * -1;
  end

  % Approximate FWHM by calculating the duration spent at > half-maximal amplitude
  y50 = 0.5 * max(y);
  t50 = sum(y>y50)/Fs;

  % Approximate time-to-peak by finding the point of maximum deviation from the baseline
  ypeak = max(y);
  ipeak = find(y==ypeak);
  tpeak = (sum(t<mean(t(ipeak)))/Fs) - base;

  % Approximate decay half-life by calculating the duration of the event post-peak spent at > half-maximal amplitude
  tdecay = sum((y>y50) & (t>mean(t(ipeak))))/Fs;

  % Calculate the area-under-curve
  auc = trapz(t,y);

  % Calculate event distribution skew (with respect to the baseline i.e. 0)
  skew = (n^-1)*sum(y.^3) / (sqrt((n^-1)*sum(y.^2)))^3;

end

%----------------------------------------------------------------------

function merge_data(average,s,win,export,optimoptions,cwd,figform,config,taus)

  % Merge the event data for all the waves analysed in this experiment

  % Merge all data from eventer.output folder
  count = 0;
  cd eventer.output
  numtraces=0;
  dirlist = dir('.');
  dirlist = char(dirlist.name);
  numdir = size(dirlist,1);
  dirarray = mat2cell(dirlist,ones(numdir,1),size(dirlist,2));
  t = [];
  root = pwd;
  for i=1:numdir
    dirname{i} = strtrim(dirarray(i));
    if ~strcmp(dirname{i},'ALL_events') &&... %isdir(char(dirname{i})) && was removed
    ~strcmp(dirname{i},'.') &&...
    ~strcmp(dirname{i},'..')
      count = count+1;
	  if i==3
	    chdir(char(dirname{i}));
	  elseif i>3
        %chdir(['../',dirname{i}]);
	    location = strcat(root,filesep,dirname{i});
	    chdir(char(location));
	  end
      if exist('event_data.phy','file')
        [temp,xdiff,xunit,yunit] = ephysIO('event_data.phy');
        temp(:,1) = temp(:,1)+win(1);
        temp(abs(temp(:,1))<eps,1)=0;
        if isempty(t)
          t = temp(:,1);
        elseif count>1
          if numel(t)==numel(temp(:,1))
             if all(t==temp(:,1))~=1
               error('Inconsistent window dimensions. Cannot merge data.');
             end
          else
            error('Inconsistent window dimensions. Cannot merge data.');
          end
        end
        temp(:,1) = [];
        data{count} = temp;
        numtraces(count,1) = size(data{count},2);
      else
        numtraces(count,1) = 0;
      end
      parameters(:,count) = load('-ascii','_parameters');
      TC(count,:) = parameters(1:2,count)';
      sigma(count,1) = parameters(3,count);
      AnalysedTime(count,1) = parameters(4,count);
      sample_rate(count,1) = parameters(5,count);
      if sample_rate(count)~=sample_rate(1)
        error('Inconsistent sample rate. Cannot merge data.')
      end
      if exist('txt','dir')
        cd txt
        IEI{i,1} = load('-ascii','IEI.txt');
        peak{i,1} = load('-ascii','peak.txt');
        if exist('features.txt','file')
          features{i,1} = load('-ascii','features.txt');
        end
      end
    else
      % The name in the directory list is not a folder suitable for the
      % merge process so do nothing
    end
	%chdir(root);
  end
  chdir(root);
  % Overide data units with configurationn argument
  if strcmpi(config,'CC')
    yunit = 'V';
  elseif strcmp(config,'VC')
    yunit = 'A';
  elseif strcmp(config,'')
    yunit = '';
  end
  numEvents = sum(numtraces);
  if exist('ALL_events','dir')==0
    mkdir('ALL_events');
  end
  cd('ALL_events')
  if numEvents > 0
    tau_rise = sum(TC(:,1).*numtraces/sum(numtraces));
    tau_decay = sum(TC(:,2).*numtraces/sum(numtraces));
    y = cell2mat(data);
    IEI = cell2mat(IEI);
    peak = cell2mat(peak);
    if exist('features','var')
      features = cell2mat(features);
    end
    %nanidx = isnan(IEI);
    %peak(nanidx) = [];
    %IEI(nanidx) = [];
    %y(:,nanidx) = [];
    freq = 1/median(IEI);
    numEvents = numel(peak);
    events = [sample_rate(1)^-1*[0:size(y,1)-1]',y];
    if strcmp(average,'mean')
      y_avg = mean(y,2);
    elseif strcmp(average,'median')
      y_avg = median(y,2);
    end
    ensemble_average = [sample_rate(1)^-1*[0:size(y_avg,1)-1]',y_avg];

    % Fit a sum of exponentials function to the ensemble average event
    p0 = [1,tau_rise,tau_decay];
    tpeak0 = p0(3)*p0(2)/(p0(3)-p0(2))*log(p0(3)/p0(2));
    tlim = p0(3)*taus;
    idx = t>=0 & t<=tpeak0+tlim;
    tdata = t(idx);
    fun2 = @(p,tdata)-exp(-tdata/p(1))+exp(-tdata/p(2));
    ypeak0 = fun2([p0(2),p0(3)],tpeak0);
    if s=='-'
      NF = ypeak0/min(y_avg(idx));  % Normalization factor
      ydata = y_avg(idx)*NF;
    elseif s=='+'
      NF = ypeak0/max(y_avg(idx));  % Normalization factor
      ydata = y_avg(idx)*NF;
    end
    fun3 = @(p,tdata)p(1)*(-exp(-tdata/p(2))+exp(-tdata/p(3)));
	try
      [p,resnorm,residual,exitflag] = lsqfit(fun3,p0,tdata,ydata,[],[],optimoptions);
      tpeak = p(3)*p(2)/(p(3)-p(2))*log(p(3)/p(2));
      fitAmplitude = abs((fun3(p,tpeak))/NF);
      fitIntegral = abs(p(1)*(p(3)-p(2))/NF);
      fit = fun3(p,tdata)/NF;
      residuals = y_avg(idx)-fit;
	  errflag = 0;
	catch
	  % do nothing
	  errflag = 1;
	end

    % Get screen size and set figure sizes
    set(0,'units','pixels');
    scn_sz = get(0,'screensize');
    sw = scn_sz(3);
    sh = scn_sz(4);
    fw = sw/3;
    fh = sh/2;

    % Figures
    vector = 'pdf eps epsc eps2 epsc2 meta svg ps psc ps2 psc2';
    bitmap = 'jpeg png tiff tiffn bmpmono bmp bmp16m bmp256 hdf pbm pbmraw pcxmono pcx24b pcx256 pcx16 pgm pgmraw ppm ppmraw';

    % Calculate axes autoscaling for figure 6
    y_autoscale = 0.1*max(range(y));
    y_maxlim = max(max(y))+y_autoscale;
    y_minlim = min(min(y))-y_autoscale;
    % Figure 6: Identified events aligned and overlayed with the ensemble average event
    h6 = figure(6);set(h6,'OuterPosition',[fw*2 0 fw fh]);
    addToolbarExplorationButtons(gcf);
    ylimits = [y_minlim y_maxlim]; % Encoded y-axis autoscaling
    if ~isempty(regexpi(vector,figform))
      try
        reduce_plot(t,y,'color',[0.85,0.85,0.85]);
      catch
        plot(t,y,'color',[0.85,0.85,0.85]);
      end
    else
      plot(t,y,'color',[0.85,0.85,0.85]);
    end
    ax = gca;
    ax.Toolbar.Visible = 'off';
    hold on;
    if ~isempty(regexpi(vector,figform))
      try
        reduce_plot(t,y_avg,'-b');
		if errflag < 1
          reduce_plot(tdata,fit,'r-','linewidth',2);
		end
      catch
        plot(t,y_avg,'-b');
		if errflag < 1
          plot(tdata,fit,'r-','linewidth',2);
		end
      end
    else
      plot(t,y_avg,'-b');
	  if errflag < 1
        plot(tdata,fit,'r-','linewidth',2);
	  end
    end
    xlim(win);
    ylim([ylimits(1), ylimits(2)]);
    if strcmp(average,'mean')
      title('Ensemble mean (blue) and fit (red)');
    elseif strcmp(average,'median')
      title('Ensemble median (blue) and fit (red)');
    end
    xlabel('Time (s)');
    if strcmp(yunit,'A')
      ylabel('Current (A)');
    elseif strcmp(yunit,'V')
      ylabel('Voltage (V)');
    else
      ylabel('Amplitude');
    end
    box('off'); grid('off');
    hold off;
	if errflag > 0
	  error('Fit to ensemble average event failed');
	end

    % Save data
    save('ensemble_average.txt','ensemble_average','-ascii','-tabs');
    save('fit.txt','fit','-ascii','-tabs');
    save('residuals.txt','residuals','-ascii','-tabs');
    fid = fopen('event_counts.txt','w');
    fprintf(fid,'%d\n',numtraces);
    fclose(fid);
    ephysIO ('event_data.phy',events,xunit,yunit);
    ephysIO ('ensemble_average.phy',ensemble_average,xunit,yunit);
    if ~strcmpi(export,'none')
      ephysIO (sprintf('event_data.%s',export),events,xunit,yunit);
      ephysIO (sprintf('ensemble_average.%s',export),ensemble_average,xunit,yunit);
    end
    dlmwrite('_parameters',[tau_rise;tau_decay;sigma;AnalysedTime],'newline','pc');
    dlmwrite('_offset',win(1),'newline','pc');
    if exist('img','dir')==0
      mkdir('img');
    end
    cd('img')
    len = numel(figform);
    if strcmpi(figform,'fig')
      set(h6, 'CreateFcn', 'set(gcbo,''Visible'',''on'')');
      savefig(h6,'output_avg.fig','compact')
    elseif ~isempty(regexpi(bitmap,figform))
      print(h6,sprintf('output_avg.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-r300','-opengl');
      if strcmpi(figform,'jpeg')
        movefile('output_avg.jpe','output_avg.jpg');
      end
    elseif ~isempty(regexpi(vector,figform))
      print(h6,sprintf('output_avg.%s',figform(1:min(3,len))),sprintf('-d%s',figform),'-painters');
      if strcmpi(figform(1:2),'ps')
        movefile('output_avg.ps*','output_avg.ps');
      end
      if strcmpi(figform,'meta')
        movefile('output_avg.met','output_avg.emf');
      end
    end
    cd ..
    if exist('txt','dir')==0
      mkdir('txt');
    end
    cd('txt')
    dlmwrite('IEI.txt',IEI,'delimiter','\t','newline','pc');
    dlmwrite('peak.txt',peak,'delimiter','\t','newline','pc');
    if exist('features','var')
      dlmwrite('features.txt',features,'delimiter','\t','newline','pc');
    end
    cd ..
  end
  sigma = sum(sigma.*AnalysedTime/sum(AnalysedTime));
  AnalysedTime = sum(AnalysedTime);

  % Print basic information
  fid=fopen('ALL_events','w+t');
  fprintf(fid,'Number of waves analysed: %d\n',count);
  fprintf(fid,'Total recording time analysed (in s): %.1f\n',AnalysedTime);
  fprintf(fid,'Total number of events: %d\n',numEvents);
  fprintf(fid,'Event frequency (in Hz): %.3g\n',numEvents/AnalysedTime);
  if numEvents > 0
    fprintf(fid,'Ensemble average: %s\n',average);
    if strcmp(yunit,'A')
      fprintf(fid,'Amplitude of the model PSC fit (pA): %.3g\n',fitAmplitude*1e+12);
      fprintf(fid,'Integral (charge) of the model PSC fit (fC): %.4g\n',fitIntegral*1e+15);
      fprintf(fid,'Rise time constant of the model PSC fit (ms): %.3g\n',p(2)*1e+03);
      fprintf(fid,'Decay time constant of the model PSC fit (ms): %.3g\n',p(3)*1e+03);
    elseif strcmp(yunit,'V')
      fprintf(fid,'Amplitude of the model PSP fit (mV): %.3g\n',fitAmplitude*1e+03);
      fprintf(fid,'Integral of the model PSP fit (mV.ms): %.4g\n',fitIntegral*1e+06);
      fprintf(fid,'Rise time constant of the model PSP fit (ms): %.3g\n',p(2)*1e+03);
      fprintf(fid,'Decay time constant of the model PSP fit (ms): %.3g\n',p(3)*1e+03);
    else
      fprintf(fid,'Amplitude of the model event fit: %.3g\n',fitAmplitude);
      fprintf(fid,'Integral of the model event fit: %.4g\n',fitIntegral);
      fprintf(fid,'Rise time constant of the model event fit (ms): %.3g\n',p(2)*1e+03);
      fprintf(fid,'Decay time constant of the model event fit (ms): %.3g\n',p(3)*1e+03);
    end
      fprintf(fid,'lsqfit exitflag for fitting the ensemble average event: %d\n',exitflag);
  else
    fprintf(fid,'Note: Not enough events for analysis\n');
  end
  fprintf(fid,'Standard deviation of the noise of the deconvoluted waves (a.u.): %.3g\n',sigma);
  fclose(fid);
  movefile(['./ALL_events'],'summary.txt');
  cd ../..
  chdir(cwd);

end
