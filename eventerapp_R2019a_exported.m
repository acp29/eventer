classdef eventerapp_R2019a_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Eventer                         matlab.ui.Figure
        FilePanel                       matlab.ui.container.Panel
        LoadButton                      matlab.ui.control.Button
        ChannelSpinnerLabel             matlab.ui.control.Label
        ChannelSpinner                  matlab.ui.control.Spinner
        CloseButton                     matlab.ui.control.Button
        FullPathNameBox                 matlab.ui.control.ListBox
        PresetsButton                   matlab.ui.control.Button
        ApplypresetsButton              matlab.ui.control.Button
        ClosefiguresButton              matlab.ui.control.Button
        SplitSpinnerLabel               matlab.ui.control.Label
        SplitSpinner                    matlab.ui.control.Spinner
        sLabel                          matlab.ui.control.Label
        TabGroupEventer                 matlab.ui.container.TabGroup
        PreviewTab                      matlab.ui.container.Tab
        WavePreviewAxes                 matlab.ui.control.UIAxes
        TemplateTab                     matlab.ui.container.Tab
        TemplatePreviewAxes             matlab.ui.control.UIAxes
        FitparametersPanel              matlab.ui.container.Panel
        TemplateSelectButton            matlab.ui.control.Button
        SelectLabel                     matlab.ui.control.Label
        tau1EditFieldLabel              matlab.ui.control.Label
        tau1EditField                   matlab.ui.control.NumericEditField
        tau2EditFieldLabel              matlab.ui.control.Label
        tau2EditField                   matlab.ui.control.NumericEditField
        msLabel_4                       matlab.ui.control.Label
        msLabel_5                       matlab.ui.control.Label
        Button                          matlab.ui.control.Button
        TimeconstantsPanel              matlab.ui.container.Panel
        TimeConstantsEditField2         matlab.ui.control.NumericEditField
        TimeConstantsEditField1         matlab.ui.control.NumericEditField
        msLabel_2                       matlab.ui.control.Label
        RiseLabel                       matlab.ui.control.Label
        DecayLabel                      matlab.ui.control.Label
        ApplyToAllButtonTemplate        matlab.ui.control.Button
        msLabel                         matlab.ui.control.Label
        SignoftheEventsSwitch_2         matlab.ui.control.Switch
        SignoftheEventsSwitchLabel_2    matlab.ui.control.Label
        ExcludeTab                      matlab.ui.container.Tab
        zone_three_x                    matlab.ui.control.Button
        zone_four_x                     matlab.ui.control.Button
        zone_five_x                     matlab.ui.control.Button
        zone_six_x                      matlab.ui.control.Button
        exselect_1                      matlab.ui.control.Button
        exselect_2                      matlab.ui.control.Button
        exselect_3                      matlab.ui.control.Button
        exselect_4                      matlab.ui.control.Button
        exselect_5                      matlab.ui.control.Button
        exselect_6                      matlab.ui.control.Button
        zone_eleven_x                   matlab.ui.control.Button
        ExtraExclusions                 matlab.ui.control.TextArea
        ApplyToAllButton_ex_1           matlab.ui.control.Button
        ApplyToAllButton_ex_2           matlab.ui.control.Button
        zone_two_x                      matlab.ui.control.Button
        ApplyToAllButton_ex_3           matlab.ui.control.Button
        ApplyToAllButton_ex_4           matlab.ui.control.Button
        ApplyToAllButton_ex_5           matlab.ui.control.Button
        ApplyToAllButton_ex_6           matlab.ui.control.Button
        ApplyToAllButton_xexclusion     matlab.ui.control.Button
        zone_one_x                      matlab.ui.control.Button
        EditField_1                     matlab.ui.control.EditField
        EditField_2                     matlab.ui.control.EditField
        EditField_3                     matlab.ui.control.EditField
        EditField_4                     matlab.ui.control.NumericEditField
        EditField_5                     matlab.ui.control.NumericEditField
        EditField_6                     matlab.ui.control.NumericEditField
        EditField_7                     matlab.ui.control.NumericEditField
        EditField_8                     matlab.ui.control.NumericEditField
        EditField_9                     matlab.ui.control.NumericEditField
        cell_three                      matlab.ui.control.NumericEditField
        cell_four                       matlab.ui.control.NumericEditField
        cell_one                        matlab.ui.control.NumericEditField
        cell_two                        matlab.ui.control.NumericEditField
        cell_seven                      matlab.ui.control.NumericEditField
        cell_eight                      matlab.ui.control.NumericEditField
        cell_five                       matlab.ui.control.NumericEditField
        cell_six                        matlab.ui.control.NumericEditField
        cell_eleven                     matlab.ui.control.NumericEditField
        cell_twelve                     matlab.ui.control.NumericEditField
        cell_nine                       matlab.ui.control.NumericEditField
        cell_ten                        matlab.ui.control.NumericEditField
        DetectionTab                    matlab.ui.container.Tab
        stdevLabel                      matlab.ui.control.Label
        ThresholdSpinnerLabel           matlab.ui.control.Label
        ThresholdSpinner                matlab.ui.control.Spinner
        FilterWavesPanel                matlab.ui.container.Panel
        HzLabel                         matlab.ui.control.Label
        HzLabel_2                       matlab.ui.control.Label
        HighpassFilterCutOffSpinnerLabel  matlab.ui.control.Label
        HighpassPreFilterCutOffSpinner  matlab.ui.control.Spinner
        LowpassFilterCutOffSpinnerLabel  matlab.ui.control.Label
        LowpassPreFilterCutOffSpinner   matlab.ui.control.Spinner
        OnOffCheckBoxHPF                matlab.ui.control.CheckBox
        OnOffCheckBoxLPF                matlab.ui.control.CheckBox
        HighpassfiltermethodDropDownLabel  matlab.ui.control.Label
        HighpassPreFiltermethodDropDown  matlab.ui.control.DropDown
        SignoftheEventsSwitchLabel      matlab.ui.control.Label
        SignoftheEventsSwitch           matlab.ui.control.Switch
        CriterionDropDown               matlab.ui.control.DropDown
        CorrelationCoefficientLabel     matlab.ui.control.Label
        CorrelationCoefficientSpinner   matlab.ui.control.Spinner
        EventCriterionLabel             matlab.ui.control.Label
        ConfigurationDropDownLabel      matlab.ui.control.Label
        ConfigurationDropDown           matlab.ui.control.DropDown
        LoadmodelButton                 matlab.ui.control.Button
        TrainingmodeCheckBox            matlab.ui.control.CheckBox
        ModelfileEditFieldLabel         matlab.ui.control.Label
        ModelfileEditField              matlab.ui.control.EditField
        ThresholdabsoluteEditFieldLabel  matlab.ui.control.Label
        ThresholdAbsoluteEditField      matlab.ui.control.NumericEditField
        AdvancedTab                     matlab.ui.container.Tab
        NoofTausSpinnerLabel            matlab.ui.control.Label
        NoofTausSpinner                 matlab.ui.control.Spinner
        BaselineTimeSpinnerLabel        matlab.ui.control.Label
        BaselineTimeSpinner             matlab.ui.control.Spinner
        msLabel_3                       matlab.ui.control.Label
        ExmodeDropDownLabel             matlab.ui.control.Label
        ExmodeDropDown                  matlab.ui.control.DropDown
        LevenbergMarquardtSettingsPanel  matlab.ui.container.Panel
        LambdaSliderLabel               matlab.ui.control.Label
        LambdaSlider                    matlab.ui.control.Slider
        LambdaDisp                      matlab.ui.control.NumericEditField
        DeconvolutedWaveSignalProcessingPanel_2  matlab.ui.container.Panel
        HighpassFilterCutOffSpinner_2Label  matlab.ui.control.Label
        HzLabel_4                       matlab.ui.control.Label
        HighpassFilterCutOffSpinner     matlab.ui.control.Spinner
        HzLabel_3                       matlab.ui.control.Label
        LowpassFilterCutOffSpinner      matlab.ui.control.Spinner
        LowpassFilterCutOffSpinnerLabel_2  matlab.ui.control.Label
        OutputTab                       matlab.ui.container.Tab
        EnsembleAverageButtonGroup      matlab.ui.container.ButtonGroup
        MedianButton                    matlab.ui.control.RadioButton
        MeanButton                      matlab.ui.control.RadioButton
        WaveFormatDropDownLabel         matlab.ui.control.Label
        WaveFormatDropDown              matlab.ui.control.DropDown
        FigureFormatDropDownLabel       matlab.ui.control.Label
        FigureFormatDropDown            matlab.ui.control.DropDown
        dpiLabel                        matlab.ui.control.Label
        wavesstackedLabel               matlab.ui.control.Label
        GNUZipCompressionCheckBox       matlab.ui.control.CheckBox
        MaxWindowSpinner                matlab.ui.control.Spinner
        EventwindowLabel                matlab.ui.control.Label
        MinWindowSpinner                matlab.ui.control.Spinner
        sLabel_2                        matlab.ui.control.Label
        sLabel_3                        matlab.ui.control.Label
        RootdirectoryEditFieldLabel     matlab.ui.control.Label
        RootdirectoryEditField          matlab.ui.control.EditField
        SetOutputFolderButton           matlab.ui.control.Button
        outdirLabel                     matlab.ui.control.Label
        SummaryTab                      matlab.ui.container.Tab
        TabGroupSummary                 matlab.ui.container.TabGroup
        AllTab                          matlab.ui.container.Tab
        SummaryAll                      matlab.ui.control.TextArea
        CurrentTab                      matlab.ui.container.Tab
        SummaryCurrent                  matlab.ui.control.TextArea
        ParallelPanel                   matlab.ui.container.Panel
        ParallelCheckBox                matlab.ui.control.CheckBox
        NoofworkersSpinnerLabel         matlab.ui.control.Label
        NoofworkersSpinner              matlab.ui.control.Spinner
        ProfileNameButton               matlab.ui.control.Button
        ProfileLabel                    matlab.ui.control.Label
        ParallelsettingsLabel           matlab.ui.control.Label
        StorePanel                      matlab.ui.container.Panel
        WaveDropDownLabel               matlab.ui.control.Label
        WaveDropDown                    matlab.ui.control.DropDown
        StoreAllWavesButton             matlab.ui.control.Button
        PopupGraphButton                matlab.ui.control.Button
        RunningLamp                     matlab.ui.control.Lamp
        RunButton                       matlab.ui.control.Button
        RunDropDown                     matlab.ui.control.DropDown
        CurrentWaveStoredBox            matlab.ui.control.CheckBox
        StoreCurrentWaveButton          matlab.ui.control.Button
        UnsavedLabel                    matlab.ui.control.Label
        CreditsButton                   matlab.ui.control.Button
    end

    
    properties (Access = private)
        %defaults
        timeconstant1_default = 0.45;
        timeconstant2_default = 3;
        sign_default = '-';
        scalefactor_default = 4;
        exclude_default = [];
        rmin_default = 0.4;
        hpf_default = 10;
        lpf_default = 200;
        phpf_default = 0;
        plpf_default = Inf;
        taus_default = 2;
        base_line_default = 1;
        exmode_default = '1';
        lambda_default = 1;
        config_default = 'VC';
        average_default = 'median';
        export_default = 'mat';
        figure_default = 'fig';
        gz_default = 0;
        %file path
        baseName;
        FullFileName;
        nFiles;
        %preset path
        presets_file='';
        presets_path='';
        presetsFile_flag = 0;
        %model path
        model_file=0;
        model_path='';
        %array
        current_wave;
        wave_number;
        xdiff;
        yunit;
        xunit;
        ref_array = [];
        array = [];
        fig_wave = [];
        nWaves;
        S;
        %plotting variables
        ch=1;
        template_plot;
        ex_plot;
        preview_plot;
        prevone;
        prevtwo;
        base_x = 0;
        base_y = 0;
        ex_1;
        ex_2;
        ex_3;
        ex_4;
        ex_5;
        ex_6;
        ex_7;
        ex_8;
        ex_9;
        ex_10;
        ex_11;
        ex_12;
        xexclusion=[0, 0];
        %misc
        saved = [];
        h
        file = [];
        settings = {};
        fullpathlist = {};
        refpathlist = {};
        path = '';
        wavefileidx = [];
        profile = 'local';
        predlg = [];
        prefield = struct;
        split_excl = [0,0];
        outdir = {''};
        model = [];
        confirmedUnits = {};
        xSF = '';
        ySF = '';
        %train eventer
        train_dlg 
        event_checkbox
        event_spinner
        event_time
        train_btn
        selectall_btn
        event_plot
        training_data
        event_class
        event_features
    end
    
    methods (Access = private)
        
        
        function unstored(app)
            if app.CurrentWaveStoredBox.Value == 1
                if ( app.TimeConstantsEditField1.Value ~= app.settings{app.current_wave+1}.TC1*1000 )                     || ...
                        ( app.TimeConstantsEditField2.Value ~= app.settings{app.current_wave+1}.TC2*1000 )                || ...
                        ( ~strcmp(app.SignoftheEventsSwitch.Value,app.settings{1}.s) )                   || ...
                        ( app.ThresholdSpinner.Value ~= app.settings{1}.threshold )                      || ...
                        ( ~strcmp(app.CriterionDropDown.Value,app.settings{1}.criterion) )               || ...
                        ( app.CorrelationCoefficientSpinner.Value ~= app.settings{1}.rmin )              || ...
                        ( app.MinWindowSpinner.Value ~= app.settings{1}.win(1) )                         || ...
                        ( app.MaxWindowSpinner.Value ~= app.settings{1}.win(2) )                         || ...
                        ( app.HighpassFilterCutOffSpinner.Value ~= app.settings{1}.hpf )                 || ...
                        ( app.LowpassFilterCutOffSpinner.Value ~= app.settings{1}.lpf )                  || ...
                        ( ~strcmp(app.HighpassPreFiltermethodDropDown.Value,app.settings{1}.phpf_type) ) || ...
                        ( app.HighpassPreFilterCutOffSpinner.Value ~= app.settings{1}.phpf )             || ...
                        ( app.LowpassPreFilterCutOffSpinner.Value ~= app.settings{1}.plpf )              || ...
                        ( app.NoofTausSpinner.Value ~= app.settings{1}.taus )                            || ...
                        ( app.BaselineTimeSpinner.Value ~= app.settings{1}.baseline*1000 )               || ...
                        ( app.LambdaDisp.Value ~= app.settings{1}.lambda )                               || ...
                        ( ~strcmp(app.ConfigurationDropDown.Value,app.settings{1}.config) )              || ...
                        ( strcmp(app.settings{1}.average,'mean') && (app.MedianButton.Value == 1) )      || ...
                        ( strcmp(app.settings{1}.average,'median') && (app.MedianButton.Value == 0) )    || ...
                        ( ~strcmp(app.ExmodeDropDown.Value,app.settings{1}.exmode) )                     || ...
                        ( ~strcmp(app.WaveFormatDropDown.Value,app.settings{1}.export) )                 || ...
                        ( ~strcmp(app.FigureFormatDropDown.Value,app.settings{1}.format) )               || ...
                        ( ~strcmp(app.outdirLabel.Text,app.settings{1}.outdir{1}) )                      || ...
                        ( app.GNUZipCompressionCheckBox.Value ~= app.settings{1}.gz )                    || ...
                        ( app.cell_one.Value ~= app.settings{app.current_wave+1}.cell_one )              || ...
                        ( app.cell_two.Value ~= app.settings{app.current_wave+1}.cell_two )              || ...
                        ( app.cell_three.Value ~= app.settings{app.current_wave+1}.cell_three )          || ...
                        ( app.cell_four.Value ~= app.settings{app.current_wave+1}.cell_four )            || ...
                        ( app.cell_five.Value ~= app.settings{app.current_wave+1}.cell_five )            || ...
                        ( app.cell_six.Value ~= app.settings{app.current_wave+1}.cell_six )              || ...
                        ( app.cell_seven.Value ~= app.settings{app.current_wave+1}.cell_seven )          || ...
                        ( app.cell_eight.Value ~= app.settings{app.current_wave+1}.cell_eight )          || ...
                        ( app.cell_nine.Value ~= app.settings{app.current_wave+1}.cell_nine )            || ...
                        ( app.cell_ten.Value ~= app.settings{app.current_wave+1}.cell_ten )              || ...
                        ( app.cell_eleven.Value ~= app.settings{app.current_wave+1}.cell_eleven )        || ...
                        ( app.cell_twelve.Value ~= app.settings{app.current_wave+1}.cell_twelve )        || ...
                        ( app.ThresholdAbsoluteEditField.Value ~= app.settings{1}.absthreshold )         || ...
                        ( ~strcmp(app.ModelfileEditField.Value,app.settings{1}.model_source))            || ...
                        ( ~strcmp(app.ExtraExclusions.Value{1},app.settings{app.current_wave+1}.xexclusion{1}) )  
                    app.UnsavedLabel.Visible = 'on';
                    app.UnsavedLabel.Enable = 'on';
                else
                    app.UnsavedLabel.Visible = 'off';
                    app.UnsavedLabel.Enable = 'off';
                end
            end
        end
    
        function  PreFilterWaves(app)
            filter_waitbar = waitbar(0,'Please wait while we apply filter settings to all the waves...');
            n = size(app.ref_array,2);
            for i=2:size(app.ref_array,2)
              waitbar((i-1)/(n-1),filter_waitbar);
              app.array(:,i) = filter1 (app.ref_array(:,i), app.array(:,1), app.HighpassPreFilterCutOffSpinner.Value, app.LowpassPreFilterCutOffSpinner.Value, app.HighpassPreFiltermethodDropDown.Value); 
            end
            close(filter_waitbar);
        end
        
        function UpdateWavePreview(app)
            app.fig_wave = [app.array(:,1),app.array(:,app.current_wave+1)];
            app.ApplyExclusionZones;
            fig_wave = reduce_data(app.fig_wave,app.WavePreviewAxes.Position(3));
            app.preview_plot = plot(app.WavePreviewAxes,fig_wave(:,1),fig_wave(:,2),'Color',[0 0 0],'LineWidth',0.25);
            app.WavePreviewAxes.XLim = [min(app.fig_wave(:,1)) max(app.fig_wave(:,1))];
            app.WavePreviewAxes.YLim = [min(app.fig_wave(:,2)) max(app.fig_wave(:,2))];
        end
    
        function ApplyExclusionZones(app) 
            app.ex_1 = dsearchn(app.array(:,1), app.cell_one.Value);
            app.ex_2 = dsearchn(app.array(:,1), app.cell_two.Value);
            app.ex_3 = dsearchn(app.array(:,1), app.cell_three.Value);
            app.ex_4 = dsearchn(app.array(:,1), app.cell_four.Value);
            app.ex_5 = dsearchn(app.array(:,1), app.cell_five.Value);
            app.ex_6 = dsearchn(app.array(:,1), app.cell_six.Value);
            app.ex_7 = dsearchn(app.array(:,1), app.cell_seven.Value);
            app.ex_8 = dsearchn(app.array(:,1), app.cell_eight.Value);
            app.ex_9 = dsearchn(app.array(:,1), app.cell_nine.Value);
            app.ex_10 = dsearchn(app.array(:,1), app.cell_ten.Value);
            app.ex_11 = dsearchn(app.array(:,1), app.cell_eleven.Value);
            app.ex_12 = dsearchn(app.array(:,1), app.cell_twelve.Value);
            app.fig_wave = [app.array(:,1),app.array(:,app.current_wave+1)];
            app.fig_wave(app.ex_1:app.ex_2,2) = NaN;
            app.fig_wave(app.ex_3:app.ex_4,2) = NaN;
            app.fig_wave(app.ex_5:app.ex_6,2) = NaN;
            app.fig_wave(app.ex_7:app.ex_8,2) = NaN;
            app.fig_wave(app.ex_9:app.ex_10,2) = NaN;
            app.fig_wave(app.ex_11:app.ex_12,2) = NaN;
            app.create_xexclusion;
            for i=1:size(app.xexclusion)
                temp_ex1 = dsearchn(app.array(:,1), app.xexclusion(i,1));
                temp_ex2 = dsearchn(app.array(:,1), app.xexclusion(i,2));
                app.fig_wave(temp_ex1:temp_ex2,2) = NaN;
            end
            unstored(app);
        end
        
        function UpdatePopupGraph(app)
            if ishandle(7)
                figure(7);
                p = get(gca);
                app.fig_wave = [app.array(:,1),app.array(:,app.current_wave+1)];
                app.ApplyExclusionZones;
                app.ex_plot = plot(app.fig_wave(:,1),app.fig_wave(:,2),'Color',[0 0 0],'linewidth',1.25);xlim(p.XLim);ylim('auto');
                figure(app.Eventer); % reset focus on eventer window
            end 
        end
        
        function create_xexclusion(app)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            if isempty(app.ExtraExclusions.Value{1})
                app.xexclusion = [0 0];
            end
            try
                app.xexclusion = eval(cell2mat(app.ExtraExclusions.Value'));
                app.ExtraExclusions.FontColor = [0 0 0];
            catch
                app.ExtraExclusions.FontColor = [1 0 0];
            end
            if size(app.xexclusion,2) ~= 2
                app.ExtraExclusions.FontColor = [1 0 0];
                return
            end     
        end
        
        function f = AddFile(app)
            % Add a single file to file list
            % Loading previous analysis from .evt file
            if strcmpi(app.file.baseName(end-3:end),'.evt')
                chdir(app.file.Path);
                load(app.file.baseName,'-mat')
                app.settings = saveddata;
                % The following if statements and assignments are for backwards compatibility
                if ~isfield(app.settings{1},'xexclusion')
                    for i=1:numel(app.settings)
                        app.settings{i}.xexclusion={'[0 0]'};
                    end
                end
                if ~isfield(app.settings{1},'split')
                    app.settings{1}.split = 0; % this was not an option on previous versions
                else
                    app.SplitSpinner.Value = app.settings{1}.split;
                end
                if ~isfield(app.settings{1},'criterion')
                    app.settings{1}.criterion = 'Pearson'; % this was not an option on previous versions
                else
                    app.CriterionDropDown.Value = app.settings{1}.criterion;
                end
                if ~isfield(app.settings{1},'absthreshold')
                    app.settings{1}.absthreshold = 0; % this was not an option on previous versions
                else
                    app.ThresholdAbsoluteEditField.Value = app.settings{1}.absthreshold;
                end
                if ~isfield(app.settings{1},'outdir')
                    app.settings{1}.outdir = {''}; % this was not an option on previous versions
                end
                app.outdir = app.settings{1}.outdir;
                if ~isempty(app.outdir{1})
                    cd ..
                    app.path = pwd;
                    chdir(app.outdir{1});
                else
                    app.path = app.file.Path;
                end  
                % If filepaths.txt exists pathlist is created from there
                if ~exist('filepaths.txt')
                    f = errordlg('Filepaths file not found','Error');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    return
                else
                    fid=fopen('filepaths.txt','r');
                    rootpath = fgetl(fid);
                    temp = fgetl(fid);
                    app.fullpathlist = cell(1);
                    count = 0;
                    while ischar(temp)
                        count = count + 1;
                        app.fullpathlist{1,count} = temp;
                        temp = fgetl(fid);
                    end
                    fclose(fid);
                    if ~strcmpi(rootpath,'.')
                        % If necessary, calculate relative path list (for backwards compatibility)
                        relpathlist = cell(size(app.fullpathlist));
                        filenamelist = cell(size(app.fullpathlist));
                        for j=1:numel(relpathlist)
                            [fullpath,fname,extn] = fileparts(app.fullpathlist{j});
                            relpathlist{j} = relativepath(fullpath,rootpath);
                            if strcmp(relpathlist{j},filesep)
                                relpathlist{j} = ['.' relpathlist{j}];
                            end    
                            filenamelist{j} = [fname,extn];
                            app.fullpathlist{j} = fullfile(relpathlist{j},filenamelist{j});
                            %app.fullpathlist{j} = [relpathlist{j} filesep filenamelist{j}];
                        end
                    end
                    % Convert to absolute path list
                    for j=1:numel(app.fullpathlist)
                        chdir(app.path);
                        [relpath, fname, extn] = fileparts(parse_path(app,app.fullpathlist{j}));
                        if ~isempty(relpath)
                            chdir(relpath)
                        end
                        app.fullpathlist{j} = fullfile(pwd,[fname extn]);
                    end
                    app.FullPathNameBox.Items = app.fullpathlist;
                    chdir(app.path);
                    if ~isempty(app.outdir{1})
                        chdir(app.outdir{1});
                    end
                    % Check for eventer.output for summary read
                    if exist('./eventer.output/ALL_events/summary.txt','file')
                        cd eventer.output/ALL_events/
                        app.SummaryAll.Value = fileread('summary.txt');
                    end
                    app.refpathlist = cell(size(app.fullpathlist));
                end
            end
            if isempty(app.refpathlist)
                app.path = app.file.Path;
                chdir(app.path);
            end
            if ~strcmpi(app.file.baseName(end-3:end),'.evt')
                app.fullpathlist = [app.fullpathlist {strcat(app.file.Path,app.file.baseName)}];
                app.refpathlist = [app.refpathlist cell(1)];
                if numel(unique(app.fullpathlist)) ~= numel(app.fullpathlist)
                    errMsg = sprintf('The following file you selected is already loaded:\n%s ',app.fullpathlist{end});                    
                    app.fullpathlist(end)=[];
                    app.refpathlist(end)=[];
                    app.FullPathNameBox.Items = app.fullpathlist;
                    f = errordlg(errMsg,'Error');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    return
                end
                app.FullPathNameBox.Items = app.fullpathlist;
            end
            % requires: nFiles, fullpathlist, array, settings, ref array
            % check if fullpathlist exists
            % if no fullpathlist from selection
            % if yes, add selection to existing fullpathlist
            app.nFiles = numel(app.fullpathlist);
            c = cell(1);
            % Systematically chdir and run ephysIO on newly added files
            for i=1:app.nFiles
                if strcmp(app.fullpathlist{i},app.refpathlist{i})
                    continue
                    if strcmpi(app.file.baseName(end-3:end),'.evt')
                        waitbar(i/numel(app.nFiles),app.h);
                    end
                end
                if i==1
                    chdir(fileparts(app.fullpathlist{i}));
                    lasterr('');
                    warning('');
                    try
                        app.S = ephysIO({app.fullpathlist{i},app.ChannelSpinner.Value}); % replaced 1 with app.ch
                    catch
                        app.fullpathlist(end)=[];
                        app.refpathlist(end)=[];
                        app.FullPathNameBox.Items = app.fullpathlist;
                        [errMsg] = lasterr;
                        f = errordlg(errMsg,'Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                    if any(strcmpi(app.file.baseName(end-3:end),{'.csv','.txt'}))
                        % Enter units for raw text files if they are not
                        % defined in a header
                        prompt = {'Enter the units for x (e.g. ms):','Enter the units for y (e.g. pA):'};
                        app.confirmedUnits = inputdlg(prompt,'Data units',1,{'s','A'});
                        if isempty(app.confirmedUnits)
                            f = uifigure('Visible','off'); % create invisible figure handle
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            app.S = {};
                            return
                        end
                        app.S.xunit = app.confirmedUnits{1};
                        app.S.yunit = app.confirmedUnits{2};
                        [app.S.array(:,1), app.S.xunit, app.xSF] = app.scale_units(app.S.array(:,1),app.S.xunit);
                        if ~strcmp(app.S.xunit,'s')
                            errMsg = 'Base units for time not recognised. Units must be s';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            app.S = {};
                            return
                        end
                        if (app.S.xdiff == 0)
                            errMsg = 'The data must be sampled at even intervals.';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            app.S = {};
                            return
                        end
                        app.S.xdiff = app.S.xdiff*app.xSF;
                        [app.S.array(:,2:end),app.S.yunit, app.ySF] = app.scale_units(app.S.array(:,2:end),app.S.yunit);
                        if ~any(strcmp(app.S.yunit,{'A','V','au',''}))
                            errMsg = 'Base units not recognised. If specified, units must be A, V or au.';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            app.S = {};
                            return
                        end
                    elseif strcmpi(app.file.baseName(end-4:end),'.tdms')
                        % Allow user to scale data input from tdms files
                        prompt = 'Enter the factor to scale the data by:';
                        app.ySF = inputdlg(prompt,'Data scaling',1,{'1'});
                        if isempty(app.ySF)
                            f = uifigure('Visible','off'); % create invisible figure handle
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            app.S = {};
                            return
                        end
                        app.ySF = str2num(app.ySF{1});
                        if isempty(app.ySF)
                            errMsg = 'The scale factor must be numeric';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            app.S = {};
                            return
                        else
                            if (app.ySF <= 0) || (~isreal(app.ySF))
                                errMsg = 'The scale factor must be a real, non-zero and positive number';  
                                f = errordlg(errMsg,'Error');
                                set(f,'WindowStyle','modal');
                                uiwait(f);
                                app.fullpathlist(end)=[];
                                app.refpathlist(end)=[];
                                app.FullPathNameBox.Items = app.fullpathlist;
                                app.S = {};
                            end
                        end
                        app.S.array(:,2:end) = app.S.array(:,2:end) * app.ySF;
                    end
                    [warnMsg] = lastwarn;
                    if ~isempty(warnMsg)
                        f = errordlg(warnMsg,'Warning');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                    end
                    app.split_excl = [0 0];
                    if app.SplitSpinner.Value > 0
                        rectime = size(app.S.array,1)*(size(app.S.array,2)-1)*app.S.xdiff;
                        if app.SplitSpinner.Value < rectime
                            splitwaves(app); 
                            app.nWaves = size(app.S.array,2)-1;
                        else
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            errMsg='Duration of each wave after splitting must be <= the total recording time.';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            return                            
                        end
                    end  
                    app.array = app.S.array;
                    app.nWaves = size(app.S.array,2)-1;
                    if ~strcmpi(app.file.baseName(end-3:end),'.evt')
                        app.settings = cell(app.nWaves+1,1);
                    end
                    app.xdiff = app.S.xdiff;
                    app.xunit = app.S.xunit;
                    app.yunit = app.S.yunit;
                else
                    lasterr('');
                    warning('');
                    try
                        app.S = ephysIO({app.fullpathlist{i},app.ChannelSpinner.Value});%replaced 1 with app.ch
                    catch
                        app.fullpathlist(end)=[];
                        app.refpathlist(end)=[];
                        app.FullPathNameBox.Items = app.fullpathlist;
                        [errMsg] = lasterr;
                        f = errordlg(errMsg,'Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                    [warnMsg] = lastwarn;
                    if ~isempty(warnMsg)
                        f = errordlg(warnMsg,'Warning');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                    end
                    if any(strcmpi(app.file.baseName(end-3:end),{'.csv','.txt'}))
                        % Assume the same units as for the first file loaded
                        % if loading data from raw text files
                        app.S.xunit = app.xunit;
                        app.S.xdiff = app.xdiff;
                        app.S.yunit = app.yunit;
                        app.S.array(:,1) = app.S.array(:,1) * app.xSF;
                        app.S.array(2:end) = app.S.array(2:end) * app.ySF;
                    elseif strcmpi(app.file.baseName(end-4:end),'.tdms')
                        app.S.array(:,2:end) = app.S.array(:,2:end) * app.ySF;
                    end
                    app.split_excl = [0 0];
                    if app.SplitSpinner.Value > 0
                        rectime = size(app.S.array,1)*(size(app.S.array,2)-1)*app.S.xdiff;
                        if app.SplitSpinner.Value < rectime
                            splitwaves(app); 
                            app.nWaves = size(app.S.array,2)-1;
                        else
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            errMsg='Duration of each wave after splitting must be <= the total recording time.';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            return                            
                        end
                    end
                    if abs(app.S.xdiff-app.xdiff) > eps('single')
                        try
                            error(sprintf('inconsistent sampling interval encountered at file:\n%s',app.fullpathlist{i}))
                        catch
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            [errMsg] = lasterr;
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            return
                        end
                    end
                    if size(app.array,1) ~= size(app.S.array,1)
                        try
                            error('Recording length is inconsistent at file:\n%s',app.fullpathlist{i});
                        catch
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            [errMsg] = lasterr;
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            return
                        end
                    end
                    if ~strcmp(app.S.xunit,app.xunit)
                        try
                            error(sprintf('xunits are inconsistent at file:\n&s',app.fullpathlist{i}))
                        catch
                            app.fullpathlist(end)=[];
                            app.refpathlist(end)=[];
                            app.FullPathNameBox.Items = app.fullpathlist;
                            [errMsg] = lasterr;
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            return
                        end
                    end
                    warning('');
                    if ~strcmp(app.S.yunit,app.yunit)
                        warning(sprintf('yunits are inconsistent at file:\n&s',app.fullpathlist{i}))
                        [warnMsg] = lastwarn;
                        if ~isempty(warnMsg)
                            f = errordlg(warnMsg,'Warning');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                        end
                    end
                    app.array = cat(2,app.ref_array,app.S.array(:,2:end));
                    if ~strcmpi(app.file.baseName(end-3:end),'.evt')
                        app.settings = cat(1,app.settings,cell(size(app.S.array,2)-1,1));
                    end
                    app.nWaves = size(app.array,2)-1;
                end
                app.wavefileidx = [app.wavefileidx; i*ones(size(app.S.array,2)-1,1)];
                if strcmpi(app.file.baseName(end-3:end),'.evt')
                    waitbar(i/numel(app.nFiles),app.h);
                end
            end
            app.settings{app.nWaves+1}.xexclusion{1} = sprintf('[%.6g %.6g]',app.split_excl(1),app.split_excl(2));
            if app.nWaves ~= size(app.settings,1)-1
                app.fullpathlist(end)=[];
                app.refpathlist(end)=[];
                app.FullPathNameBox.Items = app.fullpathlist;
                f = errordlg('inconsistent dimensions between wave number and settings array','Error');
                set(f,'WindowStyle','modal');
                uiwait(f);
                return
            end
            app.ref_array = app.array;

            %wave numbers
            for i = 1:app.nWaves
                wave_drop = int2str(i);
                items{1,i} = wave_drop;
                app.WaveDropDown.Items = items;
            end
            
            %Rename waves
            app.S.names = {'Time'};
            for i = 1:app.nWaves
                app.S.names{i+1} = ['YWave' pad(num2str(i),3,'left','0')];
            end

            %load first wave
            if isempty(app.refpathlist{1})
                app.WaveDropDown.Value = '1';
            else
                app.WaveDropDown.Value = num2str(app.nWaves);
            end
            app.WaveDropDownValueChanged;
            
            % Store a reference list of current file paths
            app.refpathlist = app.fullpathlist;
            
            % Return value for f upon success file load
            f = 1;
            
        end
        
        function LoadPresetsButtonPushed(app, event)
            cwd = pwd;
            if app.presets_file ~= 0
                chdir(app.presets_path)
            end
            f = figure('Units','normalized','Position',[0.4,0.5,0.25,0.02],'NumberTitle', 'off', 'Name','Loading presets file open dialogue...','Toolbar','None','MenuBar','None'); 
            drawnow;
            f.Visible = 'off';
            [app.presets_file, app.presets_path] = uigetfile(...
                {'*.m','MATLAB script file (*.m)'},...
                'Load file');
            % delete dummy figure
            delete(f);
            chdir(cwd);
            if app.presets_file ~= 0
                app.presetsFile_flag = 1;
            else
                return
            end   
            app.prefield.Value = fullfile(app.presets_path,app.presets_file);
        end
    
        
        function SavePresetsButtonPushed(app, event, filename)
            format short g
            if nargin > 2
                chdir(app.path); 
                if ~isempty(app.outdir{1})
                    chdir(app.outdir{1});
                    pathname = pwd;
                    cd ..
                else
                    pathname = pwd;
                end
            else
                [filename, pathname] = uiputfile({'*.m','MATLAB script file (*.m)'},'Save as');
                if filename == 0
                    return
                end
            end
            fid=fopen(fullfile(pathname,filename),'w+t');
            fprintf(fid,'app.TimeConstantsEditField1.Value = %g;\n',app.TimeConstantsEditField1.Value);
            fprintf(fid,'app.TimeConstantsEditField2.Value = %g;\n',app.TimeConstantsEditField2.Value);
            fprintf(fid,'app.ConfigurationDropDown.Value = ''%s'';\n',app.ConfigurationDropDown.Value);
            fprintf(fid,'app.SignoftheEventsSwitch.Value = ''%s'';\n',app.SignoftheEventsSwitch.Value);
            fprintf(fid,'app.ThresholdSpinner.Value = %g;\n',app.ThresholdSpinner.Value);
            fprintf(fid,'app.CriterionDropDown.Value = ''%s'';\n',app.CriterionDropDown.Value);         
            fprintf(fid,'app.CorrelationCoefficientSpinner.Value = %g;\n',app.CorrelationCoefficientSpinner.Value);
            fprintf(fid,'app.HighpassPreFiltermethodDropDown.Value = ''%s'';\n',app.HighpassPreFiltermethodDropDown.Value);
            fprintf(fid,'app.HighpassPreFilterCutOffSpinner.Value = %g;\n',app.HighpassPreFilterCutOffSpinner.Value);
            fprintf(fid,'app.LowpassPreFilterCutOffSpinner.Value = %g;\n',app.LowpassPreFilterCutOffSpinner.Value);
            fprintf(fid,'app.ExtraExclusions.Value = {''%s''};\n',app.ExtraExclusions.Value{1});
            fprintf(fid,'app.NoofTausSpinner.Value = %g;\n',app.NoofTausSpinner.Value);
            fprintf(fid,'app.BaselineTimeSpinner.Value = %g;\n',app.BaselineTimeSpinner.Value);
            fprintf(fid,'app.ExmodeDropDown.Value = ''%s'';\n',app.ExmodeDropDown.Value);
            fprintf(fid,'app.LambdaDisp.Value = %g;\n',app.LambdaDisp.Value);
            fprintf(fid,'app.HighpassFilterCutOffSpinner.Value = %g;\n',app.HighpassFilterCutOffSpinner.Value);
            fprintf(fid,'app.LowpassFilterCutOffSpinner.Value = %g;\n',app.LowpassFilterCutOffSpinner.Value);
            fprintf(fid,'app.MedianButton.Value = %g;\n',app.MedianButton.Value);
            fprintf(fid,'app.MinWindowSpinner.Value = %g;\n',app.MinWindowSpinner.Value);
            fprintf(fid,'app.MaxWindowSpinner.Value = %g;\n',app.MaxWindowSpinner.Value);
            fprintf(fid,'app.WaveFormatDropDown.Value = ''%s'';\n',app.WaveFormatDropDown.Value);
            fprintf(fid,'app.GNUZipCompressionCheckBox.Value = %g;\n',app.GNUZipCompressionCheckBox.Value);
            fprintf(fid,'app.FigureFormatDropDown.Value = ''%s'';\n',app.FigureFormatDropDown.Value);
            fprintf(fid,'app.SplitSpinner.Value = %g;\n',app.SplitSpinner.Value);
            fprintf(fid,'app.ThresholdAbsoluteEditField.Value = %g;\n',app.ThresholdAbsoluteEditField.Value);
            %fprintf(fid,'app.outdir = {''%s''};\n',app.outdir{1});
            fclose(fid);
            app.presets_path = pathname;
            app.presets_file = filename;
            app.LoadSavePresetsButtonPushed;
            app.prefield.Value = fullfile(app.presets_path, app.presets_file);
            app.presetsFile_flag = 1;
        end
        
        function SaveAnalysis(app)
            saveflag = 0;
            for i=1:app.nWaves
              if isfield(app.settings{i+1},'s')
                saveflag = 1;
              end
            end
            if saveflag == 1
                chdir(app.path);
                if ~isempty(app.outdir{1})
                    if ~exist(['./',app.outdir{1}],'dir')
                        mkdir(app.outdir{1});
                    end
                    chdir(app.outdir{1});
                end
                if app.CurrentWaveStoredBox.Value == 1
                    if strcmpi(app.UnsavedLabel.Visible,'on')
                        app.StoreCurrentWaveButtonPushed;
                    end
                end
                relpathlist = cell(size(app.fullpathlist));
                filenamelist = cell(size(app.fullpathlist));
                for j=1:numel(relpathlist)
                    [fullpath,fname,extn] = fileparts(app.fullpathlist{j});
                    relpathlist{j} = relativepath(fullpath,app.path);
                    filenamelist{j} = [fname,extn];
                end
                fullpath = app.path;
                saveddata = app.settings; % settings to saveddata here
                save('analysis.evt','fullpath','relpathlist','saveddata','-mat','-v7.3');
                % Save full file paths in readable filepaths.txt
                fid=fopen('filepaths.txt','w+t');
                fprintf(fid,'%s\n',fullpath);
                for j=1:numel(relpathlist)
                    fprintf(fid,'%s\n',[relpathlist{j} filenamelist{j}]);
                end
                fclose(fid);
                if ~isempty(app.outdir{1})
                  cd ..
                end          
            end
        end
    
        
        function splitwaves(app)
            % split waves function
            temp = app.S.array(:,2:end);
            temp = temp(:);
            n = round(app.SplitSpinner.Value/app.S.xdiff);
            l = ceil(size(temp,1)/n);
            app.S.array = NaN([n,l+1]);
            app.S.array(:,1) = app.S.xdiff*[1:n]';
            for i = 1:l
                if i < l
                    app.S.array(:,i+1) = temp((i-1)*n+1:i*n);
                else
                    app.S.array(:,l+1) = temp(end);
                    m = numel(temp((l-1)*n+1:end));
                    app.S.array(1:m,l+1) = temp((l-1)*n+1:end);
                    if size(app.S.array,1)-m ~= 0
                        app.split_excl = [app.S.array(m+1,1) app.S.array(end,1)];
                    end
                end
            end
        end
        
        function flag = closeEventer(app)
            saveflag = 0;
            for i=1:app.nWaves
              if isfield(app.settings{i+1},'s')
                saveflag = 1;
              end
            end
            if saveflag == 1
                selection = uiconfirm(app.Eventer,'Save and close current analysis?','Close analysis',...
                        'Options',{'Close','Save and close','Cancel'},'DefaultOption',3,'CancelOption',3,'Icon','warning');
            else
                selection = uiconfirm(app.Eventer,sprintf('At least one wave must be stored to enable saving the\nanalysis. Do you want to continue to close without saving?'),'Close analysis',...
                        'Options',{'Close','Cancel'},'DefaultOption',2,'CancelOption',2,'Icon','warning');
            end
            if strcmpi(selection,'Save and close')
                app.SaveAnalysis;
            end
            if ~isempty(regexpi(selection,'close'))
                %clear all variables,plots and edit fields
                clear app.file app.array app.ref_array app.settings app.xdiff app.S app.fullpathlist app.nFiles app.xunit app.yunit app.nWaves saveddata
                app.FullPathNameBox.Items = {};
                app.WaveDropDown.Items = {};
                app.ChannelSpinner.Value = 1;
                cla(app.WavePreviewAxes);
                cla(app.TemplatePreviewAxes);
                delete(app.preview_plot);
                delete(app.template_plot);
                app.SummaryCurrent.Value = '';
                app.SummaryAll.Value = '';
                app.ExtraExclusions.Value = {'[0 0]'};
                app.StoreAllWavesButton.Text = 'Store all waves';
                app.StoreAllWavesButton.Enable = 'off';
                app.StoreCurrentWaveButton.Enable = 'off';
                app.CurrentWaveStoredBox.Enable = 'off';
                app.ApplypresetsButton.Enable = 'off';
                app.PopupGraphButton.Enable = 'off';
                app.RunButton.Enable = 'off';
                app.OnOffCheckBoxHPF.Enable = 'off';
                app.OnOffCheckBoxLPF.Enable = 'off';
                app.CloseButton.Enable = 'off';
                app.settings = {};
                app.fullpathlist = {};
                app.refpathlist = {};
                app.path = '';
                app.wavefileidx = [];
                app.CurrentWaveStoredBox.Value = 0;
                app.UnsavedLabel.Visible = 'off';
                app.UnsavedLabel.Enable = 'off';
                app.TabGroupEventer.SelectedTab = app.PreviewTab;
                app.TabGroupEventerSelectionChanged
                app.RootdirectoryEditField.Value = '';
                app.outdir = {''};
                app.outdirLabel.Text = app.outdir{1};
                app.RootdirectoryEditField.Enable = 'off';
                close all
            end
            if strcmpi(selection,'Cancel')
                flag=0;
            else
                flag=1;
            end
        end
        
        function output = parse_path(app,input)
            if ispc 
                if ~isempty(regexp(input,'/'))
                    output = regexprep(input,'/','\');
                else 
                    output = input;
                end
            else
                if ~isempty(regexp(input,'\'))
                    output = regexprep(input,'\','/');
                else
                    output = input;
                end
            end    
        end
    
        function return_eventer_fit(app)         
            if isempty(app.outdir{1})
                chdir(fullfile(app.path,'eventer.output','ALL_events'));
            else
                chdir(fullfile(app.path,app.outdir{1},'eventer.output','ALL_events'));
            end
            fid = fopen('summary.txt');
            C = textscan(fid,'%s %s','Delimiter',[':','\n']);
            fclose(fid);
            cla(app.TemplatePreviewAxes);
            if eval(C{2}{3}) > 0
                app.tau1EditField.Value = eval(C{2}{8}); % rise time constant
                app.tau2EditField.Value = eval(C{2}{9}); % decay time constant
            else
                app.tau1EditField.Value = 0; 
                app.tau2EditField.Value = 0; 
            end
            chdir(app.path);         
        end
    
        function loadEventClassifier(app)
            % load event data
            chdir(fullfile(app.outdir{1},'eventer.output','ALL_events'));
            app.training_data = ephysIO('event_data.phy');
            cd txt
            app.event_features = load('-ascii','features.txt');
            N = size(app.training_data.array,2)-1;
            chdir(app.path); 
            % create event classification user dialog
            app.train_dlg = uifigure; app.train_dlg.Position = [0 0 500 500]; app.train_dlg.Name = 'Classify events'; 
            app.event_checkbox = uicheckbox(app.train_dlg); app.event_checkbox.Position = [45 15 80 22]; app.event_checkbox.Text = ' Select?'; app.event_checkbox.Enable = 'off';
            app.event_spinner = uispinner(app.train_dlg); app.event_spinner.Position = [145 15 80 22]; app.event_spinner.Step = 1; app.event_spinner.Limits = [1 N]; app.event_spinner.Enable = 'off';
            %app.event_time = uieditfield(app.train_dlg,'numeric'); app.event_time.Position = [260 15 80 22];
            app.train_btn = uibutton(app.train_dlg); app.train_btn.Position = [375 15 90 22]; app.train_btn.Text='Start';
            app.selectall_btn = uibutton(app.train_dlg); app.selectall_btn.Position = [260 15 85 22]; app.selectall_btn.Text='Select all'; app.selectall_btn.Enable = 'off';
            
            % create callbacks
            app.event_spinner.ValueChangedFcn = createCallbackFcn(app, @event_spinnerValueChanged, true);
            app.train_btn.ButtonPushedFcn = createCallbackFcn(app, @train_ButtonPushed, true);
            app.selectall_btn.ButtonPushedFcn = createCallbackFcn(app, @selectall_ButtonPushed, true);
            app.event_checkbox.ValueChangedFcn = createCallbackFcn(app, @event_checkboxValueChanged, true);
            app.train_dlg.WindowKeyPressFcn = createCallbackFcn(app, @EventClassifierWindowKeyPress, true);
            app.event_spinner.Interruptible = 'off';
            app.event_checkbox.Interruptible = 'off';
            
            % tooltips
            app.event_checkbox.Tooltip = {'Select (Key: s) or Reject (Key: r) event'};
            app.event_spinner.Tooltip = {'Move to next (Key: k) or preceeding (Key: m) event'}; 
            app.train_btn.Tooltip = {'Complete classification and train eventer'};
            app.selectall_btn.Tooltip = {'Toggle select or reject all events'};
            
            % plot data
            app.event_plot = uiaxes(app.train_dlg); app.event_plot.Position = [25 50 450 425];

            % initialize event list
            app.event_class = zeros(N,1); % default is event not selected
            
            % select and plot first event
            app.event_spinnerValueChanged;
                       
        end
        
        function event_spinnerValueChanged(app, event)
            set(app.event_plot,'ylimmode','auto');
            plot(app.event_plot,app.training_data.array(:,1),app.training_data.array(:,app.event_spinner.Value+1),'Color',[0 0 0]);
            event_start = abs(app.MinWindowSpinner.Value);
            ax_y = get(app.event_plot,'Ylim');
            hold(app.event_plot,'on');
            plot(app.event_plot,[event_start event_start],app.event_plot.YLim,'g','LineWidth',2);
            hold(app.event_plot,'off');
            set(app.event_plot,'Ylim',ax_y);
            if app.event_class(app.event_spinner.Value) == 0
                app.event_checkbox.Value = 0;
            elseif app.event_class(app.event_spinner.Value) == 1
                app.event_checkbox.Value = 1;
            end
        end
        
        function train_ButtonPushed(app, event)
            if strcmpi(app.train_btn.Text,'Start')
                app.event_spinner.Enable='on';
                app.event_checkbox.Enable='on';
                app.selectall_btn.Enable = 'on';
                app.train_btn.Text = 'Complete';
                chdir(app.path);
                chdir(app.outdir{1});
                if exist('classification.txt','file')
                    temp = load('-ascii','classification.txt');
                    if all(size(temp)==size(app.event_class))
                        app.event_class = temp;
                    end
                    app.event_checkbox.Value = app.event_class(1);
                    app.event_checkboxValueChanged;
                end
            elseif strcmpi(app.train_btn.Text,'Complete')
                chdir(app.path);
                % Train eventer
                app.h = waitbar(0,'Please wait...');
                frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
                n = size(app.event_features,2);
                N = sum(app.event_class);
                app.model = TreeBagger(128,app.event_features,app.event_class,...
                                       'Method','classification',...
                                       'MinLeafSize',max(1,ceil(0.05*N)),...        
                                       'NumPredictorsToSample',ceil(sqrt(n)),...
                                       'OOBPrediction','on',...
                                       'OOBPredictorImportance','on'); 
                waitbar(1,app.h);
                % Mdl =load('path/to/model.mlm','-mat')
                % Mdl.model.OOBPermutedPredictorDeltaError
                close(app.h);
                model = app.model;
                % Plot out-of-bag classification error
                figure(7);
                plot(oobError(app.model));
                xlabel('Number of grown trees');
                ylabel('Out-of-bag classification error');
                % Save trained model
                chdir(app.outdir{1});
                save([app.outdirLabel.Text,'.mlm'],'model','-v7.3');
                % Save the classification
                dlmwrite('classification.txt',app.event_class,'delimiter','\t','newline','pc');
                % Save the eventer settings used during training
                SavePresetsButtonPushed(app,event,[app.outdirLabel.Text,'.m']);
                delete(app.predlg);
                % Turn off training mode
                app.TrainingmodeCheckBox.Value = 0;
                delete(app.train_dlg);
                % Load trained model and add to stored settings
                chdir(app.path);
                app.model_path = fullfile(app.path,app.outdir{1});
                app.model_file = [app.outdir{1} '.mlm'];
                app.settings{1}.model = app.model;
                app.settings{1}.model_source = fullfile(app.model_path,app.model_file);
                app.ModelfileEditFieldValueChanged;
                % reset output directory
                app.outdir = {''};
                app.outdirLabel.Text = app.outdir{1};
                app.RootdirectoryEditFieldValueChanged;
            end
        end
        
        function selectall_ButtonPushed(app, event)
            N = size(app.training_data.array,2)-1;
            if strcmpi(app.selectall_btn.Text, 'Select all')
              app.event_class = ones(N,1); 
              app.selectall_btn.Text = 'Reject all';
            elseif strcmpi(app.selectall_btn.Text, 'Reject all')
              app.event_class = zeros(N,1); 
              app.selectall_btn.Text = 'Select all';
            end
            app.event_spinnerValueChanged;
        end
        
        function EventClassifierWindowKeyPress(app, event)
            key = event.Key;
            % Keyboard shortcuts
            % eg. key = event.Key;
            try
                switch key
                    case 'r'
                        % reject event
                        app.event_checkbox.Value = 0;
                        app.event_checkboxValueChanged;
                    case 's'
                        % select event
                        app.event_checkbox.Value = 1;
                        app.event_checkboxValueChanged;
                    case 'k'
                        app.event_spinner.Value = app.event_spinner.Value+1;
                        app.event_spinnerValueChanged;
                    case 'm'
                        app.event_spinner.Value = app.event_spinner.Value-1;
                        app.event_spinnerValueChanged;
                end
            catch
                % do nothing
            end
        end
        
        function event_checkboxValueChanged(app, event)
            app.event_class(app.event_spinner.Value) = app.event_checkbox.Value;
        end
    
        function [data, unit, SF] = scale_units (app, data, unit)
            
            % Scale the data so that their respective units are without prefixes
            % Establish key-value pairs
            key = [102,112,110,181,109,107,77,71,84,80,117,99];
            val = [nonzeros(-15:3:15);-6;-2];

            % Read unit prefix
            if numel(unit) > 1
              idx = strfind(char(key),unit(1));
              SF = 10^val(idx);
            else
              % Unit has no prefix
              idx = [];
              SF = 1;
            end

            % Scale the data and correct the unit
            if ~isempty(idx)
              % Scale the data
              data = data * SF;
              % Remove the unit prefix
              unit(1) = '';
            else
              % do nothing
            end
            
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.StoreAllWavesButton.Enable = 'off';
            app.StoreCurrentWaveButton.Enable = 'off';
            app.CurrentWaveStoredBox.Enable = 'off';
            app.ApplypresetsButton.Enable = 'off';
            app.PopupGraphButton.Enable = 'off';
            app.RunButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OnOffCheckBoxHPF.Enable = 'off';
            app.OnOffCheckBoxLPF.Enable = 'off';
            app.ExtraExclusions.Value = {'[0,0]'};
            app.FullPathNameBox.Tooltip = {''};
            app.ClosefiguresButton.Tooltip = {''};
            app.CriterionDropDownValueChanged;
            app.WavePreviewAxes.Toolbar.Visible = 'off';
            close all
            format short g
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            close all % close all existing figures
            % Create invisible dummy figure (disguised as a wait bar/message) 
            % and bring it in to focus then hide it. Required for File Open dialogue to be on top (on macOS and linux platforms).
            f = figure('Units','normalized','Position',[0.4,0.5,0.25,0.02],'NumberTitle', 'off', 'Name','Loading file open dialogue...','Toolbar','None','MenuBar','None');
            drawnow;
            f.Visible = 'off';
            %User selection of file & display of file name
            [file.baseName, file.Path] = uigetfile(...
                {'*.abf;*.axgx;*.axgd;*.dat;*.cfs;*.smr;*.tdms;*.wcp;*.EDR;*.pxp;*.ibw;*.bwav;*.ma;*.h5;*.mat;*.phy;*.itx;*.awav;*.atf;*.txt;*.csv;*.evt','All Types';...
                '*.abf','Axon binary files 1 and 2 (*.abf)';...
                '*.axgx;*.axgd','Axograph binary file (*.axgx, *.axgd)';...
                '*.dat','HEKA PatchMaster,Pulse and ChartMaster binary files (*.dat)';...
                '*.cfs','CED Signal binary files (*.cfs)';...
                '*.smr','CED Spike2 binary files (*.smr)';...
                '*.tdms','LabVIEW Signal Express TDMS binary files (*.tdms)';...
                '*.wcp','WinWCP binary file (*.wcp)';...
                '*.EDR','WinEDR binary file (*.EDR)';...
                '*.pxp','Igor Packed experiment binary files (*.pxp)';...
                '*.ibw;*.bwav','Igor binary wave files (*.ibw, *.bwav)';...
                '*.ma','ACQ4 binary (hdf5) files (*.ma)';...
                '*.h5','WaveSurfer binary (hdf5) files (*.h5)';...
                '*.h5','Stimfit binary (hdf5) files (*.h5)';...
                '*.mat','GINJ2 MATLAB binary files (*.mat)';...
                '*.phy','ephysIO HDF5/MATLAB binary files (*.phy)';...
                '*.itx;*.awav','Igor text files (*.itx, *.awav)';...
                '*.atf','Axon text files (*.atf)';...
                '*.txt','Tab-delimited text files (*.txt)';...
                '*.csv','Comma-separated values text files (*.csv)';...
                '*.evt','Eventer analysis (*.evt)'},...
                'Select file(s)','Multiselect','on');
            % delete dummy figure
            delete(f);
            if iscell(file.baseName) 
                if isempty(file.baseName)
                    return
                end
            elseif isnumeric(file.baseName) 
                if file.baseName == 0
                    return
                end
            end
            app.h = waitbar(0,'Please wait while we load the data...');
            frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1);
            app.file.Path = file.Path;
            if iscell(file.baseName)
                for i=1:numel(file.baseName)
                    app.file.baseName = file.baseName{i}; 
                    lasterr('');
                    try
                        app.AddFile;
                    catch
                        app.fullpathlist(end)=[];
                        app.refpathlist(end)=[];
                        app.FullPathNameBox.Items = app.fullpathlist;
                        [errMsg] = lasterr;
                        f = errordlg(errMsg,'Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        close(app.h);
                        return
                    end    
                    waitbar(i/numel(file.baseName),app.h);
                end
            elseif ischar(file.baseName)
                app.file.baseName = file.baseName;
                lasterr('');
                try
                    f = app.AddFile;
                    if ishandle(f)
                        close(app.h);
                        return
                    end
                catch
                    if numel(app.fullpathlist)>1
                        app.fullpathlist(end)=[];
                    else
                        app.fullpathlist={};
                    end
                    if numel(app.refpathlist)>1
                        app.refpathlist(end)=[];
                    else
                        app.refpathlist={};
                    end
                    app.FullPathNameBox.Items = app.fullpathlist;
                    [errMsg] = lasterr;
                    f = errordlg(errMsg,'Error');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    close(app.h);
                    return
                end  
                waitbar(1,app.h);
            end
            close(app.h);
            figure(app.Eventer);
            
            %turning options on
            app.StoreAllWavesButton.Enable = 'on';
            app.StoreCurrentWaveButton.Enable = 'on';
            app.CurrentWaveStoredBox.Enable = 'on';
            app.ApplypresetsButton.Enable = 'on';
            app.PopupGraphButton.Enable = 'on';
            app.RunButton.Enable = 'on';
            app.CloseButton.Enable = 'on';
            app.PresetsButton.Enable = 'on';
            app.OnOffCheckBoxHPF.Enable = 'on';
            app.OnOffCheckBoxLPF.Enable = 'on';
            app.RootdirectoryEditField.Enable = 'on';
            app.ThresholdAbsoluteEditFieldValueChanged;
            if strcmpi(app.file.baseName(end-3:end),'.evt')
                if app.settings{1}.phpf > 0
                    app.OnOffCheckBoxHPF.Value = 1;
                    app.OnOffCheckBoxHPFValueChanged;
                end
                if app.settings{1}.plpf < inf
                    app.OnOffCheckBoxLPF.Value = 1;
                    app.OnOffCheckBoxLPFValueChanged;
                end
            end
            if app.OnOffCheckBoxHPF.Value || app.OnOffCheckBoxLPF.Value
              app.PreFilterCutOffSpinnerValueChanged;
            end
  
            %turn off unsaved warning
            app.UnsavedLabel.Visible = 'off';
            app.UnsavedLabel.Enable = 'off';
            
            %set output path
            %note that these resets every time a file loads
            app.RootdirectoryEditField.Value = app.path;
            
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            app.RunningLamp.Enable = 'on';
            chdir(app.path);
            if ~isempty(app.outdir{1})
                if ~exist(['./',app.outdir{1}],'dir')
                    mkdir(app.outdir{1});
                end
                chdir(app.outdir{1});
            end
            if app.TrainingmodeCheckBox.Value == 1
                if exist('eventer.output','dir')
                    %Delete old eventer.output file
                    try
                        rmdir('eventer.output','s');
                    catch
                        figure(app.Eventer);
                        app.RunningLamp.Enable = 'off';
                        chdir(app.path)
                        f = errordlg('The eventer.output folder is in use and cannot be deleted.'...
                            ,'Error: File in Use');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                end
            end
            %Retrieve stored settings and send to eventer.m
            if strcmp(app.RunDropDown.Value,'Current')
                app.StoreCurrentWaveButtonPushed;
                app.SaveAnalysis;
                if ~isempty(app.outdir{1})
                  chdir(app.outdir{1});
                end
                S.array = [];
                S.xdiff = app.S.xdiff;                  
                S.xunit = app.S.xunit; 
                S.yunit = app.S.yunit; 
                S.names = {}; 
                S.notes = app.S.notes; 
                h = waitbar(0,'Please wait for the analysis to complete...','windowstyle','modal');
                frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
                %retrieval of saved settings for current wave to send to eventer command line
                wave = app.current_wave;
                s = app.settings{1}.s;
                hpf = app.settings{1}.hpf;
                lpf = app.settings{1}.lpf;
                scalefactor = app.settings{1}.threshold;
                time_constant1 = app.settings{wave+1}.TC1;
                time_constant2 = app.settings{wave+1}.TC2;
                win = app.settings{1}.win;
                taus = app.settings{1}.taus;
                baseline = app.settings{1}.baseline;
                lambda = app.settings{1}.lambda;
                average = app.settings{1}.average;
                threshold = app.settings{1}.absthreshold;
                if strcmpi(app.CriterionDropDown.Value,'Machine Learning')       
                    if ~isempty(app.model)
                        criterion = app.model;
                    else
                        if app.TrainingmodeCheckBox.Value > 0
                            criterion = 'Pearson';
                        else
                            errMsg = 'Create or train a model before running eventer';
                            f = errordlg(errMsg,'Error');
                            set(f,'WindowStyle','modal');
                            uiwait(f);
                            return                                
                        end
                    end
                    rmin = -1;
                else
                    criterion = app.settings{1}.criterion;
                    rmin = app.settings{1}.rmin;
                end
                if strcmp(app.ConfigurationDropDown.Value,'dummy')
                    config = '';
                else
                    config = app.settings{1}.config;
                end
                format = app.settings{1}.format;
                exmode = str2double(app.settings{1}.exmode);
                exclude = [app.settings{wave+1}.cell_one app.settings{wave+1}.cell_two;...
                    app.settings{wave+1}.cell_three app.settings{wave+1}.cell_four;...
                    app.settings{wave+1}.cell_five app.settings{wave+1}.cell_six;...
                    app.settings{wave+1}.cell_seven app.settings{wave+1}.cell_eight;...
                    app.settings{wave+1}.cell_nine app.settings{wave+1}.cell_ten;...
                    app.settings{wave+1}.cell_eleven app.settings{wave+1}.cell_twelve];
                exclude((sum(exclude,2)==0),:)=[];
                if ~isempty(app.xexclusion)
                    exclude = cat(1,exclude,app.xexclusion);
                end
                export = app.settings{1}.export;
                if app.settings{1}.gz == 1
                    export = strcmp(export,'.gz');
                end
                
                %adding settings to eventer command line
                lasterr('');
                try
                    S.array = [app.array(:,1) app.array(:,wave+1)];
                    S.names = {'Time' sprintf('YWave%s',pad(num2str(wave),3,'left','0'))};
                    eventer(S,[time_constant1 time_constant2],s,scalefactor,'rmin',rmin,'win',win,'hpf',hpf,'lpf',lpf,...
                        'taus',taus,'baseline',baseline,'config',config,'average',average,'exclude',exclude,'wave',1,...
                        'lambda',lambda,'exmode',exmode,'figure',format,'export',export,'criterion',criterion,'threshold',threshold);
                    waitbar(1,h);
                catch
                    if exist('h','var')
                        close(h);
                    end
                    figure(app.Eventer);
                    app.RunningLamp.Enable = 'off';
                    chdir(app.path);
                    [errMsg] = lasterr;
                    f = errordlg(errMsg,'Error');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    return
                end
                %reading summary.txt for display
                chdir(app.path);
                if ~isempty(app.outdir{1})
                    chdir(app.outdir{1})
                end
                cd eventer.output/ALL_events/
                app.SummaryAll.Value = fileread('summary.txt');
                chdir(['../Data_ch1_YWave' pad(num2str(wave),3,'left','0')]);
                app.SummaryCurrent.Value = fileread('summary.txt');
                if exist('h','var')
                    close(h);
                end
            end
            %run eventer.m with values from saved structure in settings array
            if strcmp(app.RunDropDown.Value,'Batch')
                runflag = 0;
                for i=1:app.nWaves
                  if isfield(app.settings{i+1},'s')
                    runflag = 1;
                  end
                end
                if runflag == 0
                    figure(app.Eventer);
                    app.RunningLamp.Enable = 'off';
                    chdir(app.path)
                    f = errordlg('Please store atleast one wave before running batch analysis');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    return
                end
                chdir(app.path);
                if app.CurrentWaveStoredBox.Value == 1
                    if strcmpi(app.UnsavedLabel.Visible,'on')
                        app.StoreCurrentWaveButtonPushed;
                    end
                end
                app.SaveAnalysis;
                if ~isempty(app.outdir{1})
                  chdir(app.outdir{1});
                end
                if exist('eventer.output','dir')
                    %Delete old eventer.output file
                    try
                        rmdir('eventer.output','s');
                    catch
                        figure(app.Eventer);
                        app.RunningLamp.Enable = 'off';
                        chdir(app.path)
                        f = errordlg('The eventer.output folder is in use and cannot be deleted.'...
                            ,'Error: File in Use');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                end
                % Initialize data structure for eventer
                S.array = [];
                S.xdiff = app.S.xdiff;                  
                S.xunit = app.S.xunit; 
                S.yunit = app.S.yunit; 
                S.names = {}; 
                S.notes = app.S.notes; 
                if app.ParallelCheckBox.Value == 0
                    % Analyse waves in serial
                    wavelist = [];
                    for wave=1:app.nWaves
                        % Create list of waves to analyse
                        if isfield(app.settings{wave+1},'s')
                            wavelist=[wavelist;wave];
                        end
                    end
                    %apply settings from master settings struct {1}
                    n = numel(wavelist);
                    s = app.settings{1}.s;
                    hpf = app.settings{1}.hpf;
                    lpf = app.settings{1}.lpf;
                    scalefactor = app.settings{1}.threshold;
                    win = app.settings{1}.win;
                    taus = app.settings{1}.taus;
                    baseline = app.settings{1}.baseline;
                    lambda = app.settings{1}.lambda;
                    average = app.settings{1}.average;
                    threshold = app.settings{1}.absthreshold;
                    if strcmpi(app.CriterionDropDown.Value,'Machine Learning')       
                        if ~isempty(app.model)
                            criterion = app.model;
                        else
                            if app.TrainingmodeCheckBox.Value > 0
                                criterion = 'Pearson';
                            else
                                errMsg = 'Create or train a model before running eventer';
                                f = errordlg(errMsg,'Error');
                                set(f,'WindowStyle','modal');
                                uiwait(f);
                                return                                
                            end
                        end
                        rmin = -1;
                    else
                        criterion = app.settings{1}.criterion;
                        rmin = app.settings{1}.rmin;
                    end
                    if strcmp(app.ConfigurationDropDown.Value,'dummy')
                        config = '';
                    else
                        config = app.settings{1}.config;
                    end
                    format = app.settings{1}.format;
                    exmode = str2double(app.settings{1}.exmode);
                    export = app.settings{1}.export;
                    exclude = cell(app.nWaves,1);
                    %apply exclusion zones
                    for wave=1:app.nWaves
                        if isfield(app.settings{wave+1},'s')
                            time_constant1{wave} = app.settings{wave+1}.TC1;
                            time_constant2{wave} = app.settings{wave+1}.TC2;
                            exclude{wave} = [app.settings{wave+1}.cell_one app.settings{wave+1}.cell_two;...
                                app.settings{wave+1}.cell_three app.settings{wave+1}.cell_four;...
                                app.settings{wave+1}.cell_five app.settings{wave+1}.cell_six;...
                                app.settings{wave+1}.cell_seven app.settings{wave+1}.cell_eight;...
                                app.settings{wave+1}.cell_nine app.settings{wave+1}.cell_ten;...
                                app.settings{wave+1}.cell_eleven app.settings{wave+1}.cell_twelve];
                            exclude{wave} = cat(1,exclude{wave},eval(app.settings{wave+1}.xexclusion{1}));
                            exclude{wave}((sum(exclude{wave},2)==0),:)=[];
                        else
                            exclude{wave}=[];
                        end
                    end
                    lasterr('');
                    try
                        h = waitbar(0,'Please wait for the analysis to complete...','windowstyle','modal');
                        frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
                        for i = 1:n-1
                            h = waitbar((i-1)/n,h,sprintf('Processing wave %d. Please wait... ', wavelist(i)));
                            S.array = [app.array(:,1) app.array(:,wavelist(i)+1)];
                            S.names = {'Time' sprintf('YWave%s',pad(num2str(wavelist(i)),3,'left','0'))};
                            eventer(S,[time_constant1{wavelist(i)} time_constant2{wavelist(i)}],s,scalefactor,'rmin',rmin,'win',win,'hpf',hpf,'lpf',lpf,'taus',taus,...
                                'baseline',baseline,'config',config,'average',average,'exclude',exclude{wavelist(i)},'wave',1,'lambda',lambda,...
                                'exmode',exmode,'figure',format,'export',export,'merge',0,'showfig','on','criterion',criterion,'threshold',threshold);
                        end
                        % Do merge for last wave
                        waitbar((n-1)/n,h,sprintf('Processing wave %d. Please wait... ', wavelist(n)));
                        S.array = [app.array(:,1) app.array(:,wavelist(n)+1)];
                        S.names = {'Time' sprintf('YWave%s',pad(num2str(wavelist(n)),3,'left','0'))};
                        eventer(S,[time_constant1{wavelist(n)} time_constant2{wavelist(n)}],s,scalefactor,'rmin',rmin,'win',win,'hpf',hpf,'lpf',lpf,'taus',taus,...
                            'baseline',baseline,'config',config,'average',average,'exclude',exclude{wavelist(n)},'wave',1,'lambda',lambda,...
                            'exmode',exmode,'figure',format,'export',export,'merge',1,'showfig','on','criterion',criterion,'threshold',threshold);
                        waitbar(1,h);
                        if exist('h','var')
                            close(h);
                        end
                    catch
                        if exist('h','var')
                            close(h);
                        end
                        figure(app.Eventer);
                        app.RunningLamp.Enable = 'off';
                        chdir(app.path)
                        [errMsg] = lasterr;
                        f = errordlg(errMsg,'Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                elseif app.ParallelCheckBox.Value == 1
                    % Analyse waves in parallel
                    wavelist = [];
                    % Creation of wave names and setting S.array to array
                    % This is more memory intensive than the serial version
                    S.array = app.array;
                    S.names = {'Time'};
                    for wave = 1:app.nWaves
                        S.names{wave+1} = sprintf('YWave%s',pad(num2str(wave),3,'left','0'));
                    end
                    for wave=1:app.nWaves
                        % Create list of waves to analyse
                        if isfield(app.settings{wave+1},'s')
                            wavelist=[wavelist;wave];
                        end
                    end
                    %apply settings from master settings struct {1}
                    n = numel(wavelist);
                    s = app.settings{1}.s;
                    hpf = app.settings{1}.hpf;
                    lpf = app.settings{1}.lpf;
                    scalefactor = app.settings{1}.threshold;
                    win = app.settings{1}.win;
                    taus = app.settings{1}.taus;
                    baseline = app.settings{1}.baseline;
                    lambda = app.settings{1}.lambda;
                    average = app.settings{1}.average;
                    threshold = app.settings{1}.absthreshold;
                    if strcmpi(app.CriterionDropDown.Value,'Machine Learning')       
                        if ~isempty(app.model)
                            criterion = app.model;
                        else
                            if app.TrainingmodeCheckBox.Value > 0
                                criterion = 'Pearson';
                            else
                                errMsg = 'Create or train a model before running eventer';
                                f = errordlg(errMsg,'Error');
                                set(f,'WindowStyle','modal');
                                uiwait(f);
                                return                                
                            end
                        end
                        rmin = -1;
                    else
                        criterion = app.settings{1}.criterion;
                        rmin = app.settings{1}.rmin;
                    end
                    if strcmp(app.ConfigurationDropDown.Value,'dummy')
                        config = '';
                    else
                        config = app.settings{1}.config;
                    end
                    format = app.settings{1}.format;
                    exmode = str2double(app.settings{1}.exmode);
                    export = app.settings{1}.export;
                    exclude = cell(app.nWaves+1,1);
                    %apply exclusion zones
                    for wave=1:app.nWaves
                        if isfield(app.settings{wave+1},'s')
                            time_constant1{wave} = app.settings{wave+1}.TC1;
                            time_constant2{wave} = app.settings{wave+1}.TC2;
                            exclude{wave} = [app.settings{wave+1}.cell_one app.settings{wave+1}.cell_two;...
                                app.settings{wave+1}.cell_three app.settings{wave+1}.cell_four;...
                                app.settings{wave+1}.cell_five app.settings{wave+1}.cell_six;...
                                app.settings{wave+1}.cell_seven app.settings{wave+1}.cell_eight;...
                                app.settings{wave+1}.cell_nine app.settings{wave+1}.cell_ten;...
                                app.settings{wave+1}.cell_eleven app.settings{wave+1}.cell_twelve];
                            exclude{wave} = cat(1,exclude{wave},eval(app.settings{wave+1}.xexclusion{1}));
                            exclude{wave}((sum(exclude{wave},2)==0),:)=[];
                        else
                            exclude{wave}=[];
                        end
                    end
                    lasterr('');
                    try
                        h = parfor_progressbar(n,'Please wait for the analysis to complete...');
                        parfor i = 1:n-1
                            eventer(S,[time_constant1{wavelist(i)} time_constant2{wavelist(i)}],s,scalefactor,'rmin',rmin,'win',win,'hpf',hpf,'lpf',lpf,...
                                'taus',taus,'baseline',baseline,'config',config,'average',average,'exclude',exclude{wavelist(i)},'wave',wavelist(i),...
                                'lambda',lambda,'exmode',exmode,'figure',format,'export',export,'merge',0,'showfig','off','criterion',criterion,'threshold',threshold);
                            h.iterate(1)
                        end
                        % Do merge for last wave
                        eventer(S,[time_constant1{wavelist(n)} time_constant2{wavelist(n)}],s,scalefactor,'rmin',rmin,'win',win,'hpf',hpf,'lpf',lpf,'taus',taus,...
                            'baseline',baseline,'config',config,'average',average,'exclude',exclude{wavelist(n)},'wave',wavelist(n),'lambda',lambda,...
                            'exmode',exmode,'figure',format,'export',export,'merge',1,'showfig','off','criterion',criterion,'threshold',threshold);
                        h.iterate(1)
                        if exist('h','var')
                            close(h);
                        end
                    catch
                        if exist('h','var')
                            close(h);
                        end
                        figure(app.Eventer);
                        app.RunningLamp.Enable = 'off';
                        chdir(app.path);
                        [errMsg] = lasterr;
                        f = errordlg(errMsg,'Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                end
                %reading summary.txt for display
                chdir(app.path);
                if ~isempty(app.outdir{1})
                    chdir(app.outdir{1})
                end
                cd eventer.output/ALL_events/
                app.SummaryAll.Value = fileread('summary.txt');
                app.SummaryCurrent.Value = '';
                try
                    close(1);
                    close(2);
                    close(3);
                    close(4);
                    close(5);
                catch
                end
            end
            app.RunningLamp.Enable = 'off';
            app.Eventer.Visible = 'off';
            app.Eventer.Visible = 'on';
            app.TabGroupEventer.SelectedTab = app.SummaryTab;
            app.TabGroupEventerSelectionChanged
            %if strcmp(app.RunDropDown.Value,'Current')
            %    app.TabGroupSummary.SelectedTab = app.CurrentTab;
            %else
                app.TabGroupSummary.SelectedTab = app.AllTab;
            %end
            app.TabGroupSummarySelectionChanged
            return_eventer_fit(app);
            if strcmpi(app.CriterionDropDown.Value,'Machine Learning')
                if app.TrainingmodeCheckBox.Value > 0
                    app.loadEventClassifier;
                end
            end
        end

        % Button pushed function: ApplypresetsButton
        function ApplypresetsButtonPushed(app, event)
            h_presets = waitbar(0,'Please wait for the settings to be applied...');
            frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
            app.OnOffCheckBoxHPF.Value = 1;
            app.HighpassPreFilterCutOffSpinner.Enable = 'on';
            app.OnOffCheckBoxLPF.Value = 1;
            app.LowpassPreFilterCutOffSpinner.Enable = 'on';
            new_prefilter_settings_flag = 0;
            if app.presetsFile_flag == 1
                % Load the presets file
                lasterr('');
                assignin('base','pname', app.presets_path)
                assignin('base','fname', app.presets_file)
                try
                    fid=fopen([app.presets_path,'/',app.presets_file],'r');
                    temp = fgetl(fid);
                    count = 1;                    
                    while ischar(temp)
                        if isnumeric(temp) % temp will be -1
                            break
                        end
                        temp_cell = split(temp,{' = ',';'});
                        if strcmp(temp_cell{1},'app.HighpassPreFilterCutOffSpinner.Value')
                            if eval(temp_cell{2}) ~= app.HighpassPreFilterCutOffSpinner.Value
                                 new_prefilter_settings_flag = 1;
                            end
                        end
                        if strcmp(temp_cell{1},'app.LowpassPreFilterCutOffSpinner.Value')
                            if eval(temp_cell{2}) ~= app.LowpassPreFilterCutOffSpinner.Value
                                 new_prefilter_settings_flag = 1;
                            end
                        end
                        eval(temp);
                        temp = fgetl(fid);
                        count = count + 1;
                    end
                    fclose(fid);
                catch
                    [errMsg] = lasterr;
                    if exist('count','var')
                      f = errordlg(sprintf('Error reading presets file line %u:\n%s\n%s ',count,temp,errMsg),'Error');
                    else
                      f = errordlg(sprintf('Error opening presets file: \n%s', errMsg),'Error');
                    end
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    if fid ~= -1 
                      fclose(fid);
                    end
                    return
                end
            elseif app.presetsFile_flag == 0
                %Sets Values to presets/defaults specified in Help Eventer
                app.TimeConstantsEditField1.Value = app.timeconstant1_default;
                app.TimeConstantsEditField2.Value = app.timeconstant2_default;
                app.SignoftheEventsSwitch.Value = app.sign_default;
                app.ThresholdSpinner.Value = app.scalefactor_default;
                app.CriterionDropDown.Value = 'Pearson';             
                app.CorrelationCoefficientSpinner.Value = 0.4; 
                if app.phpf_default ~= app.HighpassPreFilterCutOffSpinner.Value
                    new_prefilter_settings_flag = 1;
                end
                if app.plpf_default ~= app.LowpassPreFilterCutOffSpinner.Value
                    new_prefilter_settings_flag = 1;
                end
                app.HighpassPreFilterCutOffSpinner.Value = app.phpf_default;
                app.LowpassPreFilterCutOffSpinner.Value = app.plpf_default;
                app.HighpassFilterCutOffSpinner.Value = app.hpf_default;
                app.LowpassFilterCutOffSpinner.Value = app.lpf_default;
                app.NoofTausSpinner.Value = app.taus_default;
                app.BaselineTimeSpinner.Value = app.base_line_default;
                app.ExmodeDropDown.Value = app.exmode_default;
                app.LambdaDisp.Value = app.lambda_default;
                app.ConfigurationDropDown.Value = 'VC';
                app.MedianButton.Value = 1;
                app.MinWindowSpinner.Value = -0.01;
                app.MaxWindowSpinner.Value = +0.04;
                app.WaveFormatDropDown.Value = 'phy';
                app.GNUZipCompressionCheckBox.Value = 0;
                app.SplitSpinner.Value = 0;
                app.ThresholdAbsoluteEditField.Value = 0;
                app.FigureFormatDropDown.Value = 'fig';
                app.outdir = {''};
                app.ExtraExclusions.Value={'[0, 0]'};
            end
            app.outdirLabel.Text = app.outdir{1};
            if app.HighpassPreFilterCutOffSpinner.Value == 0
                app.HighpassPreFilterCutOffSpinner.Enable = 'off';
                app.OnOffCheckBoxHPF.Value = 0;
            end
            if isinf(app.LowpassPreFilterCutOffSpinner.Value)
                app.LowpassPreFilterCutOffSpinner.Enable = 'off';
                app.OnOffCheckBoxLPF.Value = 0;
            end
            app.CriterionDropDownValueChanged;
            app.SignoftheEventsSwitchValueChanged;
            app.ThresholdAbsoluteEditFieldValueChanged;
            if ~isempty(app.fullpathlist) 
                app.LambdaDispValueChanged;
                app.ConfigurationDropDownValueChanged;
                waitbar(1,h_presets);
                close(h_presets);  
                app.TabGroupEventer.SelectedTab = app.TemplateTab;
                app.TabGroupEventerSelectionChanged;       
                app.ApplyToAllButtonTemplatePushed();
                app.TabGroupEventer.SelectedTab = app.ExcludeTab;
                app.TabGroupEventerSelectionChanged;
                app.settings{app.current_wave+1}.xexclusion = app.ExtraExclusions.Value;
                app.ApplyToAllButtonPushed_xexclusion();
                if new_prefilter_settings_flag == 1
                    app.PreFilterCutOffSpinnerValueChanged;
                end
            else
                waitbar(1,h_presets);
                close(h_presets);
            end
        end

        % Value changed function: LambdaDisp
        function LambdaDispValueChanged(app, event)
                lambda = app.LambdaDisp.Value;                
                reflambda = power(10,-2:3)';
                idx = dsearchn(reflambda,lambda);       
                app.LambdaDisp.Value = reflambda(idx);
                app.LambdaSlider.Value = log10(reflambda(idx));
                unstored(app);
        end

        % Button pushed function: zone_one_x
        function zone_one_xButtonPushed(app, event)
                app.cell_one.Value = 0;
                app.cell_two.Value = 0;
                app.cell_two.BackgroundColor = [1 1 1];
                app.ApplyExclusionZones;
                app.UpdateWavePreview;
                app.UpdatePopupGraph;
                unstored(app);
        end

        % Button pushed function: zone_two_x
        function zone_two_xButtonPushed(app, event)
                app.cell_three.Value = 0;
                app.cell_four.Value = 0;
                app.cell_four.BackgroundColor = [1 1 1];
                app.ApplyExclusionZones;
                app.UpdateWavePreview;
                app.UpdatePopupGraph;
                unstored(app);
        end

        % Button pushed function: zone_three_x
        function zone_three_xButtonPushed(app, event)
                app.cell_five.Value = 0;
                app.cell_six.Value = 0;
                app.cell_six.BackgroundColor = [1 1 1];
                app.ApplyExclusionZones;
                app.UpdateWavePreview;
                app.UpdatePopupGraph;
                unstored(app);
        end

        % Button pushed function: zone_four_x
        function zone_four_xButtonPushed(app, event)
                app.cell_seven.Value = 0;
                app.cell_eight.Value = 0;
                app.cell_eight.BackgroundColor = [1 1 1];
                app.ApplyExclusionZones;
                app.UpdateWavePreview;
                app.UpdatePopupGraph;
                unstored(app);
        end

        % Button pushed function: zone_five_x
        function zone_five_xButtonPushed(app, event)
                app.cell_nine.Value = 0;
                app.cell_ten.Value = 0;
                app.cell_ten.BackgroundColor = [1 1 1];
                app.ApplyExclusionZones;
                app.UpdateWavePreview;
                app.UpdatePopupGraph;
                unstored(app);
        end

        % Button pushed function: zone_six_x
        function zone_six_xButtonPushed(app, event)
                app.cell_eleven.Value = 0;
                app.cell_twelve.Value = 0;
                app.cell_twelve.BackgroundColor = [1 1 1];
                app.ApplyExclusionZones;
                app.UpdateWavePreview;
                app.UpdatePopupGraph;
                unstored(app);
        end

        % Value changed function: cell_one
        function cell_oneValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_two.Value < app.cell_one.Value
                app.cell_two.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_two.Value > app.cell_one.Value
                app.cell_two.BackgroundColor = [1 1 1];
            end
            if app.cell_one.Value == 0 && app.cell_two.Value == 0
                app.cell_two.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_two
        function cell_twoValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_two.Value < app.cell_one.Value
                app.cell_two.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_two.Value > app.cell_one.Value
                app.cell_two.BackgroundColor = [1 1 1];
            end
            if app.cell_one.Value == 0 && app.cell_two.Value == 0
                app.cell_two.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_three
        function cell_threeValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_four.Value < app.cell_three.Value
                app.cell_four.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_four.Value > app.cell_three.Value
                app.cell_four.BackgroundColor = [1 1 1];
            end
            if app.cell_three.Value == 0 && app.cell_four.Value == 0
                app.cell_four.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_four
        function cell_fourValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_four.Value < app.cell_three.Value
                app.cell_four.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_four.Value > app.cell_three.Value
                app.cell_four.BackgroundColor = [1 1 1];
            end
            if app.cell_three.Value == 0 && app.cell_four.Value == 0
                app.cell_four.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_five
        function cell_fiveValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_six.Value < app.cell_five.Value
                app.cell_six.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_six.Value > app.cell_five.Value
                app.cell_six.BackgroundColor = [1 1 1];
            end
            if app.cell_five.Value == 0 && app.cell_six.Value == 0
                app.cell_six.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_six
        function cell_sixValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_six.Value < app.cell_five.Value
                app.cell_six.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_six.Value > app.cell_five.Value
                app.cell_six.BackgroundColor = [1 1 1];
            end
            if app.cell_five.Value == 0 && app.cell_six.Value == 0
                app.cell_six.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_seven
        function cell_sevenValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_eight.Value < app.cell_seven.Value
                app.cell_eight.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_eight.Value > app.cell_seven.Value
                app.cell_eight.BackgroundColor = [1 1 1];
            end
            if app.cell_seven.Value == 0 && app.cell_eight.Value == 0
                app.cell_eight.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_eight
        function cell_eightValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_eight.Value < app.cell_seven.Value
                app.cell_eight.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_eight.Value > app.cell_seven.Value
                app.cell_eight.BackgroundColor = [1 1 1];
            end
            if app.cell_seven.Value == 0 && app.cell_eight.Value == 0
                app.cell_eight.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_nine
        function cell_nineValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_ten.Value < app.cell_nine.Value
                app.cell_ten.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_ten.Value > app.cell_nine.Value
                app.cell_ten.BackgroundColor = [1 1 1];
            end
            if app.cell_nine.Value == 0 && app.cell_ten.Value == 0
                app.cell_ten.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_ten
        function cell_tenValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_ten.Value < app.cell_nine.Value
                app.cell_ten.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_ten.Value > app.cell_nine.Value
                app.cell_ten.BackgroundColor = [1 1 1];
            end
            if app.cell_nine.Value == 0 && app.cell_ten.Value == 0
                app.cell_ten.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_eleven
        function cell_elevenValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_twelve.Value < app.cell_eleven.Value
                app.cell_twelve.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_twelve.Value > app.cell_eleven.Value
                app.cell_twelve.BackgroundColor = [1 1 1];
            end
            if app.cell_eleven.Value == 0 && app.cell_twelve.Value == 0
                app.cell_twelve.BackgroundColor = [1 1 1];
            end
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Value changed function: cell_twelve
        function cell_twelveValueChanged(app, event)
            if isempty(app.FullPathNameBox.Value)
                return
            end
            %run exclusion zone making function
            app.ApplyExclusionZones;
            %error colour for cell input
            if app.cell_twelve.Value < app.cell_eleven.Value
                app.cell_twelve.BackgroundColor = [1 0.55 0.55];
            elseif app.cell_twelve.Value > app.cell_eleven.Value
                app.cell_twelve.BackgroundColor = [1 1 1];
            end
            if app.cell_eleven.Value == 0 && app.cell_twelve.Value == 0
                app.cell_twelve.BackgroundColor = [1 1 1];
            end
            app.UpdatePopupGraph;
            app.UpdateWavePreview;
            unstored(app);
        end

        % Button pushed function: exselect_2
        function exselect_2ButtonPushed(app, event)
            if ishandle(7)
                figure(7);
                % get axis limits
                p = get(gca);
            else
                app.PopupGraphButtonPushed
                p = [];
            end
            x = ginput(2);
            app.cell_three.Value = min(x(:,1));
            app.cell_four.Value = max(x(:,1));
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            if ~isempty(p)
                xlim(p.XLim);
                ylim(p.YLim);
            else
                xlim(app.WavePreviewAxes.XLim)
                ylim(app.WavePreviewAxes.YLim)
            end
        end

        % Button pushed function: exselect_3
        function exselect_3ButtonPushed(app, event)
            if ishandle(7)
                figure(7);
                % get axis limits
                p = get(gca);
            else
                app.PopupGraphButtonPushed
                p = [];
            end
            x = ginput(2);
            app.cell_five.Value = min(x(:,1));
            app.cell_six.Value = max(x(:,1));
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            if ~isempty(p)
                xlim(p.XLim);
                ylim(p.YLim);
            else
                xlim(app.WavePreviewAxes.XLim)
                ylim(app.WavePreviewAxes.YLim)
            end
        end

        % Button pushed function: exselect_4
        function exselect_4ButtonPushed(app, event)
            if ishandle(7)
                figure(7);
                % get axis limits
                p = get(gca);
            else
                app.PopupGraphButtonPushed
                p = [];
            end
            x = ginput(2);
            app.cell_seven.Value = min(x(:,1));
            app.cell_eight.Value = max(x(:,1));
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            if ~isempty(p)
                xlim(p.XLim);
                ylim(p.YLim);
            else
                xlim(app.WavePreviewAxes.XLim)
                ylim(app.WavePreviewAxes.YLim)
            end
        end

        % Button pushed function: exselect_5
        function exselect_5ButtonPushed(app, event)
            if ishandle(7)
                figure(7);
                % get axis limits
                p = get(gca);
            else
                app.PopupGraphButtonPushed
                p = [];
            end
            x = ginput(2);
            app.cell_nine.Value = min(x(:,1));
            app.cell_ten.Value = max(x(:,1));
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            if ~isempty(p)
                xlim(p.XLim);
                ylim(p.YLim);
            else
                xlim(app.WavePreviewAxes.XLim)
                ylim(app.WavePreviewAxes.YLim)
            end
        end

        % Button pushed function: exselect_6
        function exselect_6ButtonPushed(app, event)
            if ishandle(7)
                figure(7);
                % get axis limits
                p = get(gca);
            else
                app.PopupGraphButtonPushed
                p = [];
            end
            x = ginput(2);
            app.cell_eleven.Value = min(x(:,1));
            app.cell_twelve.Value = max(x(:,1));
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            if ~isempty(p)
                xlim(p.XLim);
                ylim(p.YLim);
            else
                xlim(app.WavePreviewAxes.XLim)
                ylim(app.WavePreviewAxes.YLim)
            end
        end

        % Button pushed function: exselect_1
        function exselect_1_1ButtonPushed(app, event)
            if ishandle(7)
                figure(7);
                % get axis limits
                p = get(gca);
            else
                app.PopupGraphButtonPushed
                p = [];
            end
            x = ginput(2);
            app.cell_one.Value = min(x(:,1));
            app.cell_two.Value = max(x(:,1));
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            if ~isempty(p)
                xlim(p.XLim);
                ylim(p.YLim);
            else
                xlim(app.WavePreviewAxes.XLim)
                ylim(app.WavePreviewAxes.YLim)
            end
        end

        % Button pushed function: PopupGraphButton
        function PopupGraphButtonPushed(app, event)
                figure(7);
                app.ex_plot = reduce_plot(app.fig_wave(:,1),app.fig_wave(:,2),'Color',[0 0 0],'linewidth',1.25);
                addToolbarExplorationButtons(gcf);ax = gca; ax.Toolbar.Visible = 'off'; 
                xlim(app.WavePreviewAxes.XLim);
                ylim(app.WavePreviewAxes.YLim);
        end

        % Button pushed function: TemplateSelectButton
        function TemplateSelectButtonPushed(app, event)
            if ishandle(7)
                figure(7)
            else
                f = errordlg('First open a popup graph and zoom onto an isolated event','Info');
                set(f,'WindowStyle','modal');
                uiwait(f);
                return
            end
            x = ginput(2);
            prevone = dsearchn(app.array(:,1), min(x(:,1)));
            prevtwo = dsearchn(app.array(:,1), max(x(:,1)));
            temp = app.array;
            s = app.SignoftheEventsSwitch.Value;
            T = temp(prevone:prevtwo,1);
            T = T-T(1);
            tdata = T;
            ydata = temp(prevone:prevtwo,app.current_wave+1);
            ydata = ydata-ydata(1);
            if s=='-'
                ydata = ydata/min(ydata);
            elseif s=='+'
                ydata = ydata/max(ydata);
            end
            %Plotting template over graph selection
            time_constant1 = app.TimeConstantsEditField1.Value;
            time_constant2 = app.TimeConstantsEditField2.Value;
            tau_rise  = time_constant1*1e-3;
            tau_decay = time_constant2*1e-3;
            p0 = [1,tau_rise,tau_decay];
            tpeak0 = p0(3)*p0(2)/(p0(3)-p0(2))*log(p0(3)/p0(2));
            fun1 = @(p,tdata)-exp(-tdata/p(1))+exp(-tdata/p(2));
            ypeak0 = fun1([p0(2),p0(3)],tpeak0);
            p0 = [1/ypeak0,tau_rise,tau_decay,0];
            lambda = app.LambdaDisp.Value;
            optimoptions = struct;
            optimoptions.Algorithm = {'levenberg-marquardt',lambda};
            optimoptions.TolX = eps;
            optimoptions.TolFun = eps;
            function tdata = fun2(tdata) % required to fit delay free parameter p(4)
                tdata(tdata<0) = 0;
            end
            fun3 = @(p,tdata)p(1)*(-exp(-fun2(tdata+p(4))/p(2))+exp(-fun2(tdata+p(4))/p(3)));
            lasterr('');
            try
                [p,resnorm,residual,exitflag] = lsqfit(fun3,p0,tdata,ydata,[],[],optimoptions);
            catch
                [errMsg] = lasterr;
                f = errordlg(sprintf(errMsg),'Error');
                set(f,'WindowStyle','modal');
                uiwait(f);
                return
            end
            if exitflag == 0
                f = errordlg(sprintf('Number of iterations or function evaluations exceeded'),'Error'); 
                set(f,'WindowStyle','modal');
                uiwait(f);
                return
            elseif exitflag == -2
                f = errordlg(sprintf('The optimzation problem is infeasible'),'Error');
                set(f,'WindowStyle','modal');
                uiwait(f);
                return
            elseif exitflag == -4
                f = errordlg(sprintf('The optimization could not make further progress'),'Error');
                set(f,'WindowStyle','modal');
                uiwait(f);
                return   
            end
            fit = fun3(p,tdata);
            fit(fit<0)=0;
            app.tau1EditField.Value = p(2)*1000;
            app.tau2EditField.Value = p(3)*1000;
            tdata = tdata + app.array(prevone);
            cla(app.TemplatePreviewAxes);
            delete(app.template_plot);
            app.template_plot = plot(app.TemplatePreviewAxes,tdata,ydata,'Color',[0 0 0]);
            ax_y = get(gca,'ylim');
            hold(app.TemplatePreviewAxes,'on')
            app.template_plot = plot(app.TemplatePreviewAxes,tdata,fit,'Color',[0.76 0.03 0.03]);
            hold(app.TemplatePreviewAxes,'off')
            ax_x = [app.array(prevone) app.array(prevtwo)];
            app.TemplatePreviewAxes.XLim = ax_x;
        end

        % Value changed function: FigureFormatDropDown
        function FigureFormatDropDownValueChanged(app, event)
                value = app.FigureFormatDropDown.Value;
                if strcmp('tiff',value) | strcmp('tiffn',value) | strcmp('bmp',value) | strcmp('png',value)
                    set(app.dpiLabel,'Visible','on');
                else
                    set(app.dpiLabel,'Visible','off');
                end
                if ~ispc && strcmp(value,'emf')
                    f = errordlg('Enhanced meta format for Windows platform only','Error');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                end
                unstored(app);
        end

        % Value changed function: WaveFormatDropDown
        function WaveFormatDropDownValueChanged(app, event)
                value = app.WaveFormatDropDown.Value;
                if strcmp('asc',value)
                    set(app.wavesstackedLabel,'Visible','on');
                else
                    set(app.wavesstackedLabel,'Visible','off');
                end
                unstored(app);
        end

        % Value changed function: WaveDropDown
        function WaveDropDownValueChanged(app, event)
            value = app.WaveDropDown.Value;
            if strcmpi(app.UnsavedLabel.Visible,'on')
                % Automatically store modified settings 
                app.WaveDropDown.Value = event.PreviousValue;
                app.current_wave = str2double(app.WaveDropDown.Value);
                app.StoreCurrentWaveButtonPushed;
                app.SaveAnalysis
            end
            app.WaveDropDown.Value = value;
            app.CurrentWaveStoredBox.Value = 0;
            %Wave Preview Creation
            app.current_wave = str2double(value);
            app.FullPathNameBox.Value = app.fullpathlist{app.wavefileidx(app.current_wave)};
            scroll(app.FullPathNameBox,app.FullPathNameBox.Value);
            %Loading saved wave data
            if isfield(app.settings{app.current_wave+1},'s')
                app.SignoftheEventsSwitch.Value = app.settings{1}.s;
                app.SignoftheEventsSwitch_2.Value = app.settings{1}.s;
                app.ThresholdSpinner.Value = app.settings{1}.threshold;
                app.CorrelationCoefficientSpinner.Value = app.settings{1}.rmin;
                if isfield(app.settings{1},'win')
                    app.MinWindowSpinner.Value = app.settings{1}.win(1);
                    app.MaxWindowSpinner.Value = app.settings{1}.win(2);
                else
                    %errordlg('Warning: old version of .evt WIN set to default values','Warning');
                    app.settings{1}.win(1) = -0.01;
                    app.settings{1}.win(2) = 0.04;
                end
                app.HighpassFilterCutOffSpinner.Value = app.settings{1}.hpf;
                app.LowpassFilterCutOffSpinner.Value = app.settings{1}.lpf;
                app.HighpassPreFiltermethodDropDown.Value = app.settings{1}.phpf_type;
                app.HighpassPreFilterCutOffSpinner.Value = app.settings{1}.phpf;
                app.LowpassPreFilterCutOffSpinner.Value = app.settings{1}.plpf;
                app.NoofTausSpinner.Value = app.settings{1}.taus;
                app.BaselineTimeSpinner.Value = app.settings{1}.baseline*1000;
                app.LambdaDisp.Value = app.settings{1}.lambda;
                app.ConfigurationDropDown.Value = app.settings{1}.config;
                if strcmp(app.settings{1}.average,'median')
                    app.MedianButton.Value = 1;
                else
                    app.MeanButton.Value = 1;
                end
                app.ExmodeDropDown.Value = app.settings{1}.exmode;
                app.WaveFormatDropDown.Value = app.settings{1}.export;
                app.FigureFormatDropDown.Value = app.settings{1}.format;
                app.GNUZipCompressionCheckBox.Value = app.settings{1}.gz;
                app.SplitSpinner.Value = app.settings{1}.split;
                app.outdir = app.settings{1}.outdir;
                app.ThresholdAbsoluteEditField.Value = app.settings{1}.absthreshold;
                if isfield(app.settings{1},'model')
                    app.model = app.settings{1}.model;
                    [fpath,fname,fext] = fileparts(app.settings{1}.model_source);
                    app.model_file = [fname,fext];
                    app.model_path = fpath;
                    app.ModelfileEditFieldValueChanged;
                end
                app.CurrentWaveStoredBox.Value = 1;
            end
            if isfield(app.settings{app.current_wave+1},'TC1')
                app.TimeConstantsEditField1.Value = app.settings{app.current_wave+1}.TC1*1000;
            end
            if isfield(app.settings{app.current_wave+1},'TC2')
                app.TimeConstantsEditField2.Value = app.settings{app.current_wave+1}.TC2*1000;
            end            
            if isfield(app.settings{app.current_wave+1},'cell_two')
                app.cell_one.Value = app.settings{app.current_wave+1}.cell_one;
                app.cell_two.Value = app.settings{app.current_wave+1}.cell_two;
            else
                app.cell_one.Value = 0;
                app.cell_two.Value = 0;
            end
            if isfield(app.settings{app.current_wave+1},'cell_four')
                app.cell_three.Value = app.settings{app.current_wave+1}.cell_three;
                app.cell_four.Value = app.settings{app.current_wave+1}.cell_four;
            else
                app.cell_three.Value = 0;
                app.cell_four.Value = 0;
            end
            if isfield(app.settings{app.current_wave+1},'cell_six')
                app.cell_five.Value = app.settings{app.current_wave+1}.cell_five;
                app.cell_six.Value = app.settings{app.current_wave+1}.cell_six;
            else
                app.cell_five.Value = 0;
                app.cell_six.Value = 0;
            end
            if isfield(app.settings{app.current_wave+1},'cell_eight')
                app.cell_seven.Value = app.settings{app.current_wave+1}.cell_seven;
                app.cell_eight.Value = app.settings{app.current_wave+1}.cell_eight;
            else
                app.cell_seven.Value = 0;
                app.cell_eight.Value = 0;
            end
            if isfield(app.settings{app.current_wave+1},'cell_ten')
                app.cell_nine.Value = app.settings{app.current_wave+1}.cell_nine;
                app.cell_ten.Value = app.settings{app.current_wave+1}.cell_ten;
            else
                app.cell_nine.Value = 0;
                app.cell_ten.Value = 0;
            end
            if isfield(app.settings{app.current_wave+1},'cell_twelve')
                app.cell_eleven.Value = app.settings{app.current_wave+1}.cell_eleven;
                app.cell_twelve.Value = app.settings{app.current_wave+1}.cell_twelve;
            else
                app.cell_eleven.Value = 0;
                app.cell_twelve.Value = 0;
            end
            if isfield(app.settings{app.current_wave+1},'xexclusion')
                app.ExtraExclusions.Value = app.settings{app.current_wave+1}.xexclusion;
            else
                app.ExtraExclusions.Value = {'[0 0]'};
            end
            app.outdirLabel.Text = app.outdir{1};
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
            cla(app.TemplatePreviewAxes);
            app.UnsavedLabel.Visible = 'off';
            app.UnsavedLabel.Enable = 'off';
            app.CriterionDropDownValueChanged;
            if ishandle(1)
                close(1)
            end
            if ishandle(2)
                close(2)
            end
            if ishandle(3)
                close(3)
            end
            if ishandle(4)
                close(4)
            end
            if ishandle(5)
                close(5)
            end
            if ishandle(6)
                close(6)
            end
            unstored(app);
            figure(app.Eventer);
        end

        % Button pushed function: CloseButton
        function CloseButtonPushed(app, event)
            app.closeEventer;
        end

        % Value changed function: CurrentWaveStoredBox
        function CurrentWaveStoredBoxValueChanged(app, event)
            %remove current wave's saved data
            value = app.CurrentWaveStoredBox.Value;
            if value == 0
                if isfield(app.settings{app.current_wave+1},'s')
                    app.settings{app.current_wave+1} = ...
                        rmfield(app.settings{app.current_wave+1},'s');
                end
            end
            if value == 1
                %temp saved structure creation
                %all fields in saved structure unused for individual waves except exclusion zones
                %this is to allow the addition of seperate settings for individual waves by user choice
                %if required in the future
                saved.TC1 = app.TimeConstantsEditField1.Value/1000;
                saved.TC2 = app.TimeConstantsEditField2.Value/1000;
                saved.s = app.SignoftheEventsSwitch.Value;
                saved.threshold = app.ThresholdSpinner.Value;
                saved.cell_one = app.cell_one.Value;
                saved.cell_two = app.cell_two.Value;
                saved.cell_three = app.cell_three.Value;
                saved.cell_four = app.cell_four.Value;
                saved.cell_five = app.cell_five.Value;
                saved.cell_six = app.cell_six.Value;
                saved.cell_seven = app.cell_seven.Value;
                saved.cell_eight = app.cell_eight.Value;
                saved.cell_nine = app.cell_nine.Value;
                saved.cell_ten = app.cell_ten.Value;
                saved.cell_eleven = app.cell_eleven.Value;
                saved.cell_twelve = app.cell_twelve.Value;
                saved.xexclusion = app.ExtraExclusions.Value;
                saved.rmin = app.CorrelationCoefficientSpinner.Value;
                saved.win = [app.MinWindowSpinner.Value app.MaxWindowSpinner.Value];
                saved.hpf = app.HighpassFilterCutOffSpinner.Value;
                saved.lpf = app.LowpassFilterCutOffSpinner.Value;
                saved.phpf_type = app.HighpassPreFiltermethodDropDown.Value;
                saved.phpf = app.HighpassPreFilterCutOffSpinner.Value;
                saved.plpf = app.LowpassPreFilterCutOffSpinner.Value;
                saved.taus = app.NoofTausSpinner.Value;
                saved.baseline = app.BaselineTimeSpinner.Value/1000;
                saved.lambda = app.LambdaDisp.Value;
                saved.config = app.ConfigurationDropDown.Value;
                saved.criterion = app.CriterionDropDown.Value;                
                if app.MedianButton.Value == 1
                    saved.average = 'median';
                else
                    saved.average = 'mean';
                end
                saved.format = app.FigureFormatDropDown.Value;
                saved.exmode = app.ExmodeDropDown.Value;
                saved.export = app.WaveFormatDropDown.Value;
                saved.gz = app.GNUZipCompressionCheckBox.Value;
                saved.saved = 1;
                saved.split = app.SplitSpinner.Value;
                saved.outdir = app.outdir;
                saved.absthreshold = app.ThresholdAbsoluteEditField.Value;
                app.current_wave = str2double(app.WaveDropDown.Value);
                %temp setting structure added to cell array in position of wave number
                app.settings{1,1} = saved;
                if ~isempty(app.model)
                    app.settings{1}.model = app.model;
                    app.settings{1}.model_source = fullfile(app.model_path,app.model_file);
                else
                    app.settings{1}.model = [];
                    app.settings{1}.model_source = '';
                end
                app.settings{app.current_wave+1} = saved;
                app.CurrentWaveStoredBox.Value = 1;
            end
            app.UnsavedLabel.Visible = 'off';
            app.UnsavedLabel.Enable = 'off';
        end

        % Value changed function: OnOffCheckBoxHPF
        function OnOffCheckBoxHPFValueChanged(app, event)
            value = app.OnOffCheckBoxHPF.Value;
            if value == 0
                app.HighpassPreFilterCutOffSpinner.Value = 0;
                app.HighpassPreFilterCutOffSpinner.Enable = 'off';
                app.PreFilterCutOffSpinnerValueChanged;
            elseif value == 1
                app.HighpassPreFilterCutOffSpinner.Enable = 'on';
            end
        end

        % Value changed function: OnOffCheckBoxLPF
        function OnOffCheckBoxLPFValueChanged(app, event)
            value = app.OnOffCheckBoxLPF.Value;
            if value == 0
                app.LowpassPreFilterCutOffSpinner.Value = Inf;
                app.LowpassPreFilterCutOffSpinner.Enable = 'off';
                app.PreFilterCutOffSpinnerValueChanged;
            elseif value == 1
                app.LowpassPreFilterCutOffSpinner.Enable = 'on';
            end
        end

        % Value changed function: TimeConstantsEditField1
        function TimeConstantsEditField1ValueChanged(app, event)
            tau_rise = app.TimeConstantsEditField1.Value/1000;
            tau_decay = app.TimeConstantsEditField2.Value/1000;
            minPostEventTime = ...
                -log(tau_decay/tau_rise)/(1/tau_decay-1/tau_rise) + ...
                tau_decay * app.NoofTausSpinner.Value;
            if app.MaxWindowSpinner.Value <= minPostEventTime
                msgbox('Increase post-event time of the Event Window under the ''Output'' tab to avoid errors during the analysis run','Adjust Event Window Size','none')
            end
            unstored(app);
        end

        % Value changed function: TimeConstantsEditField2
        function TimeConstantsEditField2ValueChanged(app, event)
            tau_rise = app.TimeConstantsEditField1.Value/1000;
            tau_decay = app.TimeConstantsEditField2.Value/1000;
            minPostEventTime = ...
                -log(tau_decay/tau_rise)/(1/tau_decay-1/tau_rise) + ...
                tau_decay * app.NoofTausSpinner.Value;
            if app.MaxWindowSpinner.Value <= minPostEventTime
                msgbox('Increase post-event time of the Event Window under the ''Output'' tab to avoid errors during the analysis run','Adjust Event Window Size','none')
            end
            unstored(app);
        end

        % Value changed function: ConfigurationDropDown
        function ConfigurationDropDownValueChanged(app, event)
            if strcmp(app.ConfigurationDropDown.Value,'VC')
                app.WavePreviewAxes.YLabel.String = 'Current (A)';
            elseif strcmp(app.ConfigurationDropDown.Value,'CC')
                app.WavePreviewAxes.YLabel.String = 'Voltage (V)';
            elseif strcmp(app.ConfigurationDropDown.Value,'dummy')
                app.WavePreviewAxes.YLabel.String = 'Amplitude';
            end
            unstored(app);
        end

        % Value changed function: ThresholdSpinner
        function ThresholdSpinnerValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: CorrelationCoefficientSpinner
        function CorrelationCoefficientValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: NoofTausSpinner
        function NoofTausSpinnerValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: BaselineTimeSpinner
        function BaselineTimeSpinnerValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: ExmodeDropDown
        function ExmodeDropDownValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: HighpassFilterCutOffSpinner
        function HighpassFilterCutOffSpinnerValueChanged(app, event)
            lim = 0.443/(app.xdiff*3);
            if app.HighpassFilterCutOffSpinner.Value > lim
                app.HighpassFilterCutOffSpinner.Value = lim;
            end
            unstored(app);
        end

        % Value changed function: LowpassFilterCutOffSpinner
        function LowpassFilterCutOffSpinnerValueChanged(app, event)
            unstored(app);
        end

        % Selection changed function: EnsembleAverageButtonGroup
        function EnsembleAverageButtonGroupSelectionChanged(app, event)
            unstored(app);
        end

        % Value changed function: GNUZipCompressionCheckBox
        function GNUZipCompressionCheckBoxValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: SignoftheEventsSwitch
        function SignoftheEventsSwitchValueChanged(app, event)
            value1 = app.SignoftheEventsSwitch.Value;
            app.SignoftheEventsSwitch_2.Value = value1;
            unstored(app);
        end

        % Button pushed function: StoreCurrentWaveButton
        function StoreCurrentWaveButtonPushed(app, event)
            app.CurrentWaveStoredBox.Value = 1;
            app.CurrentWaveStoredBoxValueChanged;
        end

        % Button pushed function: PresetsButton
        function LoadSavePresetsButtonPushed(app, event)
            if ~isempty(app.predlg)
               if isvalid(app.predlg)
                   figure(app.predlg);
                   return
               end
            end
            % Create load/save dialog box
            dlg = uifigure; dlg.Position = [680 558 225 75]; dlg.Name = 'Presets file';
            app.prefield = uieditfield(dlg); app.prefield.Position = [20 40 180 22];
            if app.presetsFile_flag == 1
                app.prefield.Value = fullfile(app.presets_path,app.presets_file);
            end
            loadbtn = uibutton(dlg); loadbtn.Position = [20 10 80 22]; loadbtn.Text='Load';
            loadbtn.ButtonPushedFcn = createCallbackFcn(app, @LoadPresetsButtonPushed, true);
            savebtn = uibutton(dlg); savebtn.Position = [120 10 80 22]; savebtn.Text='Save as';
            savebtn.ButtonPushedFcn = createCallbackFcn(app, @SavePresetsButtonPushed, true);    
            app.predlg = dlg;
        end

        % Callback function
        function HighpassPreFiltermethodDropDownChanged(app, event)
            unstored(app);
        end

        % Value changed function: ParallelCheckBox
        function ParallelCheckBoxValueChanged(app, event)
            h = waitbar(0,'This may take some time to initialize. Please wait...');
            frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
            try
                gcp('nocreate');
            catch
                app.ParallelCheckBox.Value = 0;
                close(h);
                f = errordlg(sprintf(['Parallel Computing Toolbox is required for this feature.\n'...
                                      'Parallel capabilities are not available for desktop versions of Eventer.']),'Error');
                set(f,'WindowStyle','modal');
                uiwait(f);
                return
            end
            if app.ParallelCheckBox.Value == 1
                if app.NoofworkersSpinner.Value > 0
                    delete(gcp('nocreate'))
                    parpool(app.ProfileLabel.Text,app.NoofworkersSpinner.Value,'IdleTimeout', Inf);  
                else
                    app.NoofworkersSpinner.Value = feature('numcores');
                    delete(gcp('nocreate'))
                    parpool(app.ProfileLabel.Text,app.NoofworkersSpinner.Value,'IdleTimeout', Inf);  
                end
            end
            if exist('h','var')
                close(h);
            end
        end

        % Button pushed function: ClosefiguresButton
        function ClosefiguresButtonPushed(app, event)
            close all;
        end

        % Selection change function: TabGroupEventer
        function TabGroupEventerSelectionChanged(app, event)
            if strcmp(app.TabGroupEventer.SelectedTab.Title,'Preview')
                if ~isempty(app.fullpathlist) 
                    app.UpdateWavePreview;
                end
            end
        end

        % Callback function
        function TabGroupMainSelectionChanged(app, event)
            % Nothing to do
        end

        % Value changed function: ChannelSpinner
        function ChannelSpinnerValueChanged(app, event)
            % Nothing to do
        end

        % Value changed function: ExtraExclusions
        function ExtraExclusionsValueChanged(app, event)
            %auto setting exclusion zones on preview graph
            %run exclusion zone making function
            app.create_xexclusion;
            if all(app.ExtraExclusions.FontColor == [1 0 0])
                return
            end
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Button pushed function: zone_eleven_x
        function zone_eleven_xButtonPushed(app, event)
            app.ExtraExclusions.Value = {'[0 0]'};
            app.ExtraExclusionsValueChanged;
            unstored(app);
        end

        % Window key press function: Eventer
        function EventerWindowKeyPress(app, event)
                key = event.Key;
                % Keyboard shortcuts
                % eg. key = event.Key;
                try
                    switch key
                        case 'k'
                            if strcmpi(app.UnsavedLabel.Visible,'on')
                                % Automatically store modified settings 
                                app.current_wave = str2double(app.WaveDropDown.Value);
                                app.StoreCurrentWaveButtonPushed;
                                app.SaveAnalysis
                            end
                            app.WaveDropDown.Value = num2str(max(str2double(app.WaveDropDown.Value)-1,1));
                            app.WaveDropDownValueChanged
                        case 'm'
                            if strcmpi(app.UnsavedLabel.Visible,'on')
                                % Automatically store modified settings 
                                app.current_wave = str2double(app.WaveDropDown.Value);
                                app.StoreCurrentWaveButtonPushed;
                                app.SaveAnalysis
                            end
                            app.WaveDropDown.Value = num2str(min(str2double(app.WaveDropDown.Value)+1,app.nWaves));
                            app.WaveDropDownValueChanged
                        case 'a'
                            app.LoadButtonPushed
                        case 's'
                            app.CurrentWaveStoredBox.Value = 1;
                            app.CurrentWaveStoredBoxValueChanged
                        case 'd'
                            app.CurrentWaveStoredBox.Value = 0;
                            app.CurrentWaveStoredBoxValueChanged
                        case 'g'
                            app.PopupGraphButtonPushed
                        case 'p'
                            app.RunButtonPushed
                        %case 'q'
                        %    app.TabGroupEventer.SelectedTab = app.PreviewTab;
                        %    app.TabGroupEventerSelectionChanged
                        %case 'w'
                        %    app.TabGroupEventer.SelectedTab = app.TemplateTab;
                        %    app.TabGroupEventerSelectionChanged
                        %case 'e'
                        %    app.TabGroupEventer.SelectedTab = app.ExcludeTab;
                        %    app.TabGroupEventerSelectionChanged
                        %case 'r'
                        %    app.TabGroupEventer.SelectedTab = app.DetectionTab;
                        %    app.TabGroupEventerSelectionChanged
                        %case 't'
                        %    app.TabGroupEventer.SelectedTab = app.AdvancedTab;
                        %    app.TabGroupEventerSelectionChanged
                        %case 'y'
                        %    app.TabGroupEventer.SelectedTab = app.OutputTab;
                        %    app.TabGroupEventerSelectionChanged
                        %case 'u'
                        %    app.TabGroupEventer.SelectedTab = app.SummaryTab;
                        %    app.TabGroupEventerSelectionChanged
                    end
                catch
                    % do nothing
                end
        end

        % Value changed function: NoofworkersSpinner
        function NoofworkersSpinnerChanged(app, event)
            if app.NoofworkersSpinner.Value > feature('numcores')
                app.NoofworkersSpinner.Value = feature('numcores');
            end
            if app.ParallelCheckBox.Value == 1
                try
                    delete(gcp('nocreate'));
                catch
                    errordlg('Parallel Computing Toolbox is required for this feature','Error');
                    set(f,'WindowStyle','modal');
                    uiwait(f);
                    return
                end                
                app.ParallelCheckBoxValueChanged
            end
        end

        % Value changed function: HighpassPreFilterCutOffSpinner, 
        % HighpassPreFiltermethodDropDown, 
        % LowpassPreFilterCutOffSpinner
        function PreFilterCutOffSpinnerValueChanged(app, event)
            if app.HighpassPreFilterCutOffSpinner.Value == 0
                app.OnOffCheckBoxHPF.Value = 0;
                app.HighpassPreFilterCutOffSpinner.Enable = 'off';
            end
            if isinf(app.LowpassPreFilterCutOffSpinner.Value)
                app.OnOffCheckBoxLPF.Value = 0;
                app.LowpassPreFilterCutOffSpinner.Enable = 'off';
            end
            % Cutoff limit checks
            if strcmp(app.HighpassPreFiltermethodDropDown.Value,'binomial')
                lim = 1.31/(app.xdiff*4);
                if app.HighpassPreFilterCutOffSpinner.Value > lim
                    app.HighpassPreFilterCutOffSpinner.Value = lim;
                end
                app.PreFilterWaves;
            elseif strcmp(app.HighpassPreFiltermethodDropDown.Value,'median')
                lim = 0.443/(app.xdiff*3);
                if app.HighpassPreFilterCutOffSpinner.Value > lim
                    app.HighpassPreFilterCutOffSpinner.Value = lim;
                end
                app.PreFilterWaves;
            end
            app.ApplyExclusionZones;
            app.UpdateWavePreview;
            app.UpdatePopupGraph;
            unstored(app);
        end

        % Button pushed function: ProfileNameButton
        function ProfileNameButtonPushed(app, event)
            app.profile = inputdlg('Enter parallel profile name:');
            if ~isempty(app.profile)               
               app.ProfileLabel.Text = app.profile;
            end
        end

        % Value changed function: FullPathNameBox
        function FullPathNameBoxValueChanged(app, event)
            app.FullPathNameBox.Value = app.fullpathlist{app.wavefileidx(app.current_wave)};
        end

        % Value changed function: LambdaSlider
        function LambdaSliderValueChanged(app, event)
            lambda = 10^app.LambdaSlider.Value;                
            reflambda = power(10,-2:3)';
            idx = dsearchn(reflambda,lambda);       
            app.LambdaDisp.Value = reflambda(idx);
            app.LambdaSlider.Value = log10(reflambda(idx));
            unstored(app);
        end

        % Button pushed function: ApplyToAllButton_ex_1
        function ApplyToAllButtonPushed_ex1(app, event)
            selection = uiconfirm(app.Eventer,'Apply this exclusion zone 1 setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.cell_one = app.cell_one.Value;
                    app.settings{i,1}.cell_two = app.cell_two.Value;
                end
            end
            unstored(app);
        end

        % Button pushed function: ApplyToAllButton_ex_2
        function ApplyToAllButtonPushed_ex_2(app, event)
            selection = uiconfirm(app.Eventer,'Apply these exclusion zone 2 setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.cell_three = app.cell_three.Value;
                    app.settings{i,1}.cell_four = app.cell_four.Value;
                end
            end
            unstored(app); 
        end

        % Button pushed function: ApplyToAllButton_ex_3
        function ApplyToAllButtonPushed_ex_3(app, event)
            selection = uiconfirm(app.Eventer,'Apply this exclusion zone 3 setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.cell_five = app.cell_five.Value;
                    app.settings{i,1}.cell_six = app.cell_six.Value;
                end
            end
            unstored(app);
        end

        % Button pushed function: ApplyToAllButton_ex_4
        function ApplyToAllButtonPushed_ex_4(app, event)
            selection = uiconfirm(app.Eventer,'Apply this exclusion zone 4 setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.cell_seven = app.cell_seven.Value;
                    app.settings{i,1}.cell_eight = app.cell_eight.Value;
                end
            end
            unstored(app);               
        end

        % Button pushed function: ApplyToAllButton_ex_5
        function ApplyToAllButtonPushed_ex_5(app, event)
            selection = uiconfirm(app.Eventer,'Apply this exclusion zone 5 setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.cell_nine = app.cell_nine.Value;
                    app.settings{i,1}.cell_ten = app.cell_ten.Value;
                end
            end
            unstored(app);               
        end

        % Button pushed function: ApplyToAllButton_ex_6
        function ApplyToAllButtonPushed_ex_6(app, event)
            selection = uiconfirm(app.Eventer,'Apply this exclusion zone 6 setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.cell_eleven = app.cell_eleven.Value;
                    app.settings{i,1}.cell_twelve = app.cell_twelve.Value;
                end
            end
            unstored(app);             
        end

        % Button pushed function: ApplyToAllButton_xexclusion
        function ApplyToAllButtonPushed_xexclusion(app, event)
            selection = uiconfirm(app.Eventer,'Apply this extra exclusion zone setting to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.xexclusion = app.ExtraExclusions.Value;
                end
            end
            unstored(app);             
        end

        % Selection change function: TabGroupSummary
        function TabGroupSummarySelectionChanged(app, event)
            % Nothing to do
        end

        % Value changed function: MinWindowSpinner
        function MinWindowSpinnerValueChanged(app, event)
            unstored(app);
        end

        % Value changed function: MaxWindowSpinner
        function MaxWindowSpinnerValueChanged(app, event)
            unstored(app);
        end

        % Close request function: Eventer
        function EventerCloseRequest(app, event)
            if strcmpi(app.RunButton.Enable,'on')
                flag = app.closeEventer;
            else 
                flag = 1;
            end
            if flag == 1
                delete(app);
            end
        end

        % Button pushed function: StoreAllWavesButton
        function StoreAllButtonPushed(app, event)
            value = app.WaveDropDown.Value;
            if strcmpi(app.StoreAllWavesButton.Text,'Store all waves')
              state = 1;
              app.StoreAllWavesButton.Text = 'Unstore all waves';
            elseif strcmpi(app.StoreAllWavesButton.Text,'Unstore all waves')
              state = 0;
              app.StoreAllWavesButton.Text = 'Store all waves';
            end
            h = waitbar(0,'Please wait while we store/unstore all wave settings...');
            frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
            for i=1:app.nWaves
              app.WaveDropDown.Value = num2str(i);
              app.WaveDropDownValueChanged;
              app.CurrentWaveStoredBox.Value = state;
              app.CurrentWaveStoredBoxValueChanged
              waitbar(i/app.nWaves,h);
            end
            app.WaveDropDown.Value = value;
            app.WaveDropDownValueChanged;
            close(h);
        end

        % Callback function
        function SaveButtonPushed(app, event)
            app.SaveAnalysis;
            msgbox(sprintf('Analysis settings saved at the following location:\n\n%s\n',app.path),'Save','none')
        end

        % Button pushed function: ApplyToAllButtonTemplate
        function ApplyToAllButtonTemplatePushed(app, event)
            selection = uiconfirm(app.Eventer,'Apply these template settings to all waves?','Confirm apply to all',...
                        'Icon','warning','Options',{'Yes','No'});
            if strcmpi(selection,'Yes')
                for i=1:app.nWaves+1
                    app.settings{i,1}.TC1 = app.TimeConstantsEditField1.Value/1000;
                    app.settings{i,1}.TC2 = app.TimeConstantsEditField2.Value/1000;
                end
            end
            unstored(app);            
        end

        % Value changed function: SplitSpinner
        function SplitSpinnerValueChanged(app, event)
            value = app.SplitSpinner.Value;
            app.settings{1,1}.split = value; % automatically store this settings
            unstored(app);
        end

        % Value changed function: CriterionDropDown
        function CriterionDropDownValueChanged(app, event)
            value = app.CriterionDropDown.Value;
            if strcmpi(value,'Pearson')
                app.CorrelationCoefficientSpinner.Enable='on';
                app.LoadmodelButton.Enable='off';
                app.TrainingmodeCheckBox.Enable='off';
                app.ModelfileEditField.Enable='off';
            elseif strcmpi(value,'Machine Learning')
                app.CorrelationCoefficientSpinner.Enable='off';
                app.LoadmodelButton.Enable='on';
                app.TrainingmodeCheckBox.Enable='on';
                app.ModelfileEditField.Enable='on';
            end
            unstored(app); 
        end

        % Value changed function: RootdirectoryEditField
        function RootdirectoryEditFieldValueChanged(app, event)
            app.RootdirectoryEditField.Value = app.path;
        end

        % Button pushed function: SetOutputFolderButton
        function SetOutputFolderButtonPushed(app, event)
            outdir = inputdlg('Enter folder name for Eventer output:','',[1 50],app.outdir);
            if ~isempty(outdir)
                if isempty(outdir{1})
                    app.outdir = {''};
                    app.outdirLabel.Text = app.outdir{1};
                    return
                else
                    % Error checking 
                    if ~isempty(regexpi(outdir{1},'[^A-Z0-9\_-]','once'))
                        f = errordlg('Invalid folder name','Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                    else
                        app.outdir = outdir;
                        app.outdirLabel.Text = app.outdir{1};
                    end
                end
            end 
            unstored(app);
        end

        % Button pushed function: LoadmodelButton
        function LoadmodelButtonPushed(app, event)
            %  Check if a model is already loaded
            if app.model_file ~= 0
                selection = uiconfirm(app.Eventer,'Close current model?','Close model',...
                        'Options',{'Close','Cancel'},'DefaultOption',2,'CancelOption',2,'Icon','warning');
                if strcmpi(selection,'Close')
                    app.model = [];
                    app.model_file = 0;
                    app.model_path = '';
                    app.ModelfileEditFieldValueChanged;
                elseif strcmpi(selection,'Cancel')
                    return
                end
            end
            % Create invisible dummy figure (disguised as a wait bar/message) 
            % and bring it in to focus then hide it. Required for File Open dialogue to be on top (on macOS and Linux).
            f = figure('Units','normalized','Position',[0.4,0.5,0.25,0.02],'NumberTitle', 'off', 'Name','Loading model file open dialogue...','Toolbar','None','MenuBar','None'); 
            drawnow;
            f.Visible = 'off'; 
            [app.model_file, app.model_path] = uigetfile(...
                {'*.mlm','Machine learning model (*.mlm)'},...
                'Load trained model');
            % delete dummy figure
            delete(f);
            if app.model_file == 0
               return
            end
            % Load model
            h_model = waitbar(0,'Please wait while the machine learning model file loads...');
            frames = java.awt.Frame.getFrames(); frames(end).setAlwaysOnTop(1); 
            load(fullfile(app.model_path,app.model_file),'-mat')
            app.model = model;   
            app.ModelfileEditFieldValueChanged;
            waitbar(1,h_model);
            close(h_model);
            % Load model settings
            app.predlg;
            app.presets_path = app.model_path;
            [~,fname] = fileparts(app.model_file);
            app.presets_file = [fname '.m'];
            app.presetsFile_flag = 1;
            if ~isstruct(app.prefield)
                app.prefield = struct;
            end
            app.prefield.Value = fullfile(app.presets_path,app.presets_file);
            app.ApplypresetsButtonPushed;
            delete(app.predlg);
        end

        % Value changed function: TrainingmodeCheckBox
        function TrainingmodeCheckBoxValueChanged(app, event)
            if app.TrainingmodeCheckBox.Value > 0   
                outdir = inputdlg('Enter a name for the new machine learning model:','',[1 50],app.outdir);
                if ~isempty(outdir)
                    if isempty(outdir{1})
                        app.TrainingmodeCheckBox.Value = 0;
                        app.TrainingmodeCheckBoxValueChanged;
                        f = errordlg('Invalid model name','Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    end
                    % Error checking 
                    if ~isempty(regexpi(outdir{1},'[^A-Z0-9\_-]','once'))
                        app.TrainingmodeCheckBox.Value = 0;
                        f = errordlg('Invalid model name','Error');
                        set(f,'WindowStyle','modal');
                        uiwait(f);
                        return
                    else
                        app.outdir = outdir;
                        app.outdirLabel.Text = app.outdir{1};
                    end
                    % Close loaded model 
                    app.model = [];
                    app.model_file = 0;
                    app.model_path = '';
                    app.ModelfileEditFieldValueChanged;
                else 
                    app.TrainingmodeCheckBox.Value = 0;
                    app.TrainingmodeCheckBoxValueChanged;
                end 
                unstored(app);
            else
                app.outdir = {''};
                app.outdirLabel.Text = app.outdir{1}; 
            end
        end

        % Value changed function: ModelfileEditField
        function ModelfileEditFieldValueChanged(app, event)
            if ~isempty(app.model)
                app.ModelfileEditField.Value = fullfile(app.model_path,app.model_file);
            else
                app.ModelfileEditField.Value = '';
            end
            unstored(app);
        end

        % Value changed function: SignoftheEventsSwitch_2
        function SignoftheEventsSwitch_2ValueChanged(app, event)
            value2 = app.SignoftheEventsSwitch_2.Value;
            app.SignoftheEventsSwitch.Value = value2;
            unstored(app)
        end

        % Value changed function: ThresholdAbsoluteEditField
        function ThresholdAbsoluteEditFieldValueChanged(app, event)
            value = app.ThresholdAbsoluteEditField.Value;
            if value > 0
                app.ThresholdSpinner.Enable = 'off';
            else
                app.ThresholdSpinner.Enable = 'on';
            end
            unstored(app);
        end

        % Button pushed function: CreditsButton
        function AboutEventerButtonPushed(app, event)
            credits=["\fontsize{14}\color{black}\bfEVENTER\rm",...
                   "\fontsize{12}\color{black}v1.1.3",...
                   "\fontsize{10}Compiled for Matlab 2019a (9.6) Runtime",...
                   "\fontsize{10}Copyright © 2019, Andrew Penn",...
                   "Eventer is distributed under the GNU General Public Licence v3.0","",...
                   "\fontsize{12}\bfPLEASE CITE:",...
                   "Winchester, G., Liu, S., Steele, O.G., Aziz, W. and Penn, A.C. (2020)\rm",...
                   "Eventer: \itSoftware for the detection of spontaneous synaptic events measured by electrophysiology or imaging.\rm"...
                   "http://doi.org/10.5281/zenodo.3991677","\color{black}",...
                   "\fontsize{12}Eventer acknowledges code included or modified from:\rm",...
                   "\color{blue}\fontsize{10}\bfrelativepath\rm, version 1.0.0.0","Copyright © 2003, Jochen Lenz",...
                   "\bfparfor\_progressbar\rm, version 2.13.0.0","Copyright © 2016, Daniel Terry",...
                   "\bfPlot (Big)\rm, version 1.6.0.0","Copyright © 2015 Tucker",...
                   "\bfabfload\rm, version 4 Dec 2017","Copyright © 2009, Forrest Collman, 2004, Harald Hentschke 1998, U. Egert",...
                   "\bfreadMeta\rm (from ACQ4), version 24 Dec 2013","Copyright © 2013 Luke Campagnola",...
                   "\bfIBWread\rm, version 1.0.0.0","Copyright © 2009, Jakub Bialek",...
                   "\bfimportaxo\rm, version 4 June 2015","Marco Russo, Modified from BJ/AM <importaxo.m>",...
                   "\bfImportHEKA\rm (from sigTOOL v0.95), version 02 Sep 2012","Copyright © Malcolm Lidierth & King's College London 2009-",...
                   "\bfmat64c\rm, version 2014","Jim Colebatch",...
                   "\bfTDMS DAQmx Raw data reader\rm, version 24 Mar 2014", "Copyright © CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2014, Author: Tao Lan ",...
                   "\bfSON2\rm (from sigTOOL v0.95)","Copyright © Malcolm Lidierth & King's College London 2009-",...
                   "\bfloadDataFile\rm (from WaveSurfer 1.0.5)\rm","Copyright © 2013ÿ, Howard Hughes Medical Institute",...
                   "\bfwcp\_import\rm, version 04 Feb 2015","Copyright © 2015, David Jäckel\rm",""];
                   Opt.Interpreter = 'tex';
                   Opt.WindowStyle = 'normal';
                   msgbox(credits, 'Credits', 'none', Opt);
        end

        % Button pushed function: Button
        function CopyFitParametersButtonPushed(app, event)
            app.TimeConstantsEditField1.Value = app.tau1EditField.Value;
            app.TimeConstantsEditField2.Value = app.tau2EditField.Value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Eventer and hide until all components are created
            app.Eventer = uifigure('Visible', 'off');
            app.Eventer.Colormap = [0.2431 0.149 0.6588;0.251 0.1647 0.7059;0.2588 0.1804 0.7529;0.2627 0.1961 0.7961;0.2706 0.2157 0.8353;0.2745 0.2353 0.8706;0.2784 0.2549 0.898;0.2784 0.2784 0.9216;0.2824 0.302 0.9412;0.2824 0.3216 0.9569;0.2784 0.3451 0.9725;0.2745 0.3686 0.9843;0.2706 0.3882 0.9922;0.2588 0.4118 0.9961;0.2431 0.4353 1;0.2196 0.4588 0.9961;0.1961 0.4863 0.9882;0.1843 0.5059 0.9804;0.1804 0.5294 0.9686;0.1765 0.549 0.9529;0.1686 0.5686 0.9373;0.1529 0.5922 0.9216;0.1451 0.6078 0.9098;0.1373 0.6275 0.898;0.1255 0.6471 0.8902;0.1098 0.6627 0.8745;0.0941 0.6784 0.8588;0.0706 0.6941 0.8392;0.0314 0.7098 0.8157;0.0039 0.7216 0.7922;0.0078 0.7294 0.7647;0.0431 0.7412 0.7412;0.098 0.749 0.7137;0.1412 0.7569 0.6824;0.1725 0.7686 0.6549;0.1922 0.7765 0.6235;0.2157 0.7843 0.5922;0.2471 0.7922 0.5569;0.2902 0.7961 0.5176;0.3412 0.8 0.4784;0.3922 0.8039 0.4353;0.4471 0.8039 0.3922;0.5059 0.8 0.349;0.5608 0.7961 0.3059;0.6157 0.7882 0.2627;0.6706 0.7804 0.2235;0.7255 0.7686 0.1922;0.7725 0.7608 0.1647;0.8196 0.749 0.1529;0.8627 0.7412 0.1608;0.902 0.7333 0.1765;0.9412 0.7294 0.2118;0.9725 0.7294 0.2392;0.9961 0.7451 0.2353;0.9961 0.7647 0.2196;0.9961 0.7882 0.2039;0.9882 0.8118 0.1882;0.9804 0.8392 0.1765;0.9686 0.8627 0.1647;0.9608 0.8902 0.1529;0.9608 0.9137 0.1412;0.9647 0.9373 0.1255;0.9686 0.9608 0.1059;0.9765 0.9843 0.0824];
            app.Eventer.Position = [50 50 564 503];
            app.Eventer.Name = 'Eventer';
            app.Eventer.CloseRequestFcn = createCallbackFcn(app, @EventerCloseRequest, true);
            app.Eventer.WindowKeyPressFcn = createCallbackFcn(app, @EventerWindowKeyPress, true);

            % Create FilePanel
            app.FilePanel = uipanel(app.Eventer);
            app.FilePanel.Position = [10 405 546 90];

            % Create LoadButton
            app.LoadButton = uibutton(app.FilePanel, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.BusyAction = 'cancel';
            app.LoadButton.Tooltip = {'Select and add files to the file list. Key: a'};
            app.LoadButton.Position = [10 62 43 23];
            app.LoadButton.Text = 'Load';

            % Create ChannelSpinnerLabel
            app.ChannelSpinnerLabel = uilabel(app.FilePanel);
            app.ChannelSpinnerLabel.HorizontalAlignment = 'right';
            app.ChannelSpinnerLabel.Position = [53 62 50 22];
            app.ChannelSpinnerLabel.Text = 'Channel';

            % Create ChannelSpinner
            app.ChannelSpinner = uispinner(app.FilePanel);
            app.ChannelSpinner.Limits = [1 Inf];
            app.ChannelSpinner.ValueChangedFcn = createCallbackFcn(app, @ChannelSpinnerValueChanged, true);
            app.ChannelSpinner.Tooltip = {'Select the recording channel before loading files.'};
            app.ChannelSpinner.Position = [108 62 44 22];
            app.ChannelSpinner.Value = 1;

            % Create CloseButton
            app.CloseButton = uibutton(app.FilePanel, 'push');
            app.CloseButton.ButtonPushedFcn = createCallbackFcn(app, @CloseButtonPushed, true);
            app.CloseButton.BusyAction = 'cancel';
            app.CloseButton.Tooltip = {'Close the analysis and clear the file list'};
            app.CloseButton.Position = [256 62 46 22];
            app.CloseButton.Text = 'Close';

            % Create FullPathNameBox
            app.FullPathNameBox = uilistbox(app.FilePanel);
            app.FullPathNameBox.Items = {};
            app.FullPathNameBox.ValueChangedFcn = createCallbackFcn(app, @FullPathNameBoxValueChanged, true);
            app.FullPathNameBox.Tooltip = {'File paths'};
            app.FullPathNameBox.Position = [10 7 526 50];
            app.FullPathNameBox.Value = {};

            % Create PresetsButton
            app.PresetsButton = uibutton(app.FilePanel, 'push');
            app.PresetsButton.ButtonPushedFcn = createCallbackFcn(app, @LoadSavePresetsButtonPushed, true);
            app.PresetsButton.BusyAction = 'cancel';
            app.PresetsButton.Tooltip = {'Select and load a presets file'};
            app.PresetsButton.Position = [308 62 51 22];
            app.PresetsButton.Text = 'Presets';

            % Create ApplypresetsButton
            app.ApplypresetsButton = uibutton(app.FilePanel, 'push');
            app.ApplypresetsButton.ButtonPushedFcn = createCallbackFcn(app, @ApplypresetsButtonPushed, true);
            app.ApplypresetsButton.BusyAction = 'cancel';
            app.ApplypresetsButton.Tooltip = {'Apply loaded presets'};
            app.ApplypresetsButton.Position = [364 62 83 22];
            app.ApplypresetsButton.Text = 'Apply presets';

            % Create ClosefiguresButton
            app.ClosefiguresButton = uibutton(app.FilePanel, 'push');
            app.ClosefiguresButton.ButtonPushedFcn = createCallbackFcn(app, @ClosefiguresButtonPushed, true);
            app.ClosefiguresButton.BusyAction = 'cancel';
            app.ClosefiguresButton.Tooltip = {'Close all figures'};
            app.ClosefiguresButton.Position = [452 62 83 22];
            app.ClosefiguresButton.Text = 'Close figures';

            % Create SplitSpinnerLabel
            app.SplitSpinnerLabel = uilabel(app.FilePanel);
            app.SplitSpinnerLabel.HorizontalAlignment = 'right';
            app.SplitSpinnerLabel.Position = [154 62 29 22];
            app.SplitSpinnerLabel.Text = 'Split';

            % Create SplitSpinner
            app.SplitSpinner = uispinner(app.FilePanel);
            app.SplitSpinner.Step = 0.1;
            app.SplitSpinner.Limits = [0 Inf];
            app.SplitSpinner.ValueChangedFcn = createCallbackFcn(app, @SplitSpinnerValueChanged, true);
            app.SplitSpinner.Tooltip = {'Split a continuous recording trace into episodes of the following length (in seconds). Define the split interval before loading files.'};
            app.SplitSpinner.Position = [186 62 57 22];

            % Create sLabel
            app.sLabel = uilabel(app.FilePanel);
            app.sLabel.Position = [245 62 10 22];
            app.sLabel.Text = 's';

            % Create TabGroupEventer
            app.TabGroupEventer = uitabgroup(app.Eventer);
            app.TabGroupEventer.Tooltip = {''};
            app.TabGroupEventer.SelectionChangedFcn = createCallbackFcn(app, @TabGroupEventerSelectionChanged, true);
            app.TabGroupEventer.Position = [10 42 546 323];

            % Create PreviewTab
            app.PreviewTab = uitab(app.TabGroupEventer);
            app.PreviewTab.Title = 'Preview';

            % Create WavePreviewAxes
            app.WavePreviewAxes = uiaxes(app.PreviewTab);
            title(app.WavePreviewAxes, '')
            xlabel(app.WavePreviewAxes, 'Time (s)')
            ylabel(app.WavePreviewAxes, 'Current (A)')
            app.WavePreviewAxes.PlotBoxAspectRatio = [2 1 1];
            app.WavePreviewAxes.LineWidth = 0.25;
            app.WavePreviewAxes.Color = 'none';
            app.WavePreviewAxes.Position = [1 16 543 272];

            % Create TemplateTab
            app.TemplateTab = uitab(app.TabGroupEventer);
            app.TemplateTab.Title = 'Template';
            app.TemplateTab.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TemplateTab.ForegroundColor = [0.6392 0.0784 0.1804];

            % Create TemplatePreviewAxes
            app.TemplatePreviewAxes = uiaxes(app.TemplateTab);
            title(app.TemplatePreviewAxes, '')
            xlabel(app.TemplatePreviewAxes, 'Time (s)')
            ylabel(app.TemplatePreviewAxes, 'Normalised Amplitude')
            app.TemplatePreviewAxes.PlotBoxAspectRatio = [1.47111111111111 1 1];
            app.TemplatePreviewAxes.LineWidth = 0.25;
            app.TemplatePreviewAxes.Color = 'none';
            app.TemplatePreviewAxes.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TemplatePreviewAxes.Position = [14 13 380 269];

            % Create FitparametersPanel
            app.FitparametersPanel = uipanel(app.TemplateTab);
            app.FitparametersPanel.TitlePosition = 'centertop';
            app.FitparametersPanel.Title = 'Fit parameters';
            app.FitparametersPanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.FitparametersPanel.Position = [406 49 129 122];

            % Create TemplateSelectButton
            app.TemplateSelectButton = uibutton(app.FitparametersPanel, 'push');
            app.TemplateSelectButton.ButtonPushedFcn = createCallbackFcn(app, @TemplateSelectButtonPushed, true);
            app.TemplateSelectButton.BusyAction = 'cancel';
            app.TemplateSelectButton.Icon = 'cursor-23231_1280.png';
            app.TemplateSelectButton.Tooltip = {'Select lower and upper limits on the pop-up graph around an event of interest for fitting'};
            app.TemplateSelectButton.Position = [45 71 48 20];
            app.TemplateSelectButton.Text = '';

            % Create SelectLabel
            app.SelectLabel = uilabel(app.FitparametersPanel);
            app.SelectLabel.Position = [6 70 39 22];
            app.SelectLabel.Text = 'Select';

            % Create tau1EditFieldLabel
            app.tau1EditFieldLabel = uilabel(app.FitparametersPanel);
            app.tau1EditFieldLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.tau1EditFieldLabel.Position = [6 41 29 22];
            app.tau1EditFieldLabel.Text = 'Rise';

            % Create tau1EditField
            app.tau1EditField = uieditfield(app.FitparametersPanel, 'numeric');
            app.tau1EditField.ValueDisplayFormat = '%11.3g';
            app.tau1EditField.Editable = 'off';
            app.tau1EditField.FontColor = [0.502 0.502 0.502];
            app.tau1EditField.Tooltip = {'Fitted rise time constant'};
            app.tau1EditField.Position = [45 41 48 22];

            % Create tau2EditFieldLabel
            app.tau2EditFieldLabel = uilabel(app.FitparametersPanel);
            app.tau2EditFieldLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.tau2EditFieldLabel.Position = [6 11 39 22];
            app.tau2EditFieldLabel.Text = 'Decay';

            % Create tau2EditField
            app.tau2EditField = uieditfield(app.FitparametersPanel, 'numeric');
            app.tau2EditField.ValueDisplayFormat = '%11.3g';
            app.tau2EditField.Editable = 'off';
            app.tau2EditField.FontColor = [0.502 0.502 0.502];
            app.tau2EditField.Tooltip = {'Fitted decay time constant'};
            app.tau2EditField.Position = [45 11 48 22];

            % Create msLabel_4
            app.msLabel_4 = uilabel(app.FitparametersPanel);
            app.msLabel_4.Position = [98 40 25 22];
            app.msLabel_4.Text = 'ms';

            % Create msLabel_5
            app.msLabel_5 = uilabel(app.FitparametersPanel);
            app.msLabel_5.Position = [98 10 25 22];
            app.msLabel_5.Text = 'ms';

            % Create Button
            app.Button = uibutton(app.FitparametersPanel, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @CopyFitParametersButtonPushed, true);
            app.Button.Icon = 'copy.png';
            app.Button.Tooltip = {'Copy over fitted parameters to template time constant settings'};
            app.Button.Position = [99 71 22 20];
            app.Button.Text = '';

            % Create TimeconstantsPanel
            app.TimeconstantsPanel = uipanel(app.TemplateTab);
            app.TimeconstantsPanel.TitlePosition = 'centertop';
            app.TimeconstantsPanel.Title = 'Time constants';
            app.TimeconstantsPanel.Position = [406 179 128 112];

            % Create TimeConstantsEditField2
            app.TimeConstantsEditField2 = uieditfield(app.TimeconstantsPanel, 'numeric');
            app.TimeConstantsEditField2.ValueDisplayFormat = '%11.3g';
            app.TimeConstantsEditField2.ValueChangedFcn = createCallbackFcn(app, @TimeConstantsEditField2ValueChanged, true);
            app.TimeConstantsEditField2.Tooltip = {'Decay time constant of the template'};
            app.TimeConstantsEditField2.Position = [46 36 52 22];
            app.TimeConstantsEditField2.Value = 3;

            % Create TimeConstantsEditField1
            app.TimeConstantsEditField1 = uieditfield(app.TimeconstantsPanel, 'numeric');
            app.TimeConstantsEditField1.ValueDisplayFormat = '%11.3g';
            app.TimeConstantsEditField1.ValueChangedFcn = createCallbackFcn(app, @TimeConstantsEditField1ValueChanged, true);
            app.TimeConstantsEditField1.Tooltip = {'Rise time constant of the template'};
            app.TimeConstantsEditField1.Position = [46 64 52 22];
            app.TimeConstantsEditField1.Value = 0.45;

            % Create msLabel_2
            app.msLabel_2 = uilabel(app.TimeconstantsPanel);
            app.msLabel_2.Position = [102 64 25 22];
            app.msLabel_2.Text = 'ms';

            % Create RiseLabel
            app.RiseLabel = uilabel(app.TimeconstantsPanel);
            app.RiseLabel.HorizontalAlignment = 'center';
            app.RiseLabel.Position = [5 65 29 22];
            app.RiseLabel.Text = 'Rise';

            % Create DecayLabel
            app.DecayLabel = uilabel(app.TimeconstantsPanel);
            app.DecayLabel.HorizontalAlignment = 'center';
            app.DecayLabel.Position = [4 37 39 22];
            app.DecayLabel.Text = 'Decay';

            % Create ApplyToAllButtonTemplate
            app.ApplyToAllButtonTemplate = uibutton(app.TimeconstantsPanel, 'push');
            app.ApplyToAllButtonTemplate.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonTemplatePushed, true);
            app.ApplyToAllButtonTemplate.BusyAction = 'cancel';
            app.ApplyToAllButtonTemplate.Tooltip = {'Apply these template settings to all waves'};
            app.ApplyToAllButtonTemplate.Position = [6 8 113 22];
            app.ApplyToAllButtonTemplate.Text = 'Apply to all waves';

            % Create msLabel
            app.msLabel = uilabel(app.TemplateTab);
            app.msLabel.Position = [508 215 25 22];
            app.msLabel.Text = 'ms';

            % Create SignoftheEventsSwitch_2
            app.SignoftheEventsSwitch_2 = uiswitch(app.TemplateTab, 'slider');
            app.SignoftheEventsSwitch_2.Items = {'-', '+'};
            app.SignoftheEventsSwitch_2.ValueChangedFcn = createCallbackFcn(app, @SignoftheEventsSwitch_2ValueChanged, true);
            app.SignoftheEventsSwitch_2.Tooltip = {'Select the sign of the event deflections'};
            app.SignoftheEventsSwitch_2.FontSize = 15;
            app.SignoftheEventsSwitch_2.FontAngle = 'italic';
            app.SignoftheEventsSwitch_2.Position = [451 8 41 18];
            app.SignoftheEventsSwitch_2.Value = '-';

            % Create SignoftheEventsSwitchLabel_2
            app.SignoftheEventsSwitchLabel_2 = uilabel(app.TemplateTab);
            app.SignoftheEventsSwitchLabel_2.Position = [417 26 106 22];
            app.SignoftheEventsSwitchLabel_2.Text = 'Sign of the Events:';

            % Create ExcludeTab
            app.ExcludeTab = uitab(app.TabGroupEventer);
            app.ExcludeTab.Title = 'Exclude';
            app.ExcludeTab.ForegroundColor = [0.6392 0.0784 0.1804];

            % Create zone_three_x
            app.zone_three_x = uibutton(app.ExcludeTab, 'push');
            app.zone_three_x.ButtonPushedFcn = createCallbackFcn(app, @zone_three_xButtonPushed, true);
            app.zone_three_x.IconAlignment = 'center';
            app.zone_three_x.BackgroundColor = [1 1 1];
            app.zone_three_x.Tooltip = {'Reset exclusion zone 3'};
            app.zone_three_x.Position = [357 204 35 22];
            app.zone_three_x.Text = 'X';

            % Create zone_four_x
            app.zone_four_x = uibutton(app.ExcludeTab, 'push');
            app.zone_four_x.ButtonPushedFcn = createCallbackFcn(app, @zone_four_xButtonPushed, true);
            app.zone_four_x.IconAlignment = 'center';
            app.zone_four_x.BackgroundColor = [1 1 1];
            app.zone_four_x.Tooltip = {'Reset exclusion zone 4'};
            app.zone_four_x.Position = [357 183 35 22];
            app.zone_four_x.Text = 'X';

            % Create zone_five_x
            app.zone_five_x = uibutton(app.ExcludeTab, 'push');
            app.zone_five_x.ButtonPushedFcn = createCallbackFcn(app, @zone_five_xButtonPushed, true);
            app.zone_five_x.IconAlignment = 'center';
            app.zone_five_x.BackgroundColor = [1 1 1];
            app.zone_five_x.Tooltip = {'Reset exclusion zone 5'};
            app.zone_five_x.Position = [357 162 35 22];
            app.zone_five_x.Text = 'X';

            % Create zone_six_x
            app.zone_six_x = uibutton(app.ExcludeTab, 'push');
            app.zone_six_x.ButtonPushedFcn = createCallbackFcn(app, @zone_six_xButtonPushed, true);
            app.zone_six_x.IconAlignment = 'center';
            app.zone_six_x.BackgroundColor = [1 1 1];
            app.zone_six_x.Tooltip = {'Reset exclusion zone 6'};
            app.zone_six_x.Position = [357 141 35 22];
            app.zone_six_x.Text = 'X';

            % Create exselect_1
            app.exselect_1 = uibutton(app.ExcludeTab, 'push');
            app.exselect_1.ButtonPushedFcn = createCallbackFcn(app, @exselect_1_1ButtonPushed, true);
            app.exselect_1.BusyAction = 'cancel';
            app.exselect_1.Interruptible = 'off';
            app.exselect_1.Icon = 'cursor-23231_1280.png';
            app.exselect_1.Tooltip = {'Select lower and upper limits on the pop-up graph around a region for exclusion zone 1'};
            app.exselect_1.Position = [45 246 16 21];
            app.exselect_1.Text = '';

            % Create exselect_2
            app.exselect_2 = uibutton(app.ExcludeTab, 'push');
            app.exselect_2.ButtonPushedFcn = createCallbackFcn(app, @exselect_2ButtonPushed, true);
            app.exselect_2.BusyAction = 'cancel';
            app.exselect_2.Interruptible = 'off';
            app.exselect_2.Icon = 'cursor-23231_1280.png';
            app.exselect_2.Tooltip = {'Select lower and upper limits on the pop-up graph around a region for exclusion zone 2'};
            app.exselect_2.Position = [45 225 16 21];
            app.exselect_2.Text = '';

            % Create exselect_3
            app.exselect_3 = uibutton(app.ExcludeTab, 'push');
            app.exselect_3.ButtonPushedFcn = createCallbackFcn(app, @exselect_3ButtonPushed, true);
            app.exselect_3.BusyAction = 'cancel';
            app.exselect_3.Interruptible = 'off';
            app.exselect_3.Icon = 'cursor-23231_1280.png';
            app.exselect_3.Tooltip = {'Select lower and upper limits on the pop-up graph around a region for exclusion zone 3'};
            app.exselect_3.Position = [45 205 16 21];
            app.exselect_3.Text = '';

            % Create exselect_4
            app.exselect_4 = uibutton(app.ExcludeTab, 'push');
            app.exselect_4.ButtonPushedFcn = createCallbackFcn(app, @exselect_4ButtonPushed, true);
            app.exselect_4.BusyAction = 'cancel';
            app.exselect_4.Interruptible = 'off';
            app.exselect_4.Icon = 'cursor-23231_1280.png';
            app.exselect_4.Tooltip = {'Select lower and upper limits on the pop-up graph around a region for exclusion zone 4'};
            app.exselect_4.Position = [45 184 16 21];
            app.exselect_4.Text = '';

            % Create exselect_5
            app.exselect_5 = uibutton(app.ExcludeTab, 'push');
            app.exselect_5.ButtonPushedFcn = createCallbackFcn(app, @exselect_5ButtonPushed, true);
            app.exselect_5.BusyAction = 'cancel';
            app.exselect_5.Interruptible = 'off';
            app.exselect_5.Icon = 'cursor-23231_1280.png';
            app.exselect_5.Tooltip = {'Select lower and upper limits on the pop-up graph around a region for exclusion zone 5'};
            app.exselect_5.Position = [45 163 16 21];
            app.exselect_5.Text = '';

            % Create exselect_6
            app.exselect_6 = uibutton(app.ExcludeTab, 'push');
            app.exselect_6.ButtonPushedFcn = createCallbackFcn(app, @exselect_6ButtonPushed, true);
            app.exselect_6.BusyAction = 'cancel';
            app.exselect_6.Interruptible = 'off';
            app.exselect_6.Icon = 'cursor-23231_1280.png';
            app.exselect_6.Tooltip = {'Select lower and upper limits on the pop-up graph around a region for exclusion zone 6'};
            app.exselect_6.Position = [45 142 16 21];
            app.exselect_6.Text = '';

            % Create zone_eleven_x
            app.zone_eleven_x = uibutton(app.ExcludeTab, 'push');
            app.zone_eleven_x.ButtonPushedFcn = createCallbackFcn(app, @zone_eleven_xButtonPushed, true);
            app.zone_eleven_x.IconAlignment = 'center';
            app.zone_eleven_x.BackgroundColor = [1 1 1];
            app.zone_eleven_x.Tooltip = {'Reset extra exclusion zones'};
            app.zone_eleven_x.Position = [357 120 35 22];
            app.zone_eleven_x.Text = 'X';

            % Create ExtraExclusions
            app.ExtraExclusions = uitextarea(app.ExcludeTab);
            app.ExtraExclusions.ValueChangedFcn = createCallbackFcn(app, @ExtraExclusionsValueChanged, true);
            app.ExtraExclusions.Tooltip = {'Define exclusion zones using matlab matrix notation. The input must be a two column matrix.'};
            app.ExtraExclusions.Position = [60 19 298 123];

            % Create ApplyToAllButton_ex_1
            app.ApplyToAllButton_ex_1 = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_ex_1.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_ex1, true);
            app.ApplyToAllButton_ex_1.BusyAction = 'cancel';
            app.ApplyToAllButton_ex_1.Tooltip = {'Apply this exclusion zone 1 setting to all waves'};
            app.ApplyToAllButton_ex_1.Position = [402 246 113 22];
            app.ApplyToAllButton_ex_1.Text = 'Apply to all waves';

            % Create ApplyToAllButton_ex_2
            app.ApplyToAllButton_ex_2 = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_ex_2.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_ex_2, true);
            app.ApplyToAllButton_ex_2.BusyAction = 'cancel';
            app.ApplyToAllButton_ex_2.Tooltip = {'Apply this exclusion zone 2 setting to all waves'};
            app.ApplyToAllButton_ex_2.Position = [402 225 113 22];
            app.ApplyToAllButton_ex_2.Text = 'Apply to all waves';

            % Create zone_two_x
            app.zone_two_x = uibutton(app.ExcludeTab, 'push');
            app.zone_two_x.ButtonPushedFcn = createCallbackFcn(app, @zone_two_xButtonPushed, true);
            app.zone_two_x.IconAlignment = 'center';
            app.zone_two_x.BackgroundColor = [1 1 1];
            app.zone_two_x.Tooltip = {'Reset exclusion zone 2'};
            app.zone_two_x.Position = [357 225 35 22];
            app.zone_two_x.Text = 'X';

            % Create ApplyToAllButton_ex_3
            app.ApplyToAllButton_ex_3 = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_ex_3.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_ex_3, true);
            app.ApplyToAllButton_ex_3.BusyAction = 'cancel';
            app.ApplyToAllButton_ex_3.Tooltip = {'Apply this exclusion zone 3 setting to all waves'};
            app.ApplyToAllButton_ex_3.Position = [402 203 113 23];
            app.ApplyToAllButton_ex_3.Text = 'Apply to all waves';

            % Create ApplyToAllButton_ex_4
            app.ApplyToAllButton_ex_4 = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_ex_4.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_ex_4, true);
            app.ApplyToAllButton_ex_4.BusyAction = 'cancel';
            app.ApplyToAllButton_ex_4.Tooltip = {'Apply this exclusion zone 4 setting to all waves'};
            app.ApplyToAllButton_ex_4.Position = [402 183 113 22];
            app.ApplyToAllButton_ex_4.Text = 'Apply to all waves';

            % Create ApplyToAllButton_ex_5
            app.ApplyToAllButton_ex_5 = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_ex_5.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_ex_5, true);
            app.ApplyToAllButton_ex_5.BusyAction = 'cancel';
            app.ApplyToAllButton_ex_5.Tooltip = {'Apply this exclusion zone 5 setting to all waves'};
            app.ApplyToAllButton_ex_5.Position = [402 162 113 22];
            app.ApplyToAllButton_ex_5.Text = 'Apply to all waves';

            % Create ApplyToAllButton_ex_6
            app.ApplyToAllButton_ex_6 = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_ex_6.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_ex_6, true);
            app.ApplyToAllButton_ex_6.BusyAction = 'cancel';
            app.ApplyToAllButton_ex_6.Tooltip = {'Apply this exclusion zone 6 setting to all waves'};
            app.ApplyToAllButton_ex_6.Position = [402 141 113 22];
            app.ApplyToAllButton_ex_6.Text = 'Apply to all waves';

            % Create ApplyToAllButton_xexclusion
            app.ApplyToAllButton_xexclusion = uibutton(app.ExcludeTab, 'push');
            app.ApplyToAllButton_xexclusion.ButtonPushedFcn = createCallbackFcn(app, @ApplyToAllButtonPushed_xexclusion, true);
            app.ApplyToAllButton_xexclusion.BusyAction = 'cancel';
            app.ApplyToAllButton_xexclusion.Tooltip = {'Apply this exclusion zones setting to all waves'};
            app.ApplyToAllButton_xexclusion.Position = [402 120 113 22];
            app.ApplyToAllButton_xexclusion.Text = 'Apply to all waves';

            % Create zone_one_x
            app.zone_one_x = uibutton(app.ExcludeTab, 'push');
            app.zone_one_x.ButtonPushedFcn = createCallbackFcn(app, @zone_one_xButtonPushed, true);
            app.zone_one_x.IconAlignment = 'center';
            app.zone_one_x.BackgroundColor = [1 1 1];
            app.zone_one_x.Tooltip = {'Reset exclusion zone 1'};
            app.zone_one_x.Position = [357 246 35 22];
            app.zone_one_x.Text = 'X';

            % Create EditField_1
            app.EditField_1 = uieditfield(app.ExcludeTab, 'text');
            app.EditField_1.Editable = 'off';
            app.EditField_1.BackgroundColor = [0.9412 0.9412 0.9412];
            app.EditField_1.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_1.Position = [159 267 100 22];
            app.EditField_1.Value = 'Start Time';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.ExcludeTab, 'text');
            app.EditField_2.Editable = 'off';
            app.EditField_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.EditField_2.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_2.Position = [258 267 100 22];
            app.EditField_2.Value = 'Stop Time';

            % Create EditField_3
            app.EditField_3 = uieditfield(app.ExcludeTab, 'text');
            app.EditField_3.Editable = 'off';
            app.EditField_3.BackgroundColor = [0.9412 0.9412 0.9412];
            app.EditField_3.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_3.Position = [60 267 100 22];
            app.EditField_3.Value = 'Exclusion Zones';

            % Create EditField_4
            app.EditField_4 = uieditfield(app.ExcludeTab, 'numeric');
            app.EditField_4.Editable = 'off';
            app.EditField_4.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_4.Position = [60 225 100 22];
            app.EditField_4.Value = 2;

            % Create EditField_5
            app.EditField_5 = uieditfield(app.ExcludeTab, 'numeric');
            app.EditField_5.Editable = 'off';
            app.EditField_5.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_5.Position = [60 246 100 22];
            app.EditField_5.Value = 1;

            % Create EditField_6
            app.EditField_6 = uieditfield(app.ExcludeTab, 'numeric');
            app.EditField_6.Editable = 'off';
            app.EditField_6.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_6.Position = [60 183 100 22];
            app.EditField_6.Value = 4;

            % Create EditField_7
            app.EditField_7 = uieditfield(app.ExcludeTab, 'numeric');
            app.EditField_7.Editable = 'off';
            app.EditField_7.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_7.Position = [60 204 100 22];
            app.EditField_7.Value = 3;

            % Create EditField_8
            app.EditField_8 = uieditfield(app.ExcludeTab, 'numeric');
            app.EditField_8.Editable = 'off';
            app.EditField_8.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_8.Position = [60 141 100 22];
            app.EditField_8.Value = 6;

            % Create EditField_9
            app.EditField_9 = uieditfield(app.ExcludeTab, 'numeric');
            app.EditField_9.Editable = 'off';
            app.EditField_9.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.EditField_9.Position = [60 162 100 22];
            app.EditField_9.Value = 5;

            % Create cell_three
            app.cell_three = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_three.ValueChangedFcn = createCallbackFcn(app, @cell_threeValueChanged, true);
            app.cell_three.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_three.Position = [159 225 100 22];

            % Create cell_four
            app.cell_four = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_four.ValueChangedFcn = createCallbackFcn(app, @cell_fourValueChanged, true);
            app.cell_four.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_four.Position = [258 225 100 22];

            % Create cell_one
            app.cell_one = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_one.ValueChangedFcn = createCallbackFcn(app, @cell_oneValueChanged, true);
            app.cell_one.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_one.Position = [159 246 100 22];

            % Create cell_two
            app.cell_two = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_two.ValueChangedFcn = createCallbackFcn(app, @cell_twoValueChanged, true);
            app.cell_two.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_two.Position = [258 246 100 22];

            % Create cell_seven
            app.cell_seven = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_seven.ValueChangedFcn = createCallbackFcn(app, @cell_sevenValueChanged, true);
            app.cell_seven.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_seven.Position = [159 183 100 22];

            % Create cell_eight
            app.cell_eight = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_eight.ValueChangedFcn = createCallbackFcn(app, @cell_eightValueChanged, true);
            app.cell_eight.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_eight.Position = [258 183 100 22];

            % Create cell_five
            app.cell_five = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_five.ValueChangedFcn = createCallbackFcn(app, @cell_fiveValueChanged, true);
            app.cell_five.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_five.Position = [159 204 100 22];

            % Create cell_six
            app.cell_six = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_six.ValueChangedFcn = createCallbackFcn(app, @cell_sixValueChanged, true);
            app.cell_six.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_six.Position = [258 204 100 22];

            % Create cell_eleven
            app.cell_eleven = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_eleven.ValueChangedFcn = createCallbackFcn(app, @cell_elevenValueChanged, true);
            app.cell_eleven.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_eleven.Position = [159 141 100 22];

            % Create cell_twelve
            app.cell_twelve = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_twelve.ValueChangedFcn = createCallbackFcn(app, @cell_twelveValueChanged, true);
            app.cell_twelve.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_twelve.Position = [258 141 100 22];

            % Create cell_nine
            app.cell_nine = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_nine.ValueChangedFcn = createCallbackFcn(app, @cell_nineValueChanged, true);
            app.cell_nine.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_nine.Position = [159 162 100 22];

            % Create cell_ten
            app.cell_ten = uieditfield(app.ExcludeTab, 'numeric');
            app.cell_ten.ValueChangedFcn = createCallbackFcn(app, @cell_tenValueChanged, true);
            app.cell_ten.Tooltip = {'Set exclusion zones to be used by eventer.'};
            app.cell_ten.Position = [258 162 100 22];

            % Create DetectionTab
            app.DetectionTab = uitab(app.TabGroupEventer);
            app.DetectionTab.Title = 'Detection';
            app.DetectionTab.ForegroundColor = [0 0 1];

            % Create stdevLabel
            app.stdevLabel = uilabel(app.DetectionTab);
            app.stdevLabel.Position = [240 196 35 22];
            app.stdevLabel.Text = 'stdev';

            % Create ThresholdSpinnerLabel
            app.ThresholdSpinnerLabel = uilabel(app.DetectionTab);
            app.ThresholdSpinnerLabel.Position = [27 195 106 22];
            app.ThresholdSpinnerLabel.Text = 'Threshold (relative)';

            % Create ThresholdSpinner
            app.ThresholdSpinner = uispinner(app.DetectionTab);
            app.ThresholdSpinner.Step = 0.1;
            app.ThresholdSpinner.ValueChangedFcn = createCallbackFcn(app, @ThresholdSpinnerValueChanged, true);
            app.ThresholdSpinner.Tooltip = {'Tells eventer to set the threshold for event detection at this number times the standard deviation of the noise of the deconvoluted wave.'};
            app.ThresholdSpinner.Position = [167 196 69 22];
            app.ThresholdSpinner.Value = 4;

            % Create FilterWavesPanel
            app.FilterWavesPanel = uipanel(app.DetectionTab);
            app.FilterWavesPanel.Title = 'Filter Waves';
            app.FilterWavesPanel.Position = [28 21 490 127];

            % Create HzLabel
            app.HzLabel = uilabel(app.FilterWavesPanel);
            app.HzLabel.Position = [275 7 25 22];
            app.HzLabel.Text = 'Hz';

            % Create HzLabel_2
            app.HzLabel_2 = uilabel(app.FilterWavesPanel);
            app.HzLabel_2.Position = [275 41 25 22];
            app.HzLabel_2.Text = 'Hz';

            % Create HighpassFilterCutOffSpinnerLabel
            app.HighpassFilterCutOffSpinnerLabel = uilabel(app.FilterWavesPanel);
            app.HighpassFilterCutOffSpinnerLabel.HorizontalAlignment = 'right';
            app.HighpassFilterCutOffSpinnerLabel.Position = [17 41 128 22];
            app.HighpassFilterCutOffSpinnerLabel.Text = 'High-pass filter cut-off:';

            % Create HighpassPreFilterCutOffSpinner
            app.HighpassPreFilterCutOffSpinner = uispinner(app.FilterWavesPanel);
            app.HighpassPreFilterCutOffSpinner.Limits = [0 1.79769313486232e+308];
            app.HighpassPreFilterCutOffSpinner.ValueChangedFcn = createCallbackFcn(app, @PreFilterCutOffSpinnerValueChanged, true);
            app.HighpassPreFilterCutOffSpinner.BusyAction = 'cancel';
            app.HighpassPreFilterCutOffSpinner.Enable = 'off';
            app.HighpassPreFilterCutOffSpinner.Tooltip = {'Sets the cut-off of the high-pass filter'};
            app.HighpassPreFilterCutOffSpinner.Position = [155 41 115 22];

            % Create LowpassFilterCutOffSpinnerLabel
            app.LowpassFilterCutOffSpinnerLabel = uilabel(app.FilterWavesPanel);
            app.LowpassFilterCutOffSpinnerLabel.HorizontalAlignment = 'right';
            app.LowpassFilterCutOffSpinnerLabel.Position = [18 7 125 22];
            app.LowpassFilterCutOffSpinnerLabel.Text = 'Low-pass filter cut-off:';

            % Create LowpassPreFilterCutOffSpinner
            app.LowpassPreFilterCutOffSpinner = uispinner(app.FilterWavesPanel);
            app.LowpassPreFilterCutOffSpinner.Limits = [2.22044604925031e-16 Inf];
            app.LowpassPreFilterCutOffSpinner.ValueChangedFcn = createCallbackFcn(app, @PreFilterCutOffSpinnerValueChanged, true);
            app.LowpassPreFilterCutOffSpinner.BusyAction = 'cancel';
            app.LowpassPreFilterCutOffSpinner.Enable = 'off';
            app.LowpassPreFilterCutOffSpinner.Tooltip = {'Sets the cut-off of the low-pass Gaussian filter'};
            app.LowpassPreFilterCutOffSpinner.Position = [155 7 115 22];
            app.LowpassPreFilterCutOffSpinner.Value = Inf;

            % Create OnOffCheckBoxHPF
            app.OnOffCheckBoxHPF = uicheckbox(app.FilterWavesPanel);
            app.OnOffCheckBoxHPF.ValueChangedFcn = createCallbackFcn(app, @OnOffCheckBoxHPFValueChanged, true);
            app.OnOffCheckBoxHPF.BusyAction = 'cancel';
            app.OnOffCheckBoxHPF.Tooltip = {'Turns on/off the high-pass filter'};
            app.OnOffCheckBoxHPF.Text = 'On/Off';
            app.OnOffCheckBoxHPF.Position = [326 41 58 22];

            % Create OnOffCheckBoxLPF
            app.OnOffCheckBoxLPF = uicheckbox(app.FilterWavesPanel);
            app.OnOffCheckBoxLPF.ValueChangedFcn = createCallbackFcn(app, @OnOffCheckBoxLPFValueChanged, true);
            app.OnOffCheckBoxLPF.BusyAction = 'cancel';
            app.OnOffCheckBoxLPF.Tooltip = {'Turns on/off the low-pass Gaussian filter'};
            app.OnOffCheckBoxLPF.Text = 'On/Off';
            app.OnOffCheckBoxLPF.Position = [326 7 58 22];

            % Create HighpassfiltermethodDropDownLabel
            app.HighpassfiltermethodDropDownLabel = uilabel(app.FilterWavesPanel);
            app.HighpassfiltermethodDropDownLabel.HorizontalAlignment = 'right';
            app.HighpassfiltermethodDropDownLabel.Position = [9 76 135 22];
            app.HighpassfiltermethodDropDownLabel.Text = 'High-pass filter method:';

            % Create HighpassPreFiltermethodDropDown
            app.HighpassPreFiltermethodDropDown = uidropdown(app.FilterWavesPanel);
            app.HighpassPreFiltermethodDropDown.Items = {'Median', 'Binomial'};
            app.HighpassPreFiltermethodDropDown.ItemsData = {'median', 'binomial'};
            app.HighpassPreFiltermethodDropDown.ValueChangedFcn = createCallbackFcn(app, @PreFilterCutOffSpinnerValueChanged, true);
            app.HighpassPreFiltermethodDropDown.BusyAction = 'cancel';
            app.HighpassPreFiltermethodDropDown.Tooltip = {'Select which high pass filter to use.'};
            app.HighpassPreFiltermethodDropDown.Position = [155 76 115 22];
            app.HighpassPreFiltermethodDropDown.Value = 'binomial';

            % Create SignoftheEventsSwitchLabel
            app.SignoftheEventsSwitchLabel = uilabel(app.DetectionTab);
            app.SignoftheEventsSwitchLabel.Position = [28 228 106 22];
            app.SignoftheEventsSwitchLabel.Text = 'Sign of the Events:';

            % Create SignoftheEventsSwitch
            app.SignoftheEventsSwitch = uiswitch(app.DetectionTab, 'slider');
            app.SignoftheEventsSwitch.Items = {'-', '+'};
            app.SignoftheEventsSwitch.ValueChangedFcn = createCallbackFcn(app, @SignoftheEventsSwitchValueChanged, true);
            app.SignoftheEventsSwitch.Tooltip = {'Select the sign of the event deflections'};
            app.SignoftheEventsSwitch.FontSize = 15;
            app.SignoftheEventsSwitch.FontAngle = 'italic';
            app.SignoftheEventsSwitch.Position = [180 232 41 18];
            app.SignoftheEventsSwitch.Value = '-';

            % Create CriterionDropDown
            app.CriterionDropDown = uidropdown(app.DetectionTab);
            app.CriterionDropDown.Items = {'Pearson', 'Machine learning'};
            app.CriterionDropDown.ValueChangedFcn = createCallbackFcn(app, @CriterionDropDownValueChanged, true);
            app.CriterionDropDown.Position = [384 262 134 22];
            app.CriterionDropDown.Value = 'Pearson';

            % Create CorrelationCoefficientLabel
            app.CorrelationCoefficientLabel = uilabel(app.DetectionTab);
            app.CorrelationCoefficientLabel.Position = [297 228 134 22];
            app.CorrelationCoefficientLabel.Text = 'Correlation Coefficient';

            % Create CorrelationCoefficientSpinner
            app.CorrelationCoefficientSpinner = uispinner(app.DetectionTab);
            app.CorrelationCoefficientSpinner.Step = 0.01;
            app.CorrelationCoefficientSpinner.Limits = [-1 1];
            app.CorrelationCoefficientSpinner.ValueChangedFcn = createCallbackFcn(app, @CorrelationCoefficientValueChanged, true);
            app.CorrelationCoefficientSpinner.Position = [440 228 78 22];
            app.CorrelationCoefficientSpinner.Value = 0.4;

            % Create EventCriterionLabel
            app.EventCriterionLabel = uilabel(app.DetectionTab);
            app.EventCriterionLabel.Position = [297 262 85 22];
            app.EventCriterionLabel.Text = 'Event Criterion';

            % Create ConfigurationDropDownLabel
            app.ConfigurationDropDownLabel = uilabel(app.DetectionTab);
            app.ConfigurationDropDownLabel.Position = [28 262 83 22];
            app.ConfigurationDropDownLabel.Text = 'Configuration:';

            % Create ConfigurationDropDown
            app.ConfigurationDropDown = uidropdown(app.DetectionTab);
            app.ConfigurationDropDown.Items = {'Voltage Clamp', 'Current Clamp', 'Generic', 'Fluor. (a.u.) ', 'Fluor. (dF/F0) ', 'Fluor. (Z-score)', ''};
            app.ConfigurationDropDown.ItemsData = {'VC', 'CC', 'dummy'};
            app.ConfigurationDropDown.ValueChangedFcn = createCallbackFcn(app, @ConfigurationDropDownValueChanged, true);
            app.ConfigurationDropDown.Tooltip = {'Select the damping factor used in the Levenberg-Marquardt ordinary non-linear least-squares fitting procedures.'};
            app.ConfigurationDropDown.BackgroundColor = [1 1 1];
            app.ConfigurationDropDown.Position = [121 262 115 22];
            app.ConfigurationDropDown.Value = 'VC';

            % Create LoadmodelButton
            app.LoadmodelButton = uibutton(app.DetectionTab, 'push');
            app.LoadmodelButton.ButtonPushedFcn = createCallbackFcn(app, @LoadmodelButtonPushed, true);
            app.LoadmodelButton.Position = [417 194 101 22];
            app.LoadmodelButton.Text = 'Load model';

            % Create TrainingmodeCheckBox
            app.TrainingmodeCheckBox = uicheckbox(app.DetectionTab);
            app.TrainingmodeCheckBox.ValueChangedFcn = createCallbackFcn(app, @TrainingmodeCheckBoxValueChanged, true);
            app.TrainingmodeCheckBox.Text = ' Training mode';
            app.TrainingmodeCheckBox.Position = [297 194 103 22];

            % Create ModelfileEditFieldLabel
            app.ModelfileEditFieldLabel = uilabel(app.DetectionTab);
            app.ModelfileEditFieldLabel.HorizontalAlignment = 'right';
            app.ModelfileEditFieldLabel.Position = [290 160 58 22];
            app.ModelfileEditFieldLabel.Text = 'Model file';

            % Create ModelfileEditField
            app.ModelfileEditField = uieditfield(app.DetectionTab, 'text');
            app.ModelfileEditField.ValueChangedFcn = createCallbackFcn(app, @ModelfileEditFieldValueChanged, true);
            app.ModelfileEditField.Position = [361 160 157 22];

            % Create ThresholdabsoluteEditFieldLabel
            app.ThresholdabsoluteEditFieldLabel = uilabel(app.DetectionTab);
            app.ThresholdabsoluteEditFieldLabel.Position = [27 163 129 22];
            app.ThresholdabsoluteEditFieldLabel.Text = 'Threshold (absolute)';

            % Create ThresholdAbsoluteEditField
            app.ThresholdAbsoluteEditField = uieditfield(app.DetectionTab, 'numeric');
            app.ThresholdAbsoluteEditField.Limits = [0 Inf];
            app.ThresholdAbsoluteEditField.ValueChangedFcn = createCallbackFcn(app, @ThresholdAbsoluteEditFieldValueChanged, true);
            app.ThresholdAbsoluteEditField.Tooltip = {'Absolute threshold in the original units of the deconvoluted wave. When this value is > 0 it overides the relative threshold setting.'};
            app.ThresholdAbsoluteEditField.Position = [167 165 66 21];

            % Create AdvancedTab
            app.AdvancedTab = uitab(app.TabGroupEventer);
            app.AdvancedTab.Title = 'Advanced';
            app.AdvancedTab.ForegroundColor = [0 0 1];

            % Create NoofTausSpinnerLabel
            app.NoofTausSpinnerLabel = uilabel(app.AdvancedTab);
            app.NoofTausSpinnerLabel.HorizontalAlignment = 'right';
            app.NoofTausSpinnerLabel.Position = [12 246 66 22];
            app.NoofTausSpinnerLabel.Text = 'No. of Taus';

            % Create NoofTausSpinner
            app.NoofTausSpinner = uispinner(app.AdvancedTab);
            app.NoofTausSpinner.Step = 0.1;
            app.NoofTausSpinner.ValueChangedFcn = createCallbackFcn(app, @NoofTausSpinnerValueChanged, true);
            app.NoofTausSpinner.Tooltip = {'Sets the number of decay time constants after the peak of the template to use when fitting the template to the detected events.'};
            app.NoofTausSpinner.Position = [108 246 98 22];
            app.NoofTausSpinner.Value = 2;

            % Create BaselineTimeSpinnerLabel
            app.BaselineTimeSpinnerLabel = uilabel(app.AdvancedTab);
            app.BaselineTimeSpinnerLabel.HorizontalAlignment = 'right';
            app.BaselineTimeSpinnerLabel.Position = [12 196 81 22];
            app.BaselineTimeSpinnerLabel.Text = 'Baseline Time';

            % Create BaselineTimeSpinner
            app.BaselineTimeSpinner = uispinner(app.AdvancedTab);
            app.BaselineTimeSpinner.Step = 0.1;
            app.BaselineTimeSpinner.ValueChangedFcn = createCallbackFcn(app, @BaselineTimeSpinnerValueChanged, true);
            app.BaselineTimeSpinner.Tooltip = {'Sets the length of time to use as the pre-event baseline for the template fit in seconds'};
            app.BaselineTimeSpinner.Position = [108 196 100 22];
            app.BaselineTimeSpinner.Value = 1;

            % Create msLabel_3
            app.msLabel_3 = uilabel(app.AdvancedTab);
            app.msLabel_3.Position = [212 196 25 22];
            app.msLabel_3.Text = 'ms';

            % Create ExmodeDropDownLabel
            app.ExmodeDropDownLabel = uilabel(app.AdvancedTab);
            app.ExmodeDropDownLabel.HorizontalAlignment = 'right';
            app.ExmodeDropDownLabel.Position = [12 146 50 22];
            app.ExmodeDropDownLabel.Text = 'Exmode';

            % Create ExmodeDropDown
            app.ExmodeDropDown = uidropdown(app.AdvancedTab);
            app.ExmodeDropDown.Items = {'Mode 1', 'Mode 2'};
            app.ExmodeDropDown.ItemsData = {'1', '2'};
            app.ExmodeDropDown.ValueChangedFcn = createCallbackFcn(app, @ExmodeDropDownValueChanged, true);
            app.ExmodeDropDown.Tooltip = {'Tells eventer what to do with the first event proceeding each exclusion zone. For mode = 1 IEIs are calculated for these events from the last event preceeding the exclusion zone under the assumption that no events occurred during the exclusion zone. For mode = 2 these events are assigned an IEI of NaN. Note that events with NaN values are excluded during the merge (i.e. that are in the ALL_events output directory'};
            app.ExmodeDropDown.Position = [108 146 100 22];
            app.ExmodeDropDown.Value = '1';

            % Create LevenbergMarquardtSettingsPanel
            app.LevenbergMarquardtSettingsPanel = uipanel(app.AdvancedTab);
            app.LevenbergMarquardtSettingsPanel.TitlePosition = 'centertop';
            app.LevenbergMarquardtSettingsPanel.Title = 'Levenberg-Marquardt Settings';
            app.LevenbergMarquardtSettingsPanel.Position = [0 5 547 115];

            % Create LambdaSliderLabel
            app.LambdaSliderLabel = uilabel(app.LevenbergMarquardtSettingsPanel);
            app.LambdaSliderLabel.HorizontalAlignment = 'right';
            app.LambdaSliderLabel.Position = [120 47 50 22];
            app.LambdaSliderLabel.Text = 'Lambda';

            % Create LambdaSlider
            app.LambdaSlider = uislider(app.LevenbergMarquardtSettingsPanel);
            app.LambdaSlider.Limits = [-2 3];
            app.LambdaSlider.MajorTicks = [-2 -1 0 1 2 3];
            app.LambdaSlider.MajorTickLabels = {'0.01', '0.1', '1.0', '10', '100', '1000'};
            app.LambdaSlider.ValueChangedFcn = createCallbackFcn(app, @LambdaSliderValueChanged, true);
            app.LambdaSlider.MinorTicks = [];
            app.LambdaSlider.Tooltip = {'Select the damping factor used in the Levenberg-Marquardt ordinary non-linear least-squares fitting procedures.'};
            app.LambdaSlider.Position = [191 57 150 3];

            % Create LambdaDisp
            app.LambdaDisp = uieditfield(app.LevenbergMarquardtSettingsPanel, 'numeric');
            app.LambdaDisp.ValueChangedFcn = createCallbackFcn(app, @LambdaDispValueChanged, true);
            app.LambdaDisp.Position = [361 47 47 22];
            app.LambdaDisp.Value = 1;

            % Create DeconvolutedWaveSignalProcessingPanel_2
            app.DeconvolutedWaveSignalProcessingPanel_2 = uipanel(app.AdvancedTab);
            app.DeconvolutedWaveSignalProcessingPanel_2.TitlePosition = 'centertop';
            app.DeconvolutedWaveSignalProcessingPanel_2.Title = 'Deconvoluted Wave Signal-Processing';
            app.DeconvolutedWaveSignalProcessingPanel_2.Position = [249 119 298 179];

            % Create HighpassFilterCutOffSpinner_2Label
            app.HighpassFilterCutOffSpinner_2Label = uilabel(app.DeconvolutedWaveSignalProcessingPanel_2);
            app.HighpassFilterCutOffSpinner_2Label.HorizontalAlignment = 'right';
            app.HighpassFilterCutOffSpinner_2Label.Position = [73 118 137 22];
            app.HighpassFilterCutOffSpinner_2Label.Text = 'High-pass Filter Cut-Off:';

            % Create HzLabel_4
            app.HzLabel_4 = uilabel(app.DeconvolutedWaveSignalProcessingPanel_2);
            app.HzLabel_4.Position = [203 92 25 22];
            app.HzLabel_4.Text = 'Hz';

            % Create HighpassFilterCutOffSpinner
            app.HighpassFilterCutOffSpinner = uispinner(app.DeconvolutedWaveSignalProcessingPanel_2);
            app.HighpassFilterCutOffSpinner.Limits = [0 1.79769313486232e+308];
            app.HighpassFilterCutOffSpinner.ValueChangedFcn = createCallbackFcn(app, @HighpassFilterCutOffSpinnerValueChanged, true);
            app.HighpassFilterCutOffSpinner.Tooltip = {'High-pass median filter. The cut-off is estimated according to the cutoff of a boxcar filter with the same smoothing window size.'};
            app.HighpassFilterCutOffSpinner.Position = [86 92 108 22];
            app.HighpassFilterCutOffSpinner.Value = 1;

            % Create HzLabel_3
            app.HzLabel_3 = uilabel(app.DeconvolutedWaveSignalProcessingPanel_2);
            app.HzLabel_3.Position = [203 26 25 22];
            app.HzLabel_3.Text = 'Hz';

            % Create LowpassFilterCutOffSpinner
            app.LowpassFilterCutOffSpinner = uispinner(app.DeconvolutedWaveSignalProcessingPanel_2);
            app.LowpassFilterCutOffSpinner.Limits = [2.22044604925031e-16 Inf];
            app.LowpassFilterCutOffSpinner.ValueChangedFcn = createCallbackFcn(app, @LowpassFilterCutOffSpinnerValueChanged, true);
            app.LowpassFilterCutOffSpinner.Tooltip = {'Low pass Gaussian filter'};
            app.LowpassFilterCutOffSpinner.Position = [86 26 108 22];
            app.LowpassFilterCutOffSpinner.Value = 200;

            % Create LowpassFilterCutOffSpinnerLabel_2
            app.LowpassFilterCutOffSpinnerLabel_2 = uilabel(app.DeconvolutedWaveSignalProcessingPanel_2);
            app.LowpassFilterCutOffSpinnerLabel_2.HorizontalAlignment = 'right';
            app.LowpassFilterCutOffSpinnerLabel_2.Position = [73 52 135 22];
            app.LowpassFilterCutOffSpinnerLabel_2.Text = 'Low-pass Filter Cut-Off:';

            % Create OutputTab
            app.OutputTab = uitab(app.TabGroupEventer);
            app.OutputTab.Title = 'Output';
            app.OutputTab.ForegroundColor = [0 0 1];

            % Create EnsembleAverageButtonGroup
            app.EnsembleAverageButtonGroup = uibuttongroup(app.OutputTab);
            app.EnsembleAverageButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @EnsembleAverageButtonGroupSelectionChanged, true);
            app.EnsembleAverageButtonGroup.Tooltip = {'Select whether you want the ensemble average waveform to be calculated using the arithmetic mean or the median'};
            app.EnsembleAverageButtonGroup.TitlePosition = 'centertop';
            app.EnsembleAverageButtonGroup.Title = 'Ensemble Average';
            app.EnsembleAverageButtonGroup.Position = [49 183 181 87];

            % Create MedianButton
            app.MedianButton = uiradiobutton(app.EnsembleAverageButtonGroup);
            app.MedianButton.Text = 'Median';
            app.MedianButton.Position = [11 37 62 22];
            app.MedianButton.Value = true;

            % Create MeanButton
            app.MeanButton = uiradiobutton(app.EnsembleAverageButtonGroup);
            app.MeanButton.Text = 'Mean';
            app.MeanButton.Position = [11 10 52 22];

            % Create WaveFormatDropDownLabel
            app.WaveFormatDropDownLabel = uilabel(app.OutputTab);
            app.WaveFormatDropDownLabel.HorizontalAlignment = 'right';
            app.WaveFormatDropDownLabel.Position = [49 134 80 22];
            app.WaveFormatDropDownLabel.Text = 'Wave Format:';

            % Create WaveFormatDropDown
            app.WaveFormatDropDown = uidropdown(app.OutputTab);
            app.WaveFormatDropDown.Items = {'ephysIO HDF5 binary (.phy)', 'HDF5 (Stimfit) binary (.h5)', 'Axon Text File (.atf)', 'Igor Text File (.itx)', 'ASCII CSV File (.csv)', 'ASCII TSV File (.txt)', 'ASCII TSV File (.asc)'};
            app.WaveFormatDropDown.ItemsData = {'phy', 'h5', 'atf', 'itx', 'csv', 'txt', 'asc'};
            app.WaveFormatDropDown.ValueChangedFcn = createCallbackFcn(app, @WaveFormatDropDownValueChanged, true);
            app.WaveFormatDropDown.Tooltip = {'Tells eventer to export the episodic wave data of all detected events in the specified format. Choose ephysIO HDF5 binary for optimal performance and storage efficiency or other formats for portability'};
            app.WaveFormatDropDown.Position = [134 134 208 22];
            app.WaveFormatDropDown.Value = 'phy';

            % Create FigureFormatDropDownLabel
            app.FigureFormatDropDownLabel = uilabel(app.OutputTab);
            app.FigureFormatDropDownLabel.HorizontalAlignment = 'right';
            app.FigureFormatDropDownLabel.Position = [241 194 80 22];
            app.FigureFormatDropDownLabel.Text = 'Figure Format';

            % Create FigureFormatDropDown
            app.FigureFormatDropDown = uidropdown(app.OutputTab);
            app.FigureFormatDropDown.Items = {'None', 'Matlab (fig)', 'tiff (compressed)', 'tiff (not compressed)', 'png', 'bmp', 'svg', 'eps', 'emf'};
            app.FigureFormatDropDown.ItemsData = {'none', 'fig', 'tiff', 'tiffn', 'png', 'bmp', 'svg', 'eps', 'emf'};
            app.FigureFormatDropDown.ValueChangedFcn = createCallbackFcn(app, @FigureFormatDropDownValueChanged, true);
            app.FigureFormatDropDown.Tooltip = {'Tells eventer what format to use when saving figures. Bitmap images are saved at 300 dpi resolution. Note that viewing *.fig files requires MATLAB. Set to ''none'' for speed if figures are not required.'};
            app.FigureFormatDropDown.Position = [336 193 160 22];
            app.FigureFormatDropDown.Value = 'fig';

            % Create dpiLabel
            app.dpiLabel = uilabel(app.OutputTab);
            app.dpiLabel.FontColor = [0.651 0.651 0.651];
            app.dpiLabel.Visible = 'off';
            app.dpiLabel.Position = [360 172 52 22];
            app.dpiLabel.Text = '(300 dpi)';

            % Create wavesstackedLabel
            app.wavesstackedLabel = uilabel(app.OutputTab);
            app.wavesstackedLabel.FontColor = [0.651 0.651 0.651];
            app.wavesstackedLabel.Visible = 'off';
            app.wavesstackedLabel.Position = [135 109 91 22];
            app.wavesstackedLabel.Text = '(waves stacked)';

            % Create GNUZipCompressionCheckBox
            app.GNUZipCompressionCheckBox = uicheckbox(app.OutputTab);
            app.GNUZipCompressionCheckBox.ValueChangedFcn = createCallbackFcn(app, @GNUZipCompressionCheckBoxValueChanged, true);
            app.GNUZipCompressionCheckBox.Tooltip = {'Note that in most circumstances compression offers little benefit to the HDF5 (MATLAB) binary files saved by ephysIO.'};
            app.GNUZipCompressionCheckBox.Text = 'GNU Zip Compression';
            app.GNUZipCompressionCheckBox.Position = [357 134 144 22];

            % Create MaxWindowSpinner
            app.MaxWindowSpinner = uispinner(app.OutputTab);
            app.MaxWindowSpinner.Step = 0.01;
            app.MaxWindowSpinner.Limits = [0 1.79769313486232e+308];
            app.MaxWindowSpinner.ValueChangedFcn = createCallbackFcn(app, @MaxWindowSpinnerValueChanged, true);
            app.MaxWindowSpinner.Tooltip = {'Events are aligned and exported. Set the post event time in seconds'};
            app.MaxWindowSpinner.Position = [420 238 65 22];
            app.MaxWindowSpinner.Value = 0.04;

            % Create EventwindowLabel
            app.EventwindowLabel = uilabel(app.OutputTab);
            app.EventwindowLabel.Position = [245 238 83 22];
            app.EventwindowLabel.Text = 'Event window ';

            % Create MinWindowSpinner
            app.MinWindowSpinner = uispinner(app.OutputTab);
            app.MinWindowSpinner.Step = 0.01;
            app.MinWindowSpinner.Limits = [-1.79769313486232e+308 0];
            app.MinWindowSpinner.ValueChangedFcn = createCallbackFcn(app, @MinWindowSpinnerValueChanged, true);
            app.MinWindowSpinner.Tooltip = {'Events are aligned and exported. Set the pre event time in seconds'};
            app.MinWindowSpinner.Position = [336 238 65 22];
            app.MinWindowSpinner.Value = -0.01;

            % Create sLabel_2
            app.sLabel_2 = uilabel(app.OutputTab);
            app.sLabel_2.Position = [403 237 25 22];
            app.sLabel_2.Text = 's';

            % Create sLabel_3
            app.sLabel_3 = uilabel(app.OutputTab);
            app.sLabel_3.Position = [487 238 25 22];
            app.sLabel_3.Text = 's';

            % Create RootdirectoryEditFieldLabel
            app.RootdirectoryEditFieldLabel = uilabel(app.OutputTab);
            app.RootdirectoryEditFieldLabel.Tooltip = {'Path to the root directory for the analysis. This is determined by the location of the first file loaded. It cannot be changed by the user.'};
            app.RootdirectoryEditFieldLabel.Position = [55 88 82 22];
            app.RootdirectoryEditFieldLabel.Text = 'Root directory';

            % Create RootdirectoryEditField
            app.RootdirectoryEditField = uieditfield(app.OutputTab, 'text');
            app.RootdirectoryEditField.ValueChangedFcn = createCallbackFcn(app, @RootdirectoryEditFieldValueChanged, true);
            app.RootdirectoryEditField.Editable = 'off';
            app.RootdirectoryEditField.Enable = 'off';
            app.RootdirectoryEditField.Tooltip = {'Path to root'};
            app.RootdirectoryEditField.Position = [55 63 441 22];

            % Create SetOutputFolderButton
            app.SetOutputFolderButton = uibutton(app.OutputTab, 'push');
            app.SetOutputFolderButton.ButtonPushedFcn = createCallbackFcn(app, @SetOutputFolderButtonPushed, true);
            app.SetOutputFolderButton.Tooltip = {'Enter the folder name to store Eventer output'};
            app.SetOutputFolderButton.Position = [54 24 106 22];
            app.SetOutputFolderButton.Text = 'Set output folder';

            % Create outdirLabel
            app.outdirLabel = uilabel(app.OutputTab);
            app.outdirLabel.Position = [169 24 327 22];
            app.outdirLabel.Text = '';

            % Create SummaryTab
            app.SummaryTab = uitab(app.TabGroupEventer);
            app.SummaryTab.Title = 'Summary';

            % Create TabGroupSummary
            app.TabGroupSummary = uitabgroup(app.SummaryTab);
            app.TabGroupSummary.SelectionChangedFcn = createCallbackFcn(app, @TabGroupSummarySelectionChanged, true);
            app.TabGroupSummary.Position = [0 5 547 293];

            % Create AllTab
            app.AllTab = uitab(app.TabGroupSummary);
            app.AllTab.Title = 'All';

            % Create SummaryAll
            app.SummaryAll = uitextarea(app.AllTab);
            app.SummaryAll.BackgroundColor = [0.9412 0.9412 0.9412];
            app.SummaryAll.Position = [22 2 502 264];

            % Create CurrentTab
            app.CurrentTab = uitab(app.TabGroupSummary);
            app.CurrentTab.Title = 'Current ';
            app.CurrentTab.Scrollable = 'on';

            % Create SummaryCurrent
            app.SummaryCurrent = uitextarea(app.CurrentTab);
            app.SummaryCurrent.BackgroundColor = [0.9412 0.9412 0.9412];
            app.SummaryCurrent.Position = [22 2 502 264];

            % Create ParallelPanel
            app.ParallelPanel = uipanel(app.Eventer);
            app.ParallelPanel.Position = [10 10 469 33];

            % Create ParallelCheckBox
            app.ParallelCheckBox = uicheckbox(app.ParallelPanel);
            app.ParallelCheckBox.ValueChangedFcn = createCallbackFcn(app, @ParallelCheckBoxValueChanged, true);
            app.ParallelCheckBox.BusyAction = 'cancel';
            app.ParallelCheckBox.Tooltip = {'Turn on/off parallel process to speed up batch analysis'};
            app.ParallelCheckBox.Text = 'Parallel';
            app.ParallelCheckBox.Position = [109 5 68 22];

            % Create NoofworkersSpinnerLabel
            app.NoofworkersSpinnerLabel = uilabel(app.ParallelPanel);
            app.NoofworkersSpinnerLabel.HorizontalAlignment = 'right';
            app.NoofworkersSpinnerLabel.Position = [225 5 90 22];
            app.NoofworkersSpinnerLabel.Text = 'No. of workers';

            % Create NoofworkersSpinner
            app.NoofworkersSpinner = uispinner(app.ParallelPanel);
            app.NoofworkersSpinner.Limits = [0 Inf];
            app.NoofworkersSpinner.ValueChangedFcn = createCallbackFcn(app, @NoofworkersSpinnerChanged, true);
            app.NoofworkersSpinner.BusyAction = 'cancel';
            app.NoofworkersSpinner.Tooltip = {'Select the number of workers (e.g. cores)'};
            app.NoofworkersSpinner.Position = [180 5 51 22];

            % Create ProfileNameButton
            app.ProfileNameButton = uibutton(app.ParallelPanel, 'push');
            app.ProfileNameButton.ButtonPushedFcn = createCallbackFcn(app, @ProfileNameButtonPushed, true);
            app.ProfileNameButton.BusyAction = 'cancel';
            app.ProfileNameButton.Position = [323 5 78 22];
            app.ProfileNameButton.Text = 'Profile name';

            % Create ProfileLabel
            app.ProfileLabel = uilabel(app.ParallelPanel);
            app.ProfileLabel.Position = [406 5 53 22];
            app.ProfileLabel.Text = 'local';

            % Create ParallelsettingsLabel
            app.ParallelsettingsLabel = uilabel(app.ParallelPanel);
            app.ParallelsettingsLabel.Position = [8 5 90 22];
            app.ParallelsettingsLabel.Text = 'Parallel settings';

            % Create StorePanel
            app.StorePanel = uipanel(app.Eventer);
            app.StorePanel.Position = [10 373 546 33];

            % Create WaveDropDownLabel
            app.WaveDropDownLabel = uilabel(app.StorePanel);
            app.WaveDropDownLabel.HorizontalAlignment = 'right';
            app.WaveDropDownLabel.Position = [3 5 35 22];
            app.WaveDropDownLabel.Text = 'Wave';

            % Create WaveDropDown
            app.WaveDropDown = uidropdown(app.StorePanel);
            app.WaveDropDown.Items = {};
            app.WaveDropDown.ValueChangedFcn = createCallbackFcn(app, @WaveDropDownValueChanged, true);
            app.WaveDropDown.Tooltip = {'Select current wave. Key: k (up) and'; ' m (down)'};
            app.WaveDropDown.Position = [43 5 55 22];
            app.WaveDropDown.Value = {};

            % Create StoreAllWavesButton
            app.StoreAllWavesButton = uibutton(app.StorePanel, 'push');
            app.StoreAllWavesButton.ButtonPushedFcn = createCallbackFcn(app, @StoreAllButtonPushed, true);
            app.StoreAllWavesButton.Interruptible = 'off';
            app.StoreAllWavesButton.Tooltip = {'Toggle store or unstore all waves'};
            app.StoreAllWavesButton.Position = [179 5 105 22];
            app.StoreAllWavesButton.Text = 'Store all waves';

            % Create PopupGraphButton
            app.PopupGraphButton = uibutton(app.StorePanel, 'push');
            app.PopupGraphButton.ButtonPushedFcn = createCallbackFcn(app, @PopupGraphButtonPushed, true);
            app.PopupGraphButton.BusyAction = 'cancel';
            app.PopupGraphButton.Tooltip = {'Open a pop-up graph of the wave. Zoom into a region of interest and use the cursor buttons to initiate selection of lower and upper time limits for sections of the wave to use for template fitting or exclusion. Key: g'};
            app.PopupGraphButton.Position = [288 5 92 22];
            app.PopupGraphButton.Text = 'Pop-up Graph';

            % Create RunningLamp
            app.RunningLamp = uilamp(app.StorePanel);
            app.RunningLamp.Enable = 'off';
            app.RunningLamp.Position = [516 6 20 20];

            % Create RunButton
            app.RunButton = uibutton(app.StorePanel, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.BusyAction = 'cancel';
            app.RunButton.Interruptible = 'off';
            app.RunButton.Tooltip = {'Run eventer. Key: p'};
            app.RunButton.Position = [384 5 45 22];
            app.RunButton.Text = 'Run';

            % Create RunDropDown
            app.RunDropDown = uidropdown(app.StorePanel);
            app.RunDropDown.Items = {'Current', 'Batch'};
            app.RunDropDown.Tooltip = {'Set eventer run mode to current wave or batch'};
            app.RunDropDown.Position = [433 5 77 22];
            app.RunDropDown.Value = 'Current';

            % Create CurrentWaveStoredBox
            app.CurrentWaveStoredBox = uicheckbox(app.StorePanel);
            app.CurrentWaveStoredBox.ValueChangedFcn = createCallbackFcn(app, @CurrentWaveStoredBoxValueChanged, true);
            app.CurrentWaveStoredBox.BusyAction = 'cancel';
            app.CurrentWaveStoredBox.Tooltip = {'Toggle on/off the store settings checkbox. Key: s (store) and d (delete)'};
            app.CurrentWaveStoredBox.Text = '';
            app.CurrentWaveStoredBox.Position = [161 5 15 22];

            % Create StoreCurrentWaveButton
            app.StoreCurrentWaveButton = uibutton(app.StorePanel, 'push');
            app.StoreCurrentWaveButton.ButtonPushedFcn = createCallbackFcn(app, @StoreCurrentWaveButtonPushed, true);
            app.StoreCurrentWaveButton.Interruptible = 'off';
            app.StoreCurrentWaveButton.Tooltip = {'Select and store current wave settings for analysis. Key: s'};
            app.StoreCurrentWaveButton.Position = [102 5 55 22];
            app.StoreCurrentWaveButton.Text = 'Store';

            % Create UnsavedLabel
            app.UnsavedLabel = uilabel(app.StorePanel);
            app.UnsavedLabel.VerticalAlignment = 'top';
            app.UnsavedLabel.FontSize = 16;
            app.UnsavedLabel.FontColor = [1 0 0];
            app.UnsavedLabel.Visible = 'off';
            app.UnsavedLabel.Position = [147 17 25 13];
            app.UnsavedLabel.Text = '*';

            % Create CreditsButton
            app.CreditsButton = uibutton(app.Eventer, 'push');
            app.CreditsButton.ButtonPushedFcn = createCallbackFcn(app, @AboutEventerButtonPushed, true);
            app.CreditsButton.Position = [491 14 55 22];
            app.CreditsButton.Text = 'Credits';

            % Show the figure after all components are created
            app.Eventer.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = eventerapp_R2019a_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Eventer)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Eventer)
        end
    end
end