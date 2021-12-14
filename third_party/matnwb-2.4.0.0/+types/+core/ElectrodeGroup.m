classdef ElectrodeGroup < types.core.NWBContainer & types.untyped.GroupClass
% ELECTRODEGROUP A physical grouping of electrodes, e.g. a shank of an array.


% PROPERTIES
properties
    description; % Description of this electrode group.
    device; % Link to the device that was used to record from this electrode group.
    location; % Location of electrode group. Specify the area, layer, comments on estimation of area/layer, etc. Use standard atlas names for anatomical regions when possible.
    position; % stereotaxic or common framework coordinates
end

methods
    function obj = ElectrodeGroup(varargin)
        % ELECTRODEGROUP Constructor for ElectrodeGroup
        %     obj = ELECTRODEGROUP(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % description = char
        % device = Device
        % location = char
        % position = table/struct of vectors/struct array/containers.Map of vectors with values:
        
            % x = float32
            % y = float32
            % z = float32
        obj = obj@types.core.NWBContainer(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'description',[]);
        addParameter(p, 'device',[]);
        addParameter(p, 'location',[]);
        addParameter(p, 'position',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.description = p.Results.description;
        obj.device = p.Results.device;
        obj.location = p.Results.location;
        obj.position = p.Results.position;
        if strcmp(class(obj), 'types.core.ElectrodeGroup')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.description(obj, val)
        obj.description = obj.validate_description(val);
    end
    function obj = set.device(obj, val)
        obj.device = obj.validate_device(val);
    end
    function obj = set.location(obj, val)
        obj.location = obj.validate_location(val);
    end
    function obj = set.position(obj, val)
        obj.position = obj.validate_position(val);
    end
    %% VALIDATORS
    
    function val = validate_description(obj, val)
        val = types.util.checkDtype('description', 'char', val);
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
    function val = validate_device(obj, val)
        val = types.util.checkDtype('device', 'types.core.Device', val);
    end
    function val = validate_location(obj, val)
        val = types.util.checkDtype('location', 'char', val);
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
    function val = validate_position(obj, val)
        if isempty(val) || isa(val, 'types.untyped.DataStub')
            return;
        end
        if ~istable(val) && ~isstruct(val) && ~isa(val, 'containers.Map')
            error('Property `position` must be a table,struct, or containers.Map.');
        end
        vprops = struct();
        vprops.x = 'float32';
        vprops.y = 'float32';
        vprops.z = 'float32';
        val = types.util.checkDtype('position', vprops, val);
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
        refs = export@types.core.NWBContainer(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.description)
            io.writeAttribute(fid, [fullpath '/description'], obj.description);
        else
            error('Property `description` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.device)
            refs = obj.device.export(fid, [fullpath '/device'], refs);
        else
            error('Property `device` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.location)
            io.writeAttribute(fid, [fullpath '/location'], obj.location);
        else
            error('Property `location` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.position)
            if startsWith(class(obj.position), 'types.untyped.')
                refs = obj.position.export(fid, [fullpath '/position'], refs);
            elseif ~isempty(obj.position)
                io.writeCompound(fid, [fullpath '/position'], obj.position);
            end
        end
    end
end

end