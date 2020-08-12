Instructions for National Instruments DIAdem Connectivity Library Development Files

The DIAdem Connectivity Library enables applications to read and write TDM (.tdm) 
and TDM Streaming (.tdms) files. The TDM and TDM Streaming file formats are 
supported by National Instruments DIAdem.

See license.rtf for licensing terms and restrictions.

***************************************
*****  Development Instructions   *****
***************************************

The 'dev' directory contains the library binaries and Matlab-specific header files.  

Matlab can call into Windows DLLs, including this library. You can call the loadlibrary, 
calllib, and unloadlibrary functions in Matlab to access this library. See the Matlab help
for these functions and the sample m-files included with this library for more 
information.

The 'dev\bin' and 'dev\include' directories contains separate sub-directories containing
the files required for using this library with 32-bit and 64-bit versions of Matlab.

Note that the runtime components for this library require the Microsoft Visual C++ 2005 
runtime components version 8.0.50727.762 (or a later compatible version) to be installed. 
You must install 32-bit (x86) and/or 64-bit (x64) versions of the Microsoft Visual C++ 2005 
runtime components depending on whether you are using this library with a 32-bit and/or 
64-bit version of Matlab.

The 'doc' directory includes a help file for this library.

The 'samples' directory contains sample m-files that call this library.

***************************************
***** Redistribution Instructions *****
***************************************

If you build a standalone application that calls this library, then your standalone 
application will depend on the runtime components required by this library. If you
build an installer for your standalone application, then you can include the supplied
merge modules in your installer to redistribute the required runtime components.

The 'redist' directory contains 32-bit and 64-bit merge modules that include the 
runtime components required by the 32-bit and 64-bit versions of this library.

The 'niusiemb.msm' and 'niusiemb_x64.msm' merge modules contains all files in 
'dev\bin\32-bit' and 'dev\bin\64-bit', respectively, except for nilibddc.dll. The 
'nilibddc.msm' and 'nilibddc_x64.msm' merge modules contain only the 32-bit and 64-bit 
versions of nilibddc.dll, respectively.

Your installed application will require the Microsoft Visual C++ 2005 runtime components 
version 8.0.50727.762 (or a later compatible version). The 'Microsoft_VC80_CRT_x86.msm' 
and 'policy_8_0_Microsoft_VC80_CRT_x86.msm' merge modules will install the required 
components for 32-bit applications. The 'Microsoft_VC80_CRT_x86_x64.msm' and 
'policy_8_0_Microsoft_VC80_CRT_x86_x64.msm' merge modules will install the required 
components for 64-bit applications.

The files in the included 'nilibddc[_x64]' and 'niusiemb[_x64].msm' merge modules need 
to be installed in the same directory as your executable or DLL that uses this library. 
It is highly recommended that this directory be specific to your application and not a 
shared system location like the Windows System directory. 

By default, the supplied 'nilibddc[_x64]' and 'niusiemb[_x64].msm' merge modules 
install their files to the directory specified by the INSTALLDIR installer property. 
Some installer authoring tools, including Wise for Windows Installer, set the INSTALLDIR 
property to the application directory selected by the user at install time. Other 
installer authoring tools do not use the INSTALLDIR property. For example, Microsoft 
Visual Studio uses the TARGETDIR property to store the application directory selected 
by the user at install time. If your installation directory for the files in the merge 
modules is specified by an installer property other than INSTALLDIR, then you must change 
the "Installation Directory" property of the merge modules to refer to the correct 
property name. See the documentation for your installer authoring tool for details.

These merge modules have been tested with Wise for Windows and Microsoft Visual Studio.

***************************************
*****       Version History       *****
***************************************
9.1 - Added TDM Streaming (.tdms) 2.0 file format support, 64-bit application support, 
      and additional type-safe functions for applications not written in C/C++.
8.6 - Added support for reading and writing Timestamp values and properties.
8.1 - Added support for reading and writing TDM Streaming (.tdms) file format.
    - Added functions to retrieve property names and property types from a file, 
      channelgroup, or channel.
8.0 - First release.

© 2010 National Instruments Corporation. All rights reserved.