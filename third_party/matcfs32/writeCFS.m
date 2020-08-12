% writeCFS.m
% prompts to write a CFS file - needs all data to be available first

% needs cfs32.dll and MATCFS32.dll

% 06 Mar 09: version 1 jgc
%  9 May 09: define other
% 17 June 09: transpose vector if not correct dimensions



INT1=0;
WRD1=1;
INT2=2;
WRD2=3;
INT4=4;
RL4=5;
RL8=6;
LSTR=7;
EQUALSPACED=0;
MATRIX=1;
SUBSIDIARY=2;
FILEVAR=0;
DSVAR=1;
READ=0;

other=0; % must be defined, has no role here.

info1='Have all data ready before running this m file.  Only 1 data section and no FVs or DSVs ';
info2=' time units are seconds (s).  EQUALSPACED data only, stored in RL8 format, interleaved';
info3='Remember to close the CFS file if this m file does not complete';


disp(info1);
disp(info2);
disp(info3);


if (exist('initcfsdir')==0)
    initcfsdir='C:\'; % set default
end
dataTypes=[];
% note that specifying initial directory only works for Matlab6
% [shortname, cfsdir]=uigetfile({'*.cfs','CFS files (*.cfs)'}, 'Choose a file to load', initcfsdir);
cfsdir=uigetdir(initcfsdir,'Choose a directory');
wd=cd;  % save current
eval(['cd ' '''' cfsdir '''']); % otherwise won't work if space in dir name
[fName, cfsdir]=uiputfile({'*.cfs','CFS files (*.cfs)'}, 'Choose a file to save');
if cfsdir ~=0
  initcfsdir=cfsdir;
end  
if isempty(fName)
    disp(['No valid file name provided']);
  return
else  
  fullfilename=[cfsdir fName];
  if length(fullfilename) > 255
      disp('File+path length too long!');
      return
  end
 
% for the future
% fvs=input('No of FVs? ');
% dS=input('No of dataSections? ');
dS=1;
% dsvs=input('No of DSVs? ');



s_rate=input('Sample rate (Hz)? ');
xUnits='s';
xScale=1/s_rate;
xOffset=input('Sampling onset (in s)? ');
points=input('Samples per channel? ');
chan=input('No of channels? ');
comment=input('Comment for this file? ','s');
fhandle=MATCFS32('cfsCreateCFSFile',fullfilename,comment,512,chan,1,0);
if fhandle >=0
disp('CFS file opened');    
 dataType=RL8;
 dataKind=EQUALSPACED;
 spacing=8*chan; %bytes between samples
 data=[];
 z=1:chan:chan*(points-1)+1;
for j=1:chan
   chName=input(['Channel ' int2str(j-1) 'name? '],'s');
   yScale=1;
   yOffset=0;
   startoffset=8*(j-1);
   yUnits=input(['Units for ' chName '? '],'s');
   MATCFS32('cfsSetFileChan',fhandle,j-1,chName,yUnits,xUnits,dataType,dataKind,spacing,other);
   MATCFS32('cfsSetDSChan',fhandle,j-1,0,startoffset,points,yScale,yOffset,xScale,xOffset);
   chanData=input(['Vector of values (1x' int2str(points) ' points long) ']);
   [m,n]=size(chanData);
   if (m==1 & n==points)
       data(1,z+j-1)=chanData;
   elseif (m==points & n==1)
       data(1,z+j-1)=chanData';
   else
       disp(['Wrong dimensions ( ' int2str(m) ',' int2str(n) ') - closing file and exiting']);
       ret=MATCFS32('cfsCloseFile',fhandle);
       return
   end    
end % for j
  % now write it
   [errNo]=MATCFS32('cfsWriteData',fhandle,0,0,RL8,data);
   if errNo ~=0
       disp(['An error has occurred when writing: ' int2str(errNo)]);
   end
   % and close it
    ret=MATCFS32('cfsCloseFile',fhandle);
   if ret ~=0
     disp(['An error has occurred when closing: ' int2str(ret)]);
   end
else
  disp(['Unable to open file: handle ' int2str(fhandle)]);
end  
end % mfile   