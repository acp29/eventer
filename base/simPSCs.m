% Function File: simPSCs
% ---------------------------------------------------------------------
% Simulation for data 
% 
% 25 Hz sampling rate
%
% ---------------------------------------------------------------------
% This function is for generating events that have had noise added to it to
% simulate realistic traces. Then it is possible to analyze these traces to
% see what is the best compromise between settings such that the false
% positive and false negative rate are the same. The amplitudes and time
% constants of the simulated synaptic currents have a log-normal
% distribution, with the specified mean and coefficient of variation.
%
% Example usage:
% simPSCs ('wave1', 60, 30, -10, 0.4, 4, 0.5, 2.5, 2, 'pink')
%
% filename = 'wave1';      % Name of your folder containing simulated data
% Time = 60;               % Time of simulation in s
% n = 30;                  % The number of events simulated
% A = -10;                 % The mean amplitude of events in pA
% rise = 0.4;              % The mean event rise time constant in ms                                                
% decay = 4;               % The mean event decay time constant in ms
% cv = 0.5;                % Coefficient of variation, 0 means no variation in amplitude or kinetics
% sdnoise = 2.5;           % The standard deviation of the noise in pA
% proximity = 2;           % The minimum proximity of events in ms; no events closer than this
% colour = 'pink';         % colour of the additive noise (options are 'white' or 'pink')
%
% Note that there are no defaults! All parameters must be specified;
%
% Code by Samuel Liu and Andrew Penn, 2019, (last modified: 08 July 2024)
 
function simPSCs(varargin)    

  [filename,time,n,A,rise,decay,cv,sdnoise,proximity,colour] = varargin{:};
  s=sign(A);
  A=abs(A);
  a=A*1e-12;
  tau_rise=rise*1e-3;	
  tau_decay=decay*1e-3;														
  sample_rate=25000;														
  N=sample_rate*time;																
  Event=zeros(N,1);
  EventMarkers=Event;
  Trace=zeros(N,1); 												
  T = (0:N-1)'*1/sample_rate; 										
  proximity = fix(sample_rate*1e-3*proximity);
  sd = sqrt(log((cv^2)+1));
  h = waitbar(0,'Please wait...');
  for i=1:n	

    % Generating the timings and amplitudes of events
    Event=zeros(N,1); 
    W=random('logn',log(a)-sd^2/2,sd);	% Log-normal distributed random values with mean = a and std = a * cv
    flag = 0;
    j=0;
    while flag == 0
      while (j<proximity) || (j>(N-proximity))
        j=randi(N);
      end
      if sum(Event(j-proximity:j+proximity)) == 0
        flag = 1;
      end
    end
    Event(j)=1;			
    EventMarkers=EventMarkers+Event;
  
    % Generating the template events by deconvolution
    tau_r=random('logn',log(tau_rise)-sd^2/2,sd);
    tau_d=0;																
    while tau_d <= tau_r												
      tau_d=random('logn',log(tau_decay)-sd^2/2,sd);							
    end
    Template = -exp(-T/tau_r)+exp(-T/tau_d); 								
    TemplatePeak = max(Template); 										
    Template = Template/TemplatePeak;
    Template = Template * s;

    % Convolve the event marker with the template
    Template_FFT=fft(Template); 										
    Event_FFT=fft(Event);
    temp=real(ifft(Event_FFT.*Template_FFT));
    temp=temp*W;
    Trace=Trace+temp;

    % Update wait bar
    waitbar(i/n,h)
  
  end
  close(h);
  n = sum(EventMarkers);

  % Generate noise
  switch lower(colour)
    case 'white'
      noise = randn(N,1);
    case 'pink'
      % https://ccrma.stanford.edu/~jos/sasp/Example_Synthesis_1_F_Noise.html
      coeffB = [0.049922035 -0.095993537 0.050612699 -0.004408786];
      coeffA = [1 -2.494956002   2.017265875  -0.522189400];
      nT60 = round(log(1000)/(1-max(abs(roots(coeffA))))); % T60 est.
      v = randn(1,N+nT60); % Gaussian white noise: N(0,1)
      noise = filter(coeffB,coeffA,v);    % Apply 1/F roll-off to PSD
      noise = noise(nT60+1:end)';    % Skip transient response
      noise = noise / std(noise,1);  % Scale noise to have RMSD of 1;
  end

  % Add random gaussian noise to the recordings 
  Trace = Trace + noise * sdnoise * 1e-12;
 
  %Creating the folder to save stuff
  if exist(filename)==7
   rmdir(filename, 's')
  end
  mkdir(filename);
  cd (filename);
  
  outstr = cat(2,'Filename:............................. %s \n', ...
                 'Total Simulation Time (in s):......... %.2f \n', ...
                 'Number of Events:..................... %d \n', ...
                 'Mean Amplitude (in pA):............... %.2f \n', ...
                 'Mean Rise Time Constant (in ms):...... %.2f \n', ...
                 'Mean Decay Time Constant (in ms):..... %.2f \n', ...
                 'Coefficient of Variation:............. %.2f \n', ...
                 'Standard Deviation of Noise (in pA):.. %.2f \n', ...
                 'Minimum Proximity of Events (in ms):.. %.2f \n', ...
                 'Type of Noise:........................ %s \n');
  %Saved Variables
  fid=(fopen('Variables.txt','wt'));
  fprintf(fid, outstr, varargin{:});
  fclose(fid);

  
  %Save Events
  ephysIO ('Simulation.abf',[T,Trace],'s','A',{},{});
  %Save EventMarkers(event times with amplitude)
  ephysIO ('EventMarkers.abf',[T,EventMarkers],'s','A',{},{});
  %Save Event Times
  EventTimes=find(EventMarkers~=0)/sample_rate;
  fid=(fopen('Event Times.txt','wt'));
  fprintf(fid, '%.2f\n', EventTimes);
  fclose(fid);

  %Go back to old directory
  mydir=pwd;
  idcs   = strfind(mydir,filesep);
  newdir = mydir(1:idcs(end)-1); 
  cd (newdir);
  