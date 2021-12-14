classdef OpticalChannel < types.core.NWBContainer & types.untyped.GroupClass
% OPTICALCHANNEL An optical channel used to record from an imaging plane.


% PROPERTIES
properties
    description; % Description or other notes about the channel.
    emission_lambda; % Emission wavelength for channel, in nm.
end

methods
    function obj = OpticalChannel(varargin)
        % OPTICALCHANNEL Constructor for OpticalChannel
        %     obj = OPTICALCHANNEL(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % description = char
        % emission_lambda = float32
        obj = obj@types.core.NWBContainer(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'description',[]);
        addParameter(p, 'emission_lambda',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.description = p.Results.description;
        obj.emission_lambda = p.Results.emission_lambda;
        if strcmp(class(obj), 'types.core.OpticalChannel')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.description(obj, val)
        obj.description = obj.validate_description(val);
    end
    function obj = set.emission_lambda(obj, val)
        obj.emission_lambda = obj.validate_emission_lambda(val);
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
    function val = validate_emission_lambda(obj, val)
        val = types.util.checkDtype('emission_lambda', 'float32', val);
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
        if ~isempty(obj.emission_lambda)
            if startsWith(class(obj.emission_lambda), 'types.untyped.')
                refs = obj.emission_lambda.export(fid, [fullpath '/emission_lambda'], refs);
            elseif ~isempty(obj.emission_lambda)
                io.writeDataset(fid, [fullpath '/emission_lambda'], obj.emission_lambda);
            end
        else
            error('Property `emission_lambda` is required in `%s`.', fullpath);
        end
    end
end

end