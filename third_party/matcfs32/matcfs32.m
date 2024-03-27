% matcfs32.m
% routines to access cfs files from Matlab 6.x, 7.x
% code switching originally by Mario Ringach
% by JG Colebatch v.1 Nov 2005 read only
% 12 Feb 2009 finished write routines.
% other mods required due to Matlab using double as standard
% see CFS Filing System guide from CED Ltd  www.ced.co.uk
% 1.6: fix limits for read and write (allows > 64K bytes)
%
%  general usage:
%          [ret]=matcfs32('cmd',[opt1],[opt2],[opt3]);
%  
%   varType: 2=INT2, 3=WRD2, 4=INT4, 5=RL4, 6=RL8 7=LSTR
%
%  matlab 7 is case sensitive, so use MATCFS32
% 
% cfsOpenFile - returns cfs filehandle or error thus:
%      handle=MATCFS32('cfsOpenFile',fname,enableWrite,memoryTable);
% cfsCreateCFSFile - returns cfs filehandle or error:
%      handle=MATCFS32('cfsCreateCFSFile',fName, comment, blockSize, channels, fileVars, DSVars,(DSVAindex));
%            - do not send address of FV or DS array, just number of them
%           - DSVAindex (optional) - 0 or 1 - sets lower or upper DSVArray
% cfsSetVarDesc - sets FV or DS variable descriptions
%       - must call before calling cfsCreateCFSFile
%      MATCFS32('cfsSetVarDesc',handle, varNo, varKind, varSize, varType, units, description,(DSVAindex));
%       DSVAindex - optional 0 or 1 - sets upper part of DSVarray
% cfsSetVarVal - sets value of FV or DS variable
%       MATCFS32('cfsSetVarVal',handle,varNo,varKind,dataSection,value,(DSVAindex));
%       DSVAindex - optional 0 or 1 - sets upper part of DSVarray
% cfsSetFileChan - sets file channel variables
%      MATCFS32('cfsSetFileChan',handle, channel, chName, yUnits, xUnits, dataType, dataKind, spacing, other);
% cfsWriteData - writes a dataSection of data 0=no error
%     [errNo]=MATCFS32('cfsWriteData',handle,dataSection,startOffset,dType,array);
%      INT1 and WRD1 are not supported.  Array sizes > 64K allowed
% cfsInsertDS - closes current DS, sets flags  0=no error
%    [errNo]=MATCFS32('cfsInsertDS',handle,dataSection, flagSet);
% cfsRemoveDS - unlinks a dataSection
%     MATCFS32('cfsRemoveDS',handle,dataSection);
% cfsClearDS - removes DS and recovers space 0=no error
%     [errNo]=MATCFS32('cfsClearDS',handle);
% cfsSetComment - change comment (max 72 characters)
%     MATCFS32('cfsSetComment', handle, comment);
% cfsCloseFile - closes file and returns 0 if successful, thus: 
%     ret= MATCFS32('cfsCloseFile', handle);
% cfsGetGenInfo - returns time and date of file creation, plus comment
%      [time,date,comment]=MATCFS32('cfsGetGenInfo',handle);
% cfsGetFileInfo - returns no. of: chan,fileVars, DSVars and dataSections
%   [channels,fileVars,DSVars,dataSections]=MATCFS32('cfsGetFileInfo',handle);                                                
% cfsGetVarDesc- reads file variables and datasection variables
%   [varSize,varType,varUnits,varDesc]=MATCFS32('cfsGetVarDesc',handle,varNo,varKind);
% cfsGetVarVal - gets value of file or DSect variable
%   [varValue]=MATCFS32('cfsGetVarVal',handle,varNo,varKind,dataSection,varType);
%                         n.b. must specify varType
% cfsGetFileChan - gets constant information for each channel
%    [channelName,yUnits,xUnits,dataType,dataKind,spacing,other]=MATCFS32('cfsGetFileChan',handle,channel);
% cfsGetDSChan - reads channel information for specific channel and datasection
%    [startOffset,points,yScale,yOffset,xScale,xOffset]=MATCFS32('cfsGetDSChan',handle,channel,dataSection);
% cfsGetChanData- gets channel data points
%    [chanData]=MATCFS32('cfsGetChanData',handle,channel,dataSection,firstElement,numElements,varType);
%        note: 0 for numElements is not supported.  Will read numElements
%        as requested, even if > 64K
% cfsGetDSSize - disk space required
%    [size]=MATCFS32('cfsGetDSSize',handle,dataSection);
% cfsReadData - returns data (read en bloc)
%   [data]= MATCFS32('cfsReadData',handle,dataSection,startOffset,points, dataType,);
%           points must be > 0, can be >64K
% cfsDSFlagValue returns value corresponding to flag
%       [value]=MATCFS32('cfsDSFlagValue',nflag);
% cfsDSFlags reads flags set
%       [flagSet]=MATCFS32('cfsDSFlags', handle, dSect, setit);  % setit = 0 to read
%       [flagSet]=MATCFS32('cfsDSFlags', handle, dSect, setit, flagSet); % = 1 to write - returns value
% cfsCommitCFSFile - writes headers to disk
%       [ret]=MATCFS32('cfsCommitCFSFile',handle);
% cfsFileError
%       [errStatus,handleNo,procNo,errNo]=MATCFS32('cfsFileError');
%           errStatus = 1 if error,since last call, 0 if not
%           handleNo,procNo,errNo - see CFS manual
% cfsFileSize returns file size in bytes
%       size=matcfs('cfsFileSize',fhandle);