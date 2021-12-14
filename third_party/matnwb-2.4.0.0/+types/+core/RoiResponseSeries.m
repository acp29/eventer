classdef RoiResponseSeries < types.core.TimeSeries & types.untyped.GroupClass
% ROIRESPONSESERIES ROI responses over an imaging plane. The first dimension represents time. The second dimension, if present, represents ROIs.


% PROPERTIES
properties
    rois; % DynamicTableRegion referencing into an ROITable containing information on the ROIs stored in this timeseries.
end

methods
    function obj = RoiResponseSeries(varargin)
        % ROIRESPONSESERIES Constructor for RoiResponseSeries
        %     obj = ROIRESPONSESERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % rois = DynamicTableRegion
        obj = obj@types.core.TimeSeries(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'rois',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.rois = p.Results.rois;
        if strcmp(class(obj), 'types.core.RoiResponseSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.rois(obj, val)
        obj.rois = obj.validate_rois(val);
    end
    %% VALIDATORS
    
    function val = validate_data(obj, val)
        val = types.util.checkDtype('data', 'numeric', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[Inf,Inf], [Inf]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_rois(obj, val)
        val = types.util.checkDtype('rois', 'types.hdmf_common.DynamicTableRegion', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.TimeSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.rois)
            refs = obj.rois.export(fid, [fullpath '/rois'], refs);
        else
            error('Property `rois` is required in `%s`.', fullpath);
        end
    end
end

end