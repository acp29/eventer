classdef IZeroClampSeries < types.core.CurrentClampSeries & types.untyped.GroupClass
% IZEROCLAMPSERIES Voltage data from an intracellular recording when all current and amplifier settings are off (i.e., CurrentClampSeries fields will be zero). There is no CurrentClampStimulusSeries associated with an IZero series because the amplifier is disconnected and no stimulus can reach the cell.



methods
    function obj = IZeroClampSeries(varargin)
        % IZEROCLAMPSERIES Constructor for IZeroClampSeries
        %     obj = IZEROCLAMPSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        varargin = [{'stimulus_description' 'N/A'} varargin];
        obj = obj@types.core.CurrentClampSeries(varargin{:});
        if strcmp(class(obj), 'types.core.IZeroClampSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    
    %% VALIDATORS
    
    function val = validate_bias_current(obj, val)
        val = types.util.checkDtype('bias_current', 'float32', val);
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
    function val = validate_bridge_balance(obj, val)
        val = types.util.checkDtype('bridge_balance', 'float32', val);
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
    function val = validate_capacitance_compensation(obj, val)
        val = types.util.checkDtype('capacitance_compensation', 'float32', val);
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
        refs = export@types.core.CurrentClampSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
    end
end

end