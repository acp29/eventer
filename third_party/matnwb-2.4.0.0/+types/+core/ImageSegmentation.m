classdef ImageSegmentation < types.core.NWBDataInterface & types.untyped.GroupClass
% IMAGESEGMENTATION Stores pixels in an image that represent different regions of interest (ROIs) or masks. All segmentation for a given imaging plane is stored together, with storage for multiple imaging planes (masks) supported. Each ROI is stored in its own subgroup, with the ROI group containing both a 2D mask and a list of pixels that make up this mask. Segments can also be used for masking neuropil. If segmentation is allowed to change with time, a new imaging plane (or module) is required and ROI names should remain consistent between them.


% PROPERTIES
properties
    planesegmentation; % Results from image segmentation of a specific imaging plane.
end

methods
    function obj = ImageSegmentation(varargin)
        % IMAGESEGMENTATION Constructor for ImageSegmentation
        %     obj = IMAGESEGMENTATION(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % planesegmentation = PlaneSegmentation
        obj = obj@types.core.NWBDataInterface(varargin{:});
        [obj.planesegmentation, ivarargin] = types.util.parseConstrained(obj,'planesegmentation', 'types.core.PlaneSegmentation', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.core.ImageSegmentation')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.planesegmentation(obj, val)
        obj.planesegmentation = obj.validate_planesegmentation(val);
    end
    %% VALIDATORS
    
    function val = validate_planesegmentation(obj, val)
        constrained = {'types.core.PlaneSegmentation'};
        types.util.checkSet('planesegmentation', struct(), constrained, val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.planesegmentation)
            refs = obj.planesegmentation.export(fid, fullpath, refs);
        else
            error('Property `planesegmentation` is required in `%s`.', fullpath);
        end
    end
end

end