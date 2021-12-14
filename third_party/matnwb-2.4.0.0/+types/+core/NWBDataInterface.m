classdef NWBDataInterface < types.core.NWBContainer & types.untyped.GroupClass
% NWBDATAINTERFACE An abstract data type for a generic container storing collections of data, as opposed to metadata.



methods
    function obj = NWBDataInterface(varargin)
        % NWBDATAINTERFACE Constructor for NWBDataInterface
        %     obj = NWBDATAINTERFACE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        obj = obj@types.core.NWBContainer(varargin{:});
        if strcmp(class(obj), 'types.core.NWBDataInterface')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    
    %% VALIDATORS
    
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBContainer(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
    end
end

end