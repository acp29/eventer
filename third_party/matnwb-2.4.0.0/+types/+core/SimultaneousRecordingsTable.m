classdef SimultaneousRecordingsTable < types.hdmf_common.DynamicTable & types.untyped.GroupClass
% SIMULTANEOUSRECORDINGSTABLE A table for grouping different intracellular recordings from the IntracellularRecordingsTable table together that were recorded simultaneously from different electrodes.


% PROPERTIES
properties
    recordings; % A reference to one or more rows in the IntracellularRecordingsTable table.
    recordings_index; % Index dataset for the recordings column.
end

methods
    function obj = SimultaneousRecordingsTable(varargin)
        % SIMULTANEOUSRECORDINGSTABLE Constructor for SimultaneousRecordingsTable
        %     obj = SIMULTANEOUSRECORDINGSTABLE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % recordings = DynamicTableRegion
        % recordings_index = VectorIndex
        obj = obj@types.hdmf_common.DynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'recordings',[]);
        addParameter(p, 'recordings_index',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.recordings = p.Results.recordings;
        obj.recordings_index = p.Results.recordings_index;
        if strcmp(class(obj), 'types.core.SimultaneousRecordingsTable')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.recordings(obj, val)
        obj.recordings = obj.validate_recordings(val);
    end
    function obj = set.recordings_index(obj, val)
        obj.recordings_index = obj.validate_recordings_index(val);
    end
    %% VALIDATORS
    
    function val = validate_recordings(obj, val)
        val = types.util.checkDtype('recordings', 'types.hdmf_common.DynamicTableRegion', val);
    end
    function val = validate_recordings_index(obj, val)
        val = types.util.checkDtype('recordings_index', 'types.hdmf_common.VectorIndex', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.DynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.recordings)
            refs = obj.recordings.export(fid, [fullpath '/recordings'], refs);
        else
            error('Property `recordings` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.recordings_index)
            refs = obj.recordings_index.export(fid, [fullpath '/recordings_index'], refs);
        else
            error('Property `recordings_index` is required in `%s`.', fullpath);
        end
    end
end

end