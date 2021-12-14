classdef CurrentClampSeries < types.core.PatchClampSeries & types.untyped.GroupClass
% CURRENTCLAMPSERIES Voltage data from an intracellular current-clamp recording. A corresponding CurrentClampStimulusSeries (stored separately as a stimulus) is used to store the current injected.


% PROPERTIES
properties
    bias_current; % Bias current, in amps.
    bridge_balance; % Bridge balance, in ohms.
    capacitance_compensation; % Capacitance compensation, in farads.
end

methods
    function obj = CurrentClampSeries(varargin)
        % CURRENTCLAMPSERIES Constructor for CurrentClampSeries
        %     obj = CURRENTCLAMPSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % bias_current = float32
        % bridge_balance = float32
        % capacitance_compensation = float32
        varargin = [{'data_unit' 'volts'} varargin];
        obj = obj@types.core.PatchClampSeries(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'bias_current',[]);
        addParameter(p, 'bridge_balance',[]);
        addParameter(p, 'capacitance_compensation',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.bias_current = p.Results.bias_current;
        obj.bridge_balance = p.Results.bridge_balance;
        obj.capacitance_compensation = p.Results.capacitance_compensation;
        if strcmp(class(obj), 'types.core.CurrentClampSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.bias_current(obj, val)
        obj.bias_current = obj.validate_bias_current(val);
    end
    function obj = set.bridge_balance(obj, val)
        obj.bridge_balance = obj.validate_bridge_balance(val);
    end
    function obj = set.capacitance_compensation(obj, val)
        obj.capacitance_compensation = obj.validate_capacitance_compensation(val);
    end
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
    function val = validate_data(obj, val)
    
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.PatchClampSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.bias_current)
            if startsWith(class(obj.bias_current), 'types.untyped.')
                refs = obj.bias_current.export(fid, [fullpath '/bias_current'], refs);
            elseif ~isempty(obj.bias_current)
                io.writeDataset(fid, [fullpath '/bias_current'], obj.bias_current);
            end
        end
        if ~isempty(obj.bridge_balance)
            if startsWith(class(obj.bridge_balance), 'types.untyped.')
                refs = obj.bridge_balance.export(fid, [fullpath '/bridge_balance'], refs);
            elseif ~isempty(obj.bridge_balance)
                io.writeDataset(fid, [fullpath '/bridge_balance'], obj.bridge_balance);
            end
        end
        if ~isempty(obj.capacitance_compensation)
            if startsWith(class(obj.capacitance_compensation), 'types.untyped.')
                refs = obj.capacitance_compensation.export(fid, [fullpath '/capacitance_compensation'], refs);
            elseif ~isempty(obj.capacitance_compensation)
                io.writeDataset(fid, [fullpath '/capacitance_compensation'], obj.capacitance_compensation);
            end
        end
    end
end

end