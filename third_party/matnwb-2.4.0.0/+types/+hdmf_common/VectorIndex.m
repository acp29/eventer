classdef VectorIndex < types.hdmf_common.VectorData & types.untyped.DatasetClass
% VECTORINDEX Used with VectorData to encode a ragged array. An array of indices into the first dimension of the target VectorData, and forming a map between the rows of a DynamicTable and the indices of the VectorData. The name of the VectorIndex is expected to be the name of the target VectorData object followed by "_index".


% PROPERTIES
properties
    target; % Reference to the target dataset that this index applies to.
end

methods
    function obj = VectorIndex(varargin)
        % VECTORINDEX Constructor for VectorIndex
        %     obj = VECTORINDEX(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % target = ref to VectorData object
        obj = obj@types.hdmf_common.VectorData(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'target',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.target = p.Results.target;
        if strcmp(class(obj), 'types.hdmf_common.VectorIndex')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.target(obj, val)
        obj.target = obj.validate_target(val);
    end
    %% VALIDATORS
    
    function val = validate_data(obj, val)
        val = types.util.checkDtype('data', 'uint8', val);
    end
    function val = validate_target(obj, val)
        % Reference to type `VectorData`
        val = types.util.checkDtype('target', 'types.untyped.ObjectView', val);
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
        refs = export@types.hdmf_common.VectorData(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.target)
            io.writeAttribute(fid, [fullpath '/target'], obj.target);
        else
            error('Property `target` is required in `%s`.', fullpath);
        end
    end
end

end