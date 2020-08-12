% cfsRead.m 
% an example of reading a cfs file

%  01.02.09: jgc version 1
%  similar to simpler.c
%  must have cfs32.dll in system directory
%  calls MATCFS32.dll

%  07.02.09: read specific value(s)
%  24.02.09: capitalise MATCFS32 for Matlab 7
%  27.02.09: more information on variable type
%  07.08.09: do not calculate sampling freq if xScale =0
%            notify if not all points read

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


if (exist('initcfsdir')==0)
    initcfsdir='C:\'; % set default
end
dataTypes=[];
% note that specifying initial directory only works for Matlab6
% [shortname, cfsdir]=uigetfile({'*.cfs','CFS files (*.cfs)'}, 'Choose a file to load', initcfsdir);
cfsdir=uigetdir(initcfsdir,'Choose a directory');
wd=cd;  % save current
eval(['cd ' '''' cfsdir '''']); % otherwise won't work if space in dir name
[fName, cfsdir]=uigetfile({'*.cfs','CFS files (*.cfs)'}, 'Choose a file to load');
if cfsdir ~=0
  initcfsdir=cfsdir;
end  
if isempty(fName)
    disp(['No valid file selected']);
  return
else  
  fullfilename=[cfsdir fName];
  if length(fullfilename) > 255
      disp('File+path length too long!');
      return
  end    
  [fhandle]=MATCFS32('cfsOpenFile',fullfilename,READ,0); % read only
 if (fhandle < 0)
   disp(['File opening error: ' int2str(fhandle)]); 
   return;
 else % file opened OK
   disp(['File information:']); 
   byteSize=MATCFS32('cfsFileSize',fhandle);
   disp(['File size is: ' int2str(byteSize) ' bytes']);
  [time,date,comment]=MATCFS32('cfsGetGenInfo',fhandle);   
  [channels,fileVars,DSVars,dataSections]=MATCFS32('cfsGetFileInfo',fhandle);
   disp(['File ' fName ' created on ' date ' at ' time]);
   if  ~(isempty(comment))
       disp(['comment: ' comment]);
   end   
   disp([int2str(channels) ' channel(s) ']);
   disp([int2str(fileVars) ' file variable(s)' ]);
   disp([int2str(DSVars) ' data section variable(s)']);
   disp([int2str(dataSections) ' data section(s)']);
   disp('paused');
   pause;
   for i=1:fileVars
    [varSize,varType,varUnits,varDesc]=MATCFS32('cfsGetVarDesc',fhandle,i-1,FILEVAR);
    if varType ~= LSTR
      [varValue]=MATCFS32('cfsGetVarVal',fhandle,(i-1),FILEVAR,0,varType);
    else
       [varValue]=MATCFS32('cfsGetVarVal',fhandle,(i-1),FILEVAR,0,varType,varSize); % needed for LSTR
    end 
    disp(' ');
    disp(['FV' int2str(i-1) ':']);
    disp(['Units: ' varUnits]);
    disp(['Description: ' varDesc]);
     switch varType
          case INT1
              dtype='INT1';
          case WRD1
              dtype='WRD1';
          case INT2
              dtype='INT2';
          case WRD2
              dtype='WRD2';
          case RL4
              dtype='RL4';
          case RL8
              dtype='RL8';
          case LSTR
              dtype='LSTR';
          otherwise
              dtype='unknown';
     end
     disp(['VarType: ' dtype]); 
    if (varType ~=7)
       disp(['Value: ' int2str(varValue)]);
    else
       disp(['Value: ' varValue]); 
    end 
   end % for fileVars
   % now for each dataSection or just 1
   if dataSections > 1
    dsVec=input('datasections to read (vector)? ');
   else
    dsVec=1;
   end
   if length(dsVec)==0
       dsVec=1:dataSections;
   end
   showChan=input('show channels? (y=yes)? ','s');
   for i=1:length(dsVec)
       % show DSVars
    if DSVars > 0   
     showDS=input('Show DS variables (y=yes)? ','s');
    else
     showDS='n';
    end    
    if showDS=='y' | showDS=='Y'
    for j=1:DSVars
     [varSize,varType,varUnits,varDesc]=MATCFS32('cfsGetVarDesc',fhandle,j-1,DSVAR);
     if varType ~= LSTR
      [varValue]=MATCFS32('cfsGetVarVal',fhandle,(j-1),DSVAR,dsVec(i),varType);
     else
      [varValue]=MATCFS32('cfsGetVarVal',fhandle,(j-1),DSVAR,dsVec(i),varType,varSize); % needed for LSTR
     end 
     disp(' ');
     disp(['DSVar' int2str(j-1) ':']);
     disp(['Units: ' varUnits]);
     disp(['Description: ' varDesc]);
     switch varType
          case INT1
              dtype='INT1';
          case WRD1
              dtype='WRD1';
          case INT2
              dtype='INT2';
          case WRD2
              dtype='WRD2';
          case RL4
              dtype='RL4';
          case RL8
              dtype='RL8';
          case LSTR
              dtype='LSTR';
          otherwise
              dtype='unknown';
     end
     disp(['VarType: ' dtype]); 
     if (varType <5)
       disp(['Value: ' int2str(varValue)]);
     elseif (varType==RL4) | (varType==RL8)
       disp(['Value: ' num2str(varValue)]); 
     elseif varType==LSTR
       disp(['Value: ' varValue]); 
     end 
    end % for DSVars
end % if showDS
      [flagSet]=MATCFS32('cfsDSFlags', fhandle, dsVec(i), READ);  % setit = 0 to read
      disp(' ');
      if flagSet > 0
       disp(['flagset is: ' int2str(flagSet)]);
      else
       disp('No flags set'); 
      end
      dSbyteSize=MATCFS32('cfsGetDSSize',fhandle,dsVec(i));
      disp(['Datasection size is: ' int2str(dSbyteSize) ' bytes']);
      for j=1:channels
      [startOffset,points,yScale,yOffset,xScale,xOffset]=MATCFS32('cfsGetDSChan',fhandle,j-1,dsVec(i));   
      [channelName,yUnits,xUnits,dataType,dataKind,spacing,other]=MATCFS32('cfsGetFileChan',fhandle,j-1);
      if i==1
          dataTypes=[dataTypes dataType];
      end    
      disp(' ');
      disp(['Channel ' int2str(j-1) ': name is: ' channelName]);
      switch dataType
          case INT1
              dtype='INT1';
          case WRD1
              dtype='WRD1';
          case INT2
              dtype='INT2';
          case WRD2
              dtype='WRD2';
          case RL4
              dtype='RL4';
          case RL8
              dtype='RL8';
          case LSTR
              dtype='LSTR';
          otherwise
              dtype='unknown';
      end
      disp(['yUnits ' yUnits ' xUnits ' xUnits ' datatype ' dtype]);
      switch dataKind
          case 0
              dKind='EqSpaced';
          case 1
              dKind='Matrix';
          case 2
              dKind='Subsiduary';
          otherwise
              dKind='unknown'
      end       
      disp(['dataKind ' dKind ' spacing ' int2str(spacing) ' other ' int2str(other)]);
      disp(['No of points ' int2str(points)]);
      disp(['yScale ' num2str(yScale) ' yOffset ' num2str(yOffset)]);
      disp(['xScale ' num2str(xScale) ' xOffset ' num2str(xOffset)]);
      if xScale ~= 0
          disp(['Sampling frequency: ' num2str(1/xScale)]);
      end    
      disp(' ');
      if points > 0
       startPt=0;
       [data]=MATCFS32('cfsGetChanData',fhandle,j-1,dsVec(i),startPt,points,dataType);
       if length(data) ~= points
         disp(['Only ' int2str(length(data)) ' points read!']);
       end    
       data=(data*yScale)-yOffset;
       if showChan=='y'
           xVar=1:length(data);
           xVar=xVar*xScale+xOffset;
           plot(xVar,data);
           xlabel(xUnits);
           title(['Datasection ' int2str(dsVec(i)) ': channel ' int2str(j-1)]);
           disp('paused');
           pause;
       end % if showChan    
       disp(['Raw values: ' num2str(data(1)) ' ' num2str(data(2)) ' ' num2str(data(3)) ' ' num2str(data(4)) ' ' ...
               num2str(data(5)) ' ' num2str(data(6)) ' ' num2str(data(7)) ' ' num2str(data(8))]);
      else
       disp('No points to show');
     end  
     end % for j
   end  % for i  
   kspecify=menu('Specific value to read?','yes','no');
   if kspecify==1
    dataS=input('dataSection to read - first is 1? ');  
    chan=input('channel - first = 0? ');
    pointS=input('point to start - first is 0? ');
    pointNum=input('Number to read? ');
    datapt=MATCFS32('cfsGetChanData',fhandle,chan,dataS,pointS,pointNum,dataTypes(chan+1));
    disp(['(Raw) value(s) are: ' num2str(datapt')]);  % not converted with yScale, yOffset
  end    
  ret=MATCFS32('cfsCloseFile',fhandle); % close the file
 end % if fhandle
end