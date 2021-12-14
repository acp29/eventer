classdef ImagingPlane < types.core.NWBContainer & types.untyped.GroupClass
% IMAGINGPLANE An imaging plane and its metadata.


% PROPERTIES
properties
    description; % Description of the imaging plane.
    device; % Link to the Device object that was used to record from this electrode.
    excitation_lambda; % Excitation wavelength, in nm.
    grid_spacing; % Space between pixels in (x, y) or voxels in (x, y, z) directions, in the specified unit. Assumes imaging plane is a regular grid. See also reference_frame to interpret the grid.
    grid_spacing_unit; % Measurement units for grid_spacing. The default value is 'meters'.
    imaging_rate; % Rate that images are acquired, in Hz. If the corresponding TimeSeries is present, the rate should be stored there instead.
    indicator; % Calcium indicator.
    location; % Location of the imaging plane. Specify the area, layer, comments on estimation of area/layer, stereotaxic coordinates if in vivo, etc. Use standard atlas names for anatomical regions when possible.
    manifold; % DEPRECATED Physical position of each pixel. 'xyz' represents the position of the pixel relative to the defined coordinate space. Deprecated in favor of origin_coords and grid_spacing.
    manifold_conversion; % Scalar to multiply each element in data to convert it to the specified 'unit'. If the data are stored in acquisition system units or other units that require a conversion to be interpretable, multiply the data by 'conversion' to convert the data to the specified 'unit'. e.g. if the data acquisition system stores values in this object as pixels from x = -500 to 499, y = -500 to 499 that correspond to a 2 m x 2 m range, then the 'conversion' multiplier to get from raw data acquisition pixel units to meters is 2/1000.
    manifold_unit; % Base unit of measurement for working with the data. The default value is 'meters'.
    opticalchannel; % An optical channel used to record from an imaging plane.
    origin_coords; % Physical location of the first element of the imaging plane (0, 0) for 2-D data or (0, 0, 0) for 3-D data. See also reference_frame for what the physical location is relative to (e.g., bregma).
    origin_coords_unit; % Measurement units for origin_coords. The default value is 'meters'.
    reference_frame; % Describes reference frame of origin_coords and grid_spacing. For example, this can be a text description of the anatomical location and orientation of the grid defined by origin_coords and grid_spacing or the vectors needed to transform or rotate the grid to a common anatomical axis (e.g., AP/DV/ML). This field is necessary to interpret origin_coords and grid_spacing. If origin_coords and grid_spacing are not present, then this field is not required. For example, if the microscope takes 10 x 10 x 2 images, where the first value of the data matrix (index (0, 0, 0)) corresponds to (-1.2, -0.6, -2) mm relative to bregma, the spacing between pixels is 0.2 mm in x, 0.2 mm in y and 0.5 mm in z, and larger numbers in x means more anterior, larger numbers in y means more rightward, and larger numbers in z means more ventral, then enter the following -- origin_coords = (-1.2, -0.6, -2) grid_spacing = (0.2, 0.2, 0.5) reference_frame = "Origin coordinates are relative to bregma. First dimension corresponds to anterior-posterior axis (larger index = more anterior). Second dimension corresponds to medial-lateral axis (larger index = more rightward). Third dimension corresponds to dorsal-ventral axis (larger index = more ventral)."
end

methods
    function obj = ImagingPlane(varargin)
        % IMAGINGPLANE Constructor for ImagingPlane
        %     obj = IMAGINGPLANE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % device = Device
        % excitation_lambda = float32
        % grid_spacing_unit = char
        % indicator = char
        % location = char
        % opticalchannel = OpticalChannel
        % origin_coords_unit = char
        % description = char
        % grid_spacing = float32
        % imaging_rate = float32
        % manifold = float32
        % manifold_conversion = float32
        % manifold_unit = char
        % origin_coords = float32
        % reference_frame = char
        varargin = [{'grid_spacing_unit' 'meters' 'manifold_conversion' types.util.correctType(1, 'float32') 'manifold_unit' 'meters' 'origin_coords_unit' 'meters'} varargin];
        obj = obj@types.core.NWBContainer(varargin{:});
        [obj.opticalchannel, ivarargin] = types.util.parseConstrained(obj,'opticalchannel', 'types.core.OpticalChannel', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'device',[]);
        addParameter(p, 'excitation_lambda',[]);
        addParameter(p, 'grid_spacing_unit',[]);
        addParameter(p, 'indicator',[]);
        addParameter(p, 'location',[]);
        addParameter(p, 'origin_coords_unit',[]);
        addParameter(p, 'description',[]);
        addParameter(p, 'grid_spacing',[]);
        addParameter(p, 'imaging_rate',[]);
        addParameter(p, 'manifold',[]);
        addParameter(p, 'manifold_conversion',[]);
        addParameter(p, 'manifold_unit',[]);
        addParameter(p, 'origin_coords',[]);
        addParameter(p, 'reference_frame',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.device = p.Results.device;
        obj.excitation_lambda = p.Results.excitation_lambda;
        obj.grid_spacing_unit = p.Results.grid_spacing_unit;
        obj.indicator = p.Results.indicator;
        obj.location = p.Results.location;
        obj.origin_coords_unit = p.Results.origin_coords_unit;
        obj.description = p.Results.description;
        obj.grid_spacing = p.Results.grid_spacing;
        obj.imaging_rate = p.Results.imaging_rate;
        obj.manifold = p.Results.manifold;
        obj.manifold_conversion = p.Results.manifold_conversion;
        obj.manifold_unit = p.Results.manifold_unit;
        obj.origin_coords = p.Results.origin_coords;
        obj.reference_frame = p.Results.reference_frame;
        if strcmp(class(obj), 'types.core.ImagingPlane')
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
    function obj = set.excitation_lambda(obj, val)
        obj.excitation_lambda = obj.validate_excitation_lambda(val);
    end
    function obj = set.grid_spacing(obj, val)
        obj.grid_spacing = obj.validate_grid_spacing(val);
    end
    function obj = set.grid_spacing_unit(obj, val)
        obj.grid_spacing_unit = obj.validate_grid_spacing_unit(val);
    end
    function obj = set.imaging_rate(obj, val)
        obj.imaging_rate = obj.validate_imaging_rate(val);
    end
    function obj = set.indicator(obj, val)
        obj.indicator = obj.validate_indicator(val);
    end
    function obj = set.location(obj, val)
        obj.location = obj.validate_location(val);
    end
    function obj = set.manifold(obj, val)
        obj.manifold = obj.validate_manifold(val);
    end
    function obj = set.manifold_conversion(obj, val)
        obj.manifold_conversion = obj.validate_manifold_conversion(val);
    end
    function obj = set.manifold_unit(obj, val)
        obj.manifold_unit = obj.validate_manifold_unit(val);
    end
    function obj = set.opticalchannel(obj, val)
        obj.opticalchannel = obj.validate_opticalchannel(val);
    end
    function obj = set.origin_coords(obj, val)
        obj.origin_coords = obj.validate_origin_coords(val);
    end
    function obj = set.origin_coords_unit(obj, val)
        obj.origin_coords_unit = obj.validate_origin_coords_unit(val);
    end
    function obj = set.reference_frame(obj, val)
        obj.reference_frame = obj.validate_reference_frame(val);
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
    function val = validate_excitation_lambda(obj, val)
        val = types.util.checkDtype('excitation_lambda', 'float32', val);
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
    function val = validate_grid_spacing(obj, val)
        val = types.util.checkDtype('grid_spacing', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[3], [2]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_grid_spacing_unit(obj, val)
        val = types.util.checkDtype('grid_spacing_unit', 'char', val);
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
    function val = validate_imaging_rate(obj, val)
        val = types.util.checkDtype('imaging_rate', 'float32', val);
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
    function val = validate_indicator(obj, val)
        val = types.util.checkDtype('indicator', 'char', val);
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
    function val = validate_manifold(obj, val)
        val = types.util.checkDtype('manifold', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[3,Inf,Inf,Inf], [3,Inf,Inf]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_manifold_conversion(obj, val)
        val = types.util.checkDtype('manifold_conversion', 'float32', val);
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
    function val = validate_manifold_unit(obj, val)
        val = types.util.checkDtype('manifold_unit', 'char', val);
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
    function val = validate_opticalchannel(obj, val)
        constrained = {'types.core.OpticalChannel'};
        types.util.checkSet('opticalchannel', struct(), constrained, val);
    end
    function val = validate_origin_coords(obj, val)
        val = types.util.checkDtype('origin_coords', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[3], [2]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_origin_coords_unit(obj, val)
        val = types.util.checkDtype('origin_coords_unit', 'char', val);
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
    function val = validate_reference_frame(obj, val)
        val = types.util.checkDtype('reference_frame', 'char', val);
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
            if startsWith(class(obj.description), 'types.untyped.')
                refs = obj.description.export(fid, [fullpath '/description'], refs);
            elseif ~isempty(obj.description)
                io.writeDataset(fid, [fullpath '/description'], obj.description);
            end
        end
        if ~isempty(obj.device)
            refs = obj.device.export(fid, [fullpath '/device'], refs);
        else
            error('Property `device` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.excitation_lambda)
            if startsWith(class(obj.excitation_lambda), 'types.untyped.')
                refs = obj.excitation_lambda.export(fid, [fullpath '/excitation_lambda'], refs);
            elseif ~isempty(obj.excitation_lambda)
                io.writeDataset(fid, [fullpath '/excitation_lambda'], obj.excitation_lambda);
            end
        else
            error('Property `excitation_lambda` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.grid_spacing)
            if startsWith(class(obj.grid_spacing), 'types.untyped.')
                refs = obj.grid_spacing.export(fid, [fullpath '/grid_spacing'], refs);
            elseif ~isempty(obj.grid_spacing)
                io.writeDataset(fid, [fullpath '/grid_spacing'], obj.grid_spacing);
            end
        end
        if ~isempty(obj.grid_spacing_unit) && ~isempty(obj.grid_spacing)
            io.writeAttribute(fid, [fullpath '/grid_spacing/unit'], obj.grid_spacing_unit);
        elseif ~isempty(obj.grid_spacing)
            error('Property `grid_spacing_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.imaging_rate)
            if startsWith(class(obj.imaging_rate), 'types.untyped.')
                refs = obj.imaging_rate.export(fid, [fullpath '/imaging_rate'], refs);
            elseif ~isempty(obj.imaging_rate)
                io.writeDataset(fid, [fullpath '/imaging_rate'], obj.imaging_rate);
            end
        end
        if ~isempty(obj.indicator)
            if startsWith(class(obj.indicator), 'types.untyped.')
                refs = obj.indicator.export(fid, [fullpath '/indicator'], refs);
            elseif ~isempty(obj.indicator)
                io.writeDataset(fid, [fullpath '/indicator'], obj.indicator);
            end
        else
            error('Property `indicator` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.location)
            if startsWith(class(obj.location), 'types.untyped.')
                refs = obj.location.export(fid, [fullpath '/location'], refs);
            elseif ~isempty(obj.location)
                io.writeDataset(fid, [fullpath '/location'], obj.location);
            end
        else
            error('Property `location` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.manifold)
            if startsWith(class(obj.manifold), 'types.untyped.')
                refs = obj.manifold.export(fid, [fullpath '/manifold'], refs);
            elseif ~isempty(obj.manifold)
                io.writeDataset(fid, [fullpath '/manifold'], obj.manifold, 'forceArray');
            end
        end
        if ~isempty(obj.manifold_conversion) && ~isempty(obj.manifold)
            io.writeAttribute(fid, [fullpath '/manifold/conversion'], obj.manifold_conversion);
        end
        if ~isempty(obj.manifold_unit) && ~isempty(obj.manifold)
            io.writeAttribute(fid, [fullpath '/manifold/unit'], obj.manifold_unit);
        end
        if ~isempty(obj.opticalchannel)
            refs = obj.opticalchannel.export(fid, fullpath, refs);
        else
            error('Property `opticalchannel` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.origin_coords)
            if startsWith(class(obj.origin_coords), 'types.untyped.')
                refs = obj.origin_coords.export(fid, [fullpath '/origin_coords'], refs);
            elseif ~isempty(obj.origin_coords)
                io.writeDataset(fid, [fullpath '/origin_coords'], obj.origin_coords);
            end
        end
        if ~isempty(obj.origin_coords_unit) && ~isempty(obj.origin_coords)
            io.writeAttribute(fid, [fullpath '/origin_coords/unit'], obj.origin_coords_unit);
        elseif ~isempty(obj.origin_coords)
            error('Property `origin_coords_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.reference_frame)
            if startsWith(class(obj.reference_frame), 'types.untyped.')
                refs = obj.reference_frame.export(fid, [fullpath '/reference_frame'], refs);
            elseif ~isempty(obj.reference_frame)
                io.writeDataset(fid, [fullpath '/reference_frame'], obj.reference_frame);
            end
        end
    end
end

end