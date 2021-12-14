classdef CurrentClampStimulusSeries < types.core.PatchClampSeries & types.untyped.GroupClass
% CURRENTCLAMPSTIMULUSSERIES Stimulus current applied during current clamp recording.



methods
    function obj = CurrentClampStimulusSeries(varargin)
        % CURRENTCLAMPSTIMULUSSERIES Constructor for CurrentClampStimulusSeries
        %     obj = CURRENTCLAMPSTIMULUSSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        varargin = [{'data_unit' 'amperes'} varargin];
        obj = obj@types.core.PatchClampSeries(varargin{:});
        if strcmp(class(obj), 'types.core.CurrentClampStimulusSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    
    %% VALIDATORS
    
    function val = validate_data(obj, val)
    
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.PatchClampSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
    end
end

end