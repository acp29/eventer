function obj=HI_ImportHEKAtoMat(obj)
% ImportHEKA imports HEKA PatchMaster and ChartMaster .DAT files
% Filepath is taken from the input object.
%
% ImportHEKA has been tested with Windows generated .DAT files on Windows,
% Linux and Mac OS10.4.
%
% Both bundled and unbundled data files are supported. If your files are
% unbundled, they must all be in the same folder.
%
% Details of the HEKA file format are available from
%       ftp://server.hekahome.de/pub/FileFormat/Patchmasterv9/
%
%--------------------------------------------------------------------------
% Author: Malcolm Lidierth 12/09
% Copyright © The Author & King's College London 2009-
%--------------------------------------------------------------------------

% Revisions
% 17.04.10  TrXUnit: see within
% 28.11.11  TrXUnit: see within
% 15.08.12  Updated to support interleaved channels and PatchMaster 2.60
%               files dated 24-Jan-2011 onwards.
% 19.05.13 Modified by Samata Katta to output Matlab variable containing data
% 12.08.15 Don't save *.kcl file (line 793 commented out).
% 03.07.17 Modified by Samata Katta to read in stimulus parameters from
% .pgf section of .dat file.
% 01.01.2019 Modified by Christian Keine to read solution parameters from
% .sol section of .dat file.
% 04.02.2019: combine readout of dataTree, stimTree and solTree.
%
% See also	HEKA_Importer
% 			HEKA_Importer.HI_loadHEKAFile
% 			HEKA_Importer.HI_extractHEKASolutionTree
% 			HEKA_Importer.HI_extractHEKAStimTree
% 			HEKA_Importer.HI_extractHEKADataTree
%			HEKA_Importer.HI_readPulseFileHEKA
%			HEKA_Importer.HI_readStimulusFileHEKA
%			HEKA_Importer.HI_readAmplifierFileHEKA
%			HEKA_Importer.HI_readSolutionFileHEKA


[pathname, filename, ext]=fileparts(obj.opt.filepath);

% Open file and get bundle header. Assume little-endian to begin with
endian='ieee-le';
fh=fopen(obj.opt.filepath, 'r', endian);
[bundle, littleendianflag, isBundled]=getBundleHeader(fh);

% Big endian so repeat process
if ~isempty(littleendianflag) && littleendianflag==false
	fclose(fh);
	endian='ieee-be';
	fh=fopen(obj.opt.filepath, 'r', endian);
	bundle=getBundleHeader(fh);
end

%% GET DATA, STIM AND SOLUTION TREE

fileExt = {'.pul','.pgf','.sol','.amp'};
treeName = {'dataTree','stimTree','solTree','ampTree'};

for iidx = fileExt
	fileExist = true;
	if isBundled
		%     ext = {'.dat','.pul','.pgf','.amp','.sol',[],[],'.mrk','.mth','.onl'};
		ext={bundle.oBundleItems.oExtension};
		% Find the section of the dat file
		idx=strcmp(iidx, ext);%15.08.2012 - change from strmatch
		if any(idx) % check if section exists, e.g. will be empty when solution base was not active during recordings
			start=bundle.oBundleItems(idx).oStart;
		else
			fileExist = false;
		end
	else
		% Or open pulse file if not bundled
		fclose(fh);
		start=0;
		fh=fopen(fullfile(pathname, [filename, iidx{1}]), 'r', endian);
		if fh<0
			fileExist = false;
		end
	end
	
	% READ OUT TREE
	if fileExist
		fseek(fh, start, 'bof');
		Magic = fread(fh, 4, 'uint8=>char');
		Levels=fread(fh, 1, 'int32=>int32');
		Sizes=fread(fh, double(Levels), 'int32=>int32');
		Position=ftell(fh);
		
		% Get the tree structures form the file sections
		obj.opt.fileData.fh = fh;
		obj.opt.fileData.Sizes = Sizes;
		obj.opt.fileData.Position = Position;
		obj.opt.fileData.fileExt = iidx{1};
		
		obj.trees.(treeName{strcmp(iidx, fileExt)})=getTree(obj);
		
	else
		obj.trees.(treeName{strcmp(iidx, fileExt)}) = [];
	end
end

% clean-up remaining temporary data
try
	obj.opt.fileData = rmfield(obj.opt.fileData,{'Sizes','Position','fileExt','Counter','Tree','Level','nchild'});
catch
end

%% GET DATA
if isBundled
	% Set offset for data
	idx=strcmp('.dat', ext);%15.08.2012 - change from strmatch
	start=bundle.oBundleItems(idx).oStart;
else
	% Or open data file if not bundled
	fclose(fh);
	fh=fopen(obj.opt.filepath, 'r', endian);
	start=bundle.BundleHeaderSize;
end

% Now set pointer to the start of the data the data
fseek(fh, start, 'bof');

% Get the group headers into a structure array
ngroup=1;
for k=1:size(obj.trees.dataTree,1)
	if ~isempty(obj.trees.dataTree{k, 2})
		grp_row(ngroup)=k;  %#ok<AGROW>
		ngroup=ngroup+1;
	end
end

% ADD MINIMUM RANDOM NUMBER TO AVOID DISCRETIZATION; ADD TO ALL CHANNELS
addEPS = @(x) x+randn(size(x))*eps;

% For each group
matData2 = cell(numel(grp_row),1);
dataRaw = cell(numel(grp_row),1);

for iGr = 1:numel(grp_row)
	matData2{iGr}=LocalImportGroup(fh, obj.trees.dataTree, iGr, grp_row);
	
	for iSer = 1:numel(matData2{iGr})
		dataRaw{iGr,:}{iSer,:} = cellfun(addEPS,matData2{iGr}{iSer},'UniformOutput',false);
	end
	
end

obj.RecTable.dataRaw = vertcat(dataRaw{:});
obj.RecTable = struct2table(obj.RecTable);
end

%--------------------------------------------------------------------------
function [h, littleendianflag, isBundled]=getBundleHeader(fh)
%--------------------------------------------------------------------------
% Get the bundle header from a HEKA .dat file
fseek(fh, 0, 'bof');
h.oSignature=deblank(fread(fh, 8, 'uint8=>char')');
switch h.oSignature
	case 'DATA'
		% Old format: nothing to do
		h.oVersion=[];
		h.oTime=[];
		h.oItems=[];
		h.oIsLittleEndian=[];
		h.oBundleItems(1:12)=[];
		h.BundleHeaderSize=0;
		isBundled=false;
	case {'DAT1' 'DAT2'}
		% Newer format
		h.oVersion			= fread(fh, 32,'uint8=>char')';
		h.oTime				= fread(fh, 1, 'double');
		h.oItems			= fread(fh, 1, 'int32=>int32');
		h.oIsLittleEndian	= fread(fh, 1, 'uint8=>logical');
		h.BundleHeaderSize	= 256;
		switch h.oSignature
			case 'DAT1'
				h.oBundleItems=[];
				isBundled=false;
			case {'DAT2'}
				fseek(fh, 64, 'bof');
				for k=1:12
					h.oBundleItems(k).oStart		 = fread(fh, 1, 'int32=>int32');
					h.oBundleItems(k).oLength		 = fread(fh, 1, 'int32=>int32');
					h.oBundleItems(k).oExtension	 = deblank(fread(fh, 8, 'uint8=>char')');
					h.oBundleItems(k).BundleItemSize = 16;
				end
				isBundled=true;
		end
	otherwise
		error('This legacy file format is not supported');
end
littleendianflag=h.oIsLittleEndian;

end


%--------------------------------------------------------------------------
function Tree=getTree(obj)
%--------------------------------------------------------------------------
% Main entry point for loading tree

obj.opt.fileData.Counter = 0;
obj.opt.fileData.Tree = {};
obj.opt.fileData.Level = 0;

Tree = getTreeReentrant(obj,0);
end


function Tree=getTreeReentrant(obj,Level)
%--------------------------------------------------------------------------
% Recursive routine called from LoadTree

switch obj.opt.fileData.fileExt
	case '.pul'
		obj.HI_readPulseFileHEKA(Level);
	case '.pgf'
		obj.HI_readStimulusFileHEKA(Level);
	case '.sol'
		obj.HI_readSolutionFileHEKA(Level);
	case '.amp'
		obj.HI_readAmplifierFileHEKA(Level);

end

for k=1:double(obj.opt.fileData.nchild)
	getTreeReentrant(obj,Level+1);
end

Tree = obj.opt.fileData.Tree;




end



%--------------------------------------------------------------------------
function matData2=LocalImportGroup(fh, dataTree, grp, grp_row)
%--------------------------------------------------------------------------
% Create a structure for the series headers


% Pad the indices for last series of last group
grp_row(end+1)=size(dataTree,1);

% Collect the series headers and row numbers for this group into a
% structure array
[ser_row, nseries]=getSeriesHeaders(dataTree, grp_row, grp);

% Pad for last series
ser_row(nseries+1)=grp_row(grp+1);

dataoffsets=[];
% Create the channels

matData2 = cell(nseries,1);
for ser=1:nseries
	
	[sw_s, sw_row, nsweeps]=getSweepHeaders(dataTree, ser_row, ser);
	
	% Make sure the sweeps are in temporal sequence
	if any(diff(cell2mat({sw_s.SwTime}))<=0)
		% TODO: sort them if this can ever happen.
		% For the moment just throw an error
		error('Sweeps not in temporal sequence');
	end
	
	
	sw_row(nsweeps+1)=ser_row(ser+1);
	% Get the trace headers for this sweep
	[tr_row]=getTraceHeaders(dataTree, sw_row);
	
	
	for k=1:size(tr_row, 1)
		
		[tr_s, isConstantScaling, isConstantFormat, isFramed]=LocalCheckEntries(dataTree, tr_row, k);
		
		% TODO: Need a better way to do this
		% Check whether interleaving is supported with this file version
		% Note: HEKA added interleaving Jan 2011.
		% TrInterleaveSkip was previously in a filler block, so should always
		% be zero with older files.
		if tr_s(1).TrInterleaveSize>0 && tr_s(1).TrInterleaveSkip>0
			INTERLEAVE_SUPPORTED=true;
		else
			INTERLEAVE_SUPPORTED=false;
		end
		
		data=zeros(max(cell2mat({tr_s.TrDataPoints})), size(tr_row,2));
		
		for tr=1:size(tr_row,2)
			% Disc format
			[fmt, nbytes]=LocalFormatToString(tr_s(tr).TrDataFormat);
			% Always read into double
			readfmt=[fmt '=>double'];
			% Skip to start of the data
			fseek(fh, dataTree{tr_row(k,tr),5}.TrData, 'bof');
			% Store data offset for later error checks
			dataoffsets(end+1)=dataTree{tr_row(k,tr),5}.TrData; %#ok<AGROW>
			% Read the data
			if ~INTERLEAVE_SUPPORTED || dataTree{tr_row(k,tr),5}.TrInterleaveSize==0
				[data(1:dataTree{tr_row(k,tr),5}.TrDataPoints, tr)]=...
					fread(fh, double(dataTree{tr_row(k,tr),5}.TrDataPoints), readfmt);
			else
				offset=1;
				nelements= double(dataTree{tr_row(k,tr),5}.TrInterleaveSize/nbytes);
				for nread=1:floor(numel(data)/double(dataTree{tr_row(k,tr),5}.TrInterleaveSize/nbytes))
					[data(offset:offset+nelements-1), N]=fread(fh, nelements, readfmt);
					if (N<nelements)
						disp('End of file reached unexpectedly');
					end
					offset=offset+nelements;
					fseek(fh, double(dataTree{tr_row(k,tr),5}.TrInterleaveSkip-dataTree{tr_row(k,tr),5}.TrInterleaveSize), 'cof');
				end
			end
		end

		% Now scale the data to real world units
		% Note we also apply zero adjustment
		for col=1:size(data,2)
			data(:,col)=data(:,col)*tr_s(col).TrDataScaler+tr_s(col).TrZeroData;
		end
		
		matData2{ser,:}{k} = data;
		
	end
	
	
end

if numel(unique(dataoffsets))<numel(dataoffsets)
	warning('ImportHEKA:warning', 'This should never happen - please report to sigtool@kcl.ac.uk if you see this warning.');
	warning('ImportHEKA:multipleBlockRead', 'sigTOOL: Unexpected result: Some data blocks appear to have been read more then once');
end


end

%--------------------------------------------------------------------------
function [fmt, nbytes]=LocalFormatToString(n)
%--------------------------------------------------------------------------
switch n
	case 0
		fmt='int16';
		nbytes=2;
	case 1
		fmt='int32';
		nbytes=4;
	case 2
		fmt='single';
		nbytes=4;
	case 3
		fmt='double';
		nbytes=8;
end
return
end

% %--------------------------------------------------------------------------
% function [res, intflag]=LocalGetRes(fmt)
% %--------------------------------------------------------------------------
% switch fmt
% 	case {'int16' 'int32'}
% 		res=double(intmax(fmt))+double(abs(intmin(fmt)))+1;
% 		intflag=true;
% 	case {'single' 'double'}
% 		res=1;
% 		intflag=false;
% end
% return
% end

%--------------------------------------------------------------------------
function [ser_row, nseries]=getSeriesHeaders(tree, grp_row, grp)
%--------------------------------------------------------------------------
nseries=0;
for k=grp_row(grp)+1:grp_row(grp+1)-1
	if ~isempty(tree{k, 3})
% 		ser_s(nseries+1)=tree{k, 3}; %#ok<AGROW>
		ser_row(nseries+1)=k; %#ok<AGROW>
		nseries=nseries+1;
	end
end
return
end

%--------------------------------------------------------------------------
function [sw_s, sw_row, nsweeps]=getSweepHeaders(tree, ser_row, ser)
%--------------------------------------------------------------------------
nsweeps=0;
for k=ser_row(ser)+1:ser_row(ser+1)
	if ~isempty(tree{k, 4})
		sw_s(nsweeps+1)=tree{k, 4}; %#ok<AGROW>
		sw_row(nsweeps+1)=k; %#ok<AGROW>
		nsweeps=nsweeps+1;
	end
end
return
end

%--------------------------------------------------------------------------
function [tr_row, ntrace]=getTraceHeaders(tree, sw_row)
%--------------------------------------------------------------------------
ntrace=0;
m=1;
n=1;
for k=sw_row(1)+1:sw_row(end)
	if ~isempty(tree{k, 5})
		%tr_s(m,n)=tree{k, 5}; %#ok<NASGU>
		tr_row(m,n)=k;  %#ok<AGROW>
		ntrace=ntrace+1;
		m=m+1;
	else
		m=1;
		n=n+1;
	end
end
return
end


%--------------------------------------------------------------------------
function [tr_s, isConstantScaling, isConstantFormat, isFramed]=LocalCheckEntries(tree, tr_row, k)
%--------------------------------------------------------------------------
% Check units are the same for all traces
tr_s=[tree{tr_row(k, :),5}];


if numel(unique({tr_s.TrYUnit}))>1
	error('1002: Waveform units are not constant');
end

if numel(unique({tr_s.TrXUnit}))>1
	error('1003: Time units are not constant');
end

if numel(unique(cell2mat({tr_s.TrXInterval})))~=1
	error('1004: Unequal sample intervals');
end

% Other unexpected conditions - give user freedom to create these but warn
% about them
if numel(unique({tr_s.TrLabel}))>1
	warning('LocalCheckEntries:w2001', 'Different trace labels');
end

if numel(unique(cell2mat({tr_s.TrAdcChannel})))>1
	warning('LocalCheckEntries:w2002', 'Data collected from different ADC channels');
end

if numel(unique(cell2mat({tr_s.TrRecordingMode})))>1
	warning('LocalCheckEntries:w2003', 'Traces collected using different recording modes');
end

if numel(unique(cell2mat({tr_s.TrCellPotential})))>1
	warning('LocalCheckEntries:w2004', 'Traces collected using different Em');
end

% Check scaling factor is constant
ScaleFactor=unique(cell2mat({tr_s.TrDataScaler}));
if numel(ScaleFactor)==1
	isConstantScaling=true;
else
	isConstantScaling=false;
end


%... and data format
if numel(unique(cell2mat({tr_s.TrDataFormat})))==1
	isConstantFormat=true;
else
	isConstantFormat=false;
end

% Do we have constant epoch lengths and offsets?
if numel(unique(cell2mat({tr_s.TrDataPoints})))==1 &&...
		numel(unique(cell2mat({tr_s.TrTimeOffset })))==1
	isFramed=true;
else
	isFramed=false;
end
return
end

