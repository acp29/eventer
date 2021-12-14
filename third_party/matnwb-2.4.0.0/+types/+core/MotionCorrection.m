classdef MotionCorrection < types.core.NWBDataInterface & types.untyped.GroupClass
% MOTIONCORRECTION An image stack where all frames are shifted (registered) to a common coordinate system, to account for movement and drift between frames. Note: each frame at each point in time is assumed to be 2-D (has only x & y dimensions).


% PROPERTIES
properties
    correctedimagestack; % Reuslts from motion correction of an image stack.
end

methods
    function obj = MotionCorrection(varargin)
        % MOTIONCORRECTION Constructor for MotionCorrection
        %     obj = MOTIONCORRECTION(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % correctedimagestack = CorrectedImageStack
        obj = obj@types.core.NWBDataInterface(varargin{:});
        [obj.correctedimagestack, ivarargin] = types.util.parseConstrained(obj,'correctedimagestack', 'types.core.CorrectedImageStack', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.core.MotionCorrection')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.correctedimagestack(obj, val)
        obj.correctedimagestack = obj.validate_correctedimagestack(val);
    end
    %% VALIDATORS
    
    function val = validate_correctedimagestack(obj, val)
        constrained = {'types.core.CorrectedImageStack'};
        types.util.checkSet('correctedimagestack', struct(), constrained, val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.correctedimagestack)
            refs = obj.correctedimagestack.export(fid, fullpath, refs);
        else
            error('Property `correctedimagestack` is required in `%s`.', fullpath);
        end
    end
end

end