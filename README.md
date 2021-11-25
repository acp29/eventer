# Eventer
Copyright © 2019  
Email: eventer.neuroscience@gmail.com  
Website: https://eventerneuro.netlify.app/  
Eventer is distributed under the GNU General Public Licence v3.0  
  
*Eventer is software for the detection of spontaneous synaptic events measured by electrophysiology or imaging. Detection is achieved by Fast Fourier Transform(FFT)-based deconvolution followed by event selection automated by machine learning using random forests.*  

Standalone executables (Windows, Mac and Linux) or MATLAB App are available from https://sourceforge.net/projects/eventer/  
  
The source code hosted on GitHub runs within Matlab and requires Appdesigner and the following toolboxes:  

- Statistics and Machine Learning Toolbox  
- Parallel Toolbox (required only for 'Parallel' functionality)  
  
To install, run or edit the source code: 

- Download and unzip the code  
- Add the eventer folder with all subdirectories to the MATLAB path  
- Start 'appdesigner', open the eventerapp.mlapp file and then click RUN  
  
### The pre-print for this software is in preparation. In the mean time please cite: 
Winchester, G., Liu, S., Steele, O.G., Aziz, W. and Penn, A.C. (2020) *Eventer: Software for the detection of spontaneous synaptic events measured by electrophysiology or imaging.* http://doi.org/10.5281/zenodo.3991677  
  
### Eventer acknowledges code included or modified from:  

- **relativepath**, version 1.0.0.0, Copyright © 2003, Jochen Lenz  
- **parfor_progressbar**, version 2.13.0.0 Copyright © 2016, Daniel Terry  
- **Plot (Big)**, version 1.6.0.0, Copyright © 2015 Tucker  
- **abfload**, version 4 Dec 2017, Copyright © 2009, Forrest Collman, 2004, Harald Hentschke 1998, U. Egert  
- **readMeta** (from ACQ4), version 24 Dec 2013, Copyright © 2013 Luke Campagnola   
- **IBWread**, version 1.0.0.0, Copyright © 2009, Jakub Bialek  
- **importaxo**, version 4 June 2015, Marco Russo, Modified from BJ/AM <importaxo.m>  
- **ImportHEKA** (from sigTOOL), version 02 Sep 2012, Copyright © Malcolm Lidierth & King's College London 2009-  
- **mat64c**, version 2014, Jim Colebatch  
- **TDMS DAQmx Raw data reader**, version 24 Mar 2014, Copyright © CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2014, Author: Tao Lan  
- **SON2** (from sigTOOL version 0.95), Copyright © Malcolm Lidierth & King's College London 2009-  
- **loadDataFile** (from WaveSurfer1.0.5), Copyright © 2013–, Howard Hughes Medical Institute. 
- **wcp_import**, version 04 Feb 2015, Copyright © 2015, David Jäckel  
  
### Principle Author
**Dr Andrew Penn**  
A.C.Penn@sussex.ac.uk.  
Sussex Neuroscience,  
School of Life Sciences,  
University of Sussex,  
Brighton, BN1 9QG.  
United Kingdom.  
  
  
## Changelog

**v1.0.0** First release (source code associated with MATLAB R2018b)  

**v1.0.1** Bug fix for version 1.0 (source code associated with MATLAB R2018b)  

- Bug fix, old version of ephysIO incompatibility with GUI load/save filetypes 

**v1.1.0** Release version (source code in two versions associated with MATLAB R2019a and 2020b versions)  

- GUI windows can now be resized  
- Under parallel settings, users can no longer attempt to set the number of processors  beyond the number of physical cores  
- Added a progress bar when applying wave filter  
- Added credits accessible by a 'Credits' button  
- Added capability to set an absolute threshold on the scale of the deconvoluted wave (as opposed to the relative threshold, which is a scale factor of the standard deviation of the noise)  
- Removed tab shortcut keys since they clash with other functionalities  
- Added message box to warning user to increase postevent window width if/when time course of the template is too small for the current event window settings  
- Fixed bug that caused the event classification window to appear off the screen at low screen resolutions  
- Fixed bug that prevented filter settings from being loaded on all waves when loading an analysis.evt file  
- Fixed bug that caused incorrect scaling of data loaded from raw .tdms files  
- Fixed bug that prevented time constants for individual waves being applied correctly when running batch mode  
- Added button to copy from fitted parameters to template time constants  

**v1.1.1** Release version (source code in two versions associated with MATLAB R2019a and 2020b versions)  

- Fixed bug where file open dialogue stays behind eventer app  
- Changed handling of path's to be case sensitive  
- Added ability to set units when importing data from raw text files  
- Added ability to set scale factor when loading tdms files  
- Fixed bug after cancellation of model file open dialogue  
- Changed wave dropdown menu interuption setting from cancel to queue  
- exported the appdesigner to .m file to simplify requesting changes to the source code via GitHub  

**v1.1.2** Release version (source code in two versions associated with MATLAB R2019a and 2020b versions)  

- Fixed bug that prevented the opening of raw text data files  

**v1.1.3** Release version (source code in two versions associated with MATLAB R2019a and 2020b versions)  

- Fixed bug that caused no dialog to appear asking whether to apply extra exclusion zone (from presets file) to all waves  
- Fixed bug introduced in recent 1.1.X version that prevented opening of model files  
- Fixed bug that prevented waitbar showing progress (relates to store-all-waves functionality)  
- Corrected tooltip for 'Apply to all waves' button on the Template tab panel  
- Minor changes and clarification in tooltips  
- Various minor changes to stream-line the process of applying presets  
- Fixed bug that prevented some wait/progress bars from staying on-top of other windows
- Added Eventer icon to title bar in uifigures of R2020b version (only visible in Windows version)

**v1.1.4** Release version (source code in version associated with MATLAB R2020b)  

- When x-units are not specified in .itx files, assume units of 'ms' instead of 's'  
- Fixed bug that prevented zip compression of exported data files  
- Fixed bug that caused .phy files to be exported in addition to files of desired export format  
- Added error messages to notify uses if required toolboxes are not installed (relevant only to Matlab app version of Eventer)  
- Fixed bug that halts merge when the fit to the ensemble average event fails (plot fit using initial values (average template time constants) instead)  
- Clarified tool tip for 'Store all waves' button  
- Prevent the template tab graph from being cleared when changing wave  
- Prevent error (and system beep) when figure closed before assigning the start and end positions on graphs for the fit and exlcusion zones  
- Changed Eventer behaviour when 'Split' valus is not an exact multiple of the whole recording length - the last wave will be discarded if it is not equal to the 'Split' value
- Fixed bug that prevented the recording configuration to be updated upon loading an analysis.evt file  

**v1.2.0** Release version (source code in version associated with MATLAB R2020b)

- Added Axon Binary File (ABF version 1.83) as an additional export format. This widely recognised format is now adopted as Eventer's default output wave format. The ABF files created by eventer are readable in ClampFit, Axograph, Stimfit, IgorPro (via Neuromatic), WinWCP and EasyElectrophysiology (at least that's what we've tested them in)  
- Fixed bug that halts merge when the fit to the ensemble average event fails (plot fit using initial values (average template time constants) instead)   

**v1.2.1** Release version (source code in version associated with MATLAB R2020b)

- Now automatically saves plot of out-of-bag classification error after training
- Fixed bug that prevented 'Store all waves' button becoming 'Unstore all waves' when loading evt file with all waves stored
- Fixed bug that caused Eventer to error when training a model when the exported wave file format was set to anything other than .phy

## Development roadmap  

- Reduce memory footprint of eventer  
- Add support to load files acquired using Symphony (http://symphony-das.github.io/)  
- Add support to load and export files in NWB format (https://www.nwb.org/nwb-neurophysiology/)  
- Add offline series resistance compensation feature
