classdef PlaneSegmentation < types.hdmf_common.DynamicTable & types.untyped.GroupClass
% PLANESEGMENTATION Results from image segmentation of a specific imaging plane.


% PROPERTIES
properties
    image_mask; % ROI masks for each ROI. Each image mask is the size of the original imaging plane (or volume) and members of the ROI are finite non-zero.
    imaging_plane; % Link to ImagingPlane object from which this data was generated.
    pixel_mask; % Pixel masks for each ROI: a list of indices and weights for the ROI. Pixel masks are concatenated and parsing of this dataset is maintained by the PlaneSegmentation
    pixel_mask_index; % Index into pixel_mask.
    reference_images; % One or more image stacks that the masks apply to (can be one-element stack).
    voxel_mask; % Voxel masks for each ROI: a list of indices and weights for the ROI. Voxel masks are concatenated and parsing of this dataset is maintained by the PlaneSegmentation
    voxel_mask_index; % Index into voxel_mask.
end

methods
    function obj = PlaneSegmentation(varargin)
        % PLANESEGMENTATION Constructor for PlaneSegmentation
        %     obj = PLANESEGMENTATION(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % imaging_plane = ImagingPlane
        % image_mask = VectorData
        % pixel_mask = VectorData
        % pixel_mask_index = VectorIndex
        % reference_images = ImageSeries
        % voxel_mask = VectorData
        % voxel_mask_index = VectorIndex
        obj = obj@types.hdmf_common.DynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'imaging_plane',[]);
        addParameter(p, 'image_mask',[]);
        addParameter(p, 'pixel_mask',[]);
        addParameter(p, 'pixel_mask_index',[]);
        addParameter(p, 'reference_images',types.untyped.Set());
        addParameter(p, 'voxel_mask',[]);
        addParameter(p, 'voxel_mask_index',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.imaging_plane = p.Results.imaging_plane;
        obj.image_mask = p.Results.image_mask;
        obj.pixel_mask = p.Results.pixel_mask;
        obj.pixel_mask_index = p.Results.pixel_mask_index;
        obj.reference_images = p.Results.reference_images;
        obj.voxel_mask = p.Results.voxel_mask;
        obj.voxel_mask_index = p.Results.voxel_mask_index;
        if strcmp(class(obj), 'types.core.PlaneSegmentation')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.image_mask(obj, val)
        obj.image_mask = obj.validate_image_mask(val);
    end
    function obj = set.imaging_plane(obj, val)
        obj.imaging_plane = obj.validate_imaging_plane(val);
    end
    function obj = set.pixel_mask(obj, val)
        obj.pixel_mask = obj.validate_pixel_mask(val);
    end
    function obj = set.pixel_mask_index(obj, val)
        obj.pixel_mask_index = obj.validate_pixel_mask_index(val);
    end
    function obj = set.reference_images(obj, val)
        obj.reference_images = obj.validate_reference_images(val);
    end
    function obj = set.voxel_mask(obj, val)
        obj.voxel_mask = obj.validate_voxel_mask(val);
    end
    function obj = set.voxel_mask_index(obj, val)
        obj.voxel_mask_index = obj.validate_voxel_mask_index(val);
    end
    %% VALIDATORS
    
    function val = validate_image_mask(obj, val)
        val = types.util.checkDtype('image_mask', 'types.hdmf_common.VectorData', val);
    end
    function val = validate_imaging_plane(obj, val)
        val = types.util.checkDtype('imaging_plane', 'types.core.ImagingPlane', val);
    end
    function val = validate_pixel_mask(obj, val)
        val = types.util.checkDtype('pixel_mask', 'types.hdmf_common.VectorData', val);
    end
    function val = validate_pixel_mask_index(obj, val)
        val = types.util.checkDtype('pixel_mask_index', 'types.hdmf_common.VectorIndex', val);
    end
    function val = validate_reference_images(obj, val)
        constrained = {'types.core.ImageSeries'};
        types.util.checkSet('reference_images', struct(), constrained, val);
    end
    function val = validate_voxel_mask(obj, val)
        val = types.util.checkDtype('voxel_mask', 'types.hdmf_common.VectorData', val);
    end
    function val = validate_voxel_mask_index(obj, val)
        val = types.util.checkDtype('voxel_mask_index', 'types.hdmf_common.VectorIndex', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.DynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.image_mask)
            refs = obj.image_mask.export(fid, [fullpath '/image_mask'], refs);
        end
        if ~isempty(obj.imaging_plane)
            refs = obj.imaging_plane.export(fid, [fullpath '/imaging_plane'], refs);
        else
            error('Property `imaging_plane` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.pixel_mask)
            refs = obj.pixel_mask.export(fid, [fullpath '/pixel_mask'], refs);
        end
        if ~isempty(obj.pixel_mask_index)
            refs = obj.pixel_mask_index.export(fid, [fullpath '/pixel_mask_index'], refs);
        end
        if ~isempty(obj.reference_images)
            refs = obj.reference_images.export(fid, [fullpath '/reference_images'], refs);
        else
            error('Property `reference_images` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.voxel_mask)
            refs = obj.voxel_mask.export(fid, [fullpath '/voxel_mask'], refs);
        end
        if ~isempty(obj.voxel_mask_index)
            refs = obj.voxel_mask_index.export(fid, [fullpath '/voxel_mask_index'], refs);
        end
    end
end

end