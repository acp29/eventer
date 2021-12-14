classdef VoltageClampSeries < types.core.PatchClampSeries & types.untyped.GroupClass
% VOLTAGECLAMPSERIES Current data from an intracellular voltage-clamp recording. A corresponding VoltageClampStimulusSeries (stored separately as a stimulus) is used to store the voltage injected.


% READONLY
properties(SetAccess=protected)
    capacitance_fast_unit; % Unit of measurement for capacitance_fast, which is fixed to 'farads'.
    capacitance_slow_unit; % Unit of measurement for capacitance_fast, which is fixed to 'farads'.
    resistance_comp_bandwidth_unit; % Unit of measurement for resistance_comp_bandwidth, which is fixed to 'hertz'.
    resistance_comp_correction_unit; % Unit of measurement for resistance_comp_correction, which is fixed to 'percent'.
    resistance_comp_prediction_unit; % Unit of measurement for resistance_comp_prediction, which is fixed to 'percent'.
    whole_cell_capacitance_comp_unit; % Unit of measurement for whole_cell_capacitance_comp, which is fixed to 'farads'.
    whole_cell_series_resistance_comp_unit; % Unit of measurement for whole_cell_series_resistance_comp, which is fixed to 'ohms'.
end
% PROPERTIES
properties
    capacitance_fast; % Fast capacitance, in farads.
    capacitance_slow; % Slow capacitance, in farads.
    resistance_comp_bandwidth; % Resistance compensation bandwidth, in hertz.
    resistance_comp_correction; % Resistance compensation correction, in percent.
    resistance_comp_prediction; % Resistance compensation prediction, in percent.
    whole_cell_capacitance_comp; % Whole cell capacitance compensation, in farads.
    whole_cell_series_resistance_comp; % Whole cell series resistance compensation, in ohms.
end

methods
    function obj = VoltageClampSeries(varargin)
        % VOLTAGECLAMPSERIES Constructor for VoltageClampSeries
        %     obj = VOLTAGECLAMPSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % capacitance_fast_unit = char
        % capacitance_slow_unit = char
        % resistance_comp_bandwidth_unit = char
        % resistance_comp_correction_unit = char
        % resistance_comp_prediction_unit = char
        % whole_cell_capacitance_comp_unit = char
        % whole_cell_series_resistance_comp_unit = char
        % capacitance_fast = float32
        % capacitance_slow = float32
        % resistance_comp_bandwidth = float32
        % resistance_comp_correction = float32
        % resistance_comp_prediction = float32
        % whole_cell_capacitance_comp = float32
        % whole_cell_series_resistance_comp = float32
        varargin = [{'capacitance_fast_unit' 'farads' 'capacitance_slow_unit' 'farads' 'data_unit' 'amperes' 'resistance_comp_bandwidth_unit' 'hertz' 'resistance_comp_correction_unit' 'percent' 'resistance_comp_prediction_unit' 'percent' 'whole_cell_capacitance_comp_unit' 'farads' 'whole_cell_series_resistance_comp_unit' 'ohms'} varargin];
        obj = obj@types.core.PatchClampSeries(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'capacitance_fast_unit',[]);
        addParameter(p, 'capacitance_slow_unit',[]);
        addParameter(p, 'resistance_comp_bandwidth_unit',[]);
        addParameter(p, 'resistance_comp_correction_unit',[]);
        addParameter(p, 'resistance_comp_prediction_unit',[]);
        addParameter(p, 'whole_cell_capacitance_comp_unit',[]);
        addParameter(p, 'whole_cell_series_resistance_comp_unit',[]);
        addParameter(p, 'capacitance_fast',[]);
        addParameter(p, 'capacitance_slow',[]);
        addParameter(p, 'resistance_comp_bandwidth',[]);
        addParameter(p, 'resistance_comp_correction',[]);
        addParameter(p, 'resistance_comp_prediction',[]);
        addParameter(p, 'whole_cell_capacitance_comp',[]);
        addParameter(p, 'whole_cell_series_resistance_comp',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.capacitance_fast_unit = p.Results.capacitance_fast_unit;
        obj.capacitance_slow_unit = p.Results.capacitance_slow_unit;
        obj.resistance_comp_bandwidth_unit = p.Results.resistance_comp_bandwidth_unit;
        obj.resistance_comp_correction_unit = p.Results.resistance_comp_correction_unit;
        obj.resistance_comp_prediction_unit = p.Results.resistance_comp_prediction_unit;
        obj.whole_cell_capacitance_comp_unit = p.Results.whole_cell_capacitance_comp_unit;
        obj.whole_cell_series_resistance_comp_unit = p.Results.whole_cell_series_resistance_comp_unit;
        obj.capacitance_fast = p.Results.capacitance_fast;
        obj.capacitance_slow = p.Results.capacitance_slow;
        obj.resistance_comp_bandwidth = p.Results.resistance_comp_bandwidth;
        obj.resistance_comp_correction = p.Results.resistance_comp_correction;
        obj.resistance_comp_prediction = p.Results.resistance_comp_prediction;
        obj.whole_cell_capacitance_comp = p.Results.whole_cell_capacitance_comp;
        obj.whole_cell_series_resistance_comp = p.Results.whole_cell_series_resistance_comp;
        if strcmp(class(obj), 'types.core.VoltageClampSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.capacitance_fast(obj, val)
        obj.capacitance_fast = obj.validate_capacitance_fast(val);
    end
    function obj = set.capacitance_slow(obj, val)
        obj.capacitance_slow = obj.validate_capacitance_slow(val);
    end
    function obj = set.resistance_comp_bandwidth(obj, val)
        obj.resistance_comp_bandwidth = obj.validate_resistance_comp_bandwidth(val);
    end
    function obj = set.resistance_comp_correction(obj, val)
        obj.resistance_comp_correction = obj.validate_resistance_comp_correction(val);
    end
    function obj = set.resistance_comp_prediction(obj, val)
        obj.resistance_comp_prediction = obj.validate_resistance_comp_prediction(val);
    end
    function obj = set.whole_cell_capacitance_comp(obj, val)
        obj.whole_cell_capacitance_comp = obj.validate_whole_cell_capacitance_comp(val);
    end
    function obj = set.whole_cell_series_resistance_comp(obj, val)
        obj.whole_cell_series_resistance_comp = obj.validate_whole_cell_series_resistance_comp(val);
    end
    %% VALIDATORS
    
    function val = validate_capacitance_fast(obj, val)
        val = types.util.checkDtype('capacitance_fast', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_capacitance_slow(obj, val)
        val = types.util.checkDtype('capacitance_slow', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_data(obj, val)
    
    end
    function val = validate_resistance_comp_bandwidth(obj, val)
        val = types.util.checkDtype('resistance_comp_bandwidth', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_resistance_comp_correction(obj, val)
        val = types.util.checkDtype('resistance_comp_correction', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_resistance_comp_prediction(obj, val)
        val = types.util.checkDtype('resistance_comp_prediction', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_whole_cell_capacitance_comp(obj, val)
        val = types.util.checkDtype('whole_cell_capacitance_comp', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_whole_cell_series_resistance_comp(obj, val)
        val = types.util.checkDtype('whole_cell_series_resistance_comp', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.PatchClampSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.capacitance_fast)
            if startsWith(class(obj.capacitance_fast), 'types.untyped.')
                refs = obj.capacitance_fast.export(fid, [fullpath '/capacitance_fast'], refs);
            elseif ~isempty(obj.capacitance_fast)
                io.writeDataset(fid, [fullpath '/capacitance_fast'], obj.capacitance_fast);
            end
        end
        if ~isempty(obj.capacitance_fast_unit) && ~isempty(obj.capacitance_fast)
            io.writeAttribute(fid, [fullpath '/capacitance_fast/unit'], obj.capacitance_fast_unit);
        elseif ~isempty(obj.capacitance_fast)
            error('Property `capacitance_fast_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.capacitance_slow)
            if startsWith(class(obj.capacitance_slow), 'types.untyped.')
                refs = obj.capacitance_slow.export(fid, [fullpath '/capacitance_slow'], refs);
            elseif ~isempty(obj.capacitance_slow)
                io.writeDataset(fid, [fullpath '/capacitance_slow'], obj.capacitance_slow);
            end
        end
        if ~isempty(obj.capacitance_slow_unit) && ~isempty(obj.capacitance_slow)
            io.writeAttribute(fid, [fullpath '/capacitance_slow/unit'], obj.capacitance_slow_unit);
        elseif ~isempty(obj.capacitance_slow)
            error('Property `capacitance_slow_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.resistance_comp_bandwidth)
            if startsWith(class(obj.resistance_comp_bandwidth), 'types.untyped.')
                refs = obj.resistance_comp_bandwidth.export(fid, [fullpath '/resistance_comp_bandwidth'], refs);
            elseif ~isempty(obj.resistance_comp_bandwidth)
                io.writeDataset(fid, [fullpath '/resistance_comp_bandwidth'], obj.resistance_comp_bandwidth);
            end
        end
        if ~isempty(obj.resistance_comp_bandwidth_unit) && ~isempty(obj.resistance_comp_bandwidth)
            io.writeAttribute(fid, [fullpath '/resistance_comp_bandwidth/unit'], obj.resistance_comp_bandwidth_unit);
        elseif ~isempty(obj.resistance_comp_bandwidth)
            error('Property `resistance_comp_bandwidth_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.resistance_comp_correction)
            if startsWith(class(obj.resistance_comp_correction), 'types.untyped.')
                refs = obj.resistance_comp_correction.export(fid, [fullpath '/resistance_comp_correction'], refs);
            elseif ~isempty(obj.resistance_comp_correction)
                io.writeDataset(fid, [fullpath '/resistance_comp_correction'], obj.resistance_comp_correction);
            end
        end
        if ~isempty(obj.resistance_comp_correction_unit) && ~isempty(obj.resistance_comp_correction)
            io.writeAttribute(fid, [fullpath '/resistance_comp_correction/unit'], obj.resistance_comp_correction_unit);
        elseif ~isempty(obj.resistance_comp_correction)
            error('Property `resistance_comp_correction_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.resistance_comp_prediction)
            if startsWith(class(obj.resistance_comp_prediction), 'types.untyped.')
                refs = obj.resistance_comp_prediction.export(fid, [fullpath '/resistance_comp_prediction'], refs);
            elseif ~isempty(obj.resistance_comp_prediction)
                io.writeDataset(fid, [fullpath '/resistance_comp_prediction'], obj.resistance_comp_prediction);
            end
        end
        if ~isempty(obj.resistance_comp_prediction_unit) && ~isempty(obj.resistance_comp_prediction)
            io.writeAttribute(fid, [fullpath '/resistance_comp_prediction/unit'], obj.resistance_comp_prediction_unit);
        elseif ~isempty(obj.resistance_comp_prediction)
            error('Property `resistance_comp_prediction_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.whole_cell_capacitance_comp)
            if startsWith(class(obj.whole_cell_capacitance_comp), 'types.untyped.')
                refs = obj.whole_cell_capacitance_comp.export(fid, [fullpath '/whole_cell_capacitance_comp'], refs);
            elseif ~isempty(obj.whole_cell_capacitance_comp)
                io.writeDataset(fid, [fullpath '/whole_cell_capacitance_comp'], obj.whole_cell_capacitance_comp);
            end
        end
        if ~isempty(obj.whole_cell_capacitance_comp_unit) && ~isempty(obj.whole_cell_capacitance_comp)
            io.writeAttribute(fid, [fullpath '/whole_cell_capacitance_comp/unit'], obj.whole_cell_capacitance_comp_unit);
        elseif ~isempty(obj.whole_cell_capacitance_comp)
            error('Property `whole_cell_capacitance_comp_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.whole_cell_series_resistance_comp)
            if startsWith(class(obj.whole_cell_series_resistance_comp), 'types.untyped.')
                refs = obj.whole_cell_series_resistance_comp.export(fid, [fullpath '/whole_cell_series_resistance_comp'], refs);
            elseif ~isempty(obj.whole_cell_series_resistance_comp)
                io.writeDataset(fid, [fullpath '/whole_cell_series_resistance_comp'], obj.whole_cell_series_resistance_comp);
            end
        end
        if ~isempty(obj.whole_cell_series_resistance_comp_unit) && ~isempty(obj.whole_cell_series_resistance_comp)
            io.writeAttribute(fid, [fullpath '/whole_cell_series_resistance_comp/unit'], obj.whole_cell_series_resistance_comp_unit);
        elseif ~isempty(obj.whole_cell_series_resistance_comp)
            error('Property `whole_cell_series_resistance_comp_unit` is required in `%s`.', fullpath);
        end
    end
end

end