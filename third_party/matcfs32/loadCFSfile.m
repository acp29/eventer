% loadCFSfile.m
% generic CFS loading file

% 13.03.09: version 1, JGC

% requires MATCFS32.DLL AND CFS32.DLL

% CFS constants

% 1.04.09: transpose z

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
READONLY=0;
WRITE=1;


if (exist('initcfsdir')==0)
    initcfsdir='C:\'; % set default
end
cfsdir=uigetdir(initcfsdir,'Choose a directory');
wd=cd;  % save current
eval(['cd ' '''' cfsdir '''']); % otherwise won't work if space in dir name
[shortname, cfsdir]=uigetfile({'*.cfs','CFS files (*.cfs)'}, 'Choose a file to load');
if cfsdir ~=0
  initcfsdir=cfsdir;
else
   disp('user cancelled');
   return
end % if cfsdir ~=0   
if ~isempty(shortname)
  fullfilename=[cfsdir shortname];
  if length(fullfilename) > 255
      disp('File+path length too long!');
      return
  end
   [fhandle]=MATCFS32('cfsOpenFile',fullfilename,READONLY,0);
  if (fhandle >=0)  
   [time,filedate,comment]=MATCFS32('cfsGetGenInfo',fhandle); 
  [channels,fileVars,DSVars,data_Sections]=MATCFS32('cfsGetFileInfo',fhandle);
  dataKinds=[];
  dataTypes=[];
  for j=1:channels  
    [channelName,yUnit,xUnit,dataType,dataKind,spacing,other]=MATCFS32('cfsGetFileChan',fhandle,j-1);
    eval(['yUnit' int2str(j-1) '=yUnit;']);
    eval(['xUnit' int2str(j-1) '=xUnit;']);
    eval(['chName' int2str(j-1) '=channelName;']);
    dataKinds=[dataKinds dataKind];
    dataTypes=[dataTypes dataType];
  end
  % this part like simpler.c
   disp(['File information:']);
   disp(['File ' shortname ' created on ' filedate ' at ' time]);
   if  ~(isempty(comment))
       disp(['comment: ' comment]);
   end   
   disp([int2str(fileVars) ' file variable(s)' ]);
   disp([int2str(DSVars) ' data section variable(s)']);
   disp([int2str(data_Sections) ' data section(s)']);
   disp([int2str(channels) ' channel(s): ']);
   for j=1:channels
     chName=[];  
     eval(['chanN = chName' int2str(j-1) ';']);  
     disp(['Chan' int2str(j-1) ' is ' chanN]);  
   end    
   disp('paused');
 else
  disp(['fhandle not valid = ' int2str(fhandle)]);
  return
end
 else
  disp(['No valid file selected']);
  return
end

pointsArr=[];
yScales=[];
yOffsets=[];
xScales=[];
xOffsets=[];
 for j=1:channels
 [startOffset,points,yScale,yOffset,xScale,xOffset]=MATCFS32('cfsGetDSChan',fhandle,j-1,1);
 pointsArr=[pointsArr points];
 yScales=[yScales yScale];
 yOffsets=[yOffsets yOffset];
 if dataKinds(j)==EQUALSPACED
    xScales=[xScales xScale];
    xOffsets=[xOffsets xOffset];
 else
    xScales=[xScales 1];
    xOffsets=[xOffsets 0]; 
 end    
% check for matrix type channels
end % for j=
ch=0;
for n=1:channels
  if dataKinds(n)==0   % implies equalspaced, OK
    ch=ch+1;
  end  
end  % for n  

kread=menu('Display all dataSections?','yes','1 only');
chVec=input('vector of channels to read (0 first) e.g [0 1 2] ');

if kread==1
    toRead=data_Sections;
else
    toRead=1;
end    
dS=[];
timebases=[];
plotVec='';
for i=1:toRead
    for j=1:length(chVec)
        [data]=MATCFS32('cfsGetChanData',fhandle,chVec(j),i,0,pointsArr(j),dataTypes(j));
        dS(:,j)=yScales(j)*data+yOffsets(j);
        z=1:pointsArr(j);
        z=z';
        timebases(:,j)=xScales(j)*z+xOffsets(j);
        if j > 1
            plotVec=[plotVec ','];
        end    
        plotVec=[plotVec 'timebases(:,' int2str(j) '),dS(:,' int2str(j) ')']; 
    end % for j
  eval(['plot(' plotVec ')']);
  title(['Datasection ' int2str(i) ' channels: ' int2str(chVec)]);
  pause
end % for i
ret=MATCFS32('cfsCloseFile',fhandle);
