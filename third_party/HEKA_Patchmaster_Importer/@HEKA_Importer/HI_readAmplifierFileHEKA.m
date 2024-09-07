function HI_readAmplifierFileHEKA(obj,Level)

% extracts data stored in the "*.amp" file, or the corresponding portion of
% the bundled ".dat" file
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


%--------------------------------------------------------------------------
% Gets one record of the tree and the number of children

s = getOneAmplifierRecord(obj,Level);
obj.opt.fileData.Tree{obj.opt.fileData.Counter, Level+1} = s;

obj.opt.fileData.Position = obj.opt.fileData.Position+obj.opt.fileData.Sizes(Level+1);
fseek(obj.opt.fileData.fh, obj.opt.fileData.Position, 'bof');
obj.opt.fileData.nchild=fread(obj.opt.fileData.fh, 1, 'int32=>int32');
obj.opt.fileData.Position=ftell(obj.opt.fileData.fh);

end

%--------------------------------------------------------------------------
function rec=getOneAmplifierRecord(obj,Level)
%--------------------------------------------------------------------------
% Gets one record
obj.opt.fileData.Counter = obj.opt.fileData.Counter+1;
switch Level
	case 0
		rec=getAmplifierRootRecord(obj);
	case 1
		rec=getAmplifierSeriesRecord(obj);
	case 2
		rec=getAmplifierStateRecord(obj);	
	otherwise
		error('Unexpected Level');
end

end

%--------------------------------------------------------------------------
function p=getAmplifierRootRecord(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

p.RoVersion			= fread(fh, 1, 'int32=>int32');%			= 0; (* INT32 *)
p.RoMark			= fread(fh, 1, 'int32=>int32');%            =   4; (* INT32 *)
p.RoVersionName		= deblank(fread(fh, 32, 'uint8=>char')');%  =   8; (* String32Type *)
p.RoAmplifierName	= deblank(fread(fh, 32, 'uint8=>char')');%  =  40; (* String32Type *)
p.RoAmplifier		= fread(fh,1,'uint8=>uint8');%				=  72; (* CHAR *)
p.RoADBoard			= fread(fh,1,'uint8=>uint8');%				=  73; (* CHAR *)
p.RoCreator			= fread(fh,1,'uint8=>uint8');%				=  74; (* CHAR *)
	p.RoFiller1		= fread(fh, 1, 'uint8=>uint8');%			=  75; (* BYTE *)
p.RoCRC				= fread(fh, 1, 'int32=>int32');%	        =  76; (* CARD32 *)
p.RootRecSize       =  80;%											   (* = 10 * 8 *)

p=orderfields(p);

end

%--------------------------------------------------------------------------
function s=getAmplifierSeriesRecord(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

s.SeMark			= fread(fh, 1, 'int32=>int32');%           =   0; (* INT32 *)
s.SeSeriesCount		= fread(fh, 1, 'int32=>int32');%		   =   4; (* INT32 *)
s.SeFiller1			= fread(fh, 1, 'int32=>int32');%		   =   8; (* INT32 *)
s.SeCRC				= fread(fh, 1, 'int32=>int32');%		   =  12; (* CARD32 *)
s.SeriesRecSize     = 16;%											  (* = 2 * 8 *)

s=orderfields(s);

end

%--------------------------------------------------------------------------
function a=getAmplifierStateRecord(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

a.AmMark			= fread(fh, 1, 'int32=>int32');%            =   0; (* INT32 *)
a.AmStateCount		= fread(fh, 1, 'int32=>int32');%			=   4; (* INT32 *)
a.AmStateVersion	= fread(fh,1,'uint8=>uint8');%				=   8; (* CHAR *)
	a.AmFiller1		= fread(fh, 1, 'uint8=>uint8');%			=   9; (* BYTE *)
	a.AmFiller2		= fread(fh, 1, 'uint8=>uint8');%			=  10; (* BYTE *)
	a.AmFiller3		= fread(fh, 1, 'uint8=>uint8');%			=  11; (* BYTE *)
	a.AmFiller4		= fread(fh, 1, 'int32=>int32');%			=  12; (* INT32 *)
a.AmLockInParams	= getSeLockInParams(fh);%					=  16; (* LockInParamsSize = 96 *)
a.AmAmplifierState	= getAmplifierState(fh);%					= 112; (* AmplifierStateSize = 400 *)
a.AmIntSol			= fread(fh, 1, 'int32=>int32');%			= 512; (* INT32 *)
a.AmExtSol			= fread(fh, 1, 'int32=>int32');%		    = 516; (* INT32 *)
	a.AmFiller5		= fread(fh, 36, 'uint8=>uint8');%		    = 520; (* spares: 36 bytes *)
a.AmCRC				= fread(fh, 1, 'int32=>int32');%	        = 556; (* CARD32 *)
a.StateRecSize      = 560;%											   (* = 70 * 8 *)
	
a = orderfields(a);

end

function L=getSeLockInParams(fh)
%--------------------------------------------------------------------------
offset=ftell(fh);
L.loExtCalPhase			= fread(fh, 1, 'double=>double');%      =   0; (* LONGREAL *)
L.loExtCalAtten			= fread(fh, 1, 'double=>double');%      =   8; (* LONGREAL *)
L.loPLPhase				= fread(fh, 1, 'double=>double');%		=  16; (* LONGREAL *)
L.loPLPhaseY1			= fread(fh, 1, 'double=>double');%      =  24; (* LONGREAL *)
L.loPLPhaseY2			= fread(fh, 1, 'double=>double');%      =  32; (* LONGREAL *)
L.loUsedPhaseShift		= fread(fh, 1, 'double=>double');%		=  40; (* LONGREAL *)
L.loUsedAttenuation		= fread(fh, 1, 'double=>double');%		=  48; (* LONGREAL *)
	L.loSpare			= fread(fh, 1, 'double=>double');%		=  56; (* LONGREAL *)
L.loExtCalValid			= fread(fh, 1, 'uint8=>logical');%      =  64; (* BOOLEAN *)
L.loPLPhaseValid		= fread(fh, 1, 'uint8=>logical');%      =  65; (* BOOLEAN *)
L.loLockInMode			= fread(fh, 1, 'uint8=>uint8');%        =  66; (* BYTE *)
L.loCalMode				= fread(fh, 1, 'uint8=>uint8');%        =  67; (* BYTE *)
	L.loSpare2			= fread(fh, 7, 'int32=>in32');%			=  68; (* remaining *)
L.LockInParamsSize		= 96;

fseek(fh, offset+L.LockInParamsSize, 'bof');

end

%--------------------------------------------------------------------------
function A=getAmplifierState(fh)
%--------------------------------------------------------------------------
offset=ftell(fh);
A.sStateVersion			= fread(fh, 1, 'double=>double');%      =   0; (* 8 = SizeStateVersion *)
A.sCurrentGain			= fread(fh, 1, 'double=>double');%		=   8; (* LONGREAL *)
A.sF2Bandwidth			= fread(fh, 1, 'double=>double');%		=  16; (* LONGREAL *)
A.sF2Frequency			= fread(fh, 1, 'double=>double');%      =  24; (* LONGREAL *)
A.sRsValue				= fread(fh, 1, 'double=>double');%      =  32; (* LONGREAL *)
A.sRsFraction			= fread(fh, 1, 'double=>double');%      =  40; (* LONGREAL *)
A.sGLeak				= fread(fh, 1, 'double=>double');%      =  48; (* LONGREAL *)
A.sCFastAmp1			= fread(fh, 1, 'double=>double');%      =  56; (* LONGREAL *)
A.sCFastAmp2			= fread(fh, 1, 'double=>double');%      =  64; (* LONGREAL *)
A.sCFastTau				= fread(fh, 1, 'double=>double');%      =  72; (* LONGREAL *)
A.sCSlow				= fread(fh, 1, 'double=>double');%      =  80; (* LONGREAL *)
A.sGSeries				= fread(fh, 1, 'double=>double');%      =  88; (* LONGREAL *)
A.sVCStimDacScale		= fread(fh, 1, 'double=>double');%      =  96; (* LONGREAL *)
A.sCCStimScale			= fread(fh, 1, 'double=>double');%      = 104; (* LONGREAL *)
A.sVHold				= fread(fh, 1, 'double=>double');%      = 112; (* LONGREAL *)
A.sLastVHold			= fread(fh, 1, 'double=>double');%      = 120; (* LONGREAL *)
A.sVpOffset				= fread(fh, 1, 'double=>double');%      = 128; (* LONGREAL *)
A.sVLiquidJunction		= fread(fh, 1, 'double=>double');%		= 136; (* LONGREAL *)
A.sCCIHold				= fread(fh, 1, 'double=>double');%      = 144; (* LONGREAL *)
A.sCSlowStimVolts		= fread(fh, 1, 'double=>double');%		= 152; (* LONGREAL *)
A.sCCTrackVHold			= fread(fh, 1, 'double=>double');%      = 160; (* LONGREAL *)
A.sTimeoutCSlow			= fread(fh, 1, 'double=>double');%      = 168; (* LONGREAL *)
A.sSearchDelay			= fread(fh, 1, 'double=>double');%      = 176; (* LONGREAL *)
A.sMConductance			= fread(fh, 1, 'double=>double');%      = 184; (* LONGREAL *)
A.sMCapacitance			= fread(fh, 1, 'double=>double');%      = 192; (* LONGREAL *)
A.sSerialNumber			= fread(fh, 1, 'double=>double');%      = 200; (* 8 = SizeSerialNumber *)

A.sE9Boards				= fread(fh, 1, 'int16=>int16');%        = 208; (* INT16 *)
A.sCSlowCycles			= fread(fh, 1, 'int16=>int16');%        = 210; (* INT16 *)
A.sIMonAdc				= fread(fh, 1, 'int16=>int16');%        = 212; (* INT16 *)
A.sVMonAdc				= fread(fh, 1, 'int16=>int16');%        = 214; (* INT16 *)
	
A.sMuxAdc				= fread(fh, 1, 'int16=>int16');%        = 216; (* INT16 *)
A.sTestDac				= fread(fh, 1, 'int16=>int16');%        = 218; (* INT16 *)
A.sStimDac				= fread(fh, 1, 'int16=>int16');%        = 220; (* INT16 *)
A.sStimDacOffset		= fread(fh, 1, 'int16=>int16');%		= 222; (* INT16 *)

A.sMaxDigitalBit		= fread(fh, 1, 'int16=>int16');%		= 224; (* INT16 *)
A.sHasCFastHigh			= fread(fh, 1, 'uint8=>uint8');%		= 226; (* BYTE *)
A.sCFastHigh			= fread(fh, 1, 'uint8=>uint8');%		= 227; (* BYTE *)
A.sHasBathSense			= fread(fh, 1, 'uint8=>uint8');%		= 228; (* BYTE *)
A.sBathSense			= fread(fh, 1, 'uint8=>uint8');%		= 229; (* BYTE *)
A.sHasF2Bypass			= fread(fh, 1, 'uint8=>uint8');%		= 230; (* BYTE *)
A.sF2Mode				= fread(fh, 1, 'uint8=>uint8');%		= 231; (* BYTE *)

A.sAmplKind				= fread(fh, 1, 'uint8=>uint8');%        = 232; (* BYTE *)
A.sIsEpc9N				= fread(fh, 1, 'uint8=>uint8');%        = 233; (* BYTE *)
A.sADBoard				= fread(fh, 1, 'uint8=>uint8');%        = 234; (* BYTE *)
A.sBoardVersion			= fread(fh, 1, 'uint8=>uint8');%        = 235; (* BYTE *)
A.sActiveE9Board		= fread(fh, 1, 'uint8=>uint8');%		= 236; (* BYTE *)
A.sMode					= fread(fh, 1, 'uint8=>uint8');%        = 237; (* BYTE *)
A.sRange				= fread(fh, 1, 'uint8=>uint8');%        = 238; (* BYTE *)
A.sF2Response			= fread(fh, 1, 'uint8=>uint8');%        = 239; (* BYTE *)

A.sRsOn					= fread(fh, 1, 'uint8=>uint8');%        = 240; (* BYTE *)
A.sCSlowRange			= fread(fh, 1, 'uint8=>uint8');%        = 241; (* BYTE *)
A.sCCRange				= fread(fh, 1, 'uint8=>uint8');%        = 242; (* BYTE *)
A.sCCGain				= fread(fh, 1, 'uint8=>uint8');%        = 243; (* BYTE *)
A.sCSlowToTestDac		= fread(fh, 1, 'uint8=>uint8');%		= 244; (* BYTE *)
A.sStimPath				= fread(fh, 1, 'uint8=>uint8');%        = 245; (* BYTE *)
A.sCCTrackTau			= fread(fh, 1, 'uint8=>uint8');%        = 246; (* BYTE *)
A.sWasClipping			= fread(fh, 1, 'uint8=>uint8');%        = 247; (* BYTE *)

A.sRepetitiveCSlow		= fread(fh, 1, 'uint8=>uint8');%		= 248; (* BYTE *)
A.sLastCSlowRange		= fread(fh, 1, 'uint8=>uint8');%		= 249; (* BYTE *)
	A.sOld1				= fread(fh, 1, 'uint8=>uint8');%        = 250; (* BYTE *)
A.sCanCCFast			= fread(fh, 1, 'uint8=>uint8');%        = 251; (* BYTE *)
A.sCanLowCCRange		= fread(fh, 1, 'uint8=>uint8');%		= 252; (* BYTE *)
A.sCanHighCCRange		= fread(fh, 1, 'uint8=>uint8');%		= 253; (* BYTE *)
A.sCanCCTrackingg		= fread(fh, 1, 'uint8=>uint8');%		= 254; (* BYTE *)
A.sCHasVmonPath			= fread(fh, 1, 'uint8=>uint8');%        = 255; (* BYTE *)

A.sHasNewCCMode			= fread(fh, 1, 'uint8=>uint8');%		= 256; (* BYTE *)
A.sSelector				= fread(fh, 1, 'uint8=>char');%         = 257; (* CHAR *)
A.sHoldInverted			= fread(fh, 1, 'uint8=>uint8');%		= 258; (* BYTE *)
A.sAutoCFast			= fread(fh, 1, 'uint8=>uint8');%        = 259; (* BYTE *)
A.sAutoCSlow			= fread(fh, 1, 'uint8=>uint8');%        = 260; (* BYTE *)
A.sHasVmonX100			= fread(fh, 1, 'uint8=>uint8');%        = 261; (* BYTE *)
A.sTestDacOn			= fread(fh, 1, 'uint8=>uint8');%        = 262; (* BYTE *)
A.sQMuxAdcOn			= fread(fh, 1, 'uint8=>uint8');%        = 263; (* BYTE *)

A.sImon1Bandwidth		= fread(fh, 1, 'double=>double');%		= 264; (* LONGREAL *)
A.sStimScale			= fread(fh, 1, 'double=>double');%      = 272; (* LONGREAL *)

A.sGain					= fread(fh, 1, 'uint8=>uint8');%        = 280; (* BYTE *)
A.sFilter1				= fread(fh, 1, 'uint8=>uint8');%        = 281; (* BYTE *)
A.sStimFilterOn			= fread(fh, 1, 'uint8=>uint8');%		= 282; (* BYTE *)
A.sRsSlow				= fread(fh, 1, 'uint8=>uint8');%        = 283; (* BYTE *)
	A.sOld2				= fread(fh, 1, 'uint8=>uint8');%        = 284; (* BYTE *)
A.sCCCFastOn			= fread(fh, 1, 'uint8=>uint8');%        = 285; (* BYTE *)
A.sCCFastSpeed			= fread(fh, 1, 'uint8=>uint8');%        = 286; (* BYTE *)
A.sF2Source				= fread(fh, 1, 'uint8=>uint8');%        = 287; (* BYTE *)

A.sTestRange			= fread(fh, 1, 'uint8=>uint8');%        = 288; (* BYTE *)
A.sTestDacPath			= fread(fh, 1, 'uint8=>uint8');%        = 289; (* BYTE *)
A.sMuxChannel			= fread(fh, 1, 'uint8=>uint8');%        = 290; (* BYTE *)
A.sMuxGain64			= fread(fh, 1, 'uint8=>uint8');%        = 291; (* BYTE *)
A.sVmonX100				= fread(fh, 1, 'uint8=>uint8');%        = 292; (* BYTE *)
A.sIsQuadro				= fread(fh, 1, 'uint8=>uint8');%        = 293; (* BYTE *)
A.sF1Mode				= fread(fh, 1, 'uint8=>uint8');%		= 294; (* BYTE *)
	A.sOld3				= fread(fh, 1, 'uint8=>uint8');%		= 295; (* BYTE *)

A.sStimFilterHz			= fread(fh, 1, 'double=>double');%		= 296; (* LONGREAL *)
A.sRsTau				= fread(fh, 1, 'double=>double');%		= 304; (* LONGREAL *)
A.sDacToAdcDelay		= fread(fh, 1, 'double=>double');%		= 312; (* LONGREAL *)
A.sInputFilterTau		= fread(fh, 1, 'double=>double');%		= 320; (* LONGREAL *)
A.sOutputFilterTau		= fread(fh, 1, 'double=>double');%		= 328; (* LONGREAL *)
A.sVmonFactor			= fread(fh, 1, 'double=>double');%		= 336; (* LONGREAL *)
A.sCalibDate			= fread(fh, 2, 'double=>double');%      = 344; (* 16 = SizeCalibDate *)
A.sVmonOffset			= fread(fh, 1, 'double=>double');%      = 360; (* LONGREAL *)

A.sEEPROMKind			= fread(fh, 1, 'uint8=>uint8');%        = 368; (* BYTE *)
A.sVrefX2				= fread(fh, 1, 'uint8=>uint8');%        = 369; (* BYTE *)
A.sHasVrefX2AndF2Vmon	= fread(fh, 1, 'uint8=>uint8');%		= 370; (* BYTE *)
A.sSpare1				= fread(fh, 1, 'uint8=>uint8');%		= 371; (* BYTE *)
A.sSpare2				= fread(fh, 1, 'uint8=>uint8');%		= 372; (* BYTE *)
A.sSpare3			    = fread(fh, 1, 'uint8=>uint8');%		= 373; (* BYTE *)
A.sSpare4				= fread(fh, 1, 'uint8=>uint8');%		= 374; (* BYTE *)
A.sSpare5				= fread(fh, 1, 'uint8=>uint8');%		= 375; (* BYTE *)

A.sCCStimDacScale		= fread(fh, 1, 'double=>double');%		= 376; (* LONGREAL *)
A.sVmonFiltBandwidth	= fread(fh, 1, 'double=>double');%		= 384; (* LONGREAL *)
A.sVmonFiltFrequency	= fread(fh, 1, 'double=>double');%		= 392; (* LONGREAL *)
A.AmplifierStateSize	= 400;%								           (* = 50 * 8 *)

fseek(fh, offset+A.AmplifierStateSize, 'bof');

end
