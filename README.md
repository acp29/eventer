# Peaker

PEAKER ANALYSIS TOOLBOX

Peaker Analysis Toolbox is a collection of scripts and functions for 
the analysis of spontaneous and evoked synaptic currents or potentials
in Matlab.



VERSION HISTORY

v1.1  Bug fixes

v1.0	Initial release


REQUIREMENTS

Requires Matlab. Tested on Windows MATLAB version 7.4 (R2007A) and 
Macintosh MATLAB version 7.9 (R2009b). The code is not compatibile with 
GNU Octave. 

Peaker Analysis Toolbox can only READ the following file formats:
- Axon binary files (.abf, ABF versions 1 and 2) using abfload.m from 
  Harald Hentschke, Forrest Collman and Ulrich Egert
- Igor Binary Files (.ibw) using IBWread.m from Jakub Bialek
- ACQ4 HDF5 binary files (.ma) using readMeta.m from Luke Campagnola
  (uncompressed format only)
- Tab-delimited text files (.txt)
- Comma-separated values text files (.csv)

Peaker Analysis Toolbox can READ and WRITE the following file formats:
- Axon text files (.atf)
- Igor text files (.itx) 
- ephysIO HDF5 (MAT v7.3) binary files (.mat) 


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

Requires toolboxes:
Statistics and Machine Learning Toolbox
Parallel Toolbox (EventerGUI only)
Image Processing Toolbox
Signal Processing Toolbox



Dr Andrew Penn, 
A.C.Penn@sussex.ac.uk.
Sussex Neuroscience,
School of Life Sciences,
University of Sussex,
Brighton, BN1 9QG.
United Kingdom.
