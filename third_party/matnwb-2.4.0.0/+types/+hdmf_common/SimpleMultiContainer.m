classdef SimpleMultiContainer < types.hdmf_common.Container & types.untyped.GroupClass
% SIMPLEMULTICONTAINER A simple Container for holding onto multiple containers.


% PROPERTIES
properties
    container; % Container objects held within this SimpleMultiContainer.
    data; % Data objects held within this SimpleMultiContainer.
end

methods
    function obj = SimpleMultiContainer(varargin)
        % SIMPLEMULTICONTAINER Constructor for SimpleMultiContainer
        %     obj = SIMPLEMULTICONTAINER(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % container = Container
        % data = Data
        obj = obj@types.hdmf_common.Container(varargin{:});
        [obj.container, ivarargin] = types.util.parseConstrained(obj,'container', 'types.hdmf_common.Container', varargin{:});
        varargin(ivarargin) = [];
        [obj.data, ivarargin] = types.util.parseConstrained(obj,'data', 'types.hdmf_common.Data', varargin{:});
        varargin(ivarargin) = [];
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        misc.parseSkipInvalidName(p, varargin);
        if strcmp(class(obj), 'types.hdmf_common.SimpleMultiContainer')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.container(obj, val)
        obj.container = obj.validate_container(val);
    end
    function obj = set.data(obj, val)
        obj.data = obj.validate_data(val);
    end
    %% VALIDATORS
    
    function val = validate_container(obj, val)
        constrained = {'types.hdmf_common.Container'};
        types.util.checkSet('container', struct(), constrained, val);
    end
    function val = validate_data(obj, val)
        constrained = { 'types.hdmf_common.Data' };
        types.util.checkSet('data', struct(), constrained, val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.hdmf_common.Container(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.container)
            refs = obj.container.export(fid, fullpath, refs);
        end
        if ~isempty(obj.data)
            refs = obj.data.export(fid, fullpath, refs);
        end
    end
end

end