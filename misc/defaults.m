% Sets Values to Defaults specified in Eventer
% Basic
app.TimeConstantsEditField1.Value = 0.5;                 % Time Constants: tau1 (rise)
app.TimeConstantsEditField2.Value = 5;                   % Time Constants: tau2 (decay)
% Detection
app.ConfigurationDropDown.Value = 'VC';                  % Configuration ('VC' = voltage clamp, 'CC' = Currentclamp)
app.SignoftheEventsSwitch.Value = '-';                   % Sign of the events ('-' or '+')
app.ThresholdSpinner.Value = 4;                          % Threshold (scale factor of the standard deviations of the noise of the deconvoluted wave)
app.CriterionDropDown.Value = 'Pearson';                 % Correlation coefficient for event selection criteria
app.CorrelationCoefficientSpinner.Value = 0.4;           % Correlation coefficient for event selection criteria
app.HighpassPreFiltermethodDropDown.Value = 'binomial';  % Prefilter wave: High-pass filter method
app.HighpassPreFilterCutOffSpinner.Value = 0;            % Prefilter wave: High-pass filter cutoff (in Hz, 0 switches filter off)
app.LowpassPreFilterCutOffSpinner.Value = inf;           % Prefilter wave: Low-pass Gaussian filter cutoff (in Hz, inf switches filter off)
% Exclude (set exclusion zones with the following format: {'[0 0.2; 0.4 0.5]'})
app.ExtraExclusions.Value = {'[0 0.2]'}                    
% Advanced
app.NoofTausSpinner.Value = 0.4;                         % Number of decay time constants for fitting events
app.BaselineTimeSpinner.Value = 1;                       % Duration of time considered baseline for the events
app.ExmodeDropDown.Value = '1';                          % Exclusion mode  ('1' or '2')
app.LambdaDisp.Value = 1;                                % Lambda value for Levenberg-Marquardt optimization
app.HighpassFilterCutOffSpinner.Value = 10;              % Deconvoluted Wave Signal Processing; High-pass median filter cutoff (in Hz, 0 switches filter off)
app.LowpassFilterCutOffSpinner.Value  = 200;             % Deconvoluted Wave Signal Processing; Low-pass Gaussian filter cutoff (in Hz, 0 switches filter off)
% Output
app.MedianButton.Value = 1;                              % Ensemble average method (set to 0 for mean and 1 for median)
app.MinWindowSpinner.Value = -0.01;                      % Minimum limit of event window
app.MaxWindowSpinner.Value = +0.04;                      % Maximum limit of event window
app.WaveFormatDropDown.Value = 'mat';                    % Wave format file extension
app.GNUZipCompressionCheckBox.Value = 0;                 % Gzip compression (1 = yes, 0 = no)
app.FigureFormatDropDown.Value = 'fig';                  % Figure file format extension 
