classdef AnnotationSeries < types.core.TimeSeries & types.untyped.GroupClass
% ANNOTATIONSERIES Stores user annotations made during an experiment. The data[] field stores a text array, and timestamps are stored for each annotation (ie, interval=1). This is largely an alias to a standard TimeSeries storing a text array but that is identifiable as storing annotations in a machine-readable way.



methods
    function obj = AnnotationSeries(varargin)
        % ANNOTATIONSERIES Constructor for AnnotationSeries
        %     obj = ANNOTATIONSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        varargin = [{'data_resolution' types.util.correctType(-1, 'float32') 'data_unit' 'n/a'} varargin];
        obj = obj@types.core.TimeSeries(varargin{:});
        if strcmp(class(obj), 'types.core.AnnotationSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    
    %% VALIDATORS
    
    function val = validate_data(obj, val)
        val = types.util.checkDtype('data', 'char', val);
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
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.TimeSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
    end
end

end