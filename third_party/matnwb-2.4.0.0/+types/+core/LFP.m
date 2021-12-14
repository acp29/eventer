classdef LFP < types.core.NWBDataInterface & types.untyped.GroupClass
% LFP LFP data from one or more channels. The electrode map in each published ElectricalSeries will identify which channels are providing LFP data. Filter properties should be noted in the ElectricalSeries 'filtering' attribute.


% PROPERTIES
properties
    electricalseries; % ElectricalSeries object(s) containing LFP data for one or more channels.
end

methods
    function obj = LFP(varargin)
        % LFP Constructor for LFP
        %     obj = LFP(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % electricalseries = ElectricalSeries
        obj = obj@types.core.NWBDataInterface(varargin{:});
        [obj.electricalseries, ivarargin] = types.util.parseConstrained(obj,'electricalseries', 'types.core.ElectricalSeries', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.core.LFP')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.electricalseries(obj, val)
        obj.electricalseries = obj.validate_electricalseries(val);
    end
    %% VALIDATORS
    
    function val = validate_electricalseries(obj, val)
        constrained = {'types.core.ElectricalSeries'};
        types.util.checkSet('electricalseries', struct(), constrained, val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.electricalseries)
            refs = obj.electricalseries.export(fid, fullpath, refs);
        else
            error('Property `electricalseries` is required in `%s`.', fullpath);
        end
    end
end

end