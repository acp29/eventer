% cfsWriteRL.m 
% an example of writing a cfs file for data as RL4, RL8
% must have cfs32.dll in system directory
% calls matcfs32.dll
% note: this is by far the easiest way to write from Matlab
%       stays in native format, not problems with Y scaling (or offset)

%  20.02.09: JGC initial version
%  24.02.09: capitalise MATCFS32 for Matlab 7


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
FLAG2=32;
noFlags=0;
dSects=4;

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
chans=4; % 4 channels
fhandle=0; % dummy value is required here for FVs
% must set all of these prior to calling cfsCreateCFSFile (except FV0)
MATCFS32('cfsSetVarDesc',fhandle,1,FILEVAR,2,INT2,'units','A second FV'); % FV1
MATCFS32('cfsSetVarDesc',fhandle,2,FILEVAR,11,LSTR,'Name','Subject 1'); % FV2
MATCFS32('cfsSetVarDesc',fhandle,0,DSVAR,4,RL4,'sec','Waveperiod');
fhandle=MATCFS32('cfsCreateCFSFile',fullfilename,comment,512,chans,3,1);
points=input('Number of samples per channel? ');
sampleRate=input('Sample rate? ');
if (fhandle >=0)
  MATCFS32('cfsSetVarVal',fhandle,1,FILEVAR,0,105); % FV1
  MATCFS32('cfsSetVarVal',fhandle,2,FILEVAR,0,'Mr J Smith'); % FV2
  for i=1:chans
  chName=['Chan' int2str(i-1)];
  yUnits='Volts';
  xUnits='s';
  dataType=RL8;
  dataKind=EQUALSPACED;
  spacing=32; % 4 chan interleaved - bytes between samples of same channel
  other=0;
  MATCFS32('cfsSetFileChan',fhandle,i-1,chName,yUnits,xUnits,dataType,dataKind,spacing,other);
  startoffset=8*(i-1);  % interleaved - bytes between points of adjacent channels
 %  points=500;
   yScale=1; % for RL data
   yOffset=0;
 %  sampleRate=1000;
   xScale=1/sampleRate;
   xOffset=-0.2; % simulate pretrigger
   MATCFS32('cfsSetDSChan',fhandle,i-1,0,startoffset,points,yScale,yOffset,xScale,xOffset);
  end
    % create some data
   z=1:floor(points/5);
   z5=1:points;
   z=(z/50)-1;
   z0=[z z z z z];
   dif=points - length(z0);
   if (dif > 0)
     addit=ones(1,dif);
     z0=[z0 addit];
   end    
  for j=1:dSects
   ch1=10*z0/j;  % modify each DSect
   ch2=abs(ch1);
   ch3=(ch1-ch2)/2;
   % sine wave amp 5, period 0.1s=100 pts
   ch4=5*sin(2*pi*z5/100);
   z1=1:4:4*points-1;
   z2=z1+1;
   z3=z2+1;
   z4=z3+1;
   data=[];
   data(1,z1)=ch1;
   data(1,z2)=ch2;
   data(1,z3)=ch3;
   data(1,z4)=ch4;
  % set the DS variable, different for each DSect
    MATCFS32('cfsSetVarVal',fhandle,0,DSVAR,0,0.1*j); % DSV0
  % and a flag
    flag=MATCFS32('cfsDSFlags',fhandle,0,WRITE,FLAG1);

   % first dataSection
   [errNo]=MATCFS32('cfsWriteData',fhandle,0,0,RL8,data);
   if errNo ~=0
       disp(['An error has occurred when writing: ' int2str(errNo)]);
   end     
   if j==1
       flag=FLAG1;
   end
   if j==2
       flag=FLAG2;
   else
       flag=noFlags;
   end
  % only enable this section with a recent version of CFS32.DLL 
 %  clearIt=input(['Clear this dataSection no. ' int2str(j) ' (y=yes)? '],'s');
   clearIt='n';
   if clearIt=='y'
       ret=MATCFS32('cfsClearDS',fhandle);
       if ret ~=0
            disp(['An error has occurred when clearing DS: ' int2str(ret)]);
       end % if ret
       % rewrite the data
       data(z4)=ch1;
       data(z1)=ch4;
       [errNo]=MATCFS32('cfsWriteData',fhandle,0,0,RL8,data);
       if errNo ~=0
           disp(['An error has occurred when rewriting: ' int2str(errNo)]);
       end    
   end  
   ret=MATCFS32('cfsInsertDS',fhandle,0,flag);       
    if ret ~=0
     disp(['An error has occurred when closing DS: ' int2str(ret)]);
   end % if ret
  
end % for j=1:
remDS=input('Datasection to remove (0=none)? ');
 if remDS > 0
    MATCFS32('cfsRemoveDS',fhandle,remDS);
 end 
 % example of cfsFileError - eg put an inappropriate value for handle
 [errStatus,handleNo,procNo,errNo]=MATCFS32('cfsFileError');
 if errStatus==1
  disp(['An error has occurred - handle: ' int2str(handleNo) ' Proc: ' int2str(procNo) ' errNo: ' int2str(errNo) ';']);
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