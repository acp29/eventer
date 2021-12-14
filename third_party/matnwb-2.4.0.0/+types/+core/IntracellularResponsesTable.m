classdef IntracellularResponsesTable < types.hdmf_common.DynamicTable & types.untyped.GroupClass
% INTRACELLULARRESPONSESTABLE Table for storing intracellular response related metadata.


% PROPERTIES
properties
    response; % Column storing the reference to the recorded response for the recording (rows)
end

methods
    function obj = IntracellularResponsesTable(varargin)
        % INTRACELLULARRESPONSESTABLE Constructor for IntracellularResponsesTable
        %     obj = INTRACELLULARRESPONSESTABLE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % response = TimeSeriesReferenceVectorData
        varargin = [{'description' 'Table for storing intracellular response related metadata.'} varargin];
        obj = obj@types.hdmf_common.DynamicTable(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'response',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.response = p.Results.response;
        if strcmp(class(obj), 'types.core.IntracellularResponsesTable')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.response(obj, val)
        obj.response = obj.validate_response(val);
    end
    %% VALIDATORS
    
    function val = validate_response(obj, val)
        val = types.util.checkDtype('response', 'types.core.TimeSeriesReferenceVectorData', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.DynamicTable(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.response)
            refs = obj.response.export(fid, [fullpath '/response'], refs);
        else
            error('Property `response` is required in `%s`.', fullpath);
        end
    end
end

end