clc;

%Recreate needed property constants defined in nilibddc_m.h
DDC_FILE_NAME					=	'name';
DDC_FILE_DESCRIPTION			=	'description';
DDC_FILE_TITLE					=	'title';
DDC_FILE_AUTHOR					=	'author';
DDC_FILE_DATETIME				=	'datetime';
DDC_CHANNELGROUP_NAME			=	'name';
DDC_CHANNELGROUP_DESCRIPTION	=	'description';
DDC_CHANNEL_NAME				=	'name';

%Check if the paths to 'nilibddc.dll' and 'nilibddc_m.h' have been
%selected. If not, prompt the user to browse to each of the files.
if exist('NI_TDM_DLL_Path','var')==0
    [dllfile,dllfolder]=uigetfile('*dll','Select nilibddc.dll');
    libname=strtok(dllfile,'.');
    NI_TDM_DLL_Path=fullfile(dllfolder,dllfile);
end
if exist('NI_TDM_H_Path','var')==0
    [hfile,hfolder]=uigetfile('*h','Select nilibddc_m.h');
    NI_TDM_H_Path=fullfile(hfolder,hfile);
end

%Prompt the user to browse to the path of the TDM or TDMS file to read
[filepath,filefolder]=uigetfile({'*.tdms';'*.tdm'},'Select a TDM or TDMS file');
Data_Path=fullfile(filefolder,filepath);

%Load nilibddc.dll (Always call 'unloadlibrary(libname)' after finished using the library)
loadlibrary(NI_TDM_DLL_Path,NI_TDM_H_Path);

%Open the file (Always call 'DDC_CloseFile' when you are finished using a file)
fileIn = 0;
[err,dummyVar,dummyVar,file]=calllib(libname,'DDC_OpenFileEx',Data_Path,'',1,fileIn);

%Get channel groups
%Get the number of channel groups
numgrpsIn = 0;
[err,numgrps]=calllib(libname,'DDC_GetNumChannelGroups',file,numgrpsIn);
%Get channel groups only if the number of channel groups is greater than zero
if numgrps>0
	%Initialize an array to hold the desired number of groups
    pgrps=libpointer('int64Ptr',zeros(1,numgrps));
    [err,grps]=calllib(libname,'DDC_GetChannelGroups',file,pgrps,numgrps);
end 

for i=1:numgrps %For each channel group
    
    %Get channels
    numchansIn = 0;
    %Get the number of channels in this channel group
    [err,numchans]=calllib(libname,'DDC_GetNumChannels',grps(i),numchansIn);
    %Get channels only if the number of channels is greater than zero
    if numchans>0
		%Initialize an array to hold the desired number of channels
        pchans=libpointer('int64Ptr',zeros(1,numchans));
        [err,chans]=calllib(libname,'DDC_GetChannels',grps(i),pchans,numchans);
    end
    
    channames=cell(1,numchans);
    for j=1:numchans %For each channel in the channel group
        
        %Get channel data type
        typeIn = 0;
        [err,type]=calllib(libname,'DDC_GetDataType',chans(j),typeIn);
        
        %Get channel values if data type of channel is double (DDC_Double = 10)
        if strcmp(type,'DDC_Double')
            numvalsIn = 0;
            [err,numvals]=calllib(libname,'DDC_GetNumDataValues',chans(j),numvalsIn);
			%Initialize an array to hold the desired number of values
            pvals=libpointer('doublePtr',zeros(1,numvals));
            [err,vals]=calllib(libname,'DDC_GetDataValues',chans(j),0,numvals,pvals);
            setdatatype(vals,'doublePtr',1,numvals);
            
            %Add channel values to a matrix. The comment, #ok<AGROW>, at
            %the end of the line prevents warnings about the matrix needing 
            %to allocate more memory for the added values.
            chanvals(:,j)=(vals.Value); %#ok<AGROW>
        end
            
    end
    
    %Plot Data from channels in this group
    %plot(chanvals);
    %clear chanvals;

end

%Close file
err = calllib(libname,'DDC_CloseFile',file);

%Unload nilibddc.dll
unloadlibrary(libname);