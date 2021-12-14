classdef SweepTable < types.hdmf_common.DynamicTable & types.untyped.GroupClass
% SWEEPTABLE [DEPRECATED] Table used to group different PatchClampSeries. SweepTable is being replaced by IntracellularRecordingsTable and SimultaneousRecordingsTable tables. Additional SequentialRecordingsTable, RepetitionsTable, and ExperimentalConditions tables provide enhanced support for experiment metadata.


% PROPERTIES
properties
    series; % The PatchClampSeries with the sweep number in that row.
    series_index; % Index for series.
    sweep_number; % Sweep number of the PatchClampSeries in that row.
end

methods
    function obj = SweepTable(varargin)
        % SWEEPTABLE Constructor for SweepTable
        %     obj = SWEEPTABLE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % series = VectorData
        % series_index = VectorIndex
        % sweep_number = VectorData
        obj = obj@types.hdmf_common.DynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'series',[]);
        addParameter(p, 'series_index',[]);
        addParameter(p, 'sweep_number',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.series = p.Results.series;
        obj.series_index = p.Results.series_index;
        obj.sweep_number = p.Results.sweep_number;
        if strcmp(class(obj), 'types.core.SweepTable')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.series(obj, val)
        obj.series = obj.validate_series(val);
    end
    function obj = set.series_index(obj, val)
        obj.series_index = obj.validate_series_index(val);
    end
    function obj = set.sweep_number(obj, val)
        obj.sweep_number = obj.validate_sweep_number(val);
    end
    %% VALIDATORS
    
    function val = validate_series(obj, val)
        val = types.util.checkDtype('series', 'types.hdmf_common.VectorData', val);
    end
    function val = validate_series_index(obj, val)
        val = types.util.checkDtype('series_index', 'types.hdmf_common.VectorIndex', val);
    end
    function val = validate_sweep_number(obj, val)
        val = types.util.checkDtype('sweep_number', 'types.hdmf_common.VectorData', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.DynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.series)
            refs = obj.series.export(fid, [fullpath '/series'], refs);
        else
            error('Property `series` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.series_index)
            refs = obj.series_index.export(fid, [fullpath '/series_index'], refs);
        else
            error('Property `series_index` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.sweep_number)
            refs = obj.sweep_number.export(fid, [fullpath '/sweep_number'], refs);
        else
            error('Property `sweep_number` is required in `%s`.', fullpath);
        end
    end
end

end