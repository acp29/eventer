function HI_loadHEKAFile(obj)
% Function to load HEKA PATCHMASTER files.
% Takes HEKA_IMPORTER object as input, loads PATCHMASTER file and extract
% data create RecTable and tree structure. Check the functions listed below
% for more information.
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

% CHECK IF FILE EXISTS
if ~exist(obj.opt.filepath,'file')
	warning('File not found'); return
end

%% CALL IMPORT FUNCTION AND EXRACT DATA
obj.HI_ImportHEKAtoMat;

% EXTRACT AND SORT INFORMATION FROM TREE STRUCTURES
obj.HI_extractHEKADataTree;
obj.HI_extractHEKAStimTree;
obj.HI_extractHEKASolutionTree;



end
