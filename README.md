# Eventer

EVENTER v1.1.0

Software for the detection of spontaneous synaptic events by Fast Fourier Transform(FFT)-based deconvolution followed by event selection using Random Forest  Machine Learning

For standalone executables (Windows, Mac and Linux), please visit https://sourceforge.net/projects/eventer/

The source code hosted on GitHub runs within Matlab and requires Appdesigner and the following toolboxes:
- Statistics and Machine Learning Toolbox
- Parallel Toolbox

This software was written and designed using MATLAB R2018b

To install and run the source code:
- Download and unzip the code
- Add the eventer folder with all subdirectories to the MATLAB path
- Start 'appdesigner', open the eventerapp.mlapp file and then click RUN.

The pre-print for this software is in preparation.

In the mean time please cite: 
Winchester, G., Liu, S., Steele, O.G., Aziz, W. and Penn, A.C. (2020) Eventer: Software for the detection of spontaneous synaptic events measured by electrophysiology or imaging (Version 1.0.1). http://doi.org/10.5281/zenodo.3991677

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

v1.0.0 First release

v1.0.1 Bug fix, old version of ephysIO incompatibility with GUI load/save filetypes

v1.1.0 Release version
- GUI windows can now be resized
- Under parallel settings, users can no longer attempt to set the number of processors beyond the number of physical cores
- Added a progress bar when applying wave filter
- Added credits accessible by a 'Credits' button
- Added capability to set an absolute threshold on the scale of the deconvoluted wave (as opposed to the relative threshold, which is a scale factor of the standard deviation of the noise)
- Removed tab shortcut keys since they clash with other functionalities
- Fixed bug that caused the event classification window to appear off the screen at low screen resolutions
- Fixed bug that prevented filter settings from being loaded on all waves when loading an analysis.evt file
- Fixed bug that caused incorrect scaling of data loaded from raw .tdms files
- Fixed bug that prevented time constants for individual waves being applied correctly when running batch mode
