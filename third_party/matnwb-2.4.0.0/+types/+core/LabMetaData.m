classdef LabMetaData < types.core.NWBContainer & types.untyped.GroupClass
% LABMETADATA Lab-specific meta-data.



methods
    function obj = LabMetaData(varargin)
        % LABMETADATA Constructor for LabMetaData
        %     obj = LABMETADATA(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        obj = obj@types.core.NWBContainer(varargin{:});
        if strcmp(class(obj), 'types.core.LabMetaData')
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