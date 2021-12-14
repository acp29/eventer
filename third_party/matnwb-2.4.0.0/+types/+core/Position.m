classdef Position < types.core.NWBDataInterface & types.untyped.GroupClass
% POSITION Position data, whether along the x, x/y or x/y/z axis.


% PROPERTIES
properties
    spatialseries; % SpatialSeries object containing position data.
end

methods
    function obj = Position(varargin)
        % POSITION Constructor for Position
        %     obj = POSITION(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % spatialseries = SpatialSeries
        obj = obj@types.core.NWBDataInterface(varargin{:});
        [obj.spatialseries, ivarargin] = types.util.parseConstrained(obj,'spatialseries', 'types.core.SpatialSeries', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.core.Position')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.spatialseries(obj, val)
        obj.spatialseries = obj.validate_spatialseries(val);
    end
    %% VALIDATORS
    
    function val = validate_spatialseries(obj, val)
        constrained = {'types.core.SpatialSeries'};
        types.util.checkSet('spatialseries', struct(), constrained, val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.spatialseries)
            refs = obj.spatialseries.export(fid, fullpath, refs);
        else
            error('Property `spatialseries` is required in `%s`.', fullpath);
        end
    end
end

end