# Eventer

EVENTER v1.1.0
eventer.neuroscience@gmail.com
https://eventerneuro.netlify.app/

Software for the detection of spontaneous synaptic events measured by electrophysiology or imaging. Detection is achieved by Fast Fourier Transform(FFT)-based deconvolution followed by event selection automated by Random Forest Machine Learning.

Standalone executables (Windows, Mac and Linux) or MATLAB App are available from https://sourceforge.net/projects/eventer/

The source code hosted on GitHub runs within Matlab and requires Appdesigner and the following toolboxes:
- Statistics and Machine Learning Toolbox
- Parallel Toolbox (required only for 'Parallel' functionality)

To install and run the source code:
- Download and unzip the code
- Add the eventer folder with all subdirectories to the MATLAB path
- Start 'appdesigner', open the eventerapp.mlapp file and then click RUN.

The pre-print for this software is in preparation.

In the mean time please cite: 
Winchester, G., Liu, S., Steele, O.G., Aziz, W. and Penn, A.C. (2020) Eventer: Software for the detection of spontaneous synaptic events measured by electrophysiology or imaging. http://doi.org/10.5281/zenodo.3991677

DISCLAIMER
The matlab files included in this analysis toolbox I have written on-and-
off over the years for the purposes of facilitating the analysis of my own
(and my lab's) electrophysiology data, mainly spontaneous and evoked synaptic
currents or potentials. As and when I had a specific analysis task I would
write a new script or function and attempt to bolt them on to one another
to create a modular analysis toolbox. Some of the code is good but some of
it is really ugly, and if I were to do it all again (which I am not!), I
certainly would have done it differently. That said I still use much of it
and am providing it to embrace open access without responsibility for it's
use (or misuse). The toolbox does not have a GUI and is not user friendly
(especially if you are not that familiar with Matlab) and it lacks tutorials
or a comprehensive manual. That said, I have tried to write extensive help
information for each script/function in this toolbox. Researchers I know
who have learnt to use this analysis toolbox like it and still use it today.
I will attempt to keep up with requests for help and for bug fixes but I do
not plan to add much more in the way of functionality.


Dr Andrew Penn,
A.C.Penn@sussex.ac.uk.
Sussex Neuroscience,
School of Life Sciences,
University of Sussex,
Brighton, BN1 9QG.
United Kingdom.


CHANGE LOG

v1.0.0 First release (source code associated with MATLAB R2018b)

v1.0.1 Bug fix for version 1.0(source code associated with MATLAB R2018b)
- Bug fix, old version of ephysIO incompatibility with GUI load/save filetypes 

v1.1.0 Release version (source code in two versions associated with MATLAB R2019a and 2020b versions)
- GUI windows can now be resized
- Under parallel settings, users can no longer attempt to set the number of processors beyond the number of physical cores
- Added a progress bar when applying wave filter
- Added credits accessible by a 'Credits' button
- Added capability to set an absolute threshold on the scale of the deconvoluted wave (as opposed to the relative threshold, which is a scale factor of the standard deviation of the noise)
- Removed tab shortcut keys since they clash with other functionalities
- Added message box to warning user to increase postevent window width if/when time course of the template is too small for the current event window settings
- Fixed bug that caused the event classification window to appear off the screen at low screen resolutions
- Fixed bug that prevented filter settings from being loaded on all waves when loading an analysis.evt file
- Fixed bug that caused incorrect scaling of data loaded from raw .tdms files
- Fixed bug that prevented time constants for individual waves being applied correctly when running batch mode
- Added button to copy from fitted paramaters to template time constants
