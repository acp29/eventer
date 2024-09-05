function HI_readPulseFileHEKA(obj,Level)

% extracts data stored in the "*.pul" file, or the corresponding portion of
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
s = getOneRecord(obj,Level);
obj.opt.fileData.Tree{obj.opt.fileData.Counter, Level+1} = s;

obj.opt.fileData.Position = obj.opt.fileData.Position+obj.opt.fileData.Sizes(Level+1);
fseek(obj.opt.fileData.fh, obj.opt.fileData.Position, 'bof');
obj.opt.fileData.nchild=fread(obj.opt.fileData.fh, 1, 'int32=>int32');
if obj.opt.fileData.nchild >10
	
end
obj.opt.fileData.Position=ftell(obj.opt.fileData.fh);

end

%--------------------------------------------------------------------------
function rec=getOneRecord(obj,Level)
%--------------------------------------------------------------------------
% Gets one record
obj.opt.fileData.Counter = obj.opt.fileData.Counter+1;

switch Level
	case 0
		rec=getRoot(obj);
	case 1
		rec=getGroup(obj);
	case 2
		rec=getSeries(obj);
	case 3
		rec=getSweep(obj);
	case 4
		rec=getTrace(obj);
	otherwise
		error('Unexpected Level');
end
end

% The functions below return data as defined by the HEKA PatchMaster
% specification found at ftp://server.hekahome.de/pub/FileFormat/

%--------------------------------------------------------------------------
function p=getRoot(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

p.RoVersion				= fread(fh, 1, 'int32=>int32');%				=   4; (* INT32 *)
p.RoMark				= fread(fh, 1, 'int32=>int32');%				=   4; (* INT32 *)
p.RoVersionName			= deblank(fread(fh, 32, 'uint8=>char')');%		=   8; (* String32Type *)
p.RoAuxFileName			= deblank(fread(fh, 80, 'uint8=>char')');%		=  40; (* String80Type *)
p.RoRootText			= deblank(fread(fh, 400, 'uint8=>char')');%		(* String400Type *)
p.RoStartTime			= fread(fh, 1, 'double=>double') ;%				= 520; (* LONGREAL *)
p.RoStartTimeMATLAB		= obj.HI_time2date(p.RoStartTime);
p.RoMaxSamples			= fread(fh, 1, 'int32=>int32'); %				= 528; (* INT32 *)
p.RoCRC					= fread(fh, 1, 'int32=>int32'); %               = 532; (* CARD32 *)
p.RoFeatures			= fread(fh, 1, 'int16=>int16'); %				= 536; (* SET16 *)
p.RoFiller1				= fread(fh, 1, 'int16=>int16');%				= 538; (* INT16 *)
p.RoFiller2				= fread(fh, 1, 'int32=>int32');%				= 540; (* INT32 *)
p.RoTcEnumerator		= fread(fh,32,'int16=>int16');%					= 544; (* ARRAY[0..Max_TcKind_M1] OF INT16 *)
p.RoTcKind				= fread(fh,32,'int8=>int8');%					= 608; (* ARRAY[0..Max_TcKind_M1] OF INT8 *)
p.RootRecSize			= 640;%												   (* = 80 * 8 *);
p=orderfields(p);

obj.opt.fileData.fileVersion = p.RoVersion; 
end

%--------------------------------------------------------------------------
function g=getGroup(obj)
%--------------------------------------------------------------------------
% Group
fh = obj.opt.fileData.fh;

g.GrMark				= fread(fh, 1, 'int32=>int32');%				=   0; (* INT32 *)
g.GrLabel				= deblank(fread(fh, 32, 'uint8=>char')');%      =   4; (* String32Size *)
g.GrText				= deblank(fread(fh, 80, 'uint8=>char')');%      =  36; (* String80Size *)
g.GrExperimentNumber	= fread(fh, 1, 'int32=>int32');%				= 116; (* INT32 *)
g.GrGroupCount			= fread(fh, 1, 'int32=>int32');%				= 120; (* INT32 *)
g.GrCRC					= fread(fh, 1, 'int32=>int32');%                = 124; (* CARD32 *)
g.GrMatrixWidth			= fread(fh,1,'double=>double');%				= 128; (* LONGREAL *)
g.GrMatrixHeight		= fread(fh,1,'double=>double');%				= 136; (* LONGREAL *)
g.GroupRecSize			= 144;  %    (* = 18 * 8 *)

g=orderfields(g);

end

%--------------------------------------------------------------------------
function s=getSeries(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

s.SeMark				= fread(fh, 1, 'int32=>int32');%				=   0; (* INT32 *)
s.SeLabel				= deblank(fread(fh, 32, 'uint8=>char')');%      =   4; (* String32Type *)
s.SeComment				= deblank(fread(fh, 80, 'uint8=>char')');%      =  36; (* String80Type *)
s.SeSeriesCount			= fread(fh, 1, 'int32=>int32');%				= 116; (* INT32 *)
s.SeNumbersw			= fread(fh, 1, 'int32=>int32');%				= 120; (* INT32 *)
switch obj.opt.fileData.fileVersion
	case 9
		s.SeAmplStateOffset		= fread(fh, 1, 'int32=>int32');%		= 124; (* INT32 *
		s.SeAmplStateSeries		= fread(fh, 1, 'int32=>int32');%		= 128; (* INT32 *
	case 1000
		s.SeAmplStateFlag		= fread(fh,1,'int32=>int32');%			= 124; (* INT32 *) // flag > 0 => load local oldAmpState, otherwise load from .amp File.
		s.SeAmplStateRef		= fread(fh,1,'int32=>int32'); %			= 128; (* INT32 *) // ref  = 0 => use local oldAmpState
end
s.SeMethodTag			= fread(fh,1,'int32=>int32'); %					= 132; (* INT32 *)
s.SeTime				= fread(fh,1,'double=>double'); %				= 136; (* LONGREAL *)
s.SeTimeMATLAB			= obj.HI_time2date(s.SeTime);
s.SePageWidth			= fread(fh, 1, 'double=>double') ;%				= 144; (* LONGREAL *)
switch obj.opt.fileData.fileVersion
	case 9
		for k=1:4 %														= 152; (* ARRAY[0..1] OF UserParamDescrType = 4*40 *)
			s.SeSwUserParamDescr(k).Name=deblank(fread(fh, 32, 'uint8=>char')');%
			s.SeSwUserParamDescr(k).Unit=deblank(fread(fh, 8, 'uint8=>char')');%
		end
	case 1000
		for k=1:2 %														= 152; (* ARRAY[0..1] OF UserParamDescrType = 4*40 *)
			s.SeUserDescr1(k).Name=deblank(fread(fh, 32, 'uint8=>char')');%
			s.SeUserDescr1(k).Unit=deblank(fread(fh, 8, 'uint8=>char')');%
		end
		s.SeFiller1		=  deblank(fread(fh,80,'uint8=>char')'); %      = 232; (* ARRAY[0..1] OF UserParamDescrType = 2*40 *)
end
s.SeMethodName			= deblank(fread(fh,32,'uint8=>char')');%        = 312; (* String32Type *)
switch obj.opt.fileData.fileVersion
	case 9
		s.SeSeUserParams1		= fread(fh ,4 ,'double=>double');%		= 344; (* ARRAY[0..3] OF LONGREAL *)
		s.SeLockInParams		= getSeLockInParams(fh);%				= 376; (* SeLockInSize = 96, see "Pulsed.de" *)
		s.SeAmplifierState		= getAmplifierState(fh);%				= 472; (* AmplifierStateSize = 400 *)
	case 1000
		s.SePhotoParams1		= fread(fh, 4, 'double=>double'); %		= 344; (* ARRAY[0..3] OF LONGREAL = 4*8 *)
		s.SeOldLockInParams		= getSeLockInParams(fh);%				= 376; (* SeOldLockInSize = 96, see "Pulsed.de" *)
		s.SeOldAmpState			= getAmplifierState(fh);%				= 472; (* SeOldAmpState = 400 -> the AmplStateRecord is now stored in the .amp file *)
end
s.SeUsername			= deblank(fread(fh, 80, 'uint8=>char')');%		= 872; (* String80Type *)
switch obj.opt.fileData.fileVersion
	case 9
		for k=1:4%														= 952; (* ARRAY[0..3] OF UserParamDescrType = 4*40 *)
			s.SeSeUserParamDescr1(k).Name=deblank(fread(fh, 32, 'uint8=>char')');%
			s.SeSeUserParamDescr1(k).Unit=deblank(fread(fh, 8, 'uint8=>char')');%
		end
	case 1000
		for k=1:4%														= 952; (* ARRAY[0..3] OF UserParamDescrType = 4*40 *)
			s.SePhotoParams2(k).Name=deblank(fread(fh, 32, 'uint8=>char')');%
			s.SePhotoParams2(k).Unit=deblank(fread(fh, 8, 'uint8=>char')');%
		end
end
s.SeFiller1				= fread(fh, 1, 'int32=>int32');%				= 1112; (* INT32 *)
s.SeCRC					=  fread(fh, 1, 'int32=>int32');%               = 1116; (* CARD32 *)
s.SeSeUserParams2		= fread(fh, 4, 'double=>double');%				= 1120; (* ARRAY[0..3] OF LONGREAL *)
for k=1:4 %																= 1152; (* ARRAY[0..3] OF UserParamDescrType = 4*40 *)
	s.SeSeUserParamDescr2(k).Name=deblank(fread(fh, 32, 'uint8=>char')');%
	s.SeSeUserParamDescr2(k).Unit=deblank(fread(fh, 8, 'uint8=>char')');%
end
s.SeScanParams			= fread(fh, 96, 'uint8=>uint8');%				= 1312; (* ScanParamsSize = 96 (ElProScan Extension) *)
switch obj.opt.fileData.fileVersion
	case 9
		s.SeriesRecSize			= 1408;%								= 1408;     (* = 176 * 8 *)
	case 1000
		for k=1:8 %														= 1408; (* ARRAY[0..7] OF UserParamDescrType = 8*40 *)
			s.SeSeUserDescr2(k).Name=deblank(fread(fh, 32, 'uint8=>char')');%
			s.SeSeUserDescr2(k).Unit=deblank(fread(fh, 8, 'uint8=>char')');
		end
		s.SeriesRecSize			= 1728;%							    = 1728;
end

s=orderfields(s);
s.Sweeps = []; % used to store all the sweeps within the recording structure later on

end

%--------------------------------------------------------------------------
function sw=getSweep(obj)
%--------------------------------------------------------------------------

fh = obj.opt.fileData.fh;

sw.SwMark				= fread(fh, 1, 'int32=>int32');%				=   0; (* INT32 *)
sw.SwLabel				= deblank(fread(fh, 32, 'uint8=>char')');%		=   4; (* String32Type *)
sw.SwAuxDataFileOffset	= fread(fh, 1, 'int32=>int32');%				=  36; (* INT32 *)
sw.SwStimCount			= fread(fh, 1, 'int32=>int32');%				=  40; (* INT32 *)
sw.SwSweepCount			= fread(fh, 1, 'int32=>int32');%				=  44; (* INT32 *)
sw.SwTime				= fread(fh, 1, 'double=>double');%              =  48; (* LONGREAL *)
sw.SwTimeMATLAB			= obj.HI_time2date(sw.SwTime);%					Also add in MATLAB datenum format
sw.SwTimer				= fread(fh, 1, 'double=>double');%              =  56; (* LONGREAL *)
switch obj.opt.fileData.fileVersion
	case 9
		sw.SwSwUserParams		= fread(fh, 4, 'double=>double');%      =  64; (* ARRAY[0..3] OF LONGREAL *)
	case 1000
		sw.SwSwUserParams		= fread(fh, 2, 'double=>double');%      =  64; (* ARRAY[0..1] OF LONGREAL *)
		sw.SwPipPressure		= fread(fh, 1, 'double=>double');%		=  80; (* LONGREAL *
		sw.SwRMSNoise			= fread(fh,1,'double=>double'); %       =  88; (* LONGREAL *)
end
sw.SwTemperature				= fread(fh, 1, 'double=>double');%      =  96; (* LONGREAL *)
sw.SwOldIntSol					= fread(fh, 1, 'int32=>int32');%        = 104; (* INT32 *)
sw.SwOldExtSol					= fread(fh, 1, 'int32=>int32');%        = 108; (* INT32 *)
sw.SwDigitalIn					= fread(fh, 1, 'int16=>int16');%        = 112; (* SET16 *)
sw.SwSweepKind					= fread(fh, 1, 'int16=>int16');%        = 114; (* SET16 *)
sw.SwDigitalOut					= fread(fh,1, 'int16=>int16');%			= 116; (* SET16 *)
sw.SwFiller1					= fread(fh, 1, 'int16=>int16');%        = 118; (* INT32 *)
sw.SwMarkers					= fread(fh, 4, 'double=>double');%		= 120; (* ARRAY[0..3] OF LONGREAL, see SwMarkersNo *)
sw.SwFiller2					= fread(fh, 1, 'int32=>int32');%        = 152; (* INT32 *)
sw.SwCRC						= fread(fh, 1, 'int32=>int32');%		= 156; (* CARD32 *)
sw.SwSwHolding					= fread(fh,16,'double=>double');%		= 160; (* ARRAY[0..15] OF LONGREAL, see SwHoldingNo *)
switch obj.opt.fileData.fileVersion
	case 9
		sw.SweepRecSize			= 288;%									= 288;      (* = 36 * 8 *)
	case 1000
		sw.SwSwUserParamEx		= fread(fh,8,'double=>double'); %		= 288; (* ARRAY[0..7] OF LONGREAL *)
		sw.SweepRecSize         = 352;%									= 352;
end
sw=orderfields(sw);
sw.Traces = []; % used to store all the traces/channels within the sweep structure later on
end

%--------------------------------------------------------------------------
function tr=getTrace(obj)
%--------------------------------------------------------------------------
fh = obj.opt.fileData.fh;

tr.TrMark				= fread(fh, 1, 'int32=>int32');%				=   0; (* INT32 *)
tr.TrLabel				= deblank(fread(fh, 32, 'uint8=>char')');%      =   4; (* String32Type *)
tr.TrTraceCount			= fread(fh, 1, 'int32=>int32');%				=  36; (* INT32 *)
tr.TrData				= fread(fh, 1, 'int32=>int32');%				=  40; (* INT32 *)
tr.TrDataPoints			= fread(fh, 1, 'int32=>int32');%				=  44; (* INT32 *)
tr.TrInternalSolution	= fread(fh, 1, 'int32=>int32');%				=  48; (* INT32 *)
tr.TrAverageCount		= fread(fh, 1, 'int32=>int32');%				=  52; (* INT32 *)
tr.TrLeakCount			= fread(fh, 1, 'int32=>int32');%				=  56; (* INT32 *)
tr.TrLeakTraces			= fread(fh, 1, 'int32=>int32');%				=  60; (* INT32 *)
tr.TrDataKind			= fread(fh, 1, 'uint16=>uint16');%				=  64; (* SET16 *) NB Stored unsigned
tr.TrFiller1			= fread(fh, 1, 'int16=>int16');%				=  66; (* SET16 *)
tr.TrRecordingMode		= fread(fh, 1, 'uint8=>uint8');%				=  68; (* BYTE *)
tr.TrAmplIndex			= fread(fh, 1, 'uint8=>uint8');%				=  69; (* CHAR *)
tr.TrDataFormat			= fread(fh, 1, 'uint8=>uint8');%				=  70; (* BYTE *)
tr.TrDataAbscissa		= fread(fh, 1, 'uint8=>uint8');%				=  71; (* BYTE *)
tr.TrDataScaler			= fread(fh, 1, 'double=>double');%				=  72; (* LONGREAL *)
tr.TrTimeOffset			= fread(fh, 1, 'double=>double');%				=  80; (* LONGREAL *)
tr.TrZeroData			= fread(fh, 1, 'double=>double');%				=  88; (* LONGREAL *)
tr.TrYUnit				= deblank(fread(fh, 8, 'uint8=>char')');%       =  96; (* String8Type *)
tr.TrXInterval			= fread(fh, 1, 'double=>double');%				= 104; (* LONGREAL *)
tr.TrXStart				= fread(fh, 1, 'double=>double');%				= 112; (* LONGREAL *)
% 17.04.10 TrXUnit bytes may include some trailing characters after NULL
% byte
tr.TrXUnit				= deblank(fread(fh, 8, 'uint8=>char')');%       = 120; (* String8Type *)
tr.TrYRange				= fread(fh, 1, 'double=>double');%				= 128; (* LONGREAL *)
tr.TrYOffset			= fread(fh, 1, 'double=>double');%				= 136; (* LONGREAL *)
tr.TrBandwidth			= fread(fh, 1, 'double=>double');%				= 144; (* LONGREAL *)
tr.TrPipetteResistance	= fread(fh, 1, 'double=>double');%				= 152; (* LONGREAL *)
tr.TrCellPotential		= fread(fh, 1, 'double=>double');%				= 160; (* LONGREAL *)
tr.TrSealResistance		= fread(fh, 1, 'double=>double');%				= 168; (* LONGREAL *)
tr.TrCSlow				= fread(fh, 1, 'double=>double');%              = 176; (* LONGREAL *)
tr.TrGSeries			= fread(fh, 1, 'double=>double');%				= 184; (* LONGREAL *)
tr.TrRsValue			= fread(fh, 1, 'double=>double');%				= 192; (* LONGREAL *)
tr.TrGLeak				= fread(fh, 1, 'double=>double');%              = 200; (* LONGREAL *)
tr.TrMConductance		= fread(fh, 1, 'double=>double');%				= 208; (* LONGREAL *)
tr.TrLinkDAChannel		= fread(fh, 1, 'int32=>int32');%				= 216; (* INT32 *)
tr.TrValidYrange		= fread(fh, 1, 'uint8=>logical');%				= 220; (* BOOLEAN *)
tr.TrAdcMode			= fread(fh, 1, 'uint8=>uint8');%				= 221; (* CHAR *)
tr.TrAdcChannel			= fread(fh, 1, 'int16=>int16');%				= 222; (* INT16 *)
tr.TrYmin				= fread(fh, 1, 'double=>double');%              = 224; (* LONGREAL *)
tr.TrYmax				= fread(fh, 1, 'double=>double');%              = 232; (* LONGREAL *)
tr.TrSourceChannel		= fread(fh, 1, 'int32=>int32');%				= 240; (* INT32 *)
tr.TrExternalSolution	= fread(fh, 1, 'int32=>int32');%				= 244; (* INT32 *)
tr.TrCM					= fread(fh, 1, 'double=>double');%              = 248; (* LONGREAL *)
tr.TrGM					= fread(fh, 1, 'double=>double');%              = 256; (* LONGREAL *)
tr.TrPhase				= fread(fh, 1, 'double=>double');%              = 264; (* LONGREAL *)
tr.TrDataCRC			= fread(fh, 1, 'int32=>int32');%				= 272; (* CARD32 *)
tr.TrCRC				= fread(fh, 1, 'int32=>int32');%                = 276; (* CARD32 *)
tr.TrGS					= fread(fh, 1, 'double=>double');%              = 280; (* LONGREAL *)
tr.TrSelfChannel		= fread(fh, 1, 'int32=>int32');%				= 288; (* INT32 *)

tr.TrInterleaveSize		= fread(fh, 1, 'int32=>int32');%				= 292; (* INT32 *)
tr.TrInterleaveSkip		= fread(fh, 1, 'int32=>int32');%				= 296; (* INT32 *)
tr.TrImageIndex			= fread(fh, 1, 'int32=>int32');%				= 300; (* INT32 *)
tr.TrMarkers			= fread(fh, 10, 'double=>double');%				= 304; (* ARRAY[0..9] OF LONGREAL *)
tr.TrSECM_X				= fread(fh, 1, 'double=>double');%				= 384; (* LONGREAL *)
tr.TrSECM_Y				= fread(fh, 1, 'double=>double');%				= 392; (* LONGREAL *)
tr.TrSECM_Z				= fread(fh, 1, 'double=>double');%				= 400; (* LONGREAL *)
tr.TrTrHolding			= fread(fh, 1, 'double=>double');%				= 408; (* LONGREAL *)
tr.TrTcEnumerator		= fread(fh, 1, 'int32=>int32');%				= 416; (* INT32 *)
tr.TrXTrace				= fread(fh, 1, 'int32=>int32');%				= 420; (* INT32 *)
tr.TrIntSolValue		= fread(fh, 1, 'double=>double');%				= 424; (* LONGREAL *)
tr.TrExtSolValue		= fread(fh, 1, 'double=>double');%				= 432; (* LONGREAL *)
tr.TrIntSolName			= deblank(fread(fh, 32, 'uint8=>char')');%      = 440; (* String32Size *)
tr.TrExtSolName			= deblank(fread(fh, 32, 'uint8=>char')');%      = 472; (* String32Size *)
tr.TrDataPedestal		= fread(fh, 1, 'double=>double');%				= 504; (* LONGREAL *)

tr.TraceRecSize=512;%														   (* = 64 * 8 *)

tr=orderfields(tr);

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