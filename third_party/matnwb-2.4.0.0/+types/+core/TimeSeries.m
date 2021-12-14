classdef TimeSeries < types.core.NWBDataInterface & types.untyped.GroupClass
% TIMESERIES General purpose time series.


% READONLY
properties(SetAccess=protected)
    starting_time_unit; % Unit of measurement for time, which is fixed to 'seconds'.
    timestamps_interval; % Value is '1'
    timestamps_unit; % Unit of measurement for timestamps, which is fixed to 'seconds'.
end
% PROPERTIES
properties
    comments; % Human-readable comments about the TimeSeries. This second descriptive field can be used to store additional information, or descriptive information if the primary description field is populated with a computer-readable string.
    control; % Numerical labels that apply to each time point in data for the purpose of querying and slicing data by these values. If present, the length of this array should be the same size as the first dimension of data.
    control_description; % Description of each control value. Must be present if control is present. If present, control_description[0] should describe time points where control == 0.
    data; % Data values. Data can be in 1-D, 2-D, 3-D, or 4-D. The first dimension should always represent time. This can also be used to store binary data (e.g., image frames). This can also be a link to data stored in an external file.
    data_continuity; % Optionally describe the continuity of the data. Can be "continuous", "instantaneous", or "step". For example, a voltage trace would be "continuous", because samples are recorded from a continuous process. An array of lick times would be "instantaneous", because the data represents distinct moments in time. Times of image presentations would be "step" because the picture remains the same until the next timepoint. This field is optional, but is useful in providing information about the underlying data. It may inform the way this data is interpreted, the way it is visualized, and what analysis methods are applicable.
    data_conversion; % Scalar to multiply each element in data to convert it to the specified 'unit'. If the data are stored in acquisition system units or other units that require a conversion to be interpretable, multiply the data by 'conversion' to convert the data to the specified 'unit'. e.g. if the data acquisition system stores values in this object as signed 16-bit integers (int16 range -32,768 to 32,767) that correspond to a 5V range (-2.5V to 2.5V), and the data acquisition system gain is 8000X, then the 'conversion' multiplier to get from raw data acquisition values to recorded volts is 2.5/32768/8000 = 9.5367e-9.
    data_resolution; % Smallest meaningful difference between values in data, stored in the specified by unit, e.g., the change in value of the least significant bit, or a larger number if signal noise is known to be present. If unknown, use -1.0.
    data_unit; % Base unit of measurement for working with the data. Actual stored values are not necessarily stored in these units. To access the data in these units, multiply 'data' by 'conversion'.
    description; % Description of the time series.
    starting_time; % Timestamp of the first sample in seconds. When timestamps are uniformly spaced, the timestamp of the first sample can be specified and all subsequent ones calculated from the sampling rate attribute.
    starting_time_rate; % Sampling rate, in Hz.
    timestamps; % Timestamps for samples stored in data, in seconds, relative to the common experiment master-clock stored in NWBFile.timestamps_reference_time.
end

methods
    function obj = TimeSeries(varargin)
        % TIMESERIES Constructor for TimeSeries
        %     obj = TIMESERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % data = any
        % data_unit = char
        % starting_time_rate = float32
        % starting_time_unit = char
        % timestamps_interval = int32
        % timestamps_unit = char
        % comments = char
        % control = uint8
        % control_description = char
        % data_continuity = char
        % data_conversion = float32
        % data_resolution = float32
        % description = char
        % starting_time = float64
        % timestamps = float64
        varargin = [{'comments' 'no comments' 'data_conversion' types.util.correctType(1, 'float32') 'data_resolution' types.util.correctType(-1, 'float32') 'description' 'no description' 'starting_time_unit' 'seconds' 'timestamps_interval' types.util.correctType(1, 'int32') 'timestamps_unit' 'seconds'} varargin];
        obj = obj@types.core.NWBDataInterface(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'data',[]);
        addParameter(p, 'data_unit',[]);
        addParameter(p, 'starting_time_rate',[]);
        addParameter(p, 'starting_time_unit',[]);
        addParameter(p, 'timestamps_interval',[]);
        addParameter(p, 'timestamps_unit',[]);
        addParameter(p, 'comments',[]);
        addParameter(p, 'control',[]);
        addParameter(p, 'control_description',[]);
        addParameter(p, 'data_continuity',[]);
        addParameter(p, 'data_conversion',[]);
        addParameter(p, 'data_resolution',[]);
        addParameter(p, 'description',[]);
        addParameter(p, 'starting_time',[]);
        addParameter(p, 'timestamps',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.data = p.Results.data;
        obj.data_unit = p.Results.data_unit;
        obj.starting_time_rate = p.Results.starting_time_rate;
        obj.starting_time_unit = p.Results.starting_time_unit;
        obj.timestamps_interval = p.Results.timestamps_interval;
        obj.timestamps_unit = p.Results.timestamps_unit;
        obj.comments = p.Results.comments;
        obj.control = p.Results.control;
        obj.control_description = p.Results.control_description;
        obj.data_continuity = p.Results.data_continuity;
        obj.data_conversion = p.Results.data_conversion;
        obj.data_resolution = p.Results.data_resolution;
        obj.description = p.Results.description;
        obj.starting_time = p.Results.starting_time;
        obj.timestamps = p.Results.timestamps;
        if strcmp(class(obj), 'types.core.TimeSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.comments(obj, val)
        obj.comments = obj.validate_comments(val);
    end
    function obj = set.control(obj, val)
        obj.control = obj.validate_control(val);
    end
    function obj = set.control_description(obj, val)
        obj.control_description = obj.validate_control_description(val);
    end
    function obj = set.data(obj, val)
        obj.data = obj.validate_data(val);
    end
    function obj = set.data_continuity(obj, val)
        obj.data_continuity = obj.validate_data_continuity(val);
    end
    function obj = set.data_conversion(obj, val)
        obj.data_conversion = obj.validate_data_conversion(val);
    end
    function obj = set.data_resolution(obj, val)
        obj.data_resolution = obj.validate_data_resolution(val);
    end
    function obj = set.data_unit(obj, val)
        obj.data_unit = obj.validate_data_unit(val);
    end
    function obj = set.description(obj, val)
        obj.description = obj.validate_description(val);
    end
    function obj = set.starting_time(obj, val)
        obj.starting_time = obj.validate_starting_time(val);
    end
    function obj = set.starting_time_rate(obj, val)
        obj.starting_time_rate = obj.validate_starting_time_rate(val);
    end
    function obj = set.timestamps(obj, val)
        obj.timestamps = obj.validate_timestamps(val);
    end
    %% VALIDATORS
    
    function val = validate_comments(obj, val)
        val = types.util.checkDtype('comments', 'char', val);
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
    function val = validate_control(obj, val)
        val = types.util.checkDtype('control', 'uint8', val);
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
    function val = validate_control_description(obj, val)
        val = types.util.checkDtype('control_description', 'char', val);
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
    function val = validate_data(obj, val)
    
    end
    function val = validate_data_continuity(obj, val)
        val = types.util.checkDtype('data_continuity', 'char', val);
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
    function val = validate_data_conversion(obj, val)
        val = types.util.checkDtype('data_conversion', 'float32', val);
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
    function val = validate_data_resolution(obj, val)
        val = types.util.checkDtype('data_resolution', 'float32', val);
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
    function val = validate_data_unit(obj, val)
        val = types.util.checkDtype('data_unit', 'char', val);
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
    function val = validate_description(obj, val)
        val = types.util.checkDtype('description', 'char', val);
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
    function val = validate_starting_time(obj, val)
        val = types.util.checkDtype('starting_time', 'float64', val);
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
    function val = validate_starting_time_rate(obj, val)
        val = types.util.checkDtype('starting_time_rate', 'float32', val);
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
    function val = validate_timestamps(obj, val)
        val = types.util.checkDtype('timestamps', 'float64', val);
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
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBDataInterface(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.comments)
            io.writeAttribute(fid, [fullpath '/comments'], obj.comments);
        end
        if ~isempty(obj.control)
            if startsWith(class(obj.control), 'types.untyped.')
                refs = obj.control.export(fid, [fullpath '/control'], refs);
            elseif ~isempty(obj.control)
                io.writeDataset(fid, [fullpath '/control'], obj.control, 'forceArray');
            end
        end
        if ~isempty(obj.control_description)
            if startsWith(class(obj.control_description), 'types.untyped.')
                refs = obj.control_description.export(fid, [fullpath '/control_description'], refs);
            elseif ~isempty(obj.control_description)
                io.writeDataset(fid, [fullpath '/control_description'], obj.control_description, 'forceArray');
            end
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
        if ~isempty(obj.data_continuity) && ~isempty(obj.data)
            io.writeAttribute(fid, [fullpath '/data/continuity'], obj.data_continuity);
        end
        if ~isempty(obj.data_conversion) && ~isempty(obj.data)
            io.writeAttribute(fid, [fullpath '/data/conversion'], obj.data_conversion);
        end
        if ~isempty(obj.data_resolution) && ~isempty(obj.data)
            io.writeAttribute(fid, [fullpath '/data/resolution'], obj.data_resolution);
        end
        if ~isempty(obj.data_unit) && ~isempty(obj.data)
            io.writeAttribute(fid, [fullpath '/data/unit'], obj.data_unit);
        elseif ~isempty(obj.data)
            error('Property `data_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.description)
            io.writeAttribute(fid, [fullpath '/description'], obj.description);
        end
        if ~isempty(obj.starting_time)
            if startsWith(class(obj.starting_time), 'types.untyped.')
                refs = obj.starting_time.export(fid, [fullpath '/starting_time'], refs);
            elseif ~isempty(obj.starting_time)
                io.writeDataset(fid, [fullpath '/starting_time'], obj.starting_time);
            end
        end
        if ~isempty(obj.starting_time_rate) && ~isempty(obj.starting_time)
            io.writeAttribute(fid, [fullpath '/starting_time/rate'], obj.starting_time_rate);
        elseif ~isempty(obj.starting_time)
            error('Property `starting_time_rate` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.starting_time_unit) && ~isempty(obj.starting_time)
            io.writeAttribute(fid, [fullpath '/starting_time/unit'], obj.starting_time_unit);
        elseif ~isempty(obj.starting_time)
            error('Property `starting_time_unit` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.timestamps)
            if startsWith(class(obj.timestamps), 'types.untyped.')
                refs = obj.timestamps.export(fid, [fullpath '/timestamps'], refs);
            elseif ~isempty(obj.timestamps)
                io.writeDataset(fid, [fullpath '/timestamps'], obj.timestamps, 'forceArray');
            end
        end
        if ~isempty(obj.timestamps_interval) && ~isempty(obj.timestamps)
            io.writeAttribute(fid, [fullpath '/timestamps/interval'], obj.timestamps_interval);
        elseif ~isempty(obj.timestamps)
            error('Property `timestamps_interval` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.timestamps_unit) && ~isempty(obj.timestamps)
            io.writeAttribute(fid, [fullpath '/timestamps/unit'], obj.timestamps_unit);
        elseif ~isempty(obj.timestamps)
            error('Property `timestamps_unit` is required in `%s`.', fullpath);
        end
    end
end

end