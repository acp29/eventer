classdef Image < types.core.NWBData & types.untyped.DatasetClass
% IMAGE An abstract data type for an image. Shape can be 2-D (x, y), or 3-D where the third dimension can have three or four elements, e.g. (x, y, (r, g, b)) or (x, y, (r, g, b, a)).


% PROPERTIES
properties
    description; % Description of the image.
    resolution; % Pixel resolution of the image, in pixels per centimeter.
end

methods
    function obj = Image(varargin)
        % IMAGE Constructor for Image
        %     obj = IMAGE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % description = char
        % resolution = float32
        obj = obj@types.core.NWBData(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'description',[]);
        addParameter(p, 'resolution',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.description = p.Results.description;
        obj.resolution = p.Results.resolution;
        if strcmp(class(obj), 'types.core.Image')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.description(obj, val)
        obj.description = obj.validate_description(val);
    end
    function obj = set.resolution(obj, val)
        obj.resolution = obj.validate_resolution(val);
    end
    %% VALIDATORS
    
    function val = validate_data(obj, val)
        val = types.util.checkDtype('data', 'numeric', val);
    end
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
    function val = validate_resolution(obj, val)
        val = types.util.checkDtype('resolution', 'float32', val);
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
        refs = export@types.core.NWBData(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.description)
            io.writeAttribute(fid, [fullpath '/description'], obj.description);
        end
        if ~isempty(obj.resolution)
            io.writeAttribute(fid, [fullpath '/resolution'], obj.resolution);
        end
    end
end

end