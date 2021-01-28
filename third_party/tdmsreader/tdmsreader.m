function [data] = tdmsreader(tdmsfilename, channel, datalen)
% Decode TDMS file, which is saved as DAQmx raw data format for PXIe-6368.
% Syntax:
% [data, rawdata] = TDMSREADER(tdmsfilename, channel, datalen)
%   tdmsfilename: the name of tdms file
%   channel: channel number
%   datalen:
%       if datalen is scalar, it means read data from 1 to datalen
%       if datalen is a two-element vector, it means read data from datalen(1) to datalen(2)
%
% For example:
% Read data from 10th channel in d:\ep_50015.tdms.
% >> data = tdmsreader('d:\EP_50015.tdms', 10, [1e5 2e5]);
%
%The format of TDMS file is descripted by NI:
% http://www.ni.com/white-paper/5696/en/
%
% See also:
%  tdmsinfo

% Copyright (c) CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2014
% Author: lantao
% Email: lantao@ustc.edu.cn
% All Rights Reserved.
% $Revision: 1.0$ Created on: 16-March-2014 16:04:10

% Obtain the structure of tdms file at first
[Root, Group, Channels] = tdmsinfo(tdmsfilename);

% Display current channel information
disp(['ChannelName: ' Channels(channel).NI_ChannelName]);
disp(['SampleTime(Sec): ' num2str(Channels(channel).wf_increment)]);
disp(['DAQTime(yyyy-mm-dd hh:MM:SS.FFF): ' Channels(channel).DAQTime]);

% open tdms file
fid = fopen(tdmsfilename,'r', Root.EndianType);
if fid <0
    error(['Can''t open ' tdmsfilename]);
end

% check datalen
if isscalar(datalen)
    datarange(1) = 1;
    datarange(2) = datalen;
elseif length(datalen)==2
    datarange = datalen;
elseif strcmpi(datalen,'all')
    datarange(1) = 1;
    datarange(2) = Channels(channel).TotalLength;
else
    error('Datalen should be a number or two-element array.')
end

CurrentChnl = Channels(channel);
% Scale Polynominal Coefficients
Coef(1) = CurrentChnl.NI_Scale_1__Polynomial_Coefficients_0_;
Coef(2) = CurrentChnl.NI_Scale_1__Polynomial_Coefficients_1_;
Coef(3) = CurrentChnl.NI_Scale_1__Polynomial_Coefficients_2_;
Coef(4) = CurrentChnl.NI_Scale_1__Polynomial_Coefficients_3_;



if datarange(2) > CurrentChnl.TotalLength
    datarange(2) = CurrentChnl.TotalLength;
    disp(['Datarange(2) exceeds range (' num2str(datarange(2)) '>' num2str(CurrentChnl.TotalLength) '). Set the datarange(2) as last sample.'])
    disp(['Datarange(2)=' num2str(datarange(2))]);
end


totaldatalen = datarange(2)-datarange(1)+1;
data = zeros(totaldatalen, 1);


if datarange(2) > CurrentChnl.DataLength
    if datarange(1) >  CurrentChnl.DataLength
        % case 3
        SecondDataRange(1) = datarange(1) - CurrentChnl.DataLength;
        SecondDataRange(2) = datarange(2) - CurrentChnl.DataLength;
        
        datarange(1) = 0;
        datarange(2) = 0;
        
        totaldatalen = 0;
    else
        % case 2
        SecondDataRange(1) = 1;
        SecondDataRange(2) = datarange(2) - CurrentChnl.DataLength;
        datarange(2) = CurrentChnl.DataLength;
        totaldatalen = datarange(2)-datarange(1)+1;
    end
else
    % case 1
    SecondDataRange(1) = 0;
    SecondDataRange(2) = 0;
end


% case 1 and case 2
if totaldatalen > 0
    
    BeginBlockPos = floor(datarange(1)/CurrentChnl.BlockLength)+1;
    EndBlockPos = floor(datarange(2)/CurrentChnl.BlockLength)+1;
    
    % move file pointer to the start of raw data
    fseek(fid, Root.RawDataOffset+28, 'bof');
    fseek(fid, (BeginBlockPos-1)*CurrentChnl.BlockLength*(sum(CurrentChnl.ChnlArrayDim(:))),'cof');
    
    % the begin and end points are in the same block
    if BeginBlockPos == EndBlockPos
        MoveOffset = 0;
        for ii=1:CurrentChnl.BlockArrayDim1
            MoveOffset = MoveOffset + CurrentChnl.BlockLength*CurrentChnl.ChnlArrayDim(ii);
        end
        fseek(fid, MoveOffset, 'cof');
        fseek(fid, CurrentChnl.ChnlArrayDim(CurrentChnl.BlockArrayDim1+1)*(datarange(1)-(BeginBlockPos-1)*CurrentChnl.BlockLength-1), 'cof');
        fseek(fid, CurrentChnl.BlockArrayDim2, 'cof');
        data(1:totaldatalen) = fread(fid, totaldatalen, 'int16', CurrentChnl.ChnlArrayDim(CurrentChnl.BlockArrayDim1+1)-2, Root.EndianType);
        
        % scale with coefficients
        rawdata = data;
        data = TDMSscale(rawdata, Coef, 4);
        
        % Close file
        fclose(fid);
        return;
    end
    
    
    % The begin and end point are not in the same block
    % first block
    firstblocklen = CurrentChnl.BlockLength*BeginBlockPos - datarange(1) +1;
    
    MoveOffset = 0;
    for ii=1:CurrentChnl.BlockArrayDim1
        MoveOffset = MoveOffset + CurrentChnl.BlockLength*CurrentChnl.ChnlArrayDim(ii);
    end
    fseek(fid, MoveOffset, 'cof');
    fseek(fid, CurrentChnl.ChnlArrayDim(CurrentChnl.BlockArrayDim1+1)*(datarange(1)-(BeginBlockPos-1)*CurrentChnl.BlockLength-1), 'cof');
    fseek(fid, CurrentChnl.BlockArrayDim2, 'cof');
    data(1:firstblocklen) = fread(fid, firstblocklen, 'int16', CurrentChnl.ChnlArrayDim(CurrentChnl.BlockArrayDim1+1)-2, Root.EndianType);
    
    MoveOffset = 0;
    for ii=CurrentChnl.BlockArrayDim1+2:CurrentChnl.TotalCardNum
        MoveOffset = MoveOffset + CurrentChnl.BlockLength*CurrentChnl.ChnlArrayDim(ii);
    end
    fseek(fid, MoveOffset, 'cof');
    
    % Inter block
    for iBlock = BeginBlockPos+1 : EndBlockPos-1
        MoveOffset = 0;
        for ii=1:CurrentChnl.BlockArrayDim1
            MoveOffset = MoveOffset + CurrentChnl.BlockLength*CurrentChnl.ChnlArrayDim(ii);
        end
        fseek(fid, MoveOffset, 'cof');
        
        index = (iBlock-BeginBlockPos-1)*CurrentChnl.BlockLength+firstblocklen+1:(iBlock-BeginBlockPos)*CurrentChnl.BlockLength+firstblocklen;
        data(index) = fread(fid, CurrentChnl.BlockLength, 'int16', CurrentChnl.ChnlArrayDim(CurrentChnl.BlockArrayDim1+1)-2, Root.EndianType);
        
        MoveOffset = 0;
        for ii=CurrentChnl.BlockArrayDim1+2:CurrentChnl.TotalCardNum
            MoveOffset = MoveOffset + CurrentChnl.BlockLength*CurrentChnl.ChnlArrayDim(ii);
        end
        fseek(fid, MoveOffset, 'cof');
    end
    
    % Last block
    HaveReadDataLen = firstblocklen + (EndBlockPos-BeginBlockPos-1)*CurrentChnl.BlockLength;
    lastblocklen = totaldatalen - HaveReadDataLen;
    
    if lastblocklen~=0
        MoveOffset = 0;
        for ii=1:CurrentChnl.BlockArrayDim1
            MoveOffset = MoveOffset + CurrentChnl.BlockLength*CurrentChnl.ChnlArrayDim(ii);
        end
        fseek(fid, MoveOffset, 'cof');
        
        data(HaveReadDataLen:totaldatalen) = fread(fid, lastblocklen, 'int16', CurrentChnl.ChnlArrayDim(CurrentChnl.BlockArrayDim1+1)-2, Root.EndianType);
    end
    
    
    % deal with second segement
    if SecondDataRange(1) > 0
        RestDatalen = SecondDataRange(2) - SecondDataRange(1) + 1;
        fseek(fid, 28 + Root.NextSegOffset + 28 + Root.RawDataOffset2,'bof');
        MoveOffset = 0;
        for ii=1:CurrentChnl.SecondBlockArrayDim1
            MoveOffset = MoveOffset + CurrentChnl.SecondBlockLength*CurrentChnl.SecondChnlArrayDim(ii);
        end
        fseek(fid, MoveOffset, 'cof');
        fseek(fid, CurrentChnl.SecondBlockArrayDim2, 'cof');
        data((1:RestDatalen)+totaldatalen) = fread(fid, RestDatalen, 'int16', CurrentChnl.SecondChnlArrayDim(CurrentChnl.SecondBlockArrayDim1+1)-2, Root.EndianType);
    end
    
    % case 1 and case 2 end
else
    % case 3
    if totaldatalen~=0
        fclose(fid);
        error('Case 3')
    end
    RestDatalen = SecondDataRange(2) - SecondDataRange(1) + 1;
    fseek(fid, 28 + Root.NextSegOffset + 28 + Root.RawDataOffset2,'bof');
    MoveOffset = 0;
    for ii=1:CurrentChnl.SecondBlockArrayDim1
        MoveOffset = MoveOffset + CurrentChnl.SecondBlockLength*CurrentChnl.SecondChnlArrayDim(ii);
    end
    fseek(fid, MoveOffset, 'cof');
    fseek(fid, CurrentChnl.SecondBlockArrayDim2, 'cof');
    fseek(fid, CurrentChnl.SecondChnlArrayDim(CurrentChnl.SecondBlockArrayDim1+1)*(SecondDataRange(1)-1), 'cof');
    data((1:RestDatalen)+totaldatalen) = fread(fid, RestDatalen, 'int16', CurrentChnl.SecondChnlArrayDim(CurrentChnl.SecondBlockArrayDim1+1)-2, Root.EndianType);
    % case 3 end
end

% scale with coefficients
rawdata = data;
data = TDMSscale(rawdata, Coef, 4);

% close file
fclose(fid);

function data = TDMSscale(rawdata, Coef, n)
% n-order Polynomial Scale
data = Coef(1);
for ii=2:n
    data = data + Coef(ii)*rawdata.^(ii-1);
end
end
end
% data = Coef(1) + Coef(2)*rawdata + Coef(3)*rawdata.^2 + Coef(4)*rawdata.^3;


