classdef IntracellularElectrodesTable < types.hdmf_common.DynamicTable & types.untyped.GroupClass
% INTRACELLULARELECTRODESTABLE Table for storing intracellular electrode related metadata.


% PROPERTIES
properties
    electrode; % Column for storing the reference to the intracellular electrode.
end

methods
    function obj = IntracellularElectrodesTable(varargin)
        % INTRACELLULARELECTRODESTABLE Constructor for IntracellularElectrodesTable
        %     obj = INTRACELLULARELECTRODESTABLE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % electrode = VectorData
        varargin = [{'description' 'Table for storing intracellular electrode related metadata.'} varargin];
        obj = obj@types.hdmf_common.DynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'electrode',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.electrode = p.Results.electrode;
        if strcmp(class(obj), 'types.core.IntracellularElectrodesTable')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.electrode(obj, val)
        obj.electrode = obj.validate_electrode(val);
    end
    %% VALIDATORS
    
    function val = validate_electrode(obj, val)
        val = types.util.checkDtype('electrode', 'types.hdmf_common.VectorData', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.DynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.electrode)
            refs = obj.electrode.export(fid, [fullpath '/electrode'], refs);
        else
            error('Property `electrode` is required in `%s`.', fullpath);
        end
    end
end

end