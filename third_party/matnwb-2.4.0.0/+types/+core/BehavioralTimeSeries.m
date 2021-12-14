classdef BehavioralTimeSeries < types.core.NWBDataInterface & types.untyped.GroupClass
% BEHAVIORALTIMESERIES TimeSeries for storing Behavoioral time series data. See description of <a href="#BehavioralEpochs">BehavioralEpochs</a> for more details.


% PROPERTIES
properties
    timeseries; % TimeSeries object containing continuous behavioral data.
end

methods
    function obj = BehavioralTimeSeries(varargin)
        % BEHAVIORALTIMESERIES Constructor for BehavioralTimeSeries
        %     obj = BEHAVIORALTIMESERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % timeseries = TimeSeries
        obj = obj@types.core.NWBDataInterface(varargin{:});
        [obj.timeseries, ivarargin] = types.util.parseConstrained(obj,'timeseries', 'types.core.TimeSeries', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.core.BehavioralTimeSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.timeseries(obj, val)
        obj.timeseries = obj.validate_timeseries(val);
    end
    %% VALIDATORS
    
    function val = validate_timeseries(obj, val)
        constrained = {'types.core.TimeSeries'};
        types.util.checkSet('timeseries', struct(), constrained, val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.timeseries)
            refs = obj.timeseries.export(fid, fullpath, refs);
        end
    end
end

end