% cfsWrite.m 
% an example of writing a cfs file
% using INT2 format
% must have cfs32.dll in system directory
% calls matcfs32.dll
% note: must choose yScale with care
%       (not very obvious in this example)
%       unless data is already in required format

% 21.02.09: version 1 JGC
% 24.02.09: capitalise MATCFS32 for Matlab 7
% 09.03.09: option to set DSV store (DSVAindex=0 or 1)
% 11.08.09: make sample rate and no of samples user-detemined


INT2=2;
WRD2=3;
INT4=4;
RL4=5;
RL8=6;
LSTR=7;
EQUALSPACED=0;
FILEVAR=0;
DSVAR=1;
WRITE=1;
FLAG1=64;

DSVAindex=0;  % 0=lower, 1=upper DSV storage area.

if (exist('initcfsdir')==0)
    initcfsdir='C:\'; % set default
end
cfsdir=uigetdir(initcfsdir,'Choose a directory');
eval(['cd ' '''' cfsdir '''']); % otherwise won't work if space in dir name
[shortname, cfsdir]=uiputfile({'*.cfs','CFS files (*.cfs)'}, 'Choose a file to write');
if cfsdir ~=0
  initcfsdir=cfsdir;  
if ~isempty(shortname)
  fullfilename=[cfsdir shortname];
  if length(fullfilename) > 255
      disp('File+path length too long!');
      return
  end    
 else
  disp(['No valid file selected']);
  return
end
comment='File written using matcfs32';
chans=2; % 2 channels
fhandle=0; % dummy value is required here for FVs
% must set all of these prior to calling cfsCreateCFSFile (except FV0)
MATCFS32('cfsSetVarDesc',fhandle,1,FILEVAR,2,INT2,'units','A second FV'); % FV1
MATCFS32('cfsSetVarDesc',fhandle,2,FILEVAR,11,LSTR,'Name','Subject 1'); % FV2
% set DSV storage area
MATCFS32('cfsSetVarDesc',fhandle,0,DSVAR,4,RL4,'sec','Waveperiod',DSVAindex);
fhandle=MATCFS32('cfsCreateCFSFile',fullfilename,comment,512,chans,3,1,DSVAindex);
points=input('Number of samples per channel? ');
sampleRate=input('Sample rate? ');
if (fhandle >=0)
  % points=500;
  % sampleRate=1000;
  xScale=1/sampleRate;
  xOffset=-0.2; % simulate pretrigger  
  MATCFS32('cfsSetVarVal',fhandle,1,FILEVAR,0,101); % FV1
  MATCFS32('cfsSetVarVal',fhandle,2,FILEVAR,0,'Mr J Smith'); % FV2
  for i=1:chans
   chName=['Chan' int2str(i-1)];
   yUnits='Volts';
   xUnits='s';
   dataType=INT2;
   dataKind=EQUALSPACED;
   spacing=2*chans; % interleaved - bytes between samples of same channel
   other=0;
   MATCFS32('cfsSetFileChan',fhandle,i-1,chName,yUnits,xUnits,dataType,dataKind,spacing,other);
   startoffset=2*(i-1);  % inteleaved - bytes between points of adjacent channels
   yScale=5/32768;
   yOffset=0;
   MATCFS32('cfsSetDSChan',fhandle,i-1,0,startoffset,points,yScale,yOffset,xScale,xOffset);
  end % for i=1:chans
  % set the DS variable
    MATCFS32('cfsSetVarVal',fhandle,0,DSVAR,0,0.1,DSVAindex); % DSV0
  % and a flag
    flag=MATCFS32('cfsDSFlags',fhandle,0,WRITE,FLAG1);
  % create some data
   z=1:(points/5);
   z=(10*z/points)-1;
   z0=[z z z z z];
   ch1=32767*z0;
   ch2=abs(ch1);
   z1=1:2:2*points-1;
   z2=z1+1;
   data=[];
   data(1,z1)=ch1;
   data(1,z2)=ch2;
   [errNo]=MATCFS32('cfsWriteData',fhandle,0,0,INT2,data);
   if errNo ~=0
       disp(['An error has occurred when writing: ' int2str(errNo)]);
   end
   ret=MATCFS32('cfsCloseFile',fhandle);
   if ret ~=0
     disp(['An error has occurred when closing: ' int2str(ret)]);
   end    
else
  disp(['An error has occurred: ' int2str(fhandle)]);
  return
end
else
   disp('user cancelled');
end % if cfsdir ~=0   