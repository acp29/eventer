classdef CorrectedImageStack < types.core.NWBDataInterface & types.untyped.GroupClass
% CORRECTEDIMAGESTACK Reuslts from motion correction of an image stack.


% PROPERTIES
properties
    corrected; % Image stack with frames shifted to the common coordinates.
    original; % Link to ImageSeries object that is being registered.
    xy_translation; % Stores the x,y delta necessary to align each frame to the common coordinates, for example, to align each frame to a reference image.
end

methods
    function obj = CorrectedImageStack(varargin)
        % CORRECTEDIMAGESTACK Constructor for CorrectedImageStack
        %     obj = CORRECTEDIMAGESTACK(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % corrected = ImageSeries
        % original = ImageSeries
        % xy_translation = TimeSeries
        obj = obj@types.core.NWBDataInterface(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'corrected',[]);
        addParameter(p, 'original',[]);
        addParameter(p, 'xy_translation',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.corrected = p.Results.corrected;
        obj.original = p.Results.original;
        obj.xy_translation = p.Results.xy_translation;
        if strcmp(class(obj), 'types.core.CorrectedImageStack')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.corrected(obj, val)
        obj.corrected = obj.validate_corrected(val);
    end
    function obj = set.original(obj, val)
        obj.original = obj.validate_original(val);
    end
    function obj = set.xy_translation(obj, val)
        obj.xy_translation = obj.validate_xy_translation(val);
    end
    %% VALIDATORS
    
    function val = validate_corrected(obj, val)
        val = types.util.checkDtype('corrected', 'types.core.ImageSeries', val);
    end
    function val = validate_original(obj, val)
        val = types.util.checkDtype('original', 'types.core.ImageSeries', val);
    end
    function val = validate_xy_translation(obj, val)
        val = types.util.checkDtype('xy_translation', 'types.core.TimeSeries', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.corrected)
            refs = obj.corrected.export(fid, [fullpath '/corrected'], refs);
        else
            error('Property `corrected` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.original)
            refs = obj.original.export(fid, [fullpath '/original'], refs);
        else
            error('Property `original` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.xy_translation)
            refs = obj.xy_translation.export(fid, [fullpath '/xy_translation'], refs);
        else
            error('Property `xy_translation` is required in `%s`.', fullpath);
        end
    end
end

end