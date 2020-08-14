# Eventer

EVENTER v1.0.1

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

Authors: Giles Winchester, Samuel Liu and Andrew Penn

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

Change log

v1.0.0 First release

v1.0.1 Bug fix, old version of ephysIO incompatibility with GUI load/save filetypes

