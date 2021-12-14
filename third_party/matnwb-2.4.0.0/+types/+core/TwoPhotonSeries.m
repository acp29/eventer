classdef TwoPhotonSeries < types.core.ImageSeries & types.untyped.GroupClass
% TWOPHOTONSERIES Image stack recorded over time from 2-photon microscope.


% PROPERTIES
properties
    field_of_view; % Width, height and depth of image, or imaged area, in meters.
    imaging_plane; % Link to ImagingPlane object from which this TimeSeries data was generated.
    pmt_gain; % Photomultiplier gain.
    scan_line_rate; % Lines imaged per second. This is also stored in /general/optophysiology but is kept here as it is useful information for analysis, and so good to be stored w/ the actual data.
end

methods
    function obj = TwoPhotonSeries(varargin)
        % TWOPHOTONSERIES Constructor for TwoPhotonSeries
        %     obj = TWOPHOTONSERIES(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % imaging_plane = ImagingPlane
        % field_of_view = float32
        % pmt_gain = float32
        % scan_line_rate = float32
        obj = obj@types.core.ImageSeries(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'imaging_plane',[]);
        addParameter(p, 'field_of_view',[]);
        addParameter(p, 'pmt_gain',[]);
        addParameter(p, 'scan_line_rate',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.imaging_plane = p.Results.imaging_plane;
        obj.field_of_view = p.Results.field_of_view;
        obj.pmt_gain = p.Results.pmt_gain;
        obj.scan_line_rate = p.Results.scan_line_rate;
        if strcmp(class(obj), 'types.core.TwoPhotonSeries')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.field_of_view(obj, val)
        obj.field_of_view = obj.validate_field_of_view(val);
    end
    function obj = set.imaging_plane(obj, val)
        obj.imaging_plane = obj.validate_imaging_plane(val);
    end
    function obj = set.pmt_gain(obj, val)
        obj.pmt_gain = obj.validate_pmt_gain(val);
    end
    function obj = set.scan_line_rate(obj, val)
        obj.scan_line_rate = obj.validate_scan_line_rate(val);
    end
    %% VALIDATORS
    
    function val = validate_field_of_view(obj, val)
        val = types.util.checkDtype('field_of_view', 'float32', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[3], [2]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_imaging_plane(obj, val)
        val = types.util.checkDtype('imaging_plane', 'types.core.ImagingPlane', val);
    end
    function val = validate_pmt_gain(obj, val)
        val = types.util.checkDtype('pmt_gain', 'float32', val);
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
    function val = validate_scan_line_rate(obj, val)
        val = types.util.checkDtype('scan_line_rate', 'float32', val);
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
        refs = export@types.core.ImageSeries(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.field_of_view)
            if startsWith(class(obj.field_of_view), 'types.untyped.')
                refs = obj.field_of_view.export(fid, [fullpath '/field_of_view'], refs);
            elseif ~isempty(obj.field_of_view)
                io.writeDataset(fid, [fullpath '/field_of_view'], obj.field_of_view);
            end
        end
        if ~isempty(obj.imaging_plane)
            refs = obj.imaging_plane.export(fid, [fullpath '/imaging_plane'], refs);
        else
            error('Property `imaging_plane` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.pmt_gain)
            io.writeAttribute(fid, [fullpath '/pmt_gain'], obj.pmt_gain);
        end
        if ~isempty(obj.scan_line_rate)
            io.writeAttribute(fid, [fullpath '/scan_line_rate'], obj.scan_line_rate);
        end
    end
end

end