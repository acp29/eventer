classdef CSRMatrix < types.hdmf_common.Container & types.untyped.GroupClass
% CSRMATRIX A compressed sparse row matrix. Data are stored in the standard CSR format, where column indices for row i are stored in indices[indptr[i]:indptr[i+1]] and their corresponding values are stored in data[indptr[i]:indptr[i+1]].


% PROPERTIES
properties
    data; % The non-zero values in the matrix.
    indices; % The column indices.
    indptr; % The row index pointer.
    shape; % The shape (number of rows, number of columns) of this sparse matrix.
end

methods
    function obj = CSRMatrix(varargin)
        % CSRMATRIX Constructor for CSRMatrix
        %     obj = CSRMATRIX(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % data = any
        % indices = uint
        % indptr = uint
        % shape = uint
        obj = obj@types.hdmf_common.Container(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'data',[]);
        addParameter(p, 'indices',[]);
        addParameter(p, 'indptr',[]);
        addParameter(p, 'shape',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.data = p.Results.data;
        obj.indices = p.Results.indices;
        obj.indptr = p.Results.indptr;
        obj.shape = p.Results.shape;
        if strcmp(class(obj), 'types.hdmf_common.CSRMatrix')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.data(obj, val)
        obj.data = obj.validate_data(val);
    end
    function obj = set.indices(obj, val)
        obj.indices = obj.validate_indices(val);
    end
    function obj = set.indptr(obj, val)
        obj.indptr = obj.validate_indptr(val);
    end
    function obj = set.shape(obj, val)
        obj.shape = obj.validate_shape(val);
    end
    %% VALIDATORS
    
    function val = validate_data(obj, val)
    
    end
    function val = validate_indices(obj, val)
        val = types.util.checkDtype('indices', 'uint', val);
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
    function val = validate_indptr(obj, val)
        val = types.util.checkDtype('indptr', 'uint', val);
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
    function val = validate_shape(obj, val)
        val = types.util.checkDtype('shape', 'uint', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[2]};
        types.util.checkDims(valsz, validshapes);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.Container(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.data)
            if startsWith(class(obj.data), 'types.untyped.')
                refs = obj.data.export(fid, [fullpath '/data'], refs);
            elseif ~isempty(obj.data)
                io.writeDataset(fid, [fullpath '/data'], obj.data, 'forceArray');
            end
        else
            error('Property `data` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.indices)
            if startsWith(class(obj.indices), 'types.untyped.')
                refs = obj.indices.export(fid, [fullpath '/indices'], refs);
            elseif ~isempty(obj.indices)
                io.writeDataset(fid, [fullpath '/indices'], obj.indices, 'forceArray');
            end
        else
            error('Property `indices` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.indptr)
            if startsWith(class(obj.indptr), 'types.untyped.')
                refs = obj.indptr.export(fid, [fullpath '/indptr'], refs);
            elseif ~isempty(obj.indptr)
                io.writeDataset(fid, [fullpath '/indptr'], obj.indptr, 'forceArray');
            end
        else
            error('Property `indptr` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.shape)
            io.writeAttribute(fid, [fullpath '/shape'], obj.shape);
        else
            error('Property `shape` is required in `%s`.', fullpath);
        end
    end
end

end