function HI_extractHEKAStimTree(obj)
%
% Function to extract parameters from the HEKA stimulus tree and sort them
% according to the recordings.
% Takes HEKA_IMPORTER object as input and adds the variables stimWave
% (containing the reconstructed stimulus wave) and stimUnits to the RecTable
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

% TODO: Add support for more complex stimuli, e.g. ramps, alternating etc.


%find Series/Recordings
%1: Root
%2 Series
%3: channels
%4: segments

stimTree = obj.trees.stimTree;

allRecs = find(~cellfun(@isempty,stimTree(:,2)));

% GET CHANNELS AND NUMBER OF SEGMENTS PER CHANNEl
Recs = [stimTree{allRecs,2}];
nRecs = numel(Recs);
STIM = cell(numel(Recs),1);
stimUnit = cell(numel(Recs),1);

for iRec = 1:numel(Recs)
	if iRec == nRecs
		nextRec = Inf;
	else
		nextRec = allRecs(iRec+1);
	end
	[STIM{iRec},stimUnit{iRec}] = ImportStimulus(stimTree,allRecs(iRec),nextRec);
end


% ADD STIMULUS TO RECORDING TABLE
obj.RecTable.stimWave = STIM;
obj.RecTable.stimUnit = stimUnit;

end



function [STIM,stimUnit] = ImportStimulus(stimTree,thisRecID,nextRecID)

% GET ALL CHANNELS OF THIS RECORDING
chIDs = find(~cellfun(@isempty,stimTree(:,3)));
chIDs = chIDs(chIDs>thisRecID & chIDs<nextRecID);
nSweeps = stimTree{thisRecID,2}.stNumberSweeps;

% GET SAMPLING RATE
SR = 1./stimTree{thisRecID,2}.stSampleInterval;

% GET STIMULUS SEGMENTS PER CHANNEL
ch = [stimTree{chIDs,3}];
nSegments = reshape([ch(:).chCRC],numel(ch),1);


%% EXTRACT STIMULUS SEGMENTS PER CHANNEL
for iC = 1:numel(ch)
	
	% GET CHANNEL NAME
	% TO DO: NEED TO FIGURE OUT HOW THOSE CODES RELATE TO ACTUAL CHANNEL
	% NAMES
	sMode = ch(iC).chStimToDacID;
	DACMode = ch(iC).chDacMode;
	%     ADCMode = ch(iC).chDacMode;
	DACBit = ch(iC).chDacBit;
	
	
	switch DACMode
		case 1
			chName = ['DA_',num2str(ch(iC).chDacChannel)];
		case 3
			chName = ['Dig_',num2str(ch(iC).chDacBit)];
		otherwise
			chName = ['DAC_',num2str(ch(iC).chDacChannel)];
	end
	
	
	% GET SEGMENTS
	segs = [stimTree{chIDs(iC)+1:chIDs(iC)+nSegments(iC),4}];
	
	% GET DURATION AND AMPLITUDE OF SEGMENTS
	segT = reshape([segs(:).seDuration],numel(segs),1);
	segV = reshape([segs(:).seVoltage],numel(segs),1);
	
	% GET CHANGES DURING SWEEPS
	% TO DO: IMPLEMENT DIFFERENT MODES (ALTERNATING ETC.) BUT NEED TEMPLATE
	% FIRST
	segDeltaT = reshape([segs(:).seDeltaTIncrement],numel(segs),1) .* reshape([segs(:).seDeltaTFactor],numel(segs),1);
	segDeltaV = reshape([segs(:).seDeltaVIncrement],numel(segs),1) .* reshape([segs(:).seDeltaVFactor],numel(segs),1);
	
	constantSegs = ~any([segDeltaT(:);segDeltaV(:)]);
	
	% DUPLICATE BASE SEGMENTS FOR MULTIPLE SWEETS
	segT = repmat(segT,1,nSweeps);
	segV = repmat(segV,1,nSweeps);
	segDeltaT = [zeros(size(segDeltaT)),repmat(segDeltaT,1,nSweeps-1)];
	segDeltaV = [zeros(size(segDeltaV)),repmat(segDeltaV,1,nSweeps-1)];
	
	% CHANGE MATRIX
	segT = segT + cumsum(segDeltaT,2);
	segV = segV + cumsum(segDeltaV,2);
	segTime = round(segT .* SR);
	
	
	% CREATE STIMULUS FOR EACH SWEEP UNLESS SWEEP PARAMETERS ARE CONSTANT
	
	% DEFINE MATRIX FOR STIMULI
	maxSweepDur = max(sum(segTime,1));
	stimMatrix = NaN(maxSweepDur,nSweeps);
	
	% CREATE STIMULUS VECTOR
	fun = @(segTime,segV) repmat(segV,[segTime,1]);
	stims = arrayfun(fun,segTime,segV,'UniformOutput',false);
	
	
	if ~constantSegs
		% SORT STIMULUS IN MATRIX
		for iS = 1:nSweeps
			stimMatrix(1:sum(segTime(:,iS)),iS) = cell2mat(stims(:,iS));
		end
		
	else
		stimMatrix = cell2mat(stims(:,1));
	end
	
	
	
	STIM.(chName) = stimMatrix;
	
end

stimUnit = reshape({ch(:).chDacUnit},1,numel(ch));

end




