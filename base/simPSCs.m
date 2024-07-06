%  Function File: simEPSCs
% ---------------------------------------------------------------------
% Simulation for data 
% 
% 25 Hz sampling rate
%
% ---------------------------------------------------------------------
% This function is for generating events that have had noise added to it to
% simulate realistic traces. Then it is possible to analyze these traces to
% see what is the best compromise between settings such that the false
% positive and false negative rate are the same

% example
% Example Settings:
%Time=300                 % time of simulation in s
%n=300;                   % number of events
%A=10;                    % average amplitude of event in pA
%cv=0;                    % coefficient of variation, 0 means no variation in amplitude or kinetics
%rise=0.4;                % template rise in ms                                                
%decay=4;                 % template decay in ms
%sdnoise=2.5;             % standard deviation of noise in pA
%latency=20;              % event latency in ms; no events closer than this
%filename='Noise Final';  % Name of your results folder
 
%filename = 'wave1';
%simPSCs(60,30,10,0.5,0.4,4,2.5,2,'wave1','pink'); % 1 minute, 30 events, pink noise
%S=ephysIO(sprintf('./%s/Events.phy',filename));
%plot(S.array(:,1),S.array(:,2))
 
function simPSCs(Time,n,A,cv,rise,decay,sdnoise,latency,filename,colour)

  % Example Settings:
  % n=200;                   % number of events
  % A=10;                    % average amplitude of event in pA
  % cv=0.15;                 % coefficient of variation 
  % rise=0.4;                % template rise in ms                                                
  % decay=4;                 % template decay in ms
  % sdnoise=2.5;             % standard deviation of noise in pA
  % latency=20;              % event latency (in ms); no events closer than this
  % filename='wave1';        % Name of your results folder
  % colour='pink';           % Colour of the noise: options are 'white' or 'pink'    

  
  if (nargin < 10)
    colour = 'pink';
  end
  a=A*1e-12;
  tau_rise=rise*1e-3;	
  tau_decay=decay*1e-3;														
  sample_rate=25000;														
  N=sample_rate*Time;																
  Event=zeros(N,1);
  EventMarkers=Event;
  Trace=zeros(N,1); 												
  T = (0:N-1)'*1/sample_rate; 										
  latency = fix(sample_rate*1e-3*latency);
  sd = sqrt(log((cv^2)+1));
  h = waitbar(0,'Please wait...');
  for i=1:n	

    % Generating the timings and amplitudes of events
    Event=zeros(N,1); 
    W=random('logn',log(a)-sd^2/2,sd);	% Log-normal distributed random values with mean = a and std = a * cv
    flag = 0;
    j=0;
    while flag == 0
      while (j<latency) || (j>(N-latency))
        j=randi(N);
      end
      if sum(Event(j-latency:j+latency)) == 0
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
    Template = Template*-1;		

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
      B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
      A = [1 -2.494956002   2.017265875  -0.522189400];
      nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
      v = randn(1,N+nT60); % Gaussian white noise: N(0,1)
      noise = filter(B,A,v);    % Apply 1/F roll-off to PSD
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
  
  Xn=               'Number of Events:.....................';
  Xcv=              'Coefficient of Variation:.............';
  XA=               'Average Amplitude of Event (in pA):...';
  Xtau_rise=        'Rise Constant (in ms):................';
  Xtau_decay=       'Decay Constant (in ms):...............';
  Xsdnoise=         'Standard Deviation of Noise (in pA):..';
  Xlatency=         'Latency (in ms):......................';
  %Saved Variables
  fid=(fopen('Variables.txt','wt'));
  fprintf(fid, '%s %d\n%s %05.2f\n%s %05.2f\n%s %05.2f\n%s %05.2f\n%s %05.2f\n%s %05.2f\n', Xn, n, XA, A, Xcv, cv, Xtau_rise, rise, Xtau_decay, decay, Xsdnoise, sdnoise);
  fclose(fid);
  
  
  %Save Events
  ephysIO ('Simulation.phy',[T,Trace],'s','A',{},{},'int32');
  %Save EventMarkers(event times with amplitude)
  ephysIO ('EventMarkers.phy',[T,EventMarkers],'s','A',{},{},'int32');
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
  