classdef IndexSeries < types.core.TimeSeries & types.untyped.GroupClass
% INDEXSERIES Stores indices to image frames stored in an ImageSeries. The purpose of the ImageIndexSeries is to allow a static image stack to be stored somewhere, and the images in the stack to be referenced out-of-order. This can be for the display of individual images, or of movie segments (as a movie is simply a series of images). The data field stores the index of the frame in the referenced ImageSeries, and the timestamps array indicates when that image was displayed.


% PROPERTIES
properties
    indexed_timeseries; % Link to ImageSeries object containing images that are indexed.
end

methods
    function obj = IndexSeries(varargin)
        % INDEXSERIES Constructor for IndexSeries
        %     obj = INDEXSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % indexed_timeseries = ImageSeries
        obj = obj@types.core.TimeSeries(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'indexed_timeseries',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.indexed_timeseries = p.Results.indexed_timeseries;
        if strcmp(class(obj), 'types.core.IndexSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.indexed_timeseries(obj, val)
        obj.indexed_timeseries = obj.validate_indexed_timeseries(val);
    end
    %% VALIDATORS
    
    function val = validate_data(obj, val)
        val = types.util.checkDtype('data', 'int32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[Inf]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_indexed_timeseries(obj, val)
        val = types.util.checkDtype('indexed_timeseries', 'types.core.ImageSeries', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.TimeSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.indexed_timeseries)
            refs = obj.indexed_timeseries.export(fid, [fullpath '/indexed_timeseries'], refs);
        else
            error('Property `indexed_timeseries` is required in `%s`.', fullpath);
        end
    end
end

end