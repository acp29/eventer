%  Function File: simEPSCs
% ---------------------------------------------------------------------
% Simulation for data 
% 
% 25 Hz
%
% 0. Create a vector of 0s called the time series vector
% 1. start for loop (for i=1:100)
% 2. model template using sum of two exponentials - random rise and decay time constants
% 3. create event marker vector of zeros - 1 event at a random time
% 4. multiply event marker vector with a random number (normal or log-normal distribution)
% 5. convolve model template with event marker vector and add the resulting vector the time series vector
% 6. add noise (Gaussian) to the time series data
% ---------------------------------------------------------------------
% This function is for generating events that have had noise added to it to
% simulate realistic traces. Then it is possible to analyze these traces to
% see what is the best compromise between settings such that the false
% positive and false negative rate are the same

% example
% Example Settings:
%Time=300                 % time of simulation in s
%n=300;                   % number of events
%A=20;                    % average amplitude of event in pA
%cv=0;                    % coefficient of variation, 0 is no variation in peak of time course
%rise=0.4;                % template rise in ms                                                
%decay=4;                 % template decay in ms
%sdnoise=2.5;             % standard deviation of noise in pA
%latency=20;              % event latency in ms; no events closer than this
%filename='Noise Final';  % Name of your results folder
 
%filename = 'wave1';
%simPSCs(300,300,20,0,0.4,4,2.5,2,filename); % 5 minute simulation, 300 events
%S=ephysIO(sprintf('./%s/Events.phy',filename));
%plot(S.array(:,1),S.array(:,2))
 
function simPSCs(Time,n,A,cv,rise,decay,sdnoise,latency,filename)

  % Example Settings:
  	%n=200;                   % number of events
    %A=10;                    % average amplitude of event in pA
 	%cv=0.15;                 % coefficient of variation 
 	%rise=0.4;                % template rise in ms                                                
 	%decay=4;                 % template decay in ms
 	%sdnoise=2.5;             % standard deviation of noise in pA
    %latency=20;              % event latency (in ms); no events closer than this
 	%filename='Noise Final';  % Name of your results folder
  % Example Command:
    %simPSCs(10,200,10,0.15,0.4,4,2.5,'Results1')
    
  a=A*1e-12;
  tau_rise=rise*1e-3;	
  tau_decay=decay*1e-3;														
  sample_rate=25000;														
  N=25000*Time;																
  Events=zeros(N,1); 														
  Trace=zeros(N,1); 												
  T = (0:N-1)'*1/sample_rate; 										
  latency = fix(sample_rate*1e-3*latency);
  
  % Generating the timings and amplitudes of events
  Events=zeros(N,1); 
  for i=1:n															
    W=a*random('logn',0,cv);	% Log-normal distributed random values with mean 1, std = cv
    flag = 0;
    j=0;
    while flag == 0
      while (j<latency) || (j>(N-latency))
        j=randi(N);
      end
      if sum(Events(j-latency:j+latency)) == 0
        flag = 1;
      end
    end
    Events(j)=W;															
  end
  
  % Generating the template events by deconvolution
  tau_r=random('logn',log(tau_rise),cv);	 
  tau_d=0;																
  while tau_d <= tau_r												
    tau_d=random('logn',log(tau_decay),cv);									
  end
  Template = -exp(-T/tau_r)+exp(-T/tau_d); 								
  TemplatePeak = max(Template); 										
  Template = Template/TemplatePeak; 								
  Template = Template*-1;																				
  Template_FFT = fft(Template); 										
  Events_FFT = fft(Events); 											
  Trace = real(ifft(Events_FFT.*Template_FFT)); 							
  n = sum(Events);
  
  % Add random gaussian noise to the recordings 
  Trace = Trace + randn(N,1) * sdnoise * 1e-12;
 
  %Creating the folder to save stuff
  if exist(filename)==7
   rmdir(filename, 's')
  end
  mkdir(filename);
  cd (filename);
  
  Xn=               'Number of Events:....................';
  Xcv=              'Coefficient of Variation:............';
  XA=               'Average Amplitude of Event(in pA):...';
  Xtau_riseV=       'Rise Constant(in ms):................';
  Xtau_decayV=      'Decay Constant(in ms):...............';
  Xsdnoise=         'Standard Deviation of Noise(in pA):..';
  %Saved Variables
  fid=(fopen('Variables.txt','wt'));
  fprintf(fid, '%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n', Xn, n, XA, a, Xcv, cv, Xtau_riseV, rise, Xtau_decayV, decay, Xsdnoise, sdnoise);
  fclose(fid);
  
  
  %Save Events
  ephysIO ('Events.phy',[T,Trace],'s','A',{},{},'int32');
  %Save EventMarkers(event times with amplitude)
  ephysIO ('EventMarkers.phy',[T,Events],'s','A',{},{},'int32');
  %Save Event Times
  EventTimes=find(Events~=0);
  fid=(fopen('Event Times.txt','wt'));
  fprintf(fid, '%.2f\n', EventTimes);
  fclose(fid);

  %Go back to old directory
  mydir=pwd;
  idcs   = strfind(mydir,filesep);
  newdir = mydir(1:idcs(end)-1); 
  cd (newdir);
  