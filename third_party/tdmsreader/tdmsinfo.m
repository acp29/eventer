function [Root, Group, Channels] = tdmsinfo(tdmsfilename)
% Read DAQmx raw data information.
% [Root, Group, Channels] = tdmsinfo_eppg(tdmsfilename)
%
% NOTE: this function can only be used in the TDMS file, which is acquired
% by PXIe-6368 DAQ card. I havn't any other card to try TDMS DAQmx raw
% data format. (One Root, one Group and some channels)
%
%The format of TDMS file is descripted by NI:
% http://www.ni.com/white-paper/5696/en/
%
% See also:
%   tdmsreader

% Copyright (c) CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2014
% Author: lantao
% Email: lantao@ustc.edu.cn
% All Rights Reserved.
% $Revision: 1.0$ Created on: 16-March-2014 16:04:10

% Edited by O.G. Steele, 08.08.19

%filename = 'd:\50012\EP_50012.tdms';
fid = fopen(tdmsfilename, 'r');
if fid <0
    error(['Can''t open ' tdmsfilename]);
end

% Lead In
TDSm_tag = fread(fid, 4, 'char=>char', 'l');  % 'TDSm' tag
if ~strncmpi(TDSm_tag, 'TDSm',4)
    error('First 4 chars not ''TDSm''')
end
ToCmask = fread(fid, 1, 'uint32=>uint32', 'l'); 
kTocMetaData = bitget(ToCmask, 2); % Segment contains meta data
kTocRawData = bitget(ToCmask, 4);  % Segment contains raw data
kTocDAQmxRawData = bitget(ToCmask, 8); % Segment contains DAQmx raw data
kTocInterleavedData = bitget(ToCmask, 6); % Raw data in the segment is interleaved (if flag is not set, data is contiguous)
kTocBigEndian = bitget(ToCmask, 7); % All numeric values in the segment, including the lead in, raw data, and meta data, are big-endian formatted (if flag is not set, data is little-endian). ToC is not affected by endianess; it is always little-endian.
kTocNewObjList = bitget(ToCmask, 3);% Segment contains new object list (e.g. channels in this segment are not the same channels the previous segment contains)

if kTocBigEndian
    EndianType = 'b';
else
    EndianType = 'l';
end

VerNum = fread(fid, 1, 'uint32=>uint32', EndianType);  % 4713 for V2.0; 4712 for V1.0
if VerNum ~= 4713,  error('Only V2.0 TDMS file can be decoded in this function'); end

% the length of the remaining segment (overall length of the segment minus length of the lead in(28bytes))
NextSegOffset = fread(fid, 1, 'uint64', EndianType);  

%  the overall length of the meta information in the segment
RawDataOffset = fread(fid, 1, 'uint64', EndianType); 

% Meta Data
% TDMS meta data consists of a three-level hierarchy of data objects including a file, groups, and channels. Each of these object types can include any number of properties. The meta data section has the following binary layout on disk:
% 	* Number of new objects in this segment (unsigned 32-bit integer).
% 	* Binary representation of each of these objects.

%  Number of objects, The first obj is root, and second obj is Group
%  and last objs are channels.
NumofObj = fread(fid, 1, 'uint32', EndianType); 


% Read root obj
if NumofObj <1, error('Empty obj in this TDMS file'); end
Root = [];   % root object
LenofRootObjPath = fread(fid, 1, 'uint32', EndianType);  % Length of root obj path
RootObjPath = fread(fid, LenofRootObjPath, 'char=>char', EndianType)'; % if ObjPath='/', it is root.
Root.path = RootObjPath;
assert(strcmp(RootObjPath, '/'));
RootRawDataIndex = fread(fid, 1, 'uint32=>uint32', EndianType);
% Raw data index ("FF FF FF FF" means there is no raw data assigned to root object)
if RootRawDataIndex == hex2dec('FFFFFFFF')
    % No raw data
end
Root.NextSegOffset = NextSegOffset;
Root.RawDataOffset = RawDataOffset;
Root.EndianType = EndianType;


NumofRootProp = fread(fid, 1, 'uint32', EndianType); % Number of properties
for ii=1:NumofRootProp
    LenofRootPropName = fread(fid, 1, 'uint32', EndianType);
    PropName = fread(fid, LenofRootPropName, 'char=>char', EndianType)';
    DataTypeofRootPropValue =  fread(fid, 1, 'uint32', EndianType); %Data type of the property value
    if DataTypeofRootPropValue == hex2dec('20'); % for string
        LenofRootPropValue = fread(fid, 1, 'uint32', EndianType);
        ValueofRootProp = fread(fid, LenofRootPropValue, 'char=>char', EndianType)';
    end
    Root.(PropName)= ValueofRootProp;
end

% Read group obj
if NumofObj <2, error('No group obj in this TDMS file'); end
Group = [];  % group object
LenofGroupObjPath = fread(fid, 1, 'uint32', EndianType);
GroupObjPath = fread(fid, LenofGroupObjPath,  'char=>char', EndianType)';
Group.path = GroupObjPath;
RawDataIndex = fread(fid, 1, 'uint32=>uint32', EndianType);
if RawDataIndex == hex2dec('FFFFFFFF')
    % No raw data
end
NumofGroupProp = fread(fid, 1, 'uint32', EndianType); % Number of properties
for ii = 1: NumofGroupProp
    LenofGroupPropName = fread(fid, 1, 'uint32', EndianType);
    PropName = fread(fid, LenofGroupPropName, 'char=>char', EndianType)';
    DataTypeofGroupPropValue =  fread(fid, 1, 'uint32', EndianType); %Data type of the property value
    if DataTypeofGroupPropValue == hex2dec('20'); % for string
        LenofGroupPropValue = fread(fid, 1, 'uint32', EndianType);
        ValueofGroupProp = fread(fid, LenofGroupPropValue, 'char=>char', EndianType)';
    end
    Root.(PropName)= ValueofGroupProp;
end

% Read Channel objects
if NumofObj <3, error('No channel objs in this TDMS file'); end
Channels = ''; % Channel Objects
for iChannel = 1: NumofObj -2
    LenofChnlObjPath = fread(fid, 1, 'uint32', EndianType);
    ChnlObjPath = fread(fid, LenofChnlObjPath, 'char=>char', EndianType)';
    Channels(iChannel).path = ChnlObjPath;
    vernumber = fread(fid, 1, 'uint32=>uint32', EndianType); % why identify vernumber again?
    assert(vernumber == 4713);
    RawDataIndex = fread(fid, 1, 'uint32=>uint32', EndianType);
    % Raw data index ("FF FF FF FF" means there is no raw data assigned to the object)
    if RawDataIndex == hex2dec('FFFFFFFF')
        % No raw data
    end
    ChnlDimension = fread(fid, 1, 'uint32', EndianType); % Dimension of Channel
    assert(ChnlDimension==1);
    ChnlBlockLen = fread(fid, 1, 'uint32', EndianType);
   
    SecondDimensionLen = fread(fid, 1, 'uint32', EndianType);
    Channels(iChannel).BlockSecondDimension = SecondDimensionLen;  % if ChnlDimension==1, this value=0
    BlockArrayDimension1Len = fread(fid, 1, 'uint32', EndianType);
    assert(BlockArrayDimension1Len==1);
    BlockArrayDimension2Len = fread(fid, 1, 'uint32', EndianType);
    assert(BlockArrayDimension2Len==3);
    for ii=1:BlockArrayDimension1Len
        % I don't know how to deal with it
    end
    for ii=1:BlockArrayDimension2Len
        % I don't know how to deal with it
    end
    Channels(iChannel).BlockArrayDim1 = fread(fid, 1, 'uint32', EndianType);
    Channels(iChannel).BlockArrayDim2 = fread(fid, 1, 'uint32', EndianType);
    fread(fid, 1, 'uint32', EndianType);
    fread(fid, 1, 'uint32', EndianType);
    
    LenChnlArrayDim = fread(fid, 1, 'uint32', EndianType);
    Channels(iChannel).TotalCardNum = LenChnlArrayDim;
    temp = 0;
    for ii=1:LenChnlArrayDim
        Channels(iChannel).ChnlArrayDim(ii) = fread(fid, 1, 'uint32', EndianType);
        temp = temp + Channels(iChannel).ChnlArrayDim(ii);
    end
    Channels(iChannel).BlockLength = ChnlBlockLen;  % This is the lengh of block which Labview stream data to disk
    Channels(iChannel).DataLength = (Root.NextSegOffset - Root.RawDataOffset)/temp;
    Channels(iChannel).TotalLength = Channels(iChannel).DataLength;
    Channels(iChannel).BlockNumbers = Channels(iChannel).DataLength/Channels(iChannel).BlockLength;
    
    ChnInfo = ChannelInfo(fid, EndianType);
    fn = fieldnames(ChnInfo);
    for ifn = fn(:)'
        Channels(iChannel).(ifn{1}) = ChnInfo.(ifn{1});
    end
end


% 最后一段信息
if fseek(fid, double(NextSegOffset)+28, 'bof')
    error('Can''t seek NextSegOffset')
end
% Lead In
TDSm_tag = fread(fid, 4, 'char=>char', 'l');  % 'TDSm' tag
if ~strncmpi(TDSm_tag, 'TDSm',4)
    error('前4个字母不是TDSm')
end
ToCmask2 = fread(fid, 1, 'uint32=>uint32', 'l'); 
kTocMetaData2 = bitget(ToCmask, 2); % Segment contains meta data
kTocRawData2 = bitget(ToCmask, 4);  % Segment contains raw data
kTocDAQmxRawData2 = bitget(ToCmask, 8); % Segment contains DAQmx raw data
kTocInterleavedData2 = bitget(ToCmask, 6); % Raw data in the segment is interleaved (if flag is not set, data is contiguous)
kTocBigEndian2 = bitget(ToCmask, 7); % All numeric values in the segment, including the lead in, raw data, and meta data, are big-endian formatted (if flag is not set, data is little-endian). ToC is not affected by endianess; it is always little-endian.
kTocNewObjList2 = bitget(ToCmask, 3);% Segment contains new object list (e.g. channels in this segment are not the same channels the previous segment contains)

if kTocBigEndian2
    EndianType = 'b';
else
    EndianType = 'l';
end

VerNum = fread(fid, 1, 'uint32', EndianType);  % 4713 for V2.0; 4712 for V1.0
if VerNum ~= 4713,  error('Only V2.0 TDMS file can be decoded in this function'); end

% the length of the remaining segment (overall length of the segment minus length of the lead in(28bytes))
NextSegOffset2 = fread(fid, 1, 'uint64', EndianType);  

%  the overall length of the meta information in the segment
RawDataOffset2 = fread(fid, 1, 'uint64', EndianType); 

Group.MultiBlocks = 1;
while NextSegOffset2~=RawDataOffset2
    Group.MultiBlocks = Group.MultiBlocks + 1;
    Root.NextSegOffset2 = NextSegOffset2;
    Root.RawDataOffset2 = RawDataOffset2;
    
    nChannels = fread(fid, 1, 'uint32', EndianType);
    for iChannel = 1: nChannels
        nChnName = fread(fid, 1, 'uint32', EndianType);
        ChnName = fread(fid, nChnName, 'char=>char', EndianType)';
        if ~strcmpi(ChnName, Channels(iChannel).path)
            fclose(fid);
            error('Path name not math')
        end
        vernumber = fread(fid, 1, 'uint32=>uint32', EndianType); % why identify vernumber again?
        assert(vernumber == 4713);
        RawDataIndex = fread(fid, 1, 'uint32=>uint32', EndianType);
        % Raw data index ("FF FF FF FF" means there is no raw data assigned to the object)
        if RawDataIndex == hex2dec('FFFFFFFF')
            % No raw data
        end
        nLength = fread(fid, 1, 'uint32', EndianType); % dimension
        BlockSize = fread(fid, nLength, 'uint32', EndianType);
        BlockSize = (Root.NextSegOffset2 - Root.RawDataOffset2)/temp; % == SecondDataLength
            % ORIGINAL: BlockSize = 100;
                
        nLength2 = fread(fid, 1, 'uint32', EndianType);
        assert(nLength2==0);
        BlockArrayDimension1Len = fread(fid, 1, 'uint32', EndianType);
        assert(BlockArrayDimension1Len==1);
        BlockArrayDimension2Len = fread(fid, 1, 'uint32', EndianType);
        assert(BlockArrayDimension2Len==3);
        for ii=1:BlockArrayDimension1Len
            % I don't know how to deal with it
        end
        for ii=1:BlockArrayDimension2Len
            % I don't know how to deal with it
        end
        Channels(iChannel).SecondBlockArrayDim1 = fread(fid, 1, 'uint32', EndianType);
        Channels(iChannel).SecondBlockArrayDim2 = fread(fid, 1, 'uint32', EndianType);
        fread(fid, 1, 'uint32', EndianType);
        fread(fid, 1, 'uint32', EndianType);
        
        LenChnlArrayDim = fread(fid, 1, 'uint32', EndianType);
        Channels(iChannel).SecondTotalCardNum = LenChnlArrayDim;
        temp = 0;
        for ii=1:LenChnlArrayDim
            Channels(iChannel).SecondChnlArrayDim(ii) = fread(fid, 1, 'uint32', EndianType);
            temp = temp + Channels(iChannel).SecondChnlArrayDim(ii);
        end
        Channels(iChannel).SecondBlockLength = (Root.NextSegOffset2 - Root.RawDataOffset2)/temp;
            %ORIGINAL: Channels(iChannel).SecondBlockLength = BlockSize;
        Channels(iChannel).SecondDataLength = (Root.NextSegOffset2 - Root.RawDataOffset2)/temp;
        Channels(iChannel).TotalLength = Channels(iChannel).DataLength + Channels(iChannel).SecondBlockLength;
        Channels(iChannel).SecondBlockNumbers = Channels(iChannel).SecondDataLength/Channels(iChannel).SecondBlockLength;
        ChnInfo = ChannelInfo(fid, EndianType);
        fn = fieldnames(ChnInfo);
      
        %% Ensure data length is below MatLab Array Size Limit.
        if Channels(iChannel).TotalLength > 62859405
            Channels(iChannel).TotalLength = 62859404;
        else
            Channels(iChannel).TotalLength = Channels(iChannel).TotalLength;
        end

        if Channels(iChannel).SecondBlockLength > 62859405
            Channels(iChannel).SecondBlockLength = 62859404;
        else 
            Channels(iChannel).SecondBlockLength = Channels(iChannel).SecondBlockLength > 62859405;
        end 
        for ifn = fn(:)'
            Channels(iChannel).(ifn{1}) = ChnInfo.(ifn{1});
        end
        
    end
%     for iChannel = 1: NumofObj -2
%         Channels(iChannel).BlockLength(Group.MultiBlocks) = ChnlBlockLen;  % This is the lengh of block which Labview stream data to disk
%         Channels(iChannel).DataLength(Group.MultiBlocks) = (Root.NextSegOffset - Root.RawDataOffset)/(2*(NumofObj -2));
%     end
    
    
    fseek(fid, double(NextSegOffset2-RawDataOffset2), 'cof');
    TDSm_tag = fread(fid, 4, 'char=>char', 'l');  % 'TDSm' tag
    if ~strncmpi(TDSm_tag, 'TDSm',4)
        fclose(fid);
        error('前4个字母不是TDSm')
    end
    ToCmask2 = fread(fid, 1, 'uint32=>uint32', 'l');
    kTocMetaData2 = bitget(ToCmask, 2); % Segment contains meta data
    kTocRawData2 = bitget(ToCmask, 4);  % Segment contains raw data
    kTocDAQmxRawData2 = bitget(ToCmask, 8); % Segment contains DAQmx raw data
    kTocInterleavedData2 = bitget(ToCmask, 6); % Raw data in the segment is interleaved (if flag is not set, data is contiguous)
    kTocBigEndian2 = bitget(ToCmask, 7); % All numeric values in the segment, including the lead in, raw data, and meta data, are big-endian formatted (if flag is not set, data is little-endian). ToC is not affected by endianess; it is always little-endian.
    kTocNewObjList2 = bitget(ToCmask, 3);% Segment contains new object list (e.g. channels in this segment are not the same channels the previous segment contains)
    
    if kTocBigEndian2
        EndianType = 'b';
    else
        EndianType = 'l';
    end
    
    VerNum = fread(fid, 1, 'uint32=>uint32', EndianType);  % 4713 for V2.0; 4712 for V1.0
    if VerNum ~= 4713,  error('Only V2.0 TDMS file can be decoded in this function'); end
    
    % the length of the remaining segment (overall length of the segment minus length of the lead in(28bytes))
    NextSegOffset2 = fread(fid, 1, 'uint64=>uint64', EndianType);
    
    %  the overall length of the meta information in the segment
    RawDataOffset2 = fread(fid, 1, 'uint64=>uint64', EndianType);
    
end

NumofChannels = fread(fid,1,'uint32', EndianType);

if NumofChannels ~= NumofObj -2
    error('Last Seg: Number of Channels wrong')
end

for iChannel = 1: NumofChannels
    LenofChnlPath = fread(fid,1,'uint32', EndianType);
    StrofChnlPath = fread(fid, LenofChnlPath, 'char=>char', EndianType)';
    if ~strcmpi(StrofChnlPath, Channels(iChannel).path)
        error('Last Seg: Path not confident')
    end
    RawDataIndex = fread(fid, 1, 'uint32=>uint32', EndianType);
    % Raw data index ("FF FF FF FF" means there is no raw data assigned to the object)
    if RawDataIndex == hex2dec('FFFFFFFF')
        % No raw data
    end
    ChnInfo = ChannelInfo(fid, EndianType);
    fn = fieldnames(ChnInfo);
    for ifn = fn(:)'
        Channels(iChannel).(ifn{1}) = ChnInfo.(ifn{1});
    end
end

% close file
fclose(fid);


% TDMS model
% NI_ChannelName
% NI_Scaling_Status
% NI_Number_Of_Scales
% NI_Scale[1]_Scale_Type
% NI_Scale[1]_Polynomial_Coefficients_Size
% NI_Scale[1]_Polynomial_Coefficients[0]
% NI_Scale[1]_Polynomial_Coefficients[1]
% NI_Scale[1]_Polynomial_Coefficients[2]
% NI_Scale[1]_Polynomial_Coefficients[3]
% NI_Scale[1]_Polynomial_Input_Source

% 
% unit_string
% NI_UnitDescription
% wf_start_time
% wf_increment
% wf_start_offset
% wf_samples


% read channel information
function ChnInfo = ChannelInfo(fid, EndianType)
NumofProp = fread(fid,1,'uint32', EndianType);
ChnInfo = struct;
for ii= 1:NumofProp
    LenofChnlProp = fread(fid, 1, 'uint32', EndianType);
    NameofChnlProp = fread(fid, LenofChnlProp, 'char=>char', EndianType)';
    NameofChnlProp = strrep(NameofChnlProp, '[', '_');
    NameofChnlProp = strrep(NameofChnlProp, ']', '_');
    TypeofChnlProp = fread(fid, 1, 'uint32', EndianType);
    ChnlPropValue = [];
    switch  TypeofChnlProp
        case hex2dec('20')   % string
            LenofChnlPropValue = fread(fid, 1, 'uint32', EndianType);
            ChnlPropValue = fread(fid, LenofChnlPropValue, 'char=>char')';
        case hex2dec('07')   % unsigned integer (32bit)
            ChnlPropValue = fread(fid, 1, 'uint32', EndianType);
        case hex2dec('0A')   % double precision (64bit)
            ChnlPropValue = fread(fid, 1, 'float64', EndianType);
        case hex2dec('44')   % date string
            ChnlPropValue(1) = fread(fid, 1, 'uint64', EndianType);  % TimeStamp http://www.ni.com/white-paper/7900/en/
            ChnlPropValue(2) = fread(fid, 1, 'int64', EndianType);  % TimeStamp http://www.ni.com/white-paper/7900/en/
            utce = datenum('01-jan-1904 00:00:00')+8/24;  % We are in +8:00 Timezone (UTC+8)
            ChnInfo.DAQTime=datestr(utce+(ChnlPropValue(2)+ChnlPropValue(1)/2^64)/86400,'yyyy-mm-dd hh:MM:SS.FFF AM');
        case hex2dec('03')   % integer (32bit);
            ChnlPropValue = fread(fid, 1, 'int32', EndianType);
        otherwise
            error(['Type of Chnl Prop =' dec2hex(TypeofChnlProp)])
    end
    ChnInfo.(NameofChnlProp) = ChnlPropValue;
end
