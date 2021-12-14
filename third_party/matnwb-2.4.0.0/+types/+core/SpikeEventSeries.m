classdef SpikeEventSeries < types.core.ElectricalSeries & types.untyped.GroupClass
% SPIKEEVENTSERIES Stores snapshots/snippets of recorded spike events (i.e., threshold crossings). This may also be raw data, as reported by ephys hardware. If so, the TimeSeries::description field should describe how events were detected. All SpikeEventSeries should reside in a module (under EventWaveform interface) even if the spikes were reported and stored by hardware. All events span the same recording channels and store snapshots of equal duration. TimeSeries::data array structure: [num events] [num channels] [num samples] (or [num events] [num samples] for single electrode).



methods
    function obj = SpikeEventSeries(varargin)
        % SPIKEEVENTSERIES Constructor for SpikeEventSeries
        %     obj = SPIKEEVENTSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        varargin = [{'data_unit' 'volts' 'timestamps_interval' types.util.correctType(1, 'int32') 'timestamps_unit' 'seconds'} varargin];
        obj = obj@types.core.ElectricalSeries(varargin{:});
        if strcmp(class(obj), 'types.core.SpikeEventSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    
    %% VALIDATORS
    
    function val = validate_data(obj, val)
        val = types.util.checkDtype('data', 'numeric', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[Inf,Inf,Inf], [Inf,Inf]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_timestamps(obj, val)
        val = types.util.checkDtype('timestamps', 'float64', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[Inf]};
        types.util.checkDims(valsz, validshapes);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.ElectricalSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
    end
end

end