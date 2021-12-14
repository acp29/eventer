classdef FilteredEphys < types.core.NWBDataInterface & types.untyped.GroupClass
% FILTEREDEPHYS Electrophysiology data from one or more channels that has been subjected to filtering. Examples of filtered data include Theta and Gamma (LFP has its own interface). FilteredEphys modules publish an ElectricalSeries for each filtered channel or set of channels. The name of each ElectricalSeries is arbitrary but should be informative. The source of the filtered data, whether this is from analysis of another time series or as acquired by hardware, should be noted in each's TimeSeries::description field. There is no assumed 1::1 correspondence between filtered ephys signals and electrodes, as a single signal can apply to many nearby electrodes, and one electrode may have different filtered (e.g., theta and/or gamma) signals represented. Filter properties should be noted in the ElectricalSeries 'filtering' attribute.


% PROPERTIES
properties
    electricalseries; % ElectricalSeries object(s) containing filtered electrophysiology data.
end

methods
    function obj = FilteredEphys(varargin)
        % FILTEREDEPHYS Constructor for FilteredEphys
        %     obj = FILTEREDEPHYS(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % electricalseries = ElectricalSeries
        obj = obj@types.core.NWBDataInterface(varargin{:});
        [obj.electricalseries, ivarargin] = types.util.parseConstrained(obj,'electricalseries', 'types.core.ElectricalSeries', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.core.FilteredEphys')
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