function HI_readStimulusFileHEKA(obj,Level)
%
% extracts data stored in the "*.pgf" file, or the corresponding portion of
% the bundled ".dat" file
%
%% See also	HEKA_Importer
% 			HEKA_Importer.HI_loadHEKAFile
% 			HEKA_Importer.HI_extractHEKASolutionTree
% 			HEKA_Importer.HI_extractHEKAStimTree
% 			HEKA_Importer.HI_extractHEKADataTree
%			HEKA_Importer.HI_readPulseFileHEKA
%			HEKA_Importer.HI_readStimulusFileHEKA
%			HEKA_Importer.HI_readAmplifierFileHEKA
%			HEKA_Importer.HI_readSolutionFileHEKA

%--------------------------------------------------------------------------
% Gets one record of the tree and the number of children
s = getOneStimRecord(obj,Level);
obj.opt.fileData.Tree{obj.opt.fileData.Counter, Level+1} = s;
obj.opt.fileData.Position = obj.opt.fileData.Position+obj.opt.fileData.Sizes(Level+1);
fseek(obj.opt.fileData.fh, obj.opt.fileData.Position, 'bof');
obj.opt.fileData.nchild=fread(obj.opt.fileData.fh, 1, 'int32=>int32');
obj.opt.fileData.Position=ftell(obj.opt.fileData.fh);
end


%--------------------------------------------------------------------------
function rec=getOneStimRecord(obj,Level)
%--------------------------------------------------------------------------
% Gets one record
obj.opt.fileData.Counter = obj.opt.fileData.Counter+1;
switch Level
	case 0
		rec=getStimRoot(obj);
	case 1
		rec=getStimulation(obj);
	case 2
		rec=getChannel(obj);
	case 3
		rec=getStimSegment(obj);
	otherwise
		error('Unexpected Level');
end

end

% The functions below return data as defined by the HEKA PatchMaster
% specification

%--------------------------------------------------------------------------
function p=getStimRoot(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

p.RoVersion				= fread(fh, 1, 'int32=>int32');%			=   0; (* INT32 *)
p.RoMark				= fread(fh, 1, 'int32=>int32');%            =   4; (* INT32 *)
p.RoVersionName			= deblank(fread(fh, 32, 'uint8=>char')');%  =   8; (* String32Type *)
p.RoMaxSamples			= fread(fh, 1, 'int32=>int32'); %			=  40; (* INT32 *)
p.RoFiller1				= fread(fh, 1, 'int32=>int32');%			= 44; (* INT32 *)
p.RoParams				= fread(fh, 10, 'double=>double');%         =  48; (* ARRAY[0..9] OF LONGREAL *)
for k=1:10
	p.RoParamText{k}=deblank(fread(fh, 32, 'uint8=>char')');%       = 128; (* ARRAY[0..9],[0..31]OF CHAR *)
end
p.RoReserved			=  fread(fh, 32, 'int32=>int32');%          = 448; (* INT32 *)
p.RoFiller2				= fread(fh, 1, 'int32=>int32');%			= 576; (* INT32 *)
p.RoCRC					= fread(fh, 1, 'int32=>int32');%            = 580; (* CARD32 *)
p.RootRecSize			= 584; %									(* = 73 * 8 *)
p=orderfields(p);

end

%--------------------------------------------------------------------------
function s=getStimulation(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

% Stimulus level
s.stMark				= fread(fh, 1, 'int32=>int32');%				=   0; (* INT32 *)
s.stEntryName			= deblank(fread(fh, 32, 'uint8=>char')');%      =   4; (* String32Type *)
s.stFileName			= deblank(fread(fh, 32, 'uint8=>char')');%      =  36; (* String32Type *)
s.stAnalName			= deblank(fread(fh, 32, 'uint8=>char')');%      =  68; (* String32Type *)
s.stDataStartSegment	= fread(fh, 1, 'int32=>int32');%				= 100; (* INT32 *)
s.stDataStartTime		= fread(fh, 1, 'double=>double') ;%				= 104; (* LONGREAL *)
s.stDataStartTimeMATLAB = obj.HI_time2date(s.stDataStartTime);
s.stSampleInterval		= fread(fh, 1, 'double=>double') ;%				= 112; (* LONGREAL *)
s.stSweepInterval		= fread(fh, 1, 'double=>double') ;%				= 120; (* LONGREAL *)
s.stLeakDelay			= fread(fh, 1, 'double=>double') ;%				= 128; (* LONGREAL *)
s.stFilterFactor		= fread(fh, 1, 'double=>double') ;%				= 136; (* LONGREAL *)
s.stNumberSweeps		= fread(fh, 1, 'int32=>int32');%				= 144; (* INT32 *)
s.stNumberLeaks			= fread(fh, 1, 'int32=>int32');%				= 148; (* INT32 *)
s.stNumberAverages		= fread(fh, 1, 'int32=>int32');%				= 152; (* INT32 *)
s.stActualAdcChannels	= fread(fh, 1, 'int32=>int32');%				= 156; (* INT32 *)
s.stActualDacChannels	= fread(fh, 1, 'int32=>int32');%				= 160; (* INT32 *)
s.stExtTrigger			= fread(fh, 1, 'uint8=>uint8');%				= 164; (* BYTE *)
s.stNoStartWait			= fread(fh, 1, 'uint8=>logical');%				= 165; (* BOOLEAN *)
s.stUseScanRates		= fread(fh, 1, 'uint8=>logical');%				= 166; (* BOOLEAN *)
s.stNoContAq			= fread(fh, 1, 'uint8=>logical');%				= 167; (* BOOLEAN *)
s.stHasLockIn			= fread(fh, 1, 'uint8=>logical');%				= 168; (* BOOLEAN *)
s.stOldStartMacKind		= fread(fh, 1, 'uint8=>char');%					= 169; (* CHAR *)
s.stOldEndMacKind		= fread(fh, 1, 'uint8=>logical');%				= 170; (* BOOLEAN *)
s.stAutoRange			= fread(fh, 1, 'uint8=>uint8');%				= 171; (* BYTE *)
s.stBreakNext			= fread(fh, 1, 'uint8=>logical');%				= 172; (* BOOLEAN *)
s.stIsExpanded			= fread(fh, 1, 'uint8=>logical');%				= 173; (* BOOLEAN *)
s.stLeakCompMode		= fread(fh, 1, 'uint8=>logical');%				= 174; (* BOOLEAN *)
s.stHasChirp			= fread(fh, 1, 'uint8=>logical');%				= 175; (* BOOLEAN *)
s.stOldStartMacro		= deblank(fread(fh, 32, 'uint8=>char')');%		= 176; (* String32Type *)
s.stOldEndMacro			= deblank(fread(fh, 32, 'uint8=>char')');%		= 208; (* String32Type *)
s.sIsGapFree			= fread(fh, 1, 'uint8=>logical');%				= 240; (* BOOLEAN *)
s.sHandledExternally	= fread(fh, 1, 'uint8=>logical');%				= 241; (* BOOLEAN *)
	s.stFiller1			= fread(fh, 1, 'uint8=>logical');%				= 242; (* BOOLEAN *)
	s.stFiller2			= fread(fh, 1, 'uint8=>logical');%				= 243; (* BOOLEAN *)
s.stCRC					= fread(fh, 1, 'int32=>int32'); %               = 244; (* CARD32 *)
s.StimulationRecSize	= 248;%										   (* = 35 * 8 *)

s=orderfields(s);

end

%--------------------------------------------------------------------------
function c=getChannel(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

c.chMark				= fread(fh, 1, 'int32=>int32');%				=   0; (* INT32 *)
c.chLinkedChannel		= fread(fh, 1, 'int32=>int32');%				=   4; (* INT32 *)
c.chCompressionFactor	= fread(fh, 1, 'int32=>int32');%				=   8; (* INT32 *)
c.chYUnit				= deblank(fread(fh, 8, 'uint8=>char')');%       =  12; (* String8Type *)
c.chAdcChannel			= fread(fh, 1, 'int16=>int16');%				=  20; (* INT16 *)
c.chAdcMode				= fread(fh, 1, 'uint8=>uint8');%				=  22; (* BYTE *)
c.chDoWrite				= fread(fh, 1, 'uint8=>logical');%           	=  23; (* BOOLEAN *)
c.stLeakStore			= fread(fh, 1, 'uint8=>uint8');%				=  24; (* BYTE *)
c.chAmplMode			= fread(fh, 1, 'uint8=>uint8');%				=  25; (* BYTE *)
c.chOwnSegTime			= fread(fh, 1, 'uint8=>logical');%				=  26; (* BOOLEAN *)
c.chSetLastSegVmemb		= fread(fh, 1, 'uint8=>logical');%				=  27; (* BOOLEAN *)
c.chDacChannel			= fread(fh, 1, 'int16=>int16');%				=  28; (* INT16 *)
c.chDacMode				= fread(fh, 1, 'uint8=>uint8');%				=  30; (* BYTE *)
c.chHasLockInSquare		= fread(fh, 1, 'uint8=>uint8');%				=  31; (* BYTE *)
c.chRelevantXSegment	= fread(fh, 1, 'int32=>int32');%				=  32; (* INT32 *)
c.chRelevantYSegment	= fread(fh, 1, 'int32=>int32');%				=  36; (* INT32 *)
c.chDacUnit				= deblank(fread(fh, 8, 'uint8=>char')');%       =  40; (* String8Type *)
c.chHolding				= fread(fh, 1, 'double=>double') ;%				=  48; (* LONGREAL *)
c.chLeakHolding			= fread(fh, 1, 'double=>double') ;%				=  56; (* LONGREAL *)
c.chLeakSize			= fread(fh, 1, 'double=>double') ;%				=  64; (* LONGREAL *)
c.chLeakHoldMode		= fread(fh, 1, 'uint8=>uint8');%				=  72; (* BYTE *)
c.chLeakAlternate		= fread(fh, 1, 'uint8=>logical');%				=  73; (* BOOLEAN *)
c.chAltLeakAveraging	= fread(fh, 1, 'uint8=>logical');%				=  74; (* BOOLEAN *)
c.chLeakPulseOn			= fread(fh, 1, 'uint8=>logical');%				=  75; (* BOOLEAN *)
c.chStimToDacID			= fread(fh, 1, 'int16=>int16');%				=  76; (* SET16 *)
c.chCompressionMode		= fread(fh, 1, 'int16=>int16');%				=  78; (* SET16 *)
c.chCompressionSkip		= fread(fh, 1, 'int32=>int32');%				=  80; (* INT32 *)
c.chDacBit				= fread(fh, 1, 'int16=>int16');%            	=  84; (* INT16 *)
c.chHasLockInSine		= fread(fh, 1, 'uint8=>logical');%				=  86; (* BOOLEAN *)
c.chBreakMode			= fread(fh, 1, 'uint8=>uint8');%				=  87; (* BYTE *)
c.chZeroSeg				= fread(fh, 1, 'int32=>int32');%				=  88; (* INT32 *)
c.chStimSweep			= fread(fh, 1, 'int32=>int32');%				=  92; (* INT32 *)
c.chSine_Cycle			= fread(fh, 1, 'double=>double') ;%				=  96; (* LONGREAL *)
c.chSine_Amplitude		= fread(fh, 1, 'double=>double') ;%				= 104; (* LONGREAL *)
c.chLockIn_VReversal	= fread(fh, 1, 'double=>double') ;%				= 112; (* LONGREAL *)
c.chChirp_StartFreq		= fread(fh, 1, 'double=>double') ;%				= 120; (* LONGREAL *)
c.chChirp_EndFreq		= fread(fh, 1, 'double=>double') ;%				= 128; (* LONGREAL *)
c.chChirp_MinPoints		= fread(fh, 1, 'double=>double') ;%				= 136; (* LONGREAL *)
c.chSquare_NegAmpl		= fread(fh, 1, 'double=>double') ;%				= 144; (* LONGREAL *)
c.chSquare_DurFactor	= fread(fh, 1, 'double=>double') ;%				= 152; (* LONGREAL *)
c.chLockIn_Skip			= fread(fh, 1, 'int32=>int32');%				= 160; (* INT32 *)
c.chPhoto_MaxCycles		= fread(fh, 1, 'int32=>int32');%				= 164; (* INT32 *)
c.chPhoto_SegmentNo		= fread(fh, 1, 'int32=>int32');%				= 168; (* INT32 *)
c.chLockIn_AvgCycles	= fread(fh, 1, 'int32=>int32');%				= 172; (* INT32 *)
c.chImaging_RoiNo		= fread(fh, 1, 'int32=>int32');%				= 176; (* INT32 *)
c.chChirp_Skip			= fread(fh, 1, 'int32=>int32');%				= 180; (* INT32 *)
c.chChirp_Amplitude		= fread(fh, 1, 'double=>double');%				= 184; (* LONGREAL *)
c.chPhoto_Adapt			= fread(fh, 1, 'uint8=>uint8');%				= 192; (* BYTE *)
c.chSine_Kind			= fread(fh, 1, 'uint8=>uint8');%				= 193; (* BYTE *)
c.chChirp_PreChirp		= fread(fh, 1, 'uint8=>uint8');%				= 194; (* BYTE *)
c.chSine_Source			= fread(fh, 1, 'uint8=>uint8');%				= 195; (* BYTE *)
c.chSquare_NegSource	= fread(fh, 1, 'uint8=>uint8');%				= 196; (* BYTE *)
c.chSquare_PosSource	= fread(fh, 1, 'uint8=>uint8');%				= 197; (* BYTE *)
c.chChirp_Kind			= fread(fh, 1, 'uint8=>uint8');%				= 198; (* BYTE *)
c.chChirp_Source		= fread(fh, 1, 'uint8=>uint8');%				= 199; (* BYTE *)
c.chDacOffset			= fread(fh, 1, 'double=>double') ;%				= 200; (* LONGREAL *)
c.chAdcOffset			= fread(fh, 1, 'double=>double') ;%				= 208; (* LONGREAL *)
c.chTraceMathFormat		= fread(fh, 1, 'uint8=>uint8');%				= 216; (* BYTE *)
c.chHasChirp			= fread(fh, 1, 'uint8=>logical');%				= 217; (* BOOLEAN *)
c.chSquare_Kind			= fread(fh, 1, 'uint8=>uint8');%				= 218; (* BYTE *)
	c.chFiller1			= fread(fh, 5, 'uint8=>char');%					= 219; (* ARRAY[0..5] OF CHAR *)
c.chSquare_BaseIncr		= fread(fh, 1, 'double=>double');%				= 224; (* LONGREAL *)
c.chSquare_Cycle		= fread(fh, 1, 'double=>double') ;%				= 232; (* LONGREAL *)
c.chSquare_PosAmpl		= fread(fh, 1, 'double=>double') ;%				= 240; (* LONGREAL *)
c.chCompressionOffset	= fread(fh, 1, 'int32=>int32');%				= 248; (* INT32 *)
c.chPhotoMode			= fread(fh, 1, 'int32=>int32');%				= 252; (* INT32 *)
c.chBreakLevel			= fread(fh, 1, 'double=>double') ;%				= 256; (* LONGREAL *)
c.chTraceMath			= deblank(fread(fh,128,'uint8=>char')');%       = 264; (* String128Type *)
c.chOldCRC				= fread(fh, 1, 'int32=>int32');%                = 268; (* CARD32 *)
	c.chFiller2			= fread(fh, 1, 'int32=>int32');%				= 392; (* INT32 *)
c.chCRC					= fread(fh, 1, 'int32=>int32');%                = 396; (* CARD32 *)
c.ChannelRecSize        = 400;%											(* = 50 * 8 *)
c=orderfields(c);

end

%--------------------------------------------------------------------------
function ss=getStimSegment(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

ss.seMark				= fread(fh, 1, 'int32=>int32');%		=   0; (* INT32 *)
ss.seClass				= fread(fh, 1, 'uint8=>uint8');%        =   4; (* BYTE *)
ss.seDoStore			= fread(fh, 1, 'uint8=>logical');%      =   5; (* BOOLEAN *)
ss.seVoltageIncMode		= fread(fh, 1, 'uint8=>uint8');%		=   6; (* BYTE *)
ss.seDurationIncMode	= fread(fh, 1, 'uint8=>uint8');%		=   7; (* BYTE *)
ss.seVoltage			= fread(fh, 1, 'double=>double');%      =   8; (* LONGREAL *)
ss.seVoltageSource		= fread(fh, 1, 'int32=>int32');%		=  16; (* INT32 *)
ss.seDeltaVFactor		= fread(fh, 1, 'double=>double');%      =  20; (* LONGREAL *)
ss.seDeltaVIncrement	= fread(fh, 1, 'double=>double');%		=  28; (* LONGREAL *)
ss.seDuration			= fread(fh, 1, 'double=>double');%      =  36; (* LONGREAL *)
ss.seDurationSource		= fread(fh, 1, 'int32=>int32');%		=  44; (* INT32 *)
ss.seDeltaTFactor		= fread(fh, 1, 'double=>double');%      =  48; (* LONGREAL *)
ss.seDeltaTIncrement	= fread(fh, 1, 'double=>double');%		=  56; (* LONGREAL *)
ss.seFiller1			= fread(fh, 1, 'int32=>int32');%        =  64; (* INT32 *)
ss.seCRC				= fread(fh, 1, 'int32=>int32');%        =  68; (* CARD32 *)
ss.seScanRate			= fread(fh, 1, 'double=>double');%      =  72; (* LONGREAL *)
ss.StimSegmentRecSize   = 80;%										   (* = 10 * 8 *)
ss=orderfields(ss);

end
