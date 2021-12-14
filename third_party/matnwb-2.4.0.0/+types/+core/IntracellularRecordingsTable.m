classdef IntracellularRecordingsTable < types.hdmf_common.AlignedDynamicTable & types.untyped.GroupClass
% INTRACELLULARRECORDINGSTABLE A table to group together a stimulus and response from a single electrode and a single simultaneous recording. Each row in the table represents a single recording consisting typically of a stimulus and a corresponding response. In some cases, however, only a stimulus or a response is recorded as part of an experiment. In this case, both the stimulus and response will point to the same TimeSeries while the idx_start and count of the invalid column will be set to -1, thus, indicating that no values have been recorded for the stimulus or response, respectively. Note, a recording MUST contain at least a stimulus or a response. Typically the stimulus and response are PatchClampSeries. However, the use of AD/DA channels that are not associated to an electrode is also common in intracellular electrophysiology, in which case other TimeSeries may be used.


% PROPERTIES
properties
    electrodes; % Table for storing intracellular electrode related metadata.
    responses; % Table for storing intracellular response related metadata.
    stimuli; % Table for storing intracellular stimulus related metadata.
end

methods
    function obj = IntracellularRecordingsTable(varargin)
        % INTRACELLULARRECORDINGSTABLE Constructor for IntracellularRecordingsTable
        %     obj = INTRACELLULARRECORDINGSTABLE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % electrodes = IntracellularElectrodesTable
        % responses = IntracellularResponsesTable
        % stimuli = IntracellularStimuliTable
        varargin = [{'description' 'A table to group together a stimulus and response from a single electrode and a single simultaneous recording and for storing metadata about the intracellular recording.'} varargin];
        obj = obj@types.hdmf_common.AlignedDynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'electrodes',[]);
        addParameter(p, 'responses',[]);
        addParameter(p, 'stimuli',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.electrodes = p.Results.electrodes;
        obj.responses = p.Results.responses;
        obj.stimuli = p.Results.stimuli;
        if strcmp(class(obj), 'types.core.IntracellularRecordingsTable')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.electrodes(obj, val)
        obj.electrodes = obj.validate_electrodes(val);
    end
    function obj = set.responses(obj, val)
        obj.responses = obj.validate_responses(val);
    end
    function obj = set.stimuli(obj, val)
        obj.stimuli = obj.validate_stimuli(val);
    end
    %% VALIDATORS
    
    function val = validate_electrodes(obj, val)
        val = types.util.checkDtype('electrodes', 'types.core.IntracellularElectrodesTable', val);
    end
    function val = validate_responses(obj, val)
        val = types.util.checkDtype('responses', 'types.core.IntracellularResponsesTable', val);
    end
    function val = validate_stimuli(obj, val)
        val = types.util.checkDtype('stimuli', 'types.core.IntracellularStimuliTable', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.AlignedDynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.electrodes)
            refs = obj.electrodes.export(fid, [fullpath '/electrodes'], refs);
        else
            error('Property `electrodes` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.responses)
            refs = obj.responses.export(fid, [fullpath '/responses'], refs);
        else
            error('Property `responses` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.stimuli)
            refs = obj.stimuli.export(fid, [fullpath '/stimuli'], refs);
        else
            error('Property `stimuli` is required in `%s`.', fullpath);
        end
    end
end

end