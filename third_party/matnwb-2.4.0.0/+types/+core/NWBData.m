classdef NWBData < types.hdmf_common.Data & types.untyped.DatasetClass
% NWBDATA An abstract data type for a dataset.



methods
    function obj = NWBData(varargin)
        % NWBDATA Constructor for NWBData
        %     obj = NWBDATA(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        obj = obj@types.hdmf_common.Data(varargin{:});
        if strcmp(class(obj), 'types.core.NWBData')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    
    %% VALIDATORS
    
    function val = validate_data(obj, val)
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.Data(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
    end
end

end