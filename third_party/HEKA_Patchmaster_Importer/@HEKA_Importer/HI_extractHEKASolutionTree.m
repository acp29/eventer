function HI_extractHEKASolutionTree(obj)

% Function to extract parameters from the HEKA sol tree create solution
% table containing the chemicals and concentrations for all solutions used
% in the recordings. Requires solution base to be activated when recording
% the data.
% Takes HEKA_IMPORTER object as input and adds solution table.
%
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

%1: Root
%2: Solution
%3: Chemicals

solTree = obj.trees.solTree;

if size(solTree,2) > 1 % OTHERWISE NOT SOLUTIONS DEFINED
	
	
	% FIND NUMBER OF SOLUTIONS AND INDICES
	sInd=find(~cellfun(@isempty,solTree(:,2)));
	nSolutions = numel(sInd);
	
	% GET SOLUTION NAMES AND NUMBER OF CHEMICALS PER SOLUTION
	sols = [solTree{sInd,2}];
	sNames = matlab.lang.makeValidName(reshape({sols(:).SoName},numel(sols),1));
	sNumber =reshape([sols(:).SoNumber],numel(sols),1);
	
	nChPerSol = diff([sInd;numel(solTree(:,2))+1])-1;
	
	
	for iS = 1:nSolutions
		% FIND CHEMICALS FOR THIS SOLUTION
		chems = [solTree{sInd(iS)+1:sInd(iS)+nChPerSol(iS),3}];
		% GET ALL CHEMICAL NAMES AND CONCENTRATIONS
		cNames = reshape({chems(:).ChName},numel(chems),1);
		cConcentration = reshape({chems(:).ChConcentration},numel(chems),1);
		
		obj.solutions.(sNames{iS}) = table(cNames,cConcentration,'VariableNames',{'Chemical','Concentration'});
		
	end
	%% ASSIGN SOLUTION NAMES TO SOLUTION NUMBERS FROM RECORDINGS IN RECTABLE
	
	getSolutionName = @(ID,sNames,sNumber) sNames(sNumber==ID);
	obj.RecTable.ExternalSolution = cellfun(getSolutionName,obj.RecTable.ExternalSolution,repmat({sNames},size(obj.RecTable.ExternalSolution)),repmat({sNumber},size(obj.RecTable.ExternalSolution)));
	obj.RecTable.InternalSolution = cellfun(getSolutionName,obj.RecTable.InternalSolution,repmat({sNames},size(obj.RecTable.InternalSolution)),repmat({sNumber},size(obj.RecTable.InternalSolution)));
	
	
else % USE NANs TO OVERWRITE THE STANDARD 0
	obj.RecTable.ExternalSolution = NaN(size(obj.RecTable.ExternalSolution));
	obj.RecTable.InternalSolution =  NaN(size(obj.RecTable.InternalSolution));
	
	
end



end













