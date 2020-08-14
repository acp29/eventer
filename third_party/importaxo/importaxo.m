function [data, time, meta] = importaxo(filename)
%==============================================================================
% IMPORTAXO
% Import Axograph (.axgx,.axgd) files to Matlab.
%
%   [data, time, meta] = importaxgx(filename)
%   [data, time, meta] = importaxgx() => opens a dialog box
%
% OUTPUTS
%   data        Cell array in which each column is data from a single episode.
%   time        Time vector.
%   meta        Meta data for imported file (see below for included info).
%
% INPUTS
%   filename    Filename, or list of filenames, to import.
%               If no filename is provided, a file-select dialog is opened.
%
% MJRusso 7/10/2014.  Modified from BJ/AM <importaxo.m>
%===============================================================================


%================================= Main ========================================

%If no filename provided, open dialog to select file
if nargin < 1
    [fn, pn] = uigetfile({'*.axgd;*.axgx','Axograph Files (.axgx,.axgd)';...
                          '*.*','All Files'}, ...
                          'Choose Axograph File to Import', ...
                          'MultiSelect','on');
    ext = '';
else
	[pn,fn,ext] = fileparts(filename);
end

if ~iscell(fn), fn = {fn}; end  % For PC <=> MAC compatibility

for iFn = 1:length(fn)
    %Indicate current file
	fprintf(1, ['Importing from ', fn{iFn}, '... ']);

    %Import file data, time, and metadata
	[data,time,meta] = importFromFile(fullfile(pn,[fn{iFn} ext]));

    %Get file stem and replace whitespace with underscore
    fparts = regexp(fn{iFn},'\.','split');
    fstem = fparts{1};
    ws = regexp(fstem,'\s');
    if ~isempty(ws)
        fstem(ws) = '_';
    end

    %Save data into new .mat file
	%save(fullfile(pn,fstem),'time','data','meta');
	%fprintf(1,'done.\n');
end

    %If no outputs defined, load vars to workspace for single file
    if nargout == 0 && length(fn) == 1
        assignin('base','time',time);
        assignin('base','data',data);
        assignin('base','meta',meta);
    end

end

%========================== Import Function ====================================

function [data, time, meta] = importFromFile(fn)
%Subfunction to read binary file. Details of .axgx file format:
%
% Byte		Format		Content
% 1-4		<char>		File type identifier (e.g. 'axgx');
% 5-8		<int32>		File version number (e.g. '6')
% 9-12		<int32>		Number of columns
% 13-16		<int32>		Number of elements in column
% 17-20		<int32>		Column type (see below)
% 21-24		<int32>		Number of bytes in column title (2*characters)
% 25-39		<char>		Column title, e.g. 'Time (s)' (each char preceded by null byte)
% 40-47		<double>	Sample interval (8-byte double)
% 48-55		<double>	Sample interval (8-byte double) Redundant?
% 56-59		<int32>		Number of elements in column
% 60-61		<int32>		Column type (see below)
% 62-63		<int32>		Number of bytes in column title (2*characters)
% 64-...	<char>		Column title
% ...		<datatype>	Data

%Open file for reading using little-endian encoding, by default
fid = fopen(fn,'r','ieee-le.l64');

meta.fileName   = fn;
meta.fileType   = fread(fid, 4, '*char')';
meta.fileVer    = fread(fid,1,'int32');

if meta.fileVer - swapbytes(meta.fileVer) >= 0
    %File is big-endian, close and reopen
    fclose(fid);
    fid = fopen(fn,'r','ieee-be.l64');
    meta.fileType = fread(fid,4,'*char');
    meta.fileVer = fread(fid,1,'int32');
end

meta.NDatCol    = fread(fid,1,'int32');
meta.nPoints    = fread(fid,1,'int32');
meta.XColType   = fread(fid,1,'int32');
meta.XTitleLen  = fread(fid,1,'int32');
meta.XTitle		= readtitle(fid,meta.XTitleLen);
meta.SampInt    = fread(fid,1,'double');
meta.SampInt2   = fread(fid,1,'double'); %Redundant in data file (2nd channel?)

data		  = cell(meta.NDatCol-1,1);
[data{:}]	  = deal(double(zeros(1,meta.nPoints)));
time          = double(1:meta.nPoints).*meta.SampInt;

for n = 1:(meta.NDatCol-1)
        meta.YDat(n,1).nPoints   = fread(fid,1,'int32');
        meta.YDat(n,1).YColType  = fread(fid,1,'int32');
        meta.YDat(n,1).YTitleLen = fread(fid,1,'int32');
        meta.YDat(n,1).YTitle    = readtitle(fid, meta.YDat(n).YTitleLen);

        switch meta.YDat(n).YColType
            case 4  % column type is short
                data{n,1} = double(fread(fid,meta.YDat(n).nPoints,'int16')');
            case 5  % column type is long
                data{n,1} = double(fread(fid,meta.YDat(n).nPoints,'int32')');
            case 6  % column type is float
                data{n,1} = double(fread(fid,meta.YDat(n).nPoints,'float')');
            case 7  % column type is double
                data{n,1} = double(fread(fid,meta.YDat(n).nPoints,'double')');
            case 9  % 'series'
                 data0 = fread(fid,2,'double');
                 data{n,1} = (1:1:meta.YDat(n).nPoints)*data0(2)+ data0(1);
            case 10 % 'scaled short'
                scale = fread(fid,1,'double');
                offset = fread(fid,1,'double');
                data0 = fread(fid,meta.YDat(n).nPoints,'int16')';
                data{n,1}  = double(data0)*scale + offset;
            otherwise
                fprintf(2,'Unknown data type: %s. Cannot continue reading the file',...
						num2str(meta.YDat(n).YColType));
        end
end

    %Acquisition settings - from additional ~1700 bytes
    ft = fread(fid,'int16=>char')';
    infoStart = regexp(ft,'--- Acquisition Settings ---','once');
    infoEnd = regexp(ft,'Inter-Pulse Interval Table Entries\s[\d+]','end','once');
    meta.Info = ft(infoStart:infoEnd);

    meta.Protocol = regexp(meta.Info,'Protocol\s:\s(\w+)\s','tokens','once');

    %Get acquisition channels
    meta.Channels = regexp(meta.Info,'Acquisition channels : "(.+)"','tokens','once');

    %Get number of episodes
    meta.NumEpisodes = regexp(meta.Info,'Episodes\s(\d+)\s','tokens','once');
    meta.NumEpisodes = str2num(meta.NumEpisodes{:});

    %Get number of pulses
    meta.NumPulses = regexp(meta.Info,'Pulses\s(\d+)\s','tokens','once');
    meta.NumPulses = str2num(meta.NumPulses{:});

    %Get pulse tables for protocol reconstruction
    %NOTE: Exact structure and meaning of protocol table unclear
    expProt = '(\s-?\d?\.?\d+){10,16}';
    meta.ProtocolTable = regexp(ft,expProt,'tokens');
    meta.ProtocolTable = cellfun(@(x) str2num(char(x)),meta.ProtocolTable,'UniformOutput',false);

    %Note: Remaining graph formatting information not read.
    %TODO: Read and parse entire remainder of file

    fclose(fid);

end


%============================== Subfunctions ===================================

function title = readtitle(fid,titlelen)
	str = fread(fid,titlelen,'*char')';
	title = str(~mod(1:titlelen,2));
end

