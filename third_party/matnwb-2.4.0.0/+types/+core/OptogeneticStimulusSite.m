classdef OptogeneticStimulusSite < types.core.NWBContainer & types.untyped.GroupClass
% OPTOGENETICSTIMULUSSITE A site of optogenetic stimulation.


% PROPERTIES
properties
    description; % Description of stimulation site.
    device; % Device that generated the stimulus.
    excitation_lambda; % Excitation wavelength, in nm.
    location; % Location of the stimulation site. Specify the area, layer, comments on estimation of area/layer, stereotaxic coordinates if in vivo, etc. Use standard atlas names for anatomical regions when possible.
end

methods
    function obj = OptogeneticStimulusSite(varargin)
        % OPTOGENETICSTIMULUSSITE Constructor for OptogeneticStimulusSite
        %     obj = OPTOGENETICSTIMULUSSITE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % description = char
        % device = Device
        % excitation_lambda = float32
        % location = char
        obj = obj@types.core.NWBContainer(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'description',[]);
        addParameter(p, 'device',[]);
        addParameter(p, 'excitation_lambda',[]);
        addParameter(p, 'location',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.description = p.Results.description;
        obj.device = p.Results.device;
        obj.excitation_lambda = p.Results.excitation_lambda;
        obj.location = p.Results.location;
        if strcmp(class(obj), 'types.core.OptogeneticStimulusSite')
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
    function obj = set.location(obj, val)
        obj.location = obj.validate_location(val);
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
        else
            error('Property `description` is required in `%s`.', fullpath);
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
        if ~isempty(obj.location)
            if startsWith(class(obj.location), 'types.untyped.')
                refs = obj.location.export(fid, [fullpath '/location'], refs);
            elseif ~isempty(obj.location)
                io.writeDataset(fid, [fullpath '/location'], obj.location);
            end
        else
            error('Property `location` is required in `%s`.', fullpath);
        end
    end
end

end