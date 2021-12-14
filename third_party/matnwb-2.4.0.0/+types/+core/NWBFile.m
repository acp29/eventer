classdef NWBFile < types.core.NWBContainer & types.untyped.GroupClass
% NWBFILE An NWB:N file storing cellular-based neurophysiology data from a single experimental session.


% READONLY
properties(SetAccess=protected)
    nwb_version; % File version string. Use semantic versioning, e.g. 1.2.1. This will be the name of the format with trailing major, minor and patch numbers.
end
% PROPERTIES
properties
    acquisition; % Acquired, raw data.
    analysis; % Custom analysis results.
    file_create_date; % A record of the date the file was created and of subsequent modifications. The date is stored in UTC with local timezone offset as ISO 8601 extended formatted strings: 2018-09-28T14:43:54.123+02:00. Dates stored in UTC end in "Z" with no timezone offset. Date accuracy is up to milliseconds. The file can be created after the experiment was run, so this may differ from the experiment start time. Each modification to the nwb file adds a new entry to the array.
    general; % Place-holder than can be extended so that lab-specific meta-data can be placed in /general.
    general_data_collection; % Notes about data collection and analysis.
    general_devices; % Data acquisition devices.
    general_experiment_description; % General description of the experiment.
    general_experimenter; % Name of person(s) who performed the experiment. Can also specify roles of different people involved.
    general_extracellular_ephys; % Physical group of electrodes.
    general_extracellular_ephys_electrodes; % A table of all electrodes (i.e. channels) used for recording.
    general_institution; % Institution(s) where experiment was performed.
    general_intracellular_ephys; % An intracellular electrode.
    general_intracellular_ephys_experimental_conditions; % A table for grouping different intracellular recording repetitions together that belong to the same experimental experimental_conditions.
    general_intracellular_ephys_filtering; % [DEPRECATED] Use IntracellularElectrode.filtering instead. Description of filtering used. Includes filtering type and parameters, frequency fall-off, etc. If this changes between TimeSeries, filter description should be stored as a text attribute for each TimeSeries.
    general_intracellular_ephys_intracellular_recordings; % A table to group together a stimulus and response from a single electrode and a single simultaneous recording. Each row in the table represents a single recording consisting typically of a stimulus and a corresponding response. In some cases, however, only a stimulus or a response are recorded as as part of an experiment. In this case both, the stimulus and response will point to the same TimeSeries while the idx_start and count of the invalid column will be set to -1, thus, indicating that no values have been recorded for the stimulus or response, respectively. Note, a recording MUST contain at least a stimulus or a response. Typically the stimulus and response are PatchClampSeries. However, the use of AD/DA channels that are not associated to an electrode is also common in intracellular electrophysiology, in which case other TimeSeries may be used.
    general_intracellular_ephys_repetitions; % A table for grouping different sequential intracellular recordings together. With each SequentialRecording typically representing a particular type of stimulus, the RepetitionsTable table is typically used to group sets of stimuli applied in sequence.
    general_intracellular_ephys_sequential_recordings; % A table for grouping different sequential recordings from the SimultaneousRecordingsTable table together. This is typically used to group together sequential recordings where the a sequence of stimuli of the same type with varying parameters have been presented in a sequence.
    general_intracellular_ephys_simultaneous_recordings; % A table for grouping different intracellular recordings from the IntracellularRecordingsTable table together that were recorded simultaneously from different electrodes
    general_intracellular_ephys_sweep_table; % [DEPRECATED] Table used to group different PatchClampSeries. SweepTable is being replaced by IntracellularRecordingsTable and SimultaneousRecordingsTable tabels. Additional SequentialRecordingsTable, RepetitionsTable and ExperimentalConditions tables provide enhanced support for experiment metadata.
    general_keywords; % Terms to search over.
    general_lab; % Laboratory where experiment was performed.
    general_notes; % Notes about the experiment.
    general_optogenetics; % An optogenetic stimulation site.
    general_optophysiology; % An imaging plane.
    general_pharmacology; % Description of drugs used, including how and when they were administered. Anesthesia(s), painkiller(s), etc., plus dosage, concentration, etc.
    general_protocol; % Experimental protocol, if applicable. e.g., include IACUC protocol number.
    general_related_publications; % Publication information. PMID, DOI, URL, etc.
    general_session_id; % Lab-specific ID for the session.
    general_slices; % Description of slices, including information about preparation thickness, orientation, temperature, and bath solution.
    general_source_script; % Script file or link to public source code used to create this NWB file.
    general_source_script_file_name; % Name of script file.
    general_stimulus; % Notes about stimuli, such as how and where they were presented.
    general_subject; % Information about the animal or person from which the data was measured.
    general_surgery; % Narrative description about surgery/surgeries, including date(s) and who performed surgery.
    general_virus; % Information about virus(es) used in experiments, including virus ID, source, date made, injection location, volume, etc.
    identifier; % A unique text identifier for the file. For example, concatenated lab name, file creation date/time and experimentalist, or a hash of these and/or other values. The goal is that the string should be unique to all other files.
    intervals; % Optional additional table(s) for describing other experimental time intervals.
    intervals_epochs; % Divisions in time marking experimental stages or sub-divisions of a single recording session.
    intervals_invalid_times; % Time intervals that should be removed from analysis.
    intervals_trials; % Repeated experimental events that have a logical grouping.
    processing; % Intermediate analysis of acquired data.
    scratch; % Any one-off datasets
    session_description; % A description of the experimental session and data in the file.
    session_start_time; % Date and time of the experiment/session start. The date is stored in UTC with local timezone offset as ISO 8601 extended formatted string: 2018-09-28T14:43:54.123+02:00. Dates stored in UTC end in "Z" with no timezone offset. Date accuracy is up to milliseconds.
    stimulus_presentation; % TimeSeries objects containing data of presented stimuli.
    stimulus_templates; % TimeSeries objects containing template data of presented stimuli.
    timestamps_reference_time; % Date and time corresponding to time zero of all timestamps. The date is stored in UTC with local timezone offset as ISO 8601 extended formatted string: 2018-09-28T14:43:54.123+02:00. Dates stored in UTC end in "Z" with no timezone offset. Date accuracy is up to milliseconds. All times stored in the file use this time as reference (i.e., time zero).
    units; % Data about sorted spike units.
end

methods
    function obj = NWBFile(varargin)
        % NWBFILE Constructor for NWBFile
        %     obj = NWBFILE(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % file_create_date = isodatetime
        % general_source_script_file_name = char
        % identifier = char
        % nwb_version = char
        % session_description = char
        % session_start_time = isodatetime
        % timestamps_reference_time = isodatetime
        % acquisition = NWBDataInterface
        % analysis = NWBContainer
        % general = LabMetaData
        % general_data_collection = char
        % general_devices = Device
        % general_experiment_description = char
        % general_experimenter = char
        % general_extracellular_ephys = ElectrodeGroup
        % general_extracellular_ephys_electrodes = DynamicTable
        % general_institution = char
        % general_intracellular_ephys = IntracellularElectrode
        % general_intracellular_ephys_experimental_conditions = ExperimentalConditionsTable
        % general_intracellular_ephys_filtering = char
        % general_intracellular_ephys_intracellular_recordings = IntracellularRecordingsTable
        % general_intracellular_ephys_repetitions = RepetitionsTable
        % general_intracellular_ephys_sequential_recordings = SequentialRecordingsTable
        % general_intracellular_ephys_simultaneous_recordings = SimultaneousRecordingsTable
        % general_intracellular_ephys_sweep_table = SweepTable
        % general_keywords = char
        % general_lab = char
        % general_notes = char
        % general_optogenetics = OptogeneticStimulusSite
        % general_optophysiology = ImagingPlane
        % general_pharmacology = char
        % general_protocol = char
        % general_related_publications = char
        % general_session_id = char
        % general_slices = char
        % general_source_script = char
        % general_stimulus = char
        % general_subject = Subject
        % general_surgery = char
        % general_virus = char
        % intervals = TimeIntervals
        % intervals_epochs = TimeIntervals
        % intervals_invalid_times = TimeIntervals
        % intervals_trials = TimeIntervals
        % processing = ProcessingModule
        % scratch = ScratchData
        % stimulus_presentation = TimeSeries
        % stimulus_templates = TimeSeries
        % units = Units
        varargin = [{'nwb_version' '2.4.0'} varargin];
        obj = obj@types.core.NWBContainer(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'file_create_date',[]);
        addParameter(p, 'general_source_script_file_name',[]);
        addParameter(p, 'identifier',[]);
        addParameter(p, 'nwb_version',[]);
        addParameter(p, 'session_description',[]);
        addParameter(p, 'session_start_time',[]);
        addParameter(p, 'timestamps_reference_time',[]);
        addParameter(p, 'acquisition',types.untyped.Set());
        addParameter(p, 'analysis',types.untyped.Set());
        addParameter(p, 'general',types.untyped.Set());
        addParameter(p, 'general_data_collection',[]);
        addParameter(p, 'general_devices',types.untyped.Set());
        addParameter(p, 'general_experiment_description',[]);
        addParameter(p, 'general_experimenter',[]);
        addParameter(p, 'general_extracellular_ephys',types.untyped.Set());
        addParameter(p, 'general_extracellular_ephys_electrodes',[]);
        addParameter(p, 'general_institution',[]);
        addParameter(p, 'general_intracellular_ephys',types.untyped.Set());
        addParameter(p, 'general_intracellular_ephys_experimental_conditions',[]);
        addParameter(p, 'general_intracellular_ephys_filtering',[]);
        addParameter(p, 'general_intracellular_ephys_intracellular_recordings',[]);
        addParameter(p, 'general_intracellular_ephys_repetitions',[]);
        addParameter(p, 'general_intracellular_ephys_sequential_recordings',[]);
        addParameter(p, 'general_intracellular_ephys_simultaneous_recordings',[]);
        addParameter(p, 'general_intracellular_ephys_sweep_table',[]);
        addParameter(p, 'general_keywords',[]);
        addParameter(p, 'general_lab',[]);
        addParameter(p, 'general_notes',[]);
        addParameter(p, 'general_optogenetics',types.untyped.Set());
        addParameter(p, 'general_optophysiology',types.untyped.Set());
        addParameter(p, 'general_pharmacology',[]);
        addParameter(p, 'general_protocol',[]);
        addParameter(p, 'general_related_publications',[]);
        addParameter(p, 'general_session_id',[]);
        addParameter(p, 'general_slices',[]);
        addParameter(p, 'general_source_script',[]);
        addParameter(p, 'general_stimulus',[]);
        addParameter(p, 'general_subject',[]);
        addParameter(p, 'general_surgery',[]);
        addParameter(p, 'general_virus',[]);
        addParameter(p, 'intervals',types.untyped.Set());
        addParameter(p, 'intervals_epochs',[]);
        addParameter(p, 'intervals_invalid_times',[]);
        addParameter(p, 'intervals_trials',[]);
        addParameter(p, 'processing',types.untyped.Set());
        addParameter(p, 'scratch',types.untyped.Set());
        addParameter(p, 'stimulus_presentation',types.untyped.Set());
        addParameter(p, 'stimulus_templates',types.untyped.Set());
        addParameter(p, 'units',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.file_create_date = p.Results.file_create_date;
        obj.general_source_script_file_name = p.Results.general_source_script_file_name;
        obj.identifier = p.Results.identifier;
        obj.nwb_version = p.Results.nwb_version;
        obj.session_description = p.Results.session_description;
        obj.session_start_time = p.Results.session_start_time;
        obj.timestamps_reference_time = p.Results.timestamps_reference_time;
        obj.acquisition = p.Results.acquisition;
        obj.analysis = p.Results.analysis;
        obj.general = p.Results.general;
        obj.general_data_collection = p.Results.general_data_collection;
        obj.general_devices = p.Results.general_devices;
        obj.general_experiment_description = p.Results.general_experiment_description;
        obj.general_experimenter = p.Results.general_experimenter;
        obj.general_extracellular_ephys = p.Results.general_extracellular_ephys;
        obj.general_extracellular_ephys_electrodes = p.Results.general_extracellular_ephys_electrodes;
        obj.general_institution = p.Results.general_institution;
        obj.general_intracellular_ephys = p.Results.general_intracellular_ephys;
        obj.general_intracellular_ephys_experimental_conditions = p.Results.general_intracellular_ephys_experimental_conditions;
        obj.general_intracellular_ephys_filtering = p.Results.general_intracellular_ephys_filtering;
        obj.general_intracellular_ephys_intracellular_recordings = p.Results.general_intracellular_ephys_intracellular_recordings;
        obj.general_intracellular_ephys_repetitions = p.Results.general_intracellular_ephys_repetitions;
        obj.general_intracellular_ephys_sequential_recordings = p.Results.general_intracellular_ephys_sequential_recordings;
        obj.general_intracellular_ephys_simultaneous_recordings = p.Results.general_intracellular_ephys_simultaneous_recordings;
        obj.general_intracellular_ephys_sweep_table = p.Results.general_intracellular_ephys_sweep_table;
        obj.general_keywords = p.Results.general_keywords;
        obj.general_lab = p.Results.general_lab;
        obj.general_notes = p.Results.general_notes;
        obj.general_optogenetics = p.Results.general_optogenetics;
        obj.general_optophysiology = p.Results.general_optophysiology;
        obj.general_pharmacology = p.Results.general_pharmacology;
        obj.general_protocol = p.Results.general_protocol;
        obj.general_related_publications = p.Results.general_related_publications;
        obj.general_session_id = p.Results.general_session_id;
        obj.general_slices = p.Results.general_slices;
        obj.general_source_script = p.Results.general_source_script;
        obj.general_stimulus = p.Results.general_stimulus;
        obj.general_subject = p.Results.general_subject;
        obj.general_surgery = p.Results.general_surgery;
        obj.general_virus = p.Results.general_virus;
        obj.intervals = p.Results.intervals;
        obj.intervals_epochs = p.Results.intervals_epochs;
        obj.intervals_invalid_times = p.Results.intervals_invalid_times;
        obj.intervals_trials = p.Results.intervals_trials;
        obj.processing = p.Results.processing;
        obj.scratch = p.Results.scratch;
        obj.stimulus_presentation = p.Results.stimulus_presentation;
        obj.stimulus_templates = p.Results.stimulus_templates;
        obj.units = p.Results.units;
        if strcmp(class(obj), 'types.core.NWBFile')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.acquisition(obj, val)
        obj.acquisition = obj.validate_acquisition(val);
    end
    function obj = set.analysis(obj, val)
        obj.analysis = obj.validate_analysis(val);
    end
    function obj = set.file_create_date(obj, val)
        obj.file_create_date = obj.validate_file_create_date(val);
    end
    function obj = set.general(obj, val)
        obj.general = obj.validate_general(val);
    end
    function obj = set.general_data_collection(obj, val)
        obj.general_data_collection = obj.validate_general_data_collection(val);
    end
    function obj = set.general_devices(obj, val)
        obj.general_devices = obj.validate_general_devices(val);
    end
    function obj = set.general_experiment_description(obj, val)
        obj.general_experiment_description = obj.validate_general_experiment_description(val);
    end
    function obj = set.general_experimenter(obj, val)
        obj.general_experimenter = obj.validate_general_experimenter(val);
    end
    function obj = set.general_extracellular_ephys(obj, val)
        obj.general_extracellular_ephys = obj.validate_general_extracellular_ephys(val);
    end
    function obj = set.general_extracellular_ephys_electrodes(obj, val)
        obj.general_extracellular_ephys_electrodes = obj.validate_general_extracellular_ephys_electrodes(val);
    end
    function obj = set.general_institution(obj, val)
        obj.general_institution = obj.validate_general_institution(val);
    end
    function obj = set.general_intracellular_ephys(obj, val)
        obj.general_intracellular_ephys = obj.validate_general_intracellular_ephys(val);
    end
    function obj = set.general_intracellular_ephys_experimental_conditions(obj, val)
        obj.general_intracellular_ephys_experimental_conditions = obj.validate_general_intracellular_ephys_experimental_conditions(val);
    end
    function obj = set.general_intracellular_ephys_filtering(obj, val)
        obj.general_intracellular_ephys_filtering = obj.validate_general_intracellular_ephys_filtering(val);
    end
    function obj = set.general_intracellular_ephys_intracellular_recordings(obj, val)
        obj.general_intracellular_ephys_intracellular_recordings = obj.validate_general_intracellular_ephys_intracellular_recordings(val);
    end
    function obj = set.general_intracellular_ephys_repetitions(obj, val)
        obj.general_intracellular_ephys_repetitions = obj.validate_general_intracellular_ephys_repetitions(val);
    end
    function obj = set.general_intracellular_ephys_sequential_recordings(obj, val)
        obj.general_intracellular_ephys_sequential_recordings = obj.validate_general_intracellular_ephys_sequential_recordings(val);
    end
    function obj = set.general_intracellular_ephys_simultaneous_recordings(obj, val)
        obj.general_intracellular_ephys_simultaneous_recordings = obj.validate_general_intracellular_ephys_simultaneous_recordings(val);
    end
    function obj = set.general_intracellular_ephys_sweep_table(obj, val)
        obj.general_intracellular_ephys_sweep_table = obj.validate_general_intracellular_ephys_sweep_table(val);
    end
    function obj = set.general_keywords(obj, val)
        obj.general_keywords = obj.validate_general_keywords(val);
    end
    function obj = set.general_lab(obj, val)
        obj.general_lab = obj.validate_general_lab(val);
    end
    function obj = set.general_notes(obj, val)
        obj.general_notes = obj.validate_general_notes(val);
    end
    function obj = set.general_optogenetics(obj, val)
        obj.general_optogenetics = obj.validate_general_optogenetics(val);
    end
    function obj = set.general_optophysiology(obj, val)
        obj.general_optophysiology = obj.validate_general_optophysiology(val);
    end
    function obj = set.general_pharmacology(obj, val)
        obj.general_pharmacology = obj.validate_general_pharmacology(val);
    end
    function obj = set.general_protocol(obj, val)
        obj.general_protocol = obj.validate_general_protocol(val);
    end
    function obj = set.general_related_publications(obj, val)
        obj.general_related_publications = obj.validate_general_related_publications(val);
    end
    function obj = set.general_session_id(obj, val)
        obj.general_session_id = obj.validate_general_session_id(val);
    end
    function obj = set.general_slices(obj, val)
        obj.general_slices = obj.validate_general_slices(val);
    end
    function obj = set.general_source_script(obj, val)
        obj.general_source_script = obj.validate_general_source_script(val);
    end
    function obj = set.general_source_script_file_name(obj, val)
        obj.general_source_script_file_name = obj.validate_general_source_script_file_name(val);
    end
    function obj = set.general_stimulus(obj, val)
        obj.general_stimulus = obj.validate_general_stimulus(val);
    end
    function obj = set.general_subject(obj, val)
        obj.general_subject = obj.validate_general_subject(val);
    end
    function obj = set.general_surgery(obj, val)
        obj.general_surgery = obj.validate_general_surgery(val);
    end
    function obj = set.general_virus(obj, val)
        obj.general_virus = obj.validate_general_virus(val);
    end
    function obj = set.identifier(obj, val)
        obj.identifier = obj.validate_identifier(val);
    end
    function obj = set.intervals(obj, val)
        obj.intervals = obj.validate_intervals(val);
    end
    function obj = set.intervals_epochs(obj, val)
        obj.intervals_epochs = obj.validate_intervals_epochs(val);
    end
    function obj = set.intervals_invalid_times(obj, val)
        obj.intervals_invalid_times = obj.validate_intervals_invalid_times(val);
    end
    function obj = set.intervals_trials(obj, val)
        obj.intervals_trials = obj.validate_intervals_trials(val);
    end
    function obj = set.processing(obj, val)
        obj.processing = obj.validate_processing(val);
    end
    function obj = set.scratch(obj, val)
        obj.scratch = obj.validate_scratch(val);
    end
    function obj = set.session_description(obj, val)
        obj.session_description = obj.validate_session_description(val);
    end
    function obj = set.session_start_time(obj, val)
        obj.session_start_time = obj.validate_session_start_time(val);
    end
    function obj = set.stimulus_presentation(obj, val)
        obj.stimulus_presentation = obj.validate_stimulus_presentation(val);
    end
    function obj = set.stimulus_templates(obj, val)
        obj.stimulus_templates = obj.validate_stimulus_templates(val);
    end
    function obj = set.timestamps_reference_time(obj, val)
        obj.timestamps_reference_time = obj.validate_timestamps_reference_time(val);
    end
    function obj = set.units(obj, val)
        obj.units = obj.validate_units(val);
    end
    %% VALIDATORS
    
    function val = validate_acquisition(obj, val)
        constrained = {'types.core.NWBDataInterface'};
        types.util.checkSet('acquisition', struct(), constrained, val);
    end
    function val = validate_analysis(obj, val)
        constrained = {'types.core.NWBContainer'};
        types.util.checkSet('analysis', struct(), constrained, val);
    end
    function val = validate_file_create_date(obj, val)
        val = types.util.checkDtype('file_create_date', 'isodatetime', val);
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
    function val = validate_general(obj, val)
        constrained = {'types.core.LabMetaData'};
        types.util.checkSet('general', struct(), constrained, val);
    end
    function val = validate_general_data_collection(obj, val)
        val = types.util.checkDtype('general_data_collection', 'char', val);
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
    function val = validate_general_devices(obj, val)
        constrained = {'types.core.Device'};
        types.util.checkSet('general_devices', struct(), constrained, val);
    end
    function val = validate_general_experiment_description(obj, val)
        val = types.util.checkDtype('general_experiment_description', 'char', val);
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
    function val = validate_general_experimenter(obj, val)
        val = types.util.checkDtype('general_experimenter', 'char', val);
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
    function val = validate_general_extracellular_ephys(obj, val)
        constrained = {'types.core.ElectrodeGroup'};
        types.util.checkSet('general_extracellular_ephys', struct(), constrained, val);
    end
    function val = validate_general_extracellular_ephys_electrodes(obj, val)
        val = types.util.checkDtype('general_extracellular_ephys_electrodes', 'types.hdmf_common.DynamicTable', val);
    end
    function val = validate_general_institution(obj, val)
        val = types.util.checkDtype('general_institution', 'char', val);
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
    function val = validate_general_intracellular_ephys(obj, val)
        constrained = {'types.core.IntracellularElectrode'};
        types.util.checkSet('general_intracellular_ephys', struct(), constrained, val);
    end
    function val = validate_general_intracellular_ephys_experimental_conditions(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_experimental_conditions', 'types.core.ExperimentalConditionsTable', val);
    end
    function val = validate_general_intracellular_ephys_filtering(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_filtering', 'char', val);
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
    function val = validate_general_intracellular_ephys_intracellular_recordings(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_intracellular_recordings', 'types.core.IntracellularRecordingsTable', val);
    end
    function val = validate_general_intracellular_ephys_repetitions(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_repetitions', 'types.core.RepetitionsTable', val);
    end
    function val = validate_general_intracellular_ephys_sequential_recordings(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_sequential_recordings', 'types.core.SequentialRecordingsTable', val);
    end
    function val = validate_general_intracellular_ephys_simultaneous_recordings(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_simultaneous_recordings', 'types.core.SimultaneousRecordingsTable', val);
    end
    function val = validate_general_intracellular_ephys_sweep_table(obj, val)
        val = types.util.checkDtype('general_intracellular_ephys_sweep_table', 'types.core.SweepTable', val);
    end
    function val = validate_general_keywords(obj, val)
        val = types.util.checkDtype('general_keywords', 'char', val);
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
    function val = validate_general_lab(obj, val)
        val = types.util.checkDtype('general_lab', 'char', val);
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
    function val = validate_general_notes(obj, val)
        val = types.util.checkDtype('general_notes', 'char', val);
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
    function val = validate_general_optogenetics(obj, val)
        constrained = {'types.core.OptogeneticStimulusSite'};
        types.util.checkSet('general_optogenetics', struct(), constrained, val);
    end
    function val = validate_general_optophysiology(obj, val)
        constrained = {'types.core.ImagingPlane'};
        types.util.checkSet('general_optophysiology', struct(), constrained, val);
    end
    function val = validate_general_pharmacology(obj, val)
        val = types.util.checkDtype('general_pharmacology', 'char', val);
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
    function val = validate_general_protocol(obj, val)
        val = types.util.checkDtype('general_protocol', 'char', val);
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
    function val = validate_general_related_publications(obj, val)
        val = types.util.checkDtype('general_related_publications', 'char', val);
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
    function val = validate_general_session_id(obj, val)
        val = types.util.checkDtype('general_session_id', 'char', val);
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
    function val = validate_general_slices(obj, val)
        val = types.util.checkDtype('general_slices', 'char', val);
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
    function val = validate_general_source_script(obj, val)
        val = types.util.checkDtype('general_source_script', 'char', val);
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
    function val = validate_general_source_script_file_name(obj, val)
        val = types.util.checkDtype('general_source_script_file_name', 'char', val);
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
    function val = validate_general_stimulus(obj, val)
        val = types.util.checkDtype('general_stimulus', 'char', val);
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
    function val = validate_general_subject(obj, val)
        val = types.util.checkDtype('general_subject', 'types.core.Subject', val);
    end
    function val = validate_general_surgery(obj, val)
        val = types.util.checkDtype('general_surgery', 'char', val);
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
    function val = validate_general_virus(obj, val)
        val = types.util.checkDtype('general_virus', 'char', val);
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
    function val = validate_identifier(obj, val)
        val = types.util.checkDtype('identifier', 'char', val);
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
    function val = validate_intervals(obj, val)
        constrained = {'types.core.TimeIntervals'};
        types.util.checkSet('intervals', struct(), constrained, val);
    end
    function val = validate_intervals_epochs(obj, val)
        val = types.util.checkDtype('intervals_epochs', 'types.core.TimeIntervals', val);
    end
    function val = validate_intervals_invalid_times(obj, val)
        val = types.util.checkDtype('intervals_invalid_times', 'types.core.TimeIntervals', val);
    end
    function val = validate_intervals_trials(obj, val)
        val = types.util.checkDtype('intervals_trials', 'types.core.TimeIntervals', val);
    end
    function val = validate_processing(obj, val)
        constrained = {'types.core.ProcessingModule'};
        types.util.checkSet('processing', struct(), constrained, val);
    end
    function val = validate_scratch(obj, val)
        constrained = { 'types.core.ScratchData' };
        types.util.checkSet('scratch', struct(), constrained, val);
    end
    function val = validate_session_description(obj, val)
        val = types.util.checkDtype('session_description', 'char', val);
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
    function val = validate_session_start_time(obj, val)
        val = types.util.checkDtype('session_start_time', 'isodatetime', val);
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
    function val = validate_stimulus_presentation(obj, val)
        constrained = {'types.core.TimeSeries'};
        types.util.checkSet('stimulus_presentation', struct(), constrained, val);
    end
    function val = validate_stimulus_templates(obj, val)
        constrained = {'types.core.TimeSeries'};
        types.util.checkSet('stimulus_templates', struct(), constrained, val);
    end
    function val = validate_timestamps_reference_time(obj, val)
        val = types.util.checkDtype('timestamps_reference_time', 'isodatetime', val);
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
    function val = validate_units(obj, val)
        val = types.util.checkDtype('units', 'types.core.Units', val);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBContainer(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        fullpath = '';
        if ~isempty(obj.acquisition)
            refs = obj.acquisition.export(fid, [fullpath '/acquisition'], refs);
        else
            error('Property `acquisition` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.analysis)
            refs = obj.analysis.export(fid, [fullpath '/analysis'], refs);
        else
            error('Property `analysis` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.file_create_date)
            if startsWith(class(obj.file_create_date), 'types.untyped.')
                refs = obj.file_create_date.export(fid, [fullpath '/file_create_date'], refs);
            elseif ~isempty(obj.file_create_date)
                io.writeDataset(fid, [fullpath '/file_create_date'], obj.file_create_date, 'forceArray', 'forceChunking');
            end
        else
            error('Property `file_create_date` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.general)
            refs = obj.general.export(fid, [fullpath '/general'], refs);
        else
            error('Property `general` is required in `%s`.', fullpath);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_data_collection)
            if startsWith(class(obj.general_data_collection), 'types.untyped.')
                refs = obj.general_data_collection.export(fid, [fullpath '/general/data_collection'], refs);
            elseif ~isempty(obj.general_data_collection)
                io.writeDataset(fid, [fullpath '/general/data_collection'], obj.general_data_collection);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_devices)
            refs = obj.general_devices.export(fid, [fullpath '/general/devices'], refs);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_experiment_description)
            if startsWith(class(obj.general_experiment_description), 'types.untyped.')
                refs = obj.general_experiment_description.export(fid, [fullpath '/general/experiment_description'], refs);
            elseif ~isempty(obj.general_experiment_description)
                io.writeDataset(fid, [fullpath '/general/experiment_description'], obj.general_experiment_description);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_experimenter)
            if startsWith(class(obj.general_experimenter), 'types.untyped.')
                refs = obj.general_experimenter.export(fid, [fullpath '/general/experimenter'], refs);
            elseif ~isempty(obj.general_experimenter)
                io.writeDataset(fid, [fullpath '/general/experimenter'], obj.general_experimenter, 'forceArray');
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_extracellular_ephys)
            refs = obj.general_extracellular_ephys.export(fid, [fullpath '/general/extracellular_ephys'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/extracellular_ephys']);
        if ~isempty(obj.general_extracellular_ephys_electrodes)
            refs = obj.general_extracellular_ephys_electrodes.export(fid, [fullpath '/general/extracellular_ephys/electrodes'], refs);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_institution)
            if startsWith(class(obj.general_institution), 'types.untyped.')
                refs = obj.general_institution.export(fid, [fullpath '/general/institution'], refs);
            elseif ~isempty(obj.general_institution)
                io.writeDataset(fid, [fullpath '/general/institution'], obj.general_institution);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_intracellular_ephys)
            refs = obj.general_intracellular_ephys.export(fid, [fullpath '/general/intracellular_ephys'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_experimental_conditions)
            refs = obj.general_intracellular_ephys_experimental_conditions.export(fid, [fullpath '/general/intracellular_ephys/experimental_conditions'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_filtering)
            if startsWith(class(obj.general_intracellular_ephys_filtering), 'types.untyped.')
                refs = obj.general_intracellular_ephys_filtering.export(fid, [fullpath '/general/intracellular_ephys/filtering'], refs);
            elseif ~isempty(obj.general_intracellular_ephys_filtering)
                io.writeDataset(fid, [fullpath '/general/intracellular_ephys/filtering'], obj.general_intracellular_ephys_filtering);
            end
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_intracellular_recordings)
            refs = obj.general_intracellular_ephys_intracellular_recordings.export(fid, [fullpath '/general/intracellular_ephys/intracellular_recordings'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_repetitions)
            refs = obj.general_intracellular_ephys_repetitions.export(fid, [fullpath '/general/intracellular_ephys/repetitions'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_sequential_recordings)
            refs = obj.general_intracellular_ephys_sequential_recordings.export(fid, [fullpath '/general/intracellular_ephys/sequential_recordings'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_simultaneous_recordings)
            refs = obj.general_intracellular_ephys_simultaneous_recordings.export(fid, [fullpath '/general/intracellular_ephys/simultaneous_recordings'], refs);
        end
        io.writeGroup(fid, [fullpath '/general/intracellular_ephys']);
        if ~isempty(obj.general_intracellular_ephys_sweep_table)
            refs = obj.general_intracellular_ephys_sweep_table.export(fid, [fullpath '/general/intracellular_ephys/sweep_table'], refs);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_keywords)
            if startsWith(class(obj.general_keywords), 'types.untyped.')
                refs = obj.general_keywords.export(fid, [fullpath '/general/keywords'], refs);
            elseif ~isempty(obj.general_keywords)
                io.writeDataset(fid, [fullpath '/general/keywords'], obj.general_keywords, 'forceArray');
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_lab)
            if startsWith(class(obj.general_lab), 'types.untyped.')
                refs = obj.general_lab.export(fid, [fullpath '/general/lab'], refs);
            elseif ~isempty(obj.general_lab)
                io.writeDataset(fid, [fullpath '/general/lab'], obj.general_lab);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_notes)
            if startsWith(class(obj.general_notes), 'types.untyped.')
                refs = obj.general_notes.export(fid, [fullpath '/general/notes'], refs);
            elseif ~isempty(obj.general_notes)
                io.writeDataset(fid, [fullpath '/general/notes'], obj.general_notes);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_optogenetics)
            refs = obj.general_optogenetics.export(fid, [fullpath '/general/optogenetics'], refs);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_optophysiology)
            refs = obj.general_optophysiology.export(fid, [fullpath '/general/optophysiology'], refs);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_pharmacology)
            if startsWith(class(obj.general_pharmacology), 'types.untyped.')
                refs = obj.general_pharmacology.export(fid, [fullpath '/general/pharmacology'], refs);
            elseif ~isempty(obj.general_pharmacology)
                io.writeDataset(fid, [fullpath '/general/pharmacology'], obj.general_pharmacology);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_protocol)
            if startsWith(class(obj.general_protocol), 'types.untyped.')
                refs = obj.general_protocol.export(fid, [fullpath '/general/protocol'], refs);
            elseif ~isempty(obj.general_protocol)
                io.writeDataset(fid, [fullpath '/general/protocol'], obj.general_protocol);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_related_publications)
            if startsWith(class(obj.general_related_publications), 'types.untyped.')
                refs = obj.general_related_publications.export(fid, [fullpath '/general/related_publications'], refs);
            elseif ~isempty(obj.general_related_publications)
                io.writeDataset(fid, [fullpath '/general/related_publications'], obj.general_related_publications, 'forceArray');
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_session_id)
            if startsWith(class(obj.general_session_id), 'types.untyped.')
                refs = obj.general_session_id.export(fid, [fullpath '/general/session_id'], refs);
            elseif ~isempty(obj.general_session_id)
                io.writeDataset(fid, [fullpath '/general/session_id'], obj.general_session_id);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_slices)
            if startsWith(class(obj.general_slices), 'types.untyped.')
                refs = obj.general_slices.export(fid, [fullpath '/general/slices'], refs);
            elseif ~isempty(obj.general_slices)
                io.writeDataset(fid, [fullpath '/general/slices'], obj.general_slices);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_source_script)
            if startsWith(class(obj.general_source_script), 'types.untyped.')
                refs = obj.general_source_script.export(fid, [fullpath '/general/source_script'], refs);
            elseif ~isempty(obj.general_source_script)
                io.writeDataset(fid, [fullpath '/general/source_script'], obj.general_source_script);
            end
        end
        if ~isempty(obj.general_source_script_file_name) && ~isempty(obj.general_source_script)
            io.writeAttribute(fid, [fullpath '/general/source_script/file_name'], obj.general_source_script_file_name);
        elseif ~isempty(obj.general_source_script)
            error('Property `general_source_script_file_name` is required in `%s`.', fullpath);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_stimulus)
            if startsWith(class(obj.general_stimulus), 'types.untyped.')
                refs = obj.general_stimulus.export(fid, [fullpath '/general/stimulus'], refs);
            elseif ~isempty(obj.general_stimulus)
                io.writeDataset(fid, [fullpath '/general/stimulus'], obj.general_stimulus);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_subject)
            refs = obj.general_subject.export(fid, [fullpath '/general/subject'], refs);
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_surgery)
            if startsWith(class(obj.general_surgery), 'types.untyped.')
                refs = obj.general_surgery.export(fid, [fullpath '/general/surgery'], refs);
            elseif ~isempty(obj.general_surgery)
                io.writeDataset(fid, [fullpath '/general/surgery'], obj.general_surgery);
            end
        end
        io.writeGroup(fid, [fullpath '/general']);
        if ~isempty(obj.general_virus)
            if startsWith(class(obj.general_virus), 'types.untyped.')
                refs = obj.general_virus.export(fid, [fullpath '/general/virus'], refs);
            elseif ~isempty(obj.general_virus)
                io.writeDataset(fid, [fullpath '/general/virus'], obj.general_virus);
            end
        end
        if ~isempty(obj.identifier)
            if startsWith(class(obj.identifier), 'types.untyped.')
                refs = obj.identifier.export(fid, [fullpath '/identifier'], refs);
            elseif ~isempty(obj.identifier)
                io.writeDataset(fid, [fullpath '/identifier'], obj.identifier);
            end
        else
            error('Property `identifier` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.intervals)
            refs = obj.intervals.export(fid, [fullpath '/intervals'], refs);
        end
        io.writeGroup(fid, [fullpath '/intervals']);
        if ~isempty(obj.intervals_epochs)
            refs = obj.intervals_epochs.export(fid, [fullpath '/intervals/epochs'], refs);
        end
        io.writeGroup(fid, [fullpath '/intervals']);
        if ~isempty(obj.intervals_invalid_times)
            refs = obj.intervals_invalid_times.export(fid, [fullpath '/intervals/invalid_times'], refs);
        end
        io.writeGroup(fid, [fullpath '/intervals']);
        if ~isempty(obj.intervals_trials)
            refs = obj.intervals_trials.export(fid, [fullpath '/intervals/trials'], refs);
        end
        if ~isempty(obj.nwb_version)
            io.writeAttribute(fid, [fullpath '/nwb_version'], obj.nwb_version);
        else
            error('Property `nwb_version` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.processing)
            refs = obj.processing.export(fid, [fullpath '/processing'], refs);
        else
            error('Property `processing` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.scratch)
            refs = obj.scratch.export(fid, [fullpath '/scratch'], refs);
        end
        if ~isempty(obj.session_description)
            if startsWith(class(obj.session_description), 'types.untyped.')
                refs = obj.session_description.export(fid, [fullpath '/session_description'], refs);
            elseif ~isempty(obj.session_description)
                io.writeDataset(fid, [fullpath '/session_description'], obj.session_description);
            end
        else
            error('Property `session_description` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.session_start_time)
            if startsWith(class(obj.session_start_time), 'types.untyped.')
                refs = obj.session_start_time.export(fid, [fullpath '/session_start_time'], refs);
            elseif ~isempty(obj.session_start_time)
                io.writeDataset(fid, [fullpath '/session_start_time'], obj.session_start_time);
            end
        else
            error('Property `session_start_time` is required in `%s`.', fullpath);
        end
        io.writeGroup(fid, [fullpath '/stimulus']);
        if ~isempty(obj.stimulus_presentation)
            refs = obj.stimulus_presentation.export(fid, [fullpath '/stimulus/presentation'], refs);
        else
            error('Property `stimulus_presentation` is required in `%s`.', fullpath);
        end
        io.writeGroup(fid, [fullpath '/stimulus']);
        if ~isempty(obj.stimulus_templates)
            refs = obj.stimulus_templates.export(fid, [fullpath '/stimulus/templates'], refs);
        else
            error('Property `stimulus_templates` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.timestamps_reference_time)
            if startsWith(class(obj.timestamps_reference_time), 'types.untyped.')
                refs = obj.timestamps_reference_time.export(fid, [fullpath '/timestamps_reference_time'], refs);
            elseif ~isempty(obj.timestamps_reference_time)
                io.writeDataset(fid, [fullpath '/timestamps_reference_time'], obj.timestamps_reference_time);
            end
        else
            error('Property `timestamps_reference_time` is required in `%s`.', fullpath);
        end
        if ~isempty(obj.units)
            refs = obj.units.export(fid, [fullpath '/units'], refs);
        end
    end
end

end