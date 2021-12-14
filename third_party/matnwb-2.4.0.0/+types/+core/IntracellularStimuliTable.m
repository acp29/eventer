classdef IntracellularStimuliTable < types.hdmf_common.DynamicTable & types.untyped.GroupClass
% INTRACELLULARSTIMULITABLE Table for storing intracellular stimulus related metadata.


% PROPERTIES
properties
    stimulus; % Column storing the reference to the recorded stimulus for the recording (rows).
end

methods
    function obj = IntracellularStimuliTable(varargin)
        % INTRACELLULARSTIMULITABLE Constructor for IntracellularStimuliTable
        %     obj = INTRACELLULARSTIMULITABLE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % stimulus = TimeSeriesReferenceVectorData
        varargin = [{'description' 'Table for storing intracellular stimulus related metadata.'} varargin];
        obj = obj@types.hdmf_common.DynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'stimulus',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.stimulus = p.Results.stimulus;
        if strcmp(class(obj), 'types.core.IntracellularStimuliTable')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.stimulus(obj, val)
        obj.stimulus = obj.validate_stimulus(val);
    end
    %% VALIDATORS
    
    function val = validate_stimulus(obj, val)
        val = types.util.checkDtype('stimulus', 'types.core.TimeSeriesReferenceVectorData', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.DynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.stimulus)
            refs = obj.stimulus.export(fid, [fullpath '/stimulus'], refs);
        else
            error('Property `stimulus` is required in `%s`.', fullpath);
        end
    end
end

end