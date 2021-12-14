classdef ImageMaskSeries < types.core.ImageSeries & types.untyped.GroupClass
% IMAGEMASKSERIES An alpha mask that is applied to a presented visual stimulus. The 'data' array contains an array of mask values that are applied to the displayed image. Mask values are stored as RGBA. Mask can vary with time. The timestamps array indicates the starting time of a mask, and that mask pattern continues until it's explicitly changed.


% PROPERTIES
properties
    masked_imageseries; % Link to ImageSeries object that this image mask is applied to.
end

methods
    function obj = ImageMaskSeries(varargin)
        % IMAGEMASKSERIES Constructor for ImageMaskSeries
        %     obj = IMAGEMASKSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % masked_imageseries = ImageSeries
        obj = obj@types.core.ImageSeries(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'masked_imageseries',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.masked_imageseries = p.Results.masked_imageseries;
        if strcmp(class(obj), 'types.core.ImageMaskSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.masked_imageseries(obj, val)
        obj.masked_imageseries = obj.validate_masked_imageseries(val);
    end
    %% VALIDATORS
    
    function val = validate_masked_imageseries(obj, val)
        val = types.util.checkDtype('masked_imageseries', 'types.core.ImageSeries', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.ImageSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.masked_imageseries)
            refs = obj.masked_imageseries.export(fid, [fullpath '/masked_imageseries'], refs);
        else
            error('Property `masked_imageseries` is required in `%s`.', fullpath);
        end
    end
end

end