% Function File: ephysIO
%
%  USAGE: To save a column-major XY array of electrophysiology data:
%         ephysIO (filename,array,xunit,yunit,names,notes,datatype)
%
%         To load column-major XY array of electrophysiology data:
%         data = ephysIO (filename)
%         [array,xdiff,xunit,yunit,names,notes,clist,saved] = ephysIO (filename)
%         [array,xdiff,xunit,yunit,names,notes,clist,saved] = ephysIO ({filename,channel})
%
%  Electrophysiology data input-output functionality for MATLAB. The file
%  format is automatically detected from the filename extension. The channel
%  number of the data can be specified in the first input argument by providing
%  the filename and channel number in a cell array as shown above.
%  If no input arguments are provided, a standard open file dialog box will pop-up.
%  If only one output argument is provided, the data is returned in a structure array.
%
%  The numeric data in the array argument is in column-major XY format:
%     The first column is the X dimension
%     All subsequent columns are the Y dimension
%  All Y dimension data must have the same units.
%  The X dimension can have constant or variable sampling intervals.
%
%  xunit and yunit arguments are characters defining the X (e.g. s) and Y
%  (e.g. A, V) dimension units respectively .
%
%  names is a cell array of strings with the title of each column of array.
%  notes is a cell array containing comments etc.
%  datatype for ephysIO HDF5 files can be 'int16' (default) or 'int32'.
%  clist is a cell array containing a column of channel names present in
%    original file from which the data came and a column of zeros and ones
%    indicating which channel the data in array represents
%
%  If a header line is encountered when reading text file formats (.txt or
%  .csv), it will be detected automatically. Support is also provided to
%  export an ASCII tab-delimited text file (.asc) with waves stacked;
%  suitable to import into WinWCP or WinEDR.
%
%  Zip (.zip) or gzip (.gz) compressed files of the supported input file
%  formats will automatically be decompressed.
%
%  Support for reading non-matlab binary files is available via the
%  following third party helper functions distributed with ephysIO:
%    readMeta.m from ACQ4 (Luke Campagnola)
%    IBWread.m from Jakub Bialek (modified by AP)
%    import_wcp.m from David Jaeckeld (modified by AP)
%    importaxo.m from Marco Russo
%    loadDataFile.m from WaveSurfer
%    ImportHEKA.m from Malcolm Lidierth and Sammy Katta (modified by AP)
%    abfload.m from Harald Hentschke, Forrest Collman and Ulrich Egert
%              (modified by AP)
%    matcfs32 and matcfs64d from Jim Colebatch
%    SON2 from Malcolm Lidierth
%    TDMS Reader from Jim Hokanson
%    matnwb from Lawrence Niu and Ben Dichter
%
%  Supported input file formats:
%    pCLAMP Axon binary files v1 and v2 (*.abf)
%    Axograph binary files (*.axgx, *.axgd)
%    HEKA PatchMaster, Pulse and ChartMaster binary files (*.dat)
%    Neurodata without borders v2 (*.nwb)
%    CED Spike2 binary files (*.smr)
%    CED Signal binary files (*.cfs) (windows only; 32 or 64-bit)
%    LabVIEW Signal Express TDMS binary files (*.tdms)
%    WinWCP binary files (*.wcp)
%    WinEDR binary files (*.EDR)
%    Igor Packed experiment binary files (*.pxp)
%    Igor binary wave files (*.ibw, *.bwav) (versions 2 and 5 only)
%    WaveSurfer binary (HDF5) files (*.h5)
%    ACQ4 binary (HDF5) files (*.ma) (no compression only, ch 0 auto-selects primary)
%    GINJ2 MATLAB binary files (*.mat)
%    PackIO binary files (*.paq)
%    Stimfit binary (HDF5) files (*.h5)
%    Igor text files (*.itx,*.awav)
%    Axon text files (*.atf)
%    ASCII tab-delimited text files (*.txt) (with or without header)
%    ASCII comma-separated values text files (*.csv) (with or without header)
%    ephysIO HDF5/MATLAB binary files (*.phy)
%
%  Supported output file formats:
%    Axon binary files v1.83 (*.abf, integer-type)
%    Neurodata without borders v2.6.0 (*.nwb)
%    HDF5 (Stimfit) binary files (*.h5)
%    Igor text files (*.itx)
%    Axon text files (*.atf)
%    ASCII comma-separated values text files (*.csv) (no header, waves in columns)
%    ASCII tab-delimited text files (*.txt) (no header, waves in columns)
%    ASCII tab-delimited text files (*.asc) (no header, waves stacked)
%    ephysIO HDF5 (Matlab v7.3) binary files (*.phy)
%
%  Any of the above output formats can be combined with gzip compression by including
%  a further .gz extension to the filename. Note that in most circumstances, compression
%  offers little benefit to ABF files or the specific HDF5 files saved by ephysIO.
%
%  --------------------- Notes on ephysIO's HDF5 file format ---------------------
%
%  The preferred ephysIO format (.phy) is a simple hdf5 format that is created for
%  convenience using the matlab save command (Matlab file version 7.3). It is
%  designed for efficient data storage, where the int16 data array format is
%  suitable for most applications.
%
%  In the HDF5 file, the root group members are the names of the variables used
%  to retrieve the data. These root members are:
%      /array  (int16 or int32) % Raw data (row major order, see below)
%      /start  (single)         % Start value for each wave of the actual data
%      /scale  (uint8)          % Power of two exponent for data scaling
%      /xdiff  (double)         % Sampling interval
%      /xunit  (uint16)         % Character of unit of the x-dimension wave
%      /yunit  (uint16)         % Character of unit of the y-dimension waves
%      /xname  (uint16)         % Character array of the name for the x-dimension
%      /names  (uint16)         % Character array of wave names (row major order)
%      /notes  (uint16)         % Character array of additional metadata
%      /saved  (double)         % Date and time that the file was saved
%
%  Note that Matlab 7.3 files use Unicode encoding of characters.
%
%  This simple file structure is capable of storing multiple fixed-length waves,
%  which could represent multiple recording sweeps for a single recording channel.
%  Different recording channels should be saved in separate files. In order to
%  support variable-length recording sweeps, ephysIO performs padding on the waves
%  to make them the same length.
%
%  The data array stored by ephysIO in the HDF5 files is the first derivative
%  scaled, stored as integers and transposed. Loading the HDF5 files using ephysIO
%  will return the proper (rescaled) data in the 'array' variable. If extracting the
%  raw data directly from the HDF5 file then the following retransformation must be
%  performed:
%      > scale=double(h5read('test.phy','/scale'));
%      > start=double(h5read('test.phy','/start'));
%      > array=double(h5read('test.phy','/array'));
%      > scale = 2.^(scale*ones(1,size(array,2)));
%      > array = array./scale;
%      > array = cat(2,start,array);
%      > array = transpose(cumsum(array,2));
%
%  Note that the above transformation is incompatible with NaN data values.
%  Note also that on older versions of Matlab, the matlab variables will be
%  saved with the native matlab file format instead of the HDF5 format.
%
%  -------------------------------------------------------------------------------
%
%  ephysIO v2.1.0 (last updated: 13/12/2021)
%  Author: Andrew Charles Penn
%  https://www.researchgate.net/profile/Andrew_Penn/
%
%  Copyright 2018 Andrew Charles Penn
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program. If not, see <http://www.gnu.org/licenses/>.




function [array,xdiff,xunit,yunit,names,notes,clist,saved] = ...
         ephysIO (arg1,array,xunit,yunit,names,notes,datatype,globvar) %#ok<*INUSD,*REDEF>

  % Select file if not already specified
  cwd = pwd;
  if nargin < 1
    [filename, pathname] = uigetfile('*');
    arg1 = sprintf('%s%s',pathname,filename);
  end

  % Evaluate input arguments (with error checking)
  % Check supported filetypes for loading
  if (nargin <= 1)
    if iscell(arg1)
      filename = arg1{1};
      ch = arg1{2};
      if numel(arg1) > 2
        globvar = arg1{3};
      else
        globvar = 0;
      end
    else
      filename = arg1;
      ch = 1;
      globvar = 0;
    end
    if globvar == 1
      global array %#ok<*TLEV>
      global xdiff
      global xunit
      global yunit
      global names
      global notes
      global saved
    end
    % Get file path
    [pathstr, fname, fext] = fileparts(filename);
    if ~isempty(pathstr)
      chdir(pathstr);
    end
    filename = [fname,fext];
    minlim = min(length(filename)-1,4);

    % Check file exists
    if ~exist(filename,'file')
      error('File not found')
    end
    if ~isempty(regexpi(filename(end-2:end),'.gz'))
      if exist('gunzip') %#ok<*EXIST>
        gunzip(filename);
        orifilename = filename;
        movefile(filename,'temp');
        filename(end-2:end) = '';
      else
        error('gunzip function is not available for file decompression')
      end
    end
    if ~isempty(regexpi(filename(end-3:end),'.zip'))
      if exist('unzip')
        unzip(filename);
        orifilename = filename;
        movefile(filename,'temp');
        filename(end-3:end) = '';
      else
        error('unzip function is not available for file decompression')
      end
    end
    %% Determine filename of the file that was just unzipped
    %D = dir(sprintf('%s*',filename));
    %[junk,idx] = sort([D.datenum],'descend');
    %filename = D(idx(1)).name;
    pat = ['(.\.nwb)*(.\.mat)*(.\.phy)*(.\.txt)*(.\.csv)*(.\.itx)*(\.awav)*(.\.atf)*(.\.ibw)*(.\.pxp)*(.\.paq)*'...
           '(.\.abf)*(.\.ma)*(.\.h5)*(.\.wcp)*(.\.EDR)*(\.axgd)*(\.axgx)*(\.dat)*(\.cfs)*(\.smr)*(\.tdms)*'];
    if isempty(regexpi(filename(end-minlim:end),pat))
      error('unsupported filetype for load')
    end
  end
  % Check supported filetypes for saving
  if nargin > 1
    if (nargin==2) && isstruct(array)
      xdiff = array.xdiff; %#ok<*NODEF,*NASGU>
      xunit = array.xunit;
      yunit = array.yunit;
      names = array.names;
      notes = array.notes;
      array = array.array;
    end
    if iscell(arg1)
      filename = arg1{1};
    else
      filename = arg1;
    end
    % Check if output file should be compressed
    if strcmpi(filename(end-2:end),'.gz')
      gzflag = 1;
      filename(end-2:end)='';
    else
      gzflag = 0;
    end
    pat = '(.\.abf)*(.\.nwb)*(.\.h5)*(.\.phy)*(.\.itx)*(.\.awav)*(.\.atf)*(.\.txt)*(.\.csv)*(.\.asc)*';
    if isempty(regexpi(filename(end-4:end),pat))
      error('unsupported filetype for save')
    end
    ncols = size(array,2);
    if ncols < 2
      error('The data must have X and Y dimensions')
    end
    if exist('xunit','var')
      if ~ischar(xunit)
        error('xunit must be a character string')
      end
    else
      xunit = '';
    end
    if exist('yunit','var')
      if ~ischar(yunit)
        error('yunit must be a character string')
      end
    else
      yunit = '';
    end
    if exist('names','var')
      if ~iscell(names)
        error('names must be a cell array')
      end
    else
      names = {};
    end
    if isempty(names)
      % Create default column names for data array
      names = cell(ncols,1); %#ok<*PREALL>
      if ncols > 1
        if strcmp(xunit,'s')
          names{1} = 'Time';
        else
          names{1} = 'XWave';
        end
      else
        names{1} = 'YWave';
      end
      for i=1:ncols-1
        names{i+1}=sprintf('YWave%d',i); %#ok<*AGROW>
      end
    end
    names = names(:)';
    if numel(names) ~= ncols
      error('names must match the dimensions of the data array')
    end
    if exist('notes','var')
      if ~iscell(notes)
        error('notes must be a cell array')
      end
    else
      notes={};
    end
    if exist('datatype','var')
      if ~strcmpi(filename(end-3:end),'.phy')
        fprintf('datatype only used by ephysIO HDF5/MATLAB file format\n');
      end
      if ~strcmpi(datatype,'int16') && ~strcmpi(datatype,'int32')
        error('string defining the datatype must match either int16 or int32')
      end
    else
      if strcmpi(filename(end-3:end),'.phy')
        datatype='int16';
      end
    end

  end

  % Perform input-output operation depending on function usage
  % LOAD DATA if only filename input argument is provided
  if (nargin <= 1)
    if strcmpi(filename(end-3:end),'.phy')
      [array,xdiff,xunit,yunit,names,notes,saved] = PHYload (filename); %#ok<*ASGLU>
    elseif strcmpi(filename(end-3:end),'.mat')
      [array,xdiff,xunit,yunit,names,notes] = ginj2load (filename,ch); %#ok<*ASGLU>
    elseif strcmpi(filename(end-3:end),'.paq')
      [array,xdiff,xunit,yunit,names,notes] = paqload (filename,ch); %#ok<*ASGLU>
    elseif strcmpi(filename(end-3:end),'.txt')
      [array,xdiff,xunit,yunit,names,notes] = TXTread (filename,'\t');
    elseif strcmpi(filename(end-3:end),'.csv')
      [array,xdiff,xunit,yunit,names,notes] = TXTread (filename,',');
    elseif strcmpi(filename(end-3:end),'.itx') || strcmpi(filename(end-minlim:end),'.awav')
      [array,xdiff,xunit,yunit,names,notes] = ITXread (filename);
    elseif strcmpi(filename(end-3:end),'.atf')
      [array,xdiff,xunit,yunit,names,notes] = ATFread (filename);
    elseif strcmpi(filename(end-2:end),'.ma')
      if exist('readMeta')
        [array,xdiff,xunit,yunit,names,notes,clist,ch] = MAload (filename,ch);
      else
        error('the required helper function readMeta.m cannot be found')
      end
    elseif strcmpi(filename(end-2:end),'.h5')
      S = h5info(filename);
      C = {S.Groups.Name};
      if numel(C)>0
        if strcmp(C{1},'/header')
          if exist('loadDataFile')
            [array,xdiff,xunit,yunit,names,notes,clist] = WSload (filename,ch);
          else
            error('The required helper function loadDataFile.m cannot be found')
          end
        elseif strcmp(C{end},'/comment') && strcmp(C{end-1},'/channels')
          [array,xdiff,xunit,yunit,names,notes,clist] = H5load (filename,ch);
        end
      else
        error('incompatible HDF5 file structure')
      end
    elseif strcmpi(filename(end-3:end),'.ibw') || strcmpi(filename(end-4:end),'.bwav')
      if exist('IBWread')
        [array,xdiff,xunit,yunit,names,notes] = IBWload (filename);
      else
        error('the required helper function IBWread.m cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.pxp')
      if exist('IBWread')
        [array,xdiff,xunit,yunit,names,notes] = PXPload (filename);
      else
        error('the required helper function IBWread.m cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.abf')
      if exist('abfload')
        [array,xdiff,xunit,yunit,names,notes,clist] = ABF2load (filename,ch);
      else
         error('the required helper function abfload.m cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.nwb')
      if exist('nwbRead')
        [array,xdiff,xunit,yunit,names,notes] = NWB2load (filename,ch);
      else
         error('the required helper function nwbRead.m (from matnwb) cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.wcp')
      if exist('import_wcp')
        [array,xdiff,xunit,yunit,names,notes,clist] = WCPload (filename,ch);
      else
         error('the required helper function import_wcp.m cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.EDR')
      [array,xdiff,xunit,yunit,names,notes,clist] = EDRload (filename,ch);
    elseif strcmpi(filename(end-4:end-1),'.axg')
      if exist('importaxo')
        [array,xdiff,xunit,yunit,names,notes,clist] = AXOload (filename,ch);
      else
         error('the required helper function importaxo.m cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.dat')
      if exist('ImportHEKA')
        [array,xdiff,xunit,yunit,names,notes,clist] = HEKAload (filename,ch);
      else
         error('the required helper function ImportHEKA.m cannot be found')
      end
    elseif strcmpi(filename(end-3:end),'.cfs')
      [array,xdiff,xunit,yunit,names,notes,clist] = CFSload (filename,ch);
    elseif strcmpi(filename(end-3:end),'.smr')
      [array,xdiff,xunit,yunit,names,notes,clist] = SMRload (filename,ch);
    elseif strcmpi(filename(end-4:end),'.tdms')
      [array,xdiff,xunit,yunit,names,notes,clist] = TDMSload (filename,ch);
    end
    if ~exist('clist','var')
      clist = cell(1);
    end
    clist = clist(:);
    if ~isempty(clist{1})
      cload = zeros(numel(clist),1);
      cload(ch) = 1;
      clist = {clist num2cell(cload)};
    end
    % Convert character array of column names to a cell array and transpose
    % for column-major order (if applicable)
    if ischar(names)
      names = cellstr(names)';
    end
    % Convert character array of notes to a cell array if applicable
    if ischar(notes)
      notes = cellstr(notes);
    end
    % Calculate the number of columns in the data array
    ncols = size(array,2);
    if ncols < 2
      error('the data must have X and Y dimensions')
    end
    % Remove unit prefixes and scale the data appropriately
    [array(:,1),xunit,SF] = scale_units(array(:,1),xunit);
    xdiff = xdiff*SF;
    if strcmpi(filename(end-3:end),'.phy') && abs(array(1,1))>0  
      warning('timebase offset will be reset to zero','TimeOffset')
      array(:,1) = xdiff * [0:size(array,1)-1]';
    end
    [array(:,2:end),yunit] = scale_units(array(:,2:end),yunit);
    if ~exist('saved','var')
      saved='';
    end
    names = names(:)';
  end

  % Make wave names comply with standard name rules
  for i = 1:ncols
    % Replace commas and blanks with underscore
    names{i} = regexprep(names{i},'[\s,]','_');
    % Remove all other illegal characters
    names{i} = regexprep(names{i},'[^A-Z_0-9]*','','ignorecase');
    if isempty(names{i})
      names{i}='?';
    end
    % Remove leading numeric or underscore characters
    while isempty(regexpi(names{i}(1),'[A-Z]'))
      names{i}(1)='';
      % If wave name is empty, assign an arbitrary wave name
      if (numel(names{i})==0)
        if i == 1
          if strcmp(xunit,'s')
            names{1} = 'Time';
          else
            names{1} = 'XWave';
          end
        elseif i > 1
          names{i}= sprintf('YWave%d',i-1);
        end
      end
    end
    % Truncate wave name to 31 characters
    names{i}(31:end)=[];
  end

  % SAVE DATA if both filename and data input arguments are provided
  if nargin > 1
    % Remove unit prefixes and scale the data appropriately
    [array(:,1),xunit] = scale_units(array(:,1),xunit);
    [array(:,2:end),yunit] = scale_units(array(:,2:end),yunit);
    % Set data values below the machine precision to 0
    array(abs(array)<eps) = 0;
    if strcmpi(filename(end-3:end),'.abf') 
      ABFsave (filename,array,xunit,yunit,names,notes);
    elseif strcmpi(filename(end-3:end),'.nwb') 
      if exist('nwbExport')
        NWB2save (filename,array,xunit,yunit,names,notes);
      else
        error('the required helper function nwbExport.m (from matnwb) cannot be found')
      end
    elseif strcmpi(filename(end-2:end),'.h5')
      H5save (filename,array,xunit,yunit,names,notes);
    elseif strcmpi(filename(end-3:end),'.phy')
      if any(isnan(array(:)))>0 || any(isinf(array(:)))>0
        error(['ephysIO binary files do not support the storage of NaN '...
              'or inf values in the data array'])
      end
      PHYsave (filename,array,xunit,yunit,names,notes,datatype);
    elseif strcmpi(filename(end-3:end),'.itx') || strcmpi(filename(end-4:end),'.awav')
      ITXwrite (filename,array,xunit,yunit,names,notes);
    elseif strcmpi(filename(end-3:end),'.atf')
      ATFwrite (filename,array,xunit,yunit,names,notes);
    elseif strcmpi(filename(end-3:end),'.txt')
      TXTwrite (filename,array,xunit,yunit,names,notes,'\t');
    elseif strcmpi(filename(end-3:end),'.csv')
      TXTwrite (filename,array,xunit,yunit,names,notes,',');
    elseif strcmpi(filename(end-3:end),'.asc')
      ASCwrite (filename,array,xunit,yunit,names,notes);
    end
    if gzflag == 1
      gzip(filename)
      delete(filename);
    end
    clear array xdiff xunit yunit names notes
  end

  if nargout == 1
    data = array;
    array = struct;
    array.array = data; %#ok<*STRNU>
    array.xdiff = xdiff;
    array.xunit = xunit;
    array.yunit = yunit;
    array.names = names(:)';
    array.notes = notes;
    array.clist = clist;
    if ~isempty(clist)
      for i=1:size(clist,1)
        array.clist;
      end
    end
  end

  % Clean up
  if exist('temp','file')
    delete(filename);
    movefile('temp',orifilename);
  end
  chdir(cwd)

end

%--------------------------------------------------------------------------

function [data, unit, SF] = scale_units (data, unit)

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

%--------------------------------------------------------------------------

function matrix = cells2mat (array)

  % Pad array cells and convert to matrix
  n = numel(array);
  sizes = zeros(n,1);
  for i=1:n
    sizes(i) = size(array{i},1);
  end
  N = max(sizes);
  for i=1:n
    if ~isempty(array{i})
      if sizes(i)<N
        array{i} = cat(1,array{i},ones(N-sizes(i),1)*array{i}(end,:));
      end
    end
  end
  matrix = cell2mat(array);

end

%--------------------------------------------------------------------------

function PHYsave (filename,array,xunit,yunit,names,notes,datatype)

  % ephysIO HDF5 matlab binary file

  % File format version 1 - no longer used
  % Modify the X dimension data as the difference between X values to
  % maintain the dynamic range when converting it to single precision
  %dx = diff(array(:,1));
  %if any(diff(dx) > 1.192093e-07)
  %  xdiff = 'variable';
  %else
  %  xdiff = 'constant';
  %end
  %array(2:end,1) = dx;

  % Round double array to 7 significant figures
  %array(array==0) = NaN;
  %scale = 10.^floor(log10(abs(array)))*1e-6;
  %array = round(array./scale).*scale;
  %array(isnan(array)) = 0;

  % Convert data array to single machine precision for more efficient storage
  % and transpose to row-major order so that dimensions are consistent with
  % the char array of names
  %array = single(array)';

  % Convert names and notes cell arrays to char arrays
  %names = char(names);
  %notes =  char(notes);

  % Save variables in matlab binary file
  %try
  %  % Save in the compressed MATLAB v7 filetype
  %  save (filename,'array','scale','start','xdiff','xunit',...
  %                 'yunit','names','notes','-v7')
  %catch
  %  % Save in default MATLAB filetype
  %  save (filename,'array','scale','start','xdiff','xunit',...
  %                 'yunit','names','notes','-mat')
  %end

  % File format version 2
  % Much more efficient data storage
  % Transpose data array to row-major order so that dimensions are consistent with
  % the char array of names
  array = array';
  start = array(:,1);

  % Transform data array by representing it as difference values
  % - approximate first derivative
  array = diff(array,1,2);

  % Check sampling properties of the X dimension
  if any(diff(array(1,:)) > 1.192093e-07)
    % Variable sampling interval
    xdiff = 0;
    xname = '';
  else
    % Constant sampling interval
    if abs(start(1))>0
      warning('Timebase offset will be reset to zero','TimeOffset') %#ok<*CTPCT>
    end
    xdiff = array(1,1);
    array(1,:) = [];
    xname = names(1);
    names = names(2:end);
    start(1)=[];
  end

  % Scale each row of the transformed data array by a power-of-2 scaling factor
  % Power of 2 scaling is more computationally efficient
  % Use int16 datatype for efficient storage
  % Use int32 datatype for precision
  nrows = size(array,1);
  for i=1:nrows
    maxval = max(abs(array(i,:)));
    if strcmpi(datatype,'int16')
      scale(i,1) = fix(log2(32767/maxval));
    elseif strcmpi(datatype,'int32')
      scale(i,1) = fix(log2(2147483647/maxval));
    end
    array(i,:) = array(i,:) * 2^scale(i,1);
  end

  % Change class of variables for more efficient data storage
  % Note that we store the power-of-2 exponent for the scale factor
  start = single(start);
  scale = uint8(scale);
  if strcmpi(datatype,'int16')
    array = int16(round(array));
  elseif strcmpi(datatype,'int32')
    array = int32(round(array));
  end
  xdiff = double(xdiff);
  xname = char(xname);
  names = char(names);
  notes = char(notes);
  xunit = char(xunit);
  yunit = char(yunit);

  % Create variable recording serial number of date and time
  saved = now;

  % Save variables in matlab binary file
  try
    % Save in the HDF5-based MATLAB v7.3 filetype
    save (filename,'array','scale','start','xdiff','xunit',...
                   'xname','yunit','names','notes','saved','-v7.3','-nocompression')
  catch
    % Save in default MATLAB filetype if v7.3 is not option is not available
    save (filename,'array','scale','start','xdiff','xunit',...
                   'xname','yunit','names','notes','saved','-mat')
  end

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,saved] = PHYload (filename)

  % HDF5 matlab binary file
  try
    % The matlab format of the hdf5 is not a strict requirement for saved files
    % Try loading data using hdf5 functions
    array = h5read(filename,'/array');
    xdiff = h5read(filename,'/xdiff');
    xunit = char(h5read(filename,'/xunit'));
    yunit = char(h5read(filename,'/yunit'));
    xname = char(h5read(filename,'/xname'));
    names = char(h5read(filename,'/names'));
    notes = char(h5read(filename,'/notes'));
    scale = h5read(filename,'/scale');
    if isa(array,'int16') || isa(array,'int32')
      saved = h5read(filename,'/saved');
      start = h5read(filename,'/start');
    end
  catch
    % Try loading using matlab's load command, the matlab file maybe version < 7.3
    load(filename); %#ok<*LOAD>
  end


  if isa(array,'single')

    % File format version 1
    % Included for backwards compatibility
    % Convert data array to double precision and transpose to column-
    % major order
    array = double(array)';

    % Round double array to 7 significant figures
    array(array==0) = NaN;
    scale = 10.^floor(log10(abs(array)))*1e-6;
    array = round(array./scale).*scale;
    array(isnan(array)) = 0;

    % Calculate X dimension
    if strcmp(xdiff,'constant')
      x0 = array(1,1);
      delta = array(2,1);
      array(:,1) = delta*[0:size(array,1)-1]'+x0; %#ok<*NBRAK>
    elseif strcmp(xdiff,'variable')
      array(:,1) = cumsum(array(:,1));
    end

  elseif isa(array,'int16') || isa(array,'int32')

    % File format version 2
    % Convert classes of numeric variables and transpose to column-
    % major order
    array = double(array)';
    start = double(start)';
    scale = double(scale)';
    xname = cellstr(xname)';
    names = cellstr(names)';
    notes = cellstr(notes);
    if exist('saved','var')
      saved = datestr(saved,'yyyymmddTHHMMSS');
    else
      saved = '';
    end

    % Calculate power of 2 scale factor
    scale = 2.^scale;

    % Rescale transformed data array
    ncols = size(array,2);
    for i=1:ncols
       array(:,i) = array(:,i)/scale(i);
    end

    % Backtransform data array to real world values
    array = cat(1,start,array);
    array = cumsum(array,1);

    % Calculate X dimension for constant sampling interval
    if xdiff > 0
      x = xdiff * [0:size(array,1)-1]';
      array = cat(2,x,array);
      names = cat(2,xname,names);
    else
      % do nothing
    end

  end

end

%--------------------------------------------------------------------------

function ASCwrite (filename,array,xunit,yunit,names,notes)

  % Delimited text file (ASCII encoding)
  % Similar to TXTwrite but waves are stacked
  % Get number of columns from data array
  ncols = size(array,2);

  % Open a file for writing
  fid = fopen(filename,'w+t','l','US-ASCII');

  % Print data matrix
  % X dimension: 64-bit double precision variables represent data to about
  % 15 significant figures (14 decimal places)
  dataformat = '%.14g';
  % Y dimension: 32-bit single precision variables represent data to about
  % 7 significant figures (6 decimal places)
  dataformat = strcat(dataformat,'\t%.7g\n');
  for i = 2:ncols
    fprintf(fid,dataformat,[array(:,1),array(:,i)]');
  end

  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function TXTwrite (filename,array,xunit,yunit,names,notes,delim) %#ok<*INUSL>

  % Delimited text file (ASCII encoding)
  % Get number of columns from data array
  ncols = size(array,2);

  % Open a file for writing
  fid = fopen(filename,'w+t','l','US-ASCII');

  % Print data matrix
  % X dimension: 64-bit double precision variables represent data to about
  % 15 significant figures (14 decimal places)
  dataformat = '%.14g';
  for i = 1:ncols-1
    % Y dimension: 32-bit single precision variables represent data to about
    % 7 significant figures (6 decimal places)
    if strcmp(delim,'\t')
      dataformat = strcat(dataformat,'\t%.7g');
    elseif strcmp(delim,',')
      dataformat = strcat(dataformat,',%.7g');
    end
  end
  dataformat = strcat(dataformat,'\n');
  fprintf(fid,dataformat,array');

  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes] = TXTread (filename,delim)

  % Delimited text file (ASCII encoding)
  % Read delimited text file
  try
    % Get the data
    array = dlmread(filename,delim,0,0);
    % Evaluate data array dimensions
    ncols = size(array,2);
    % Create blank names and notes variables
    names = '';
    notes = '';
  catch
    try
      % Assume there is a header line to read
      tmpstr = char(textread(filename,'%s',1,'delimiter','\n')); %#ok<*DTXTRD>
      tmp = strread(tmpstr,'%s','delimiter',delim);
      % Get the data
      array = dlmread(filename,delim,1,0);
      % Evaluate data array dimensions
      ncols = size(array,2);
      % Evaluate header line
      if numel(tmp) == ncols
        % Assign header entries to names if the dimensions match
        names = char(tmp);
        notes = '';
      else
        % Otherwise assign the header line to the notes array
        names = '';
        notes = sprintf(tmpstr);
      end
    catch
      error('the text file could not be loaded')
    end
  end

  % Evaluate X dimension
  dx = diff(array(:,1));
  if any(diff(dx) > 1.192093e-07)
    xdiff = 0;
  else
    xdiff = dx(1);
  end

  % If names array is blank, assign an array of question marks to it
  if strcmp(names,'')
    names = char(zeros(ncols,1)+63);
  end

  % Create blank units variables
  xunit = '';
  yunit = '';

end

%--------------------------------------------------------------------------

function ITXwrite (filename,array,xunit,yunit,names,notes)

  % Igor text file (UTF-8 encoding)
  % Evaluate the X dimension
  x0 = array(1,1);
  dx = diff(array(:,1));
  if any(diff(dx) > 1.192093e-07)
    xdiff = 0;
    k = 1;
  else
    delta = dx(1);
    xdiff = delta;
    k = 2;
  end

  % Open a file for writing
  fid = fopen(filename,'w+t','l','UTF-8');

  % Print IGOR keyword header
  fprintf(fid,'IGOR\n');

  % Print WAVES line
  if ~ischar(names)
    names = char(names);
  end
  ncols = size(array,2);
  fprintf(fid,'WAVES');
  for i=k:ncols
    fprintf(fid,strcat('\t',deblank(names(i,:))));
  end
  fprintf(fid,'\n');

  % Print data matrix
  fprintf(fid,'BEGIN\n');
  if k==1
    % X dimension: 64-bit double precision variables represent data to about
    % 15 significant figures (14 decimal places)
    dataformat = '\t%.15g';
  elseif k==2
    % Y dimension: 32-bit single precision variables represent data to about
    % 7 significant figures (6 decimal places)
    dataformat = '\t%.7g';
  end
  for i = k:ncols-1
    % Y dimension: 32-bit single precision variables represent data to about
    % 7 significant figures (6 decimal places)
    dataformat = strcat(dataformat,'\t%.7g');
  end
  dataformat = strcat(dataformat,'\n');
  fprintf(fid,dataformat,array(:,k:ncols)');
  fprintf(fid,'END');
  % Print footer
  for i = k:ncols
    if k==2
      fprintf(fid,'\nX SetScale/P x %g,%g,"%s", %s; ',...
              min(array(:,1)),delta,xunit,deblank(names(i,:)));
    else
      fprintf(fid,'\nX ');
    end
      fprintf(fid,'SetScale/I y %g,%g,"%s", %s',...
              min(array(:,i)),max(array(:,i)),yunit,deblank(names(i,:)));
  end

  % End file with a blank line
  fprintf(fid,'\n');

  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function [waves,xdiff,xunit,yunit,names,notes] = ITXread (filename)

  % Igor text file (UTF-8 encoding)
  % Open a file for reading
  fid = fopen(filename,'r','l','UTF-8');

  % Read IGOR keyword header (with error checking)
  tmp = fgetl(fid);
  tmp = strjust(tmp,'left');
  if regexpi(tmp,'IGOR','once') ~= 1
    error('bad Igor text file. (missing keyword IGOR)')
  end
  tmp(1:4) = [];
  if ~isempty(deblank(tmp))
    error('unknown keyword in Igor Text file')
  end

  % INITIALIZE
  % Start counter for the blocks of data
  block = 0;
  % Start counter for waves in the current data block
  count = 0;
  % Create an empty cell array for the wave names
  names = cell(0);
  % Create an empty cell array for the wave notes
  notes = cell(0);
  % Create an empty cell array for the wave data
  waves = cell(0);
  % Create empty starting index variable
  startidx = [];
  % Create empty delta variable
  delta = [];
  % Create empty x-axis unit variable
  xunit = [];
  % Create empty y-axis unit variable
  yunit = [];

  % Read through the blocks of data
  while (true)
    tmp = fgetl(fid);

    if strcmp(tmp,'')
      % Skip blank line

    elseif all(tmp==-1)
      % End-of-file (EOF) condition breaks from while loop
      break

    elseif ~isempty(regexpi(tmp,'WAVES','once'))
      tmp = strjust(tmp,'left');
      % Step-up data block counter
      block = block + 1;

      % READ WAVES LINE
      % Read WAVE keyword and associated flags (with error checking)
      tmp(1:5) = '';
      pat = '([,\s]*/\s*[^''N\s]*)*';
      [junk,eop] = regexpi(tmp,pat,'once');
      tmpstr = tmp(1:eop);
      tmp(1:eop) = [];

      % Check for unknown flags
      pat = '[^/ORCSDIWBUT\s]*';
      if ~isempty(regexpi(tmpstr,pat))
        error('unknown flag')
      end

      % Issue warnings/errors for unsupported flags
      if ~isempty(regexpi(tmpstr,'T','once'))
        error('text waves are not supported')
      end
      pat = '[RCSIWBU]*';
      if ~isempty(regexpi(tmpstr,pat))
        warning(['ignoring WAVES flags;'...
                 ' data loaded as double precision floating point.'])
      end

      % Read wave dimensions flag
      if strcmpi(tmp(1),'N')
        pat = 'N\s*=\s*\(.+\)';
        [junk,eop] = regexpi(tmp,pat,'once');
        tmpstr = tmp(1:eop);
        tmp(1:eop) = [];
        pat = 'N\s*=\s*\(\s*\d+\s*(,\s*\d+\s*)*)';
        if isempty(regexpi(tmpstr,pat,'once'))
          error(['WAVES declaration error; '...
                 ' improper specification of wave dimension sizes'])
        end
        pat = 'N\s*=\s*\(\s*\d+\s*(,\s*\d+\s*)+)';
        %if ~isempty(regexpi(tmpstr,pat,'once'))
        %  error('multidimensional waves not supported')
        %end
      end

      % Check WAVES line for illegal characters (liberal wave name rules)
      if regexp(tmp,'[";:]+','once')
        error('bad symbol on WAVES line')
      end
      numqts = numel(regexp(tmp,''''));

      % An even number of single quotes are expected on the WAVES line
      if ~isempty(numqts)
        if (numqts/2~=ceil(numqts/2))
          error('bad symbol on WAVES line')
        end
      end

      % Get wave names
      count = 0;
      tmpstr = '';
      while (true)
        % Break from while loop if remaining WAVES line is empty
        if isempty(tmp)
          break
        end
        % Break from while loop if remaining WAVES line contains only delimiters
        if strcmp(regexprep(tmp,'['',\s]','','once'),'')
          break
        end
        % Find the position of the next standard and liberal wave names
        nxtstd = regexp(tmp,'[^'',\s]','once')-1;
        if isempty(nxtstd)
          nxtstd = inf;
        end
        nxtlib = regexp(tmp,'''','once')-1;
        if isempty(nxtlib)
          nxtlib = inf;
        end
        % Check for unrecognised characters trailing the WAVES line
        if isinf(nxtstd) && isinf(nxtlib)
          error('bad symbol on WAVES line')
        end
        % Check for illegal characters between wave names
        delim = tmp(1:min(nxtlib,nxtstd));
        delim = regexprep(delim,',',' ','once');
        if ~isempty(regexp(delim,'\S','ONCE'))
          error('bad symbol on WAVES line')
        end
        % Remove wave name delimiter
        tmp(1:min(nxtlib,nxtstd)) = '';
        % Fetch next wavename
        if nxtstd < nxtlib
          % Standard wave names separated by a comma, tabs or spaces
          [tmpstr,tmp] = strtok(tmp,[',' char(9) char(32)]); %#ok<*STTOK>
          % Check that the wave name contains no illegal characters
          if ~isempty(regexp(tmpstr,'\W','ONCE'))
            error('bad symbol on WAVES line')
          end
          % Check that the wave name starts with a letter
          if isempty(regexpi(tmpstr(1),'[A-Z]'))
            error('bad symbol on WAVES line')
          end
        else
          % Liberal wave name rules implied by opening quotation mark
          [tmpstr,tmp] = strtok(tmp,'''');
          % Remove closing quotation mark left on WAVES line
          tmp(1) = '';
        end
        if isempty(names)
          names{1,1} = tmpstr;
        else
          names{end+1,1} = tmpstr;
        end
        % Step-up wave counter for current block of data
        count = 1+count;
      end

      % Check that the next line is the BEGIN keyword
      tmp = fgetl(fid);
      tmp = strjust(tmp,'left');
      if regexpi(tmp,'BEGIN','once') ~= 1
        error('expected BEGIN keyword after WAVES in Igor text file')
      end
      tmp(1:5) = [];
      if ~isempty(deblank(tmp))
        warning('data detected on BEGIN line will be ignored')
      end

      % Get the data for the current block
      tmpdata = fscanf(fid,'%g',[count,inf])';

      % Add data block to the data array
      waves{block} = tmpdata;

      % Check that the next line is the END statement of a data block
      tmp=fgetl(fid);
      tmp = strjust(tmp,'left');
      if regexpi(tmp,'END','once') ~= 1
        error('expected END keyword after data block in Igor text file')
      end

    elseif ~isempty(regexpi(tmp,'X\s+SetScale','once'))
      tmp = regexprep(tmp,'X\s*','','once','ignorecase');
      n = numel(regexpi(tmp,'SetScale'));

      % READ SETSCALE COMMANDS
      for i = 1:n
        [tmpstr,tmp] = strtok(tmp,';');
        tmparr = cell(0);
        for j = 1:5
          [tmparr{j},tmpstr] = strtok(tmpstr,[',' char(9) char(32)]);
        end
        [tmparr{j+1},tmpstr] = strtok(tmpstr,';');

        % SetScale for the X dimension
        if strcmpi(tmparr{2},'x')
          if isempty(delta) && ~isempty(startidx)
            error('conflicting calls to SetScale for the x dimension')
          end
          % Assume per point scaling (/P) for the x dimension
          if isempty(regexpi(tmparr{1},'SetScale\s*/\s*P','once'))
            error('per point scaling only is supported for the x dimension')
          end
          % num1 is starting index value
          num1 = tmparr{3};
          if isempty(startidx)
            startidx = eval(char(num1));
          else
            if startidx ~= eval(char(num1))
              error(['the starting index value for the X dimension is'...
                     ' not the same for all waves'])
            end
          end
          % num2 is the delta value
          num2 = tmparr{4};
          if isempty(delta)
            % Set the delta variable since it is undefined
            if strcmp(num2,'0')
              % Set delta to 1 if num2 is 0
              delta = 1;
            else
              delta = eval(char(num2));
            end
          else
            % Check that the value of num2 matches the delta variable
            if delta ~= eval(char(num2))
              error(['the delta value for the X dimension is not the'...
                     ' same for all waves'])
            end
          end
          % Read units of the X dimension
          if ~isempty(regexpi(tmparr{5},'".*"','once'))
            if isempty(xunit)
              % Set the X dimension unit since it is undefined
              xunit = tmparr{5}(2:end-1);
              if isempty(xunit)
                xunit = 'ms'; % defaults is ms
              end
            else
              if ~isempty(tmparr{5}(2:end-1))
                if ~strcmp(tmparr{5}(2:end-1),xunit)
                  error(['the unit for the X dimension is not the same'...
                         ' for all waves'])
                end
              end
            end
          end

        % SetScale for the Y dimension
        elseif strcmpi(tmparr{2},'y')
          %if ~isempty(regexpi(tmparr{1},'SetScale\s*/\s*P','once'))
          %  error('inclusive or data full scaling only is supported for the Y dimension')
          %end
          % Read units of the Y dimension
          if ~isempty(regexpi(tmparr{5},'".*"','once'))
            if isempty(xunit)
              % Set the X dimension unit since it is undefined
              xunit = tmparr{5}(2:end-1);
              startidx = waves{1}(1,1);
              delta = [];
              if isempty(regexp(tmparr{6},names{1},'once'))
                error('the first wave must define the X dimension units')
              end
              fprintf('ephysIO: The SetScale command did not define the X dimension.\n');
              fprintf('ephySIO: The first wave was assigned to the X dimension instead.\n');
            elseif isempty(yunit)
              % Set the Y dimension unit since it is undefined
              yunit = tmparr{5}(2:end-1);
            elseif ~strcmp(tmparr{5}(2:end-1),yunit)
              warning(['the unit for the Y dimension is not the same for'...
                       ' all waves'])
            end
            if strcmp(xunit,'dat') || strcmp(yunit,'dat')
              error('date/time waves are not supported')
            end
          end

        elseif strcmpi(tmparr{2},'t')
          error('SetScale for the chunks dimension is not supported')

        elseif strcmpi(tmparr{2},'z')
          error('SetScale for the layers dimension is not supported')
        end
      end

    else

      % Record Igor commands etc into notes cell array else skip the line
      if ~isempty(regexpi(tmp,'X\s+','once'))
        if isempty(notes)
          notes{1,1} = sprintf(tmp);
        else
          notes{end+1,1} = sprintf(tmp);
        end
      end

    end
  end
  fclose(fid);

  % Combine waves
  waves = cells2mat(waves);
  %try
  %  waves = cell2mat(waves);
  %catch
  %  error('the number of samples is not the same for all waves')
  %end

  % Evaluate the X dimension
  if ~isempty(startidx) && ~isempty(delta)
    % Create x axis and add as first column of data array using startidx and delta
    waves = cat(2,[startidx:delta:startidx+(delta*(size(waves,1)-1))]',waves);
    xdiff = delta;
    if strcmp(xunit,'s')
      xdim{1} = 'Time';
    else
      xdim{1} = 'XWave';
    end
    names = cat(1,xdim,names);
  else
    dx = diff(waves(:,1));
    if any(diff(dx) > 1.192093e-07)
      xdiff = 0;
    else
      xdiff = dx(1);
    end
  end
  names = char(names);
  if isempty(xunit)
    xunit = '';
  end
  if isempty(yunit)
    yunit = '';
  end

end

%--------------------------------------------------------------------------

function ATFwrite (filename,array,xunit,yunit,names,notes)

  % Axon text file (UTF-8 encoding)
  % Get number of columns from data array
  ncols = size(array,2);
  nopth = 0;

  % Allocate unit and scale data appropriately
  if strcmp(xunit,'s')
    array(:,1) =  array(:,1)*1e+3;
    xunit = 'ms';
    names{1} = 'Time';
  elseif strcmp(xunit,'A')
    array(:,1) =  array(:,1)*1e+12;
    xunit = 'pA';
  elseif strcmp(xunit,'V')
    array(:,1) =  array(:,1)*1e+3;
    xunit = 'mV';
  else
    % Do nothing
  end
  if strcmp(yunit,'s')
    array(:,2:end) = array(:,2:end)*1e+3;
    yunit = 'ms';
  elseif strcmp(yunit,'A')
    array(:,2:end) = array(:,2:end)*1e+12;
    yunit = 'pA';
  elseif strcmp(yunit,'V')
    array(:,2:end) = array(:,2:end)*1e+3;
    yunit = 'mV';
  else
    % Do nothing
  end

  % Open a file for writing
  fid = fopen(filename,'w+t','l','UTF-8');

  % Print first header
  fprintf(fid,'ATF\t1.0\n');

  % Print second header
  fprintf(fid,'%d\t%d\n',nopth,ncols);

  % Print column titles
  if ischar(names)
    names = cellstr(names);
  end
  fprintf(fid,'%s (%s)',deblank(names{1}),xunit);
  for i = 2:ncols
    fprintf(fid,'\t%s (%s)',deblank(names{i}),yunit);
  end
  fprintf(fid,'\n');

  % Print data matrix
  % X dimension: 64-bit double precision variables represent data to about
  % 15 significant figures (14 decimal places)
  dataformat = '%.14g';
  for i = 1:ncols-1
    % Y dimension: 32-bit single precision variables represent data to about
    % 7 significant figures (6 decimal places)
    dataformat = strcat(dataformat,'\t%.7g');
  end
  dataformat = strcat(dataformat,'\n');
  fprintf(fid,dataformat,array');

  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes] = ATFread (filename)

  % Axon text file (UTF-8 encoding)
  % Open a file for reading
  fid = fopen(filename,'r','l','UTF-8');

  % Read ATF keyword header
  tmp = fgetl(fid);
  tmpstr = strtok(tmp,char(9));
  if ~strcmp(tmpstr,'ATF')
    error('the file is not in tab-delimited Axon text format')
  end

  % Read the no. of optional headers and data columns from the 2nd header line
  tmp = fgetl(fid);
  tmpvec = sscanf(tmp,'%d');
  nopth = tmpvec(1);
  ncols = tmpvec(2);

  % Read all optional headers into notes array
  notes = cell(0);
  if nopth > 0
    for i = 1:nopth
      notes{i,1} = sprintf(fgetl(fid));
    end
  end
  notes = char(notes);

  % Get column titles and units
  tmp = fgets(fid);
  count = 0;
  tmpstr = '';
  names = cell(0);
  yunit = cell(0);
  while (true)
    % Break from while loop if remaining column titles line is empty
    if isempty(tmp)
      break
    end
    % Break from while loop if remaining column titles line contains
    % only trailing field separators, spaces and/or closing brackets
    if strcmp(regexprep(tmp,'[,\s)]',''),'')
      break
    end
    % Find the position of the next word character and next double quote
    nxtwrd = regexp(tmp,'[\w]','once')-1;
    if isempty(nxtwrd)
      nxtwrd = inf;
    end
    nxtqte = regexp(tmp,'["]','once');
    if isempty(nxtqte)
      nxtqte = inf;
    end
    % Remove field separator(s)
    tmp(1:min(nxtqte,nxtwrd)) = '';
    % Fetch next column title
    if nxtwrd < nxtqte
      % Find the next nearest field delimiter
      nxtdlm = regexp(tmp,'[),\t"\n]','once');
      % Unquoted column title (with units if applicable)
      tmpstr = deblank(tmp(1:nxtdlm-1));
      tmp(1:nxtdlm-1)='';
    else
      % Find the next nearest field delimiter
      nxtdlm = regexp(tmp,'[)"\n]','once');
      % Quoted column title (with units if applicable)
      tmpstr = deblank(tmp(1:nxtdlm-1));
      tmp(1:nxtdlm-1)='';
      % Remove closing quotation mark
      nxtqte = regexp(tmp,'["]','once');
      tmp(1:nxtqte)='';
    end
    if count == 0
      [tmpstr,rem] = strtok(tmpstr,'(');
      if isempty(rem)
        xunit = '';
      else
        xunit = regexprep(rem,'(\s*','');
      end
    else
      [tmpstr,rem] = strtok(tmpstr,'(');
      if isempty(rem)
        yunit{count,1} = '';
      else
        yunit{count,1} = regexprep(rem,'(\s*','');
      end
    end
    names{count+1,1} = strtrim(strjust(tmpstr,'left'));
    % Step-up column counter
    count = 1+count;
  end
  if all(strcmp(yunit,yunit{1}))
    yunit = yunit{1};
  else
    warning(['the unit for the Y dimension is not the same for'...
             ' all y columns'])
  end
  if numel(names) ~= ncols
    error('the number of column titles does not match the data array')
  end
  names = char(names);

  % Get the data array
  array = fscanf(fid,'%g',[ncols,inf])';

  % Evaluate X dimension
  dx = diff(array(:,1));
  if any(diff(dx) > 1.192093e-07)
    xdiff = 0;
  else
    xdiff = dx(1);
  end
       
  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist,ch] = MAload (filename,ch)

  % ACQ4 HDF5 binary file
  % Only suitable for reading 'Clamp' files
  % Read Metadata (requires readMeta.m file from 'acq4/pyqtgraph/metaarray.readMeta.m')
  if strcmp(filename(1:5),'Patch') || strcmp(filename(1:4),'Stim')
    error('the file is not a clamp recording trace')
  end

  metadata = readMeta(filename);
  if (numel(metadata) < 3)
    error('the file is not a clamp recording trace')
  end
  
  % Autoselect primary channel if user sets channel number to 0 or []
  if (ischar (ch))
    ch = find (strcmpi (cellfun(@(c) c.name, metadata{1}.cols, ...
                        'UniformOutput', false), ...
                        sprintf ('''%s''', ch)));
    if (isempty (ch))
      error ('channel name not recognised')
    end
  else    
    if (isempty (ch) || (ch == 0))
      ch = find (strcmpi (cellfun(@(c) c.name, metadata{1}.cols, ...
                          'UniformOutput', false), '''primary'''));
    end
    if (isempty (ch))
      error ('no channel is named ''primary''')
    end
  end

  % Read units for x and y axes
  xunit = metadata{2}.units(2);
  numChannels = numel(metadata{1}.cols);
  if ch > numChannels
    error('channel number out of range');
  end
  yunit = metadata{1}.cols{ch}.units(2:end-1);

  % Read x-axis name into names array
  names = cell(0);
  names{1,1} = regexprep(metadata{2}.name,'''','');

  % Read data
  clist = cell(1);
  fprintf('Number of recording channels: %d\n',numChannels); % not counting command channel
  for i = 1:numChannels  % ignoring the command channel
      clist{i,1} = regexprep(metadata{1}.cols{i}.name,'''','');
      fprintf('%d) %s\n',i,clist{i})
  end
  fprintf('loading channel %d...\n',ch)
  filepath = pwd;
  data = h5read(filename,'/data');
  l = size(data,1);
  array = zeros(l,2);
  array(:,1) = metadata{2}.values;
  array(:,2) = data(:,ch);
  names{2,1} = strcat('YWave',filepath(end-2:end));
  if strcmp(filepath(end-2:end),'000')
    cd ..
    count = 1;
    exitflag = 0;
    while exitflag < 1
      data=[];
      dirname = strcat('00',num2str(count));
      dirname = dirname(end-2:end);
      if exist(dirname,'dir')
        cd(dirname);
        try
          data = h5read(filename,'/data');
        catch
          data = zeros(l,numChannels);
        end
        array = cat(2,array,data(:,ch));
        names{count+2,1} = strcat('YWave',dirname);
        count = count + 1;
        cd ..
      else
        exitflag = 1;
      end
    end
    cd('000');
  else
    % Do nothing
  end

  % Evaluate the X dimension
  dx = diff(array(:,1));
  if any(diff(dx) > 1.192093e-07)
    xdiff = 0;
  else
    xdiff = dx(1);
  end

  % Parse metadata into notes array
  try
    % Suitable for older ACQ4 HDF5 data file versions
    notes = cell(0);
    obj = {'ClampState';'ClampParams';'DAQ';'Protocol'};
    for i=1:4
      if i == 2
        notes = cat(1,notes,[obj{i-1},'.',obj{i}]);
        key = fieldnames(metadata{3}.(obj{i-1}).(obj{i}));
        val = struct2cell(metadata{3}.(obj{i-1}).(obj{i}));
      elseif i == 3
        key = fieldnames(metadata{3}.(obj{i}));
        notes = cat(1,notes,[obj{3},'.',char(key(ch))]);
        tmp = struct2cell(metadata{3}.(obj{i}));
        key = fieldnames(tmp{ch});
        val = struct2cell(tmp{ch});
      else
        notes = cat(1,notes,[obj{i}]);
        key = fieldnames(metadata{3}.(obj{i}));
        val = struct2cell(metadata{3}.(obj{i}));
      end
      for j=1:numel(key)
        if ischar(val{j})
          notes = cat(1,notes,sprintf(['  ',char(key(j)),': ',val{j}]));
        elseif isnumeric(val{j})
          notes = cat(1,notes,sprintf(['  ',char(key(j)),': ',num2str(val{j})]));
        else
          % Do nothing
        end
      end
    end
  catch
    % Metadata organization has changed in newer versions of ACQ4 HDF5 data files
    % For now, leave notes array empty until further development
    notes = cell(0);
  end

  % Convert list of wave names to character array
  names = char(names);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = H5load (filename,ch)

  % Stimfit HDF5 binary file
  % Not supported anymore, load *.h5 is reserved for WaveSurfer
  % Fetch recording attributes
  rec_attrs = h5read(filename,'/description');
  n_channels = double(rec_attrs.channels);
  if ch > n_channels
    error('channel number out of range');
  end
  info = h5info(filename);
  groups = {info.Groups.Name};
  fprintf('Number of recording channels: %d\n',n_channels);
  for i = 1:n_channels
      fprintf('%d) %s\n',i,groups{i}(2:end))
  end
  fprintf('loading channel %d...\n',ch)
  clist = groups(1:n_channels);
  clist = clist(:);

  % Fetch channel attributes
  ch_attrs = h5read(filename,[groups{ch} '/description']);
  n_sections = double(ch_attrs.n_sections);

  % Fetch data
  names = cell(0);
  k = numel(num2str(n_sections));
  for i = 1:n_sections
     section = ['/section_' pad(num2str(i-1),k,'left','0')];
     path2sec = strcat(groups{ch},section,'/data');
     data = h5read(filename,path2sec);
     if i==1
       nrows = numel(data);
       array = zeros(nrows,n_sections);
       array(:,1) = data;
       path2attrs = strcat(groups{ch},section,'/description');
       sec_attrs = h5read(filename,path2attrs);
       % Parse section attributes
       dt = double(sec_attrs.dt);
       xdiff = dt;
       xunit = transpose(sec_attrs.xunits(:));
       yunit = transpose(sec_attrs.yunits(:));
     else
       % Check that the section attributes conform to the first section
       if numel(data)~=nrows
         error('the number of samples is not the same for all sections')
       end
       path2attrs = strcat(groups{ch},section,'/description');
       sec_attrs = h5read(filename,path2attrs);
       if double(sec_attrs.dt)~=dt
         error(['the delta value for the X dimension is not the'...
                ' same for all sections'])
       end
       if ~strcmp(transpose(sec_attrs.xunits(:)),xunit)
         error(['the unit for the X dimension is not the same for'...
                ' all sections'])
       end
       if ~strcmp(transpose(sec_attrs.yunits(:)),yunit)
         warning(['the unit for the Y dimension is not the same for'...
                ' all sections'])
       end
       array(:,i) = data;
     end
     names{i+1,1} = section;
     data = [];
  end

  % Construct X dimension and add it to the data array
  x = dt*[0:nrows-1]';
  array = cat(2,x,array);
  names{1} = 'Time';

  % Scale dimenions
  if strcmp(xunit,'ms')
    array(:,1) = 1e-3*array(:,1);
    xdiff = 1e-3*xdiff;
    xunit = 's';
  end
  if strcmp(yunit,'pA')
    array(:,2:end) = 1e-12*array(:,2:end);
    yunit = 'A';
  elseif strcmp(yunit,'mV')
    array(:,2:end) = 1e-3*array(:,2:end);
    yunit = 'V';
  end

  % Create empty notes cell array
  notes = cell(0);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes] = IBWload (filename)

  % IGOR Binary wave
  % IBWread helper function to get data from Igor binary wave
  S = IBWread (filename);

  % Create x axis and add as first column of data array
  array = cat(2,[S.x0(1):S.dx(1):S.x0(1)+(S.dx(1)*(S.Nsam-1))]',S.y);
  xdiff = S.dx(1);

  % Create blank notes variable
  try
    notes = S.WaveNotes;
    tmparr = strread(S.WaveNotes,'%s','delimiter','\n:'); %#ok<*DSTRRD>
  catch
    notes = {};
    tmparr = {};
  end

  % Get X dimension units
  try
    if isfield(S.waveHeader,'xUnits')
      xunit = regexprep(S.waveHeader.xUnits,{'[''\s]',char(0)},'');
    elseif isfield(S.waveHeader,'dimUnits')
      xunit = regexprep(S.waveHeader.dimUnits,{'[''\s]',char(0)},'');
    end
    if isempty(xunit)
      error('invoke catch statement')
    end
  catch
    xunit = strtrim(tmparr(find(strcmpi(tmparr,'xLabel'))+1));
    if isempty(xunit)
      xunit = 'ms'; % defaults is ms
    end
  end
  if iscell(xunit)
    xunit = xunit{1};
  end
  xunit = strtrim(xunit);

  % Get Y dimension units
  try
    yunit = strtrim(regexprep(S.waveHeader.dataUnits,'''',''));
    if isempty(yunit)
      error('invoke catch statement')
    end
  catch
    yunit = tmparr(find(strcmpi(tmparr,'yLabel'))+1);
    if isempty(yunit)
      yunit='';
    end
  end
  if iscell(xunit)
    yunit = yunit{1};
  end
  if numel(regexp((yunit),'[()]')) > 0
    yunit = extractBetween(yunit,'(',')');
  end
  if iscell(yunit)
    yunit = yunit{1};
  end
  yunit = strtrim(regexprep(yunit,'''',''));

  % Get X and Y dimension names
  names = cell(1,2);
  if strcmp(xunit,'s')
    names{1} = 'Time';
  else
    names{1} = 'XWave';
  end
  names{2} = S.bname;

  notes = sprintf('Date created: %d-%d-%d',[S.creationDate(1:3)]);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes] = PXPload (filename)

  % Igor Pro packed experimental binary files
  fid = fopen(filename,'r');
  D = dir(filename);
  fileSize = D.bytes;
  recordStartPos = 0;
  header=cell(1);
  count=0;
  y = {};
  names = {};
  % Loop through records to extract wave data
  while recordStartPos < fileSize
    fseek(fid,recordStartPos,'bof');

    % Read header
    recordType = fread(fid,1,'uint16');
    version = fread(fid,1,'int16');
    numDataBytes =  fread(fid,1,'int32');

    % Record type 3 is wave record
    if recordType == 3
      S = IBWread(filename,ftell(fid));
      % Only analyse data waves with defined x-units
      if isfield(S.waveHeader,'xUnits')
        tmp = deblank(regexprep(S.waveHeader.xUnits,'''',''));
      elseif isfield(S.waveHeader,'dimUnits')
        tmp = deblank(regexprep(S.waveHeader.dimUnits,'''',''));
      end
      if ( S.waveHeader.type > 0 ) && ~isempty(tmp)
        count = count + 1;
        if count==1
          xdiff = S.dx;
          xstart = S.x0;
          Nsam = S.Nsam;
          xunit = tmp;
          yunit = deblank(regexprep(S.waveHeader.dataUnits,'''',''));
          names{1} = 'Time';
          names{2} = S.bname;
        else
          if xdiff ~= S.dx
            error(['the delta value for the X dimension is not the'...
                   ' same for all waves'])
          end
          if ~strcmp(xunit,tmp)
            error(['the unit for the X dimension is not the same for'...
                   ' all waves'])
          end
          if ~strcmp(yunit,deblank(regexprep(S.waveHeader.dataUnits,'''','')))
            warning(['the unit for the Y dimension is not the same for'...
                   ' all waves'])
          end
          names{count+1} = S.bname;
        end
        y{count} = S.y;
      end
    end

    % Set new record start position
    recordStartPos=ftell(fid)+numDataBytes;
  end

  % Calculate x axis
  y = cells2mat(y);
  try
    x = [xstart:xdiff:xstart+(xdiff*(size(y,1)-1))]';
  catch
    x = [0:xdiff:0+(xdiff*(size(y,1)-1))]';
  end
  array = cat(2,x,y);

  % Return empty notes
  notes = '';

  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = ABF2load (filename,ch)

  % Axon binary file (versions 1 and 2)
  [d,si,h] = abfload(filename);

  % Evaluate the recording channels
  fprintf('Number of recording channels: %d\n',h.nADCNumChannels);
  for i = 1:h.nADCNumChannels
    fprintf('%d) %s\n',i,h.recChNames{i});
  end
  clist = h.recChNames;
  fprintf('loading channel %d...\n',ch)
  if ch > h.nADCNumChannels
    error('channel number out of range')
  end

  % Get data for the selected recording channel
  if h.nOperationMode == 3
    array = d(:,ch);
  else
    array = reshape(d(:,ch,:),h.dataPtsPerChan,h.lActualEpisodes);
  end
  if ~isfield(h,'fADCSecondSampleInterval')
    h.fADCSecondSampleInterval = 0;
  end
  if h.fADCSecondSampleInterval > 0
    % Split clock sampling
    si1 = h.fADCSampleInterval*h.nADCNumChannels*1e-6;
    si2 = h.fADCSecondSampleInterval*h.nADCNumChannels*1e-6;
    if (h.lClockChange==0)
      split = 0.5*h.lNumSamplesPerEpisode/h.nADCNumChannels;
    else
      split = h.lClockChange;
    end
    x = ones(h.dataPtsPerChan-1,1);
    x(1:split) = si1;
    x(split+1:end) = si2;
    x = cat(1,0,x);
    x = cumsum(x);
    xdiff = 0;
  else
    si = si*1e-6;
    xdiff = si;
    x = [0:si:si*(h.dataPtsPerChan-1)]';
  end
  array = cat(2,x,array);
  xunit = 's';
  yunit = strjust(h.recChUnits{ch},'left');
  notes = '';

  % Assign question marks to character array of column names
  ncols = size(array,2);
  names = char(zeros(ncols,1)+63);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = WCPload (filename,ch)

  % WinWCP binary file
  [data] = import_wcp(filename);

  % Evaluate the recording channels
  clist = cell(1);
  fprintf('Number of recording channels: %d\n',data.channel_no);
  for i = 1:data.channel_no
    fprintf('%d) %s\n',i,data.channel_info{i}.name);
    clist{i,1} = data.channel_info{i}.name;
  end
  fprintf('loading channel %d...\n',ch)
  if ch > data.channel_no
    error('channel number out of range')
  end

  % Get data for the selected recording channel
  array = cat(2,data.T',data.S{ch});
  xdiff = data.t_interval;
  xunit = 's';
  yunit = data.channel_info{ch}.unit;
  notes = data.time;

  % Assign question marks to character array of column names
  ncols = max(data.rec_index)+1;
  names = char(zeros(ncols,1)+63);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = EDRload (filename,ch)

  % WinEDR binary file
  % Read header
  EDR=[];
  fid = fopen(filename,'r','ieee-le','latin1');
  tline = fgetl(fid);
  while length(tline)<200 % better condition here?
    in=find(tline=='=');
    if not(isempty(in))
      pre=tline(1:in-1);
      post=tline(in+1:end);
      switch pre
        case('VER')
          EDR.version=str2double(post);
        case('CTIME')
          EDR.ctime=post;
        case('NC')
          EDR.nc=str2double(post);
        case('NBH')
          EDR.nbh=str2double(post);
        case('AD')
          EDR.ad=str2double(post);
        case('ADCMAX')
          EDR.adcmax=str2double(post);
        case('NP')
          EDR.np=str2double(post);
        case('DT')
          EDR.dt=str2double(post);
        case('TU')
          EDR.tu=post;
        case('ID')
          EDR.id=post;
      end
      switch(pre(1:2))
        case('YN')
          N=str2double(pre(3));
          EDR.channel_info{N+1}.yn=post;
        case('YU')
          N=str2double(pre(3));
          EDR.channel_info{N+1}.yu=post;
        case('YZ')
          N=str2double(pre(3));
          EDR.channel_info{N+1}.yz=str2double(post);
        case('YO')
          N=str2double(pre(3));
          EDR.channel_info{N+1}.yo=str2double(post);
      end
      if numel(pre)>2
        switch(pre(1:3))
          case('YCF')
            N=str2double(pre(4));
            EDR.channel_info{N+1}.ycf=str2double(post);
          case('YAG')
            N=str2double(pre(4));
            EDR.channel_info{N+1}.yag=str2double(post);
        end
      end
      % disp(tline)
      tline = fgetl(fid);
    end
  end
  % Read data
  db_pos=EDR.nbh; % position of data block
  fseek(fid,db_pos,'bof');
  DB=fread(fid,[EDR.nc,EDR.np],'*int16');
  DAB=double(DB);
  if isempty(DAB)
    error('no data in file')
  end

  % Evaluate the recording channels
  clist = cell(1);
  fprintf('Number of recording channels: %d\n',EDR.nc);
  for i = 1:EDR.nc
    fprintf('%d) %s\n',i,EDR.channel_info{i}.yn);
    clist{i,1} = EDR.channel_info{i}.yn;
  end
  fprintf('loading channel %d...\n',ch)
  if ch > EDR.nc
    error('channel number out of range')
  end

  % Reformat data
  % Create time vector
  T=(0:1:size(DAB,2)-1)*EDR.dt;
  % Convert y data to physical units
  clear S
  S=cell(1,EDR.nc);
  for j=1:EDR.nc
    S{j} = ( DAB(j,:) - EDR.channel_info{j}.yz ) * ...
           ( EDR.ad / (EDR.channel_info{j}.ycf * ...
           EDR.channel_info{j}.yag *...
           (EDR.adcmax + 1)));
  end

  % Create output
  array = cat(2,T',S{ch}');
  xdiff = EDR.dt;
  if isfield(EDR,'tu')
    xunit = EDR.tu;
  else
    xunit = 's';
  end
  yunit = EDR.channel_info{ch}.yu;
  names = char(zeros(2,1)+63);
  notes = EDR.ctime;
              
  % Close file identifier
  fclose(fid);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,ch_names] = AXOload (filename,ch)

  % Axograph X binary file
  [data, time, meta] = importaxo(filename);

  if meta.NumEpisodes > 1
    error('ephysIO does not support recordings with multiple episodes')
  end
  ch_names = strsplit(meta.Channels{1},{'"'});
  ch_names = cellfun(@strtrim,ch_names,'UniformOutput',0);
  %ch_names(find(cellfun(@isempty,ch_names)))=[];
  ch_names(cellfun(@isempty,ch_names))=[];
  nChannels = numel(ch_names);

  % Evaluate the recording channels
  fprintf('Number of recording channels: %d\n',nChannels);
  for i = 1:nChannels
    fprintf('%d) %s\n',i,ch_names{i});
  end
  fprintf('loading channel %d...\n',ch)
  if ch > nChannels
    error('channel number out of range')
  end

  % Get data for the selected recording channel
  nWaves = numel(data)/nChannels;
  data = cells2mat(data)';
  array = cat(2,time',data(:,ch:nChannels:end));
  xdiff = meta.SampInt;
  xunit = extractBetween(meta.XTitle,'(',')');
  xunit = xunit{1};
  yunit = extractBetween([meta.YDat.YTitle],'(',')');
  yunit = yunit{ch};
  notes = meta.Info;

  % Assign question marks to character array of column names
  ncols = nWaves+1;
  names = char(zeros(ncols,1)+63);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = WSload (filename,ch)

  % WaveSurfer HDF5 file
  % Load at single precision (platform independent; does not require MEX)
  S = loadDataFile(filename,'single');
  nChannels = numel(S.header.AIChannelNames);

  % Evaluate the recording channels
  fprintf('Number of recording channels: %d\n',nChannels);
  clist = cell(1);
  for i = 1:nChannels
    fprintf('%d) %s\n',i,S.header.AIChannelNames{i});
    clist{i,1} = S.header.AIChannelNames{i};
  end
  fprintf('loading channel %d...\n',ch)
  if ch > nChannels
    error('channel number out of range')
  end

  % Get data for the selected recording channel
  nWaves = S.header.NSweepsPerRun;
  for i = 1:nWaves
    sweep = sprintf('S.sweep_%s.analogScans(:,ch)',pad(num2str(i),4,'left','0'));
    array{i} = eval(sweep);
  end
  array = cells2mat(array);
  xdiff = 1/S.header.AcquisitionSampleRate;
  x = [0:xdiff:xdiff*(size(array,1)-1)]';
  array = cat(2,x,array);
  xunit = 's';
  yunit = S.header.AIChannelUnits{ch};
  notes = sprintf('Date created: %d-%d-%d',[S.header.ClockAtRunStart(1:3)]);

  % Assign question marks to character array of column names
  ncols = nWaves+1;
  names = char(zeros(ncols,1)+63);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,recChNames] = HEKAload (filename,ch)

  % HEKA PatchMaster, Pulse and ChartMaster binary file
  [matData, meta, nseries] = ImportHEKA(filename);
  recChNames=cell(1);
  nChannels=0;
  for i=1:nseries
    if nChannels > 0
      newChFlag = 1;
      for j=1:nChannels
        if strcmpi(recChNames{j},meta{i}.title)
          newChFlag=0;
        end
      end
    else
      newChFlag = 1;
    end
    if newChFlag>0
      nChannels = nChannels + 1;
      recChNames{nChannels,1} = meta{i}.title;
    end
  end
  nChannels = numel(recChNames);
  % Evaluate the recording channels
  fprintf('Number of recording channels: %d\n',nChannels);
  for i = 1:nChannels
    fprintf('%d) %s\n',i,recChNames{i});
  end
  fprintf('loading channel %d...\n',ch)
  if ch > nChannels
    error('channel number out of range')
  end
  xdiff=[];
  yunit='';
  for i=1:nseries
    if strcmp(recChNames{ch},meta{i}.title)
      if isempty(xdiff)
        xdiff = prod(meta{i}.adc.SampleInterval);
      else
        if xdiff ~= prod(meta{i}.adc.SampleInterval)
          error(['the delta value for the X dimension is not the'...
                 ' same for all waves'])
        end
      end
      if isempty(yunit)
        yunit = meta{i}.adc.Units;
      else
        if yunit ~= meta{i}.adc.Units
          warning(['the unit for the Y dimension is not the same for'...
                   ' all waves in the selected channel'])
        end
      end
    else
      matData{1}{i} = [];
    end
  end
  array = cells2mat(matData{1});
  nWaves = size(array,2);
  x = [0:xdiff:xdiff*(size(array,1)-1)]';
  array = cat(2,x,array);
  xunit = 's';
  notes = '';

  % Assign question marks to character array of column names
  ncols = nWaves+1;
  names = char(zeros(ncols,1)+63);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = CFSload (filename,ch)

  % CED Signal CFS binary file
  % Evaluate the recording channels
  if ~ispc
    error('ephysIO support for CED files is limited to Windows platforms')
  end
  READONLY = 0;
  if strcmp(computer('arch'),'win32')
    fname='MATCFS32';
  elseif strcmp(computer('arch'),'win64')
    fname='matcfs64c';
  end
  try
    ret = eval([fname,'(''cfsCloseFile'',15)']);
  catch
  end
  [fhandle] = eval([fname,'(''cfsOpenFile'',filename,READONLY,0)']);
  if (fhandle <0)
    ret = eval([fname,'(''cfsCloseFile'',fhandle)']);
    error('%s had a problem reading the cfs file',fname)
  end
  [time,filedate,comment] = eval([fname,'(''cfsGetGenInfo'',fhandle)']);
  notes = [time,': ',filedate,': ',comment];
  [nChannels,fileVars,DSVars,nWaves] = eval([fname,'(''cfsGetFileInfo'',fhandle)']);
  dataKinds = [];
  dataTypes = [];
  for j=1:nChannels
    [channelName,yunit,xunit,dataType,dataKind,spacing,other] = eval([fname,'(''cfsGetFileChan'',fhandle,j-1)']);
    eval(['chName' int2str(j-1) '=channelName;']);
    dataKinds = [dataKinds dataKind];
    dataTypes = [dataTypes dataType];
  end

  % Print recording channel information
  fprintf('Number of recording channels: %d\n',nChannels);
  count = 0;
  chNum = [];
  clist = cell(1);
  for j = 1:nChannels
    if dataKinds(j) == 0
      count = count+1;
      eval(['recChName = chName' int2str(j-1) ';']);
      fprintf('%d) %s\n',j,recChName);
      clist{count,1} = recChName;
      chNum = [chNum j];
    end
  end
  fprintf('loading channel %d...\n',ch)
  if ch > nChannels
    ret = eval([fname,'(''cfsCloseFile'',fhandle)']);
    error('channel number out of range')
  end
  if dataKinds(ch)~=0
    ret = eval([fname,'(''cfsCloseFile'',fhandle)']);
    error('channel kind is not supported')
  end
  ch=chNum(ch);

  % Load data from the selected channel
  [channelName,yunit,xunit,dataType,dataKind,spacing,other]=...
      eval([fname,'(''cfsGetFileChan'',fhandle,ch-1)']);
  xunit=strtrim(xunit);
  yunit=strtrim(yunit);
  [startOffset,points,yScale,yOffset,xdiff,xOffset]=...
      eval([fname,'(''cfsGetDSChan'',fhandle,ch-1,1)']);
  for i=1:nWaves
    [data]=...
        eval([fname,'(''cfsGetChanData'',fhandle,ch-1,i,0,points,dataTypes(ch))']);
    y{i}=yScale*data+yOffset;
  end
  if iscell(y)
    y = cells2mat(y);
  end
  x = 1:points;
  x = x';
  x = xdiff*x+xOffset;
  array = cat(2,x,y);

  % Assign question marks to character array of column names
  ncols = nWaves+1;
  names = char(zeros(ncols,1)+63);

  % Close file handle
  ret = eval([fname,'(''cfsCloseFile'',fhandle)']);

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = SMRload (filename,ch)

  % CED Spike2 SMR binary files
  % Evaluate the recording channels
  fid=fopen(filename,'r');
  %fid=fopen(filename,'r','ieee-le');

  % Print recording channel information
  chList=SONChanList(fid);
  nChannels = sum(([chList.kind]==1) | ([chList.kind]==9));
  if nChannels<1
    error('no supported channel records found')
  end
  fprintf('Number of recording channels: %d\n',nChannels);
  chNum=zeros(1,nChannels);
  count=0;
  clist = cell(1);
  for j = 1:numel([chList.number])
    chInfo = SONChannelInfo(fid,j);
    if (chInfo.kind==1) || (chInfo.kind==9)
      count = count+1;
      fprintf('%d) %s\n',count,chInfo.title);
      clist{count,1} = chInfo.title;
      chNum(count)=j;
    end
  end
  fprintf('loading channel %d...\n',ch)
  if count==0
    error('no supported channel records found')
  end
  if ch > nChannels
    error('channel number out of range')
  end
  ch=chNum(ch);
  chInfo = SONChannelInfo(fid,ch);

  % Load the data from the selected channel
  Options{1} = 'scale';         % Scale raw data to real world values and convert to doubles
  Options{2} = 'microseconds';  % Time unit will be in microseconds
  [data,header]=SONGetChannel(fid,ch,Options{:});
  % Data is a vector (if continuous)
  % or a 2D matrix   (if event driven; each epoch or 'wave' in a new column)
  % Data class returned are double precision floating point
  if isempty(header) && isempty(data)
    error('problem loading the file')
  end
  if ~strcmpi(strtrim(header.TimeUnits),'microseconds')
    error('an error occurred extracting time units from the header')
  end
  xdiff = header.sampleinterval * 1e-6;  % convert from microseconds to seconds
  xOffset = header.start * 1e-6;         % convert from microseconds to seconds
  xunit = 's';
  yunit = chInfo.units;
  if numel(yunit)>3
    if strcmpi(yunit(1:4),'Volt')
      yunit='V';
    end
  end
  if numel(yunit)>2
    if strcmpi(yunit(1:3),'Amp')
      yunit='A';
    end
  end
  notes = header.comment;
  x = 1:header.npoints;
  x = (x-1)';           % first datapoint at zero
  x = xdiff*x+xOffset;
  nWaves = size(data,2);
  array = cat(2,x,data);

  % Assign question marks to character array of column names
  ncols = nWaves+1;
  names = char(zeros(ncols,1)+63);
              
  % Close file identifier
  fclose(fid)

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = TDMSload (filename,ch)

  % Get channel information
  [Root, Group, Channels] = tdmsinfo(filename);
  nChan = numel(Channels);
  clist = cell(1);
  for i = 1:nChan
    clist{i,1} = Channels(i).NI_ChannelName;
  end
  if ch > nChan
    error('channel number out of range')
  end

  % Load TDMS file
  [data] = tdmsreader(filename,ch,'all');

  % Get meta data
  xdiff = Channels(ch).wf_increment;
  xunit =  's';
  yunit = Channels(ch).unit_string(1);
  [nPoints,nWaves] = size(data);
  xOffset = 0;

  % Create x dimension
  x = 1:nPoints;
  x = (x-1)';           % first datapoint at zero
  x = xdiff*x+xOffset;
  array = cat(2,x,data);

  % Assign question marks to character array of column names
  ncols = nWaves+1;
  names = char(zeros(ncols,1)+63);

  % Assign empty notes array
  notes = '';

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = ginj2load (filename,ch)

  % Get channel information
  load(filename);

  % Get meta data
  [nWaves,nPoints] = size(sweep_struct.data);
  if ch > nWaves
    error('channel number out of range')
  end
  xOffset = 0;
  xdiff = 1/sweep_struct.stiminfo.samplerate;
  xunit = 's';
  yunit = sweep_struct.stiminfo.in_units{ch};

  % Create x dimension
  x = 1:nPoints;
  x = (x-1)';           % first data point at zero
  x = xdiff*x+xOffset;

  % Form data array
  array = cat(2,x,sweep_struct.data(ch,:)');

  % Create cell array of column names
  names = {'Time',sweep_struct.filename};

  % Pass stimdef into notes array
  notes = sweep_struct.stimdef;

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes,clist] = paqload (filename,ch)

  % Initialize
  xunit = 's';
  yunit = 'V';
  xdiff = 0;
  array = [];
  names = '';
  notes = '';

  % Load file
  fid=fopen(filename);
 
  % Read in rate, number of channels, and channel names
  rate = fread(fid,1,'float32','b');
  numchans = fread(fid,1,'float32','b');
  for i=1:numchans
    number_of_characters = fread(fid,1,'float32','b');
    channelname{i} = [];
    for j=1:number_of_characters
      channelname{i} = [channelname{i}, strrep(fread(fid,1,'float32=>char', 'b'),' ','')];
    end
  end

  % Read in hardware channel ('HWchan') and units if available (*.paq only)
  for k=1:numchans
    number_of_characters = fread(fid,1,'float32','b');
    HWchan{k} = [];
    for m=1:number_of_characters
      HWchan{k} = [HWchan{k}, strrep(strrep(fread(fid,1,'float32=>char','b'),' ',''),'/','_')];
    end
  end
  for n=1:numchans
    number_of_characters = fread(fid,1,'float32','b');
    units{n} = [];
    for q=1:number_of_characters
      units{n}=[units{n}, strrep(fread(fid,1,'float32=>char','b'),' ','')];
    end
  end
  
  % Get filesize and fposition (which should be after all header info)
  dirinfo = dir(filename);
  for n=1:numel(dirinfo)
    if strcmp(dirinfo(n).name,filename)
      filesize = dirinfo(n).bytes;
    end
  end

  % Get 'channels'
  % Try to get included channels, or ask user
  try
    % Fetch y data
    y = fread(fid,[numchans,filesize/numchans],'*float32','b');
    notchans = 1:numchans;
    notchans(ch) = [];
    y(notchans,:) = [];
    y = y';
    fclose(fid);

    % Create x dimension
    xOffset = 0;
    xdiff = 1/rate;
    xunit = 's';
    nPoints = size(y,1);
    x = 1:nPoints;
    x = (x-1)';           % first data point at zero
    x = xdiff*x+xOffset;
 
    % Get data unit
    switch units{ch}
      case {'millivolts','mV'}
        yunit = 'mV';
      case {'volts','V'}
        yunit = 'V';
      case {'picoamps','pA'}
        yunit = 'pA';
      case {'amps','A'}
        yunit = 'A';
    end

    % Form data array
    array = cat(2,x,y);
 
    % Create channel name
    names = {'Time',channelname{ch}};
    
  catch

    % Do nothing

  end

end

%--------------------------------------------------------------------------

function [array,xdiff,xunit,yunit,names,notes] = NWB2load (filename,ch)

  % Load Neurodata Without Borders (NWB) file (version 2)
  % Currently very limited support for NWB files
  % NBW2load can load NWB files saved by ephysIO but because of the optionality in how data is stored
  % in NWB files (e.g. as sweeps, trials, epochs) it may not load NWB saved by other programs as expected.
  % We have plans to continue developing NWB file reading to support a wider range of NWB file structures.
  % Watch out for bug fix releases where NBW file reading is extended
  
  % Read NWB file using matnwb
  nwb = nwbRead(filename);
  
  % Get recording channels
  rec_channels = keys(nwb.general_intracellular_ephys);
  
  % Get names of recordings
  rec_names = keys(nwb.acquisition);
  
  % Get data
  if ~isempty(nwb.general_intracellular_ephys_sweep_table)
  
    if ch > numel(rec_channels)
      error('channel number out of range')
    end
  
    % Waves are stored as sweeps
    data = {};
    n = numel(rec_names)/numel(rec_channels);
    N = [];
    count = 0;
    for i = 1:numel(rec_names)
      
      % Get channel information for recording sweep 
      [filepath,channel] = fileparts(nwb.acquisition.get(rec_names{i}).electrode.path);
      
      % Get recording information if correct channel
      if strcmp(channel, rec_channels{ch})
      
        % Get information about the corresponding recording channel
        % We only need to do this once
        if count == 0
        
          % Get/set units
          yunit = nwb.acquisition.get(rec_names{1}).data_unit;
          if regexpi(yunit,'amp*')
            yunit = 'A';
          elseif regexpi(yunit,'volt*')
           yunit = 'V';
          end
          xunit = 's';
  
          % Calculate xdiff and time vector
          if ~isempty(nwb.acquisition.get(rec_names{1}).starting_time_rate)
            xdiff = 1/nwb.acquisition.get(rec_names{1}).starting_time_rate;
            N = numel(nwb.acquisition.get(rec_names{1}).data.load());
            % Create time stamps
            t = 1:N;
            t = (t-1)';           % first data point at zero
            t = xdiff*t;
          else
            % Get time stamps
            t = nwb.acquisition.get(rec_names{1}).timestamps.load();
            % Get sampling interval from first pair of time stamps 
            % Assume data is is evenly sampled (it might not be!!!)
            dx = diff(t);
            xdiff = dx(1);
          end
        end
        count = count + 1;    
        
        % Get data
        data{count} = double(nwb.acquisition.get(rec_names{i}).data.load()) * ...
                      nwb.acquisition.get(rec_names{i}).data_conversion;
        if size(data{count},1) == 1
          data{count} = data{count}';
        end     
        
      end
    end
    
  else
  
    % Channel number will be used to determine which recording wave to load
    % (as opposed to which recording device when data is formatted as sweeps)
    
    % Get/set units
    yunit = nwb.acquisition.get(rec_names{1}).data_unit;
    if regexpi(yunit,'amp*')
      yunit = 'A';
    elseif regexpi(yunit,'volt*')
      yunit = 'V';
    end
    xunit = 's'; 
          
    % Calculate xdiff and time vector
    if ~isempty(nwb.acquisition.get(rec_names{ch}).starting_time_rate)
      xdiff = 1/nwb.acquisition.get(rec_names{ch}).starting_time_rate;
      N = numel(nwb.acquisition.get(rec_names{ch}).data.load());
      % Create time stamps
      t = 1:N;
      t = (t-1)';           % first data point at zero
      t = xdiff*t;
    else
      % Get time stamps
      t = nwb.acquisition.get(rec_names{ch}).timestamps.load();
      % Get sampling interval from first pair of time stamps 
      % Assume data is is evenly sampled (it might not be!!!)
      dx = diff(t);
      xdiff = dx(1);
    end
    
    % Check if waves are defined in intervals_epochs or intervals_trials
    if ~isempty(nwb.intervals_epochs)
      wave_start = nwb.intervals_epochs.start_time.data.load();
      wave_stop  = nwb.intervals_epochs.stop_time.data.load();
    elseif ~isempty(nwb.intervals_trials)
      wave_start = nwb.intervals_trials.start_time.data.load();
      wave_stop  = nwb.intervals_trials.stop_time.data.load();
    end
    wave_start_idx = dsearchn(t,wave_start);
    wave_stop_idx = dsearchn(t,wave_stop);
    if numel(wave_start) ~= numel(wave_stop)
      error('inconsistent number of start and stop times in TimeIntervals')
    end
    if (any(wave_start_idx(2:end)-wave_stop_idx(1:end-1)) == 0)
      wave_stop_idx(1:end-1) = wave_stop_idx(1:end-1)-1;
    end

    % Get data points
    temp = double(nwb.acquisition.get(rec_names{ch}).data.load()) * ...
               nwb.acquisition.get(rec_names{ch}).data_conversion;
    n = numel(wave_start);
    data = {};
    for i = 1:n
      data{i} = temp(wave_start_idx(i):wave_stop_idx(i)); 
      if size(data{i},1) == 1
        data{i} = data{i}';
      end
    end

  end
  
  % Convert data cell array to matrix (with padding if necessary)
  data = cells2mat(data);
  N = size(data,1);
  
  % Create x-dimension vector
  x = 1:N;
  x = (x-1)';           % first data point at zero
  x = xdiff*x;
  
  % Combine time vector with data array
  array = [x, data];
  
  % Assign question marks to character array of column names
  ncols = n+1;
  names = char(zeros(ncols,1)+63);

  % Assign empty notes array
  notes = '';  
  
  % Remove temporary NWB cache
  if exist('+types','dir')
    rmdir('+types','s')
  end
  
  
end

%--------------------------------------------------------------------------

function H5save (filename,array,xunit,yunit,names,notes)

  % Stimfit HDF5 binary files
  [nrows, ncols] = size(array);
  nPoints = nrows;
  nWaves = ncols-1;

  % Allocate unit and scale data appropriately
  if strcmp(xunit,'s')
    array(:,1) =  array(:,1)*1e+3;
    xunit = 'ms';
    names{1} = 'Time';
  else
    % Do nothing
  end
  if strcmp(yunit,'s')
    array(:,2:end) = array(:,2:end)*1e+3;
    yunit = 'ms';
  elseif strcmp(yunit,'A')
    array(:,2:end) = array(:,2:end)*1e+12;
    yunit = 'pA';
  elseif strcmp(yunit,'V')
    array(:,2:end) = array(:,2:end)*1e+3;
    yunit = 'mV';
  else
    % Do nothing
  end

  % Evaluate the X dimension
  dt = diff(array(:,1));
  if any(diff(dt) > 1.192093e-07)
    error('data is not evenly sampled')
  else
    delta = dt(1);
    xdiff = delta;
  end

  % create file
  fileID= H5F.create(filename,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

  % create '/description'
  % create compound datatype
  typeID = H5T.create ('H5T_COMPOUND', 24);
  H5T.insert (typeID, 'channels', 0 ,'H5T_NATIVE_INT32');
  datetype = H5T.copy('H5T_C_S1');
  H5T.set_size (datetype, 11);
  H5T.insert (typeID,'date',4,datetype);
  timetype = H5T.copy('H5T_C_S1');
  H5T.set_size (timetype, 9);
  H5T.insert (typeID, 'time',15,timetype);
  % create unlimited filespace
  H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
  maxdims = H5S_UNLIMITED;
  memspace = H5S.create_simple(1, 1, maxdims);
  % create data set
  dcpl = H5P.create('H5P_DATASET_CREATE');
  H5P.set_chunk (dcpl,10);
  dset = H5D.create(fileID, 'description',typeID ,memspace, dcpl);
  % create data
  data=struct;
  data.channels = int32(1);
  data.date = datestr(now,'yyyy-mm-dd');
  data.time = ' ';
  space = H5D.get_space(dset);
  H5S.select_all(space)
  H5D.write(dset,typeID, 'H5S_ALL', space, 'H5P_DEFAULT',data);
  % close stuff
  H5S.close (space);
  H5S.close (memspace);
  H5D.close (dset);
  H5T.close (datetype);
  H5T.close (timetype);
  H5T.close (typeID);
  % create attributes
  h5writeatt(filename,'/description','CLASS','TABLE');
  h5writeatt(filename,'/description','VERSION','3.0');
  if ispc; sl='\'; else; sl='/'; end
  fullpath = [pwd sl filename];
  title = ['Description of ' fullpath];
  h5writeatt(filename,'/description','TITLE',title);
  h5writeatt(filename,'/description','FIELD_0_NAME','channels');
  h5writeatt(filename,'/description','FIELD_1_NAME','date');
  h5writeatt(filename,'/description','FIELD_2_NAME','time');

  % create '/ch0/description'
  % create compound datatype
  grpID = H5G.create(fileID,'ch0','H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
  typeID = H5T.create ('H5T_COMPOUND', 4);
  H5T.insert (typeID, 'n_sections', 0 ,'H5T_NATIVE_INT32');
  % create unlimited filespace
  H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
  maxdims = H5S_UNLIMITED;
  memspace = H5S.create_simple(1, 1, maxdims);
  % create data set
  dcpl = H5P.create('H5P_DATASET_CREATE');
  H5P.set_chunk (dcpl,10);
  dset = H5D.create(grpID, 'description',typeID ,memspace, dcpl);
  % create data
  data = struct;
  data.n_sections = int32(nWaves);
  space = H5D.get_space(dset);
  H5S.select_all(space)
  H5D.write(dset,typeID, 'H5S_ALL', space, 'H5P_DEFAULT',data);
  % close stuff
  H5S.close (space);
  H5S.close (memspace);
  H5D.close (dset);
  H5T.close (typeID);
  H5G.close (grpID);
  % create attributes
  h5writeatt(filename,'/ch0/description','CLASS','TABLE');
  h5writeatt(filename,'/ch0/description','VERSION','3.0');
  h5writeatt(filename,'/ch0/description','TITLE','Description of channel 0');
  h5writeatt(filename,'/ch0/description','FIELD_0_NAME','n_sections');

  % create wave data sets in '/ch0/section_[i]'
  k = numel(num2str(nWaves));
  for i=1:nWaves
    % create '/ch0/section_[i]/description'
    % create compound datatype
    section = ['section_' pad(num2str(i-1),k,'left','0')]; % zero indexing in python
    grpID = H5G.create(fileID,['/ch0/' section],'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
    typeID = H5T.create ('H5T_COMPOUND', 12);
    H5T.insert (typeID, 'dt', 0 ,'H5T_NATIVE_DOUBLE');
    datetype = H5T.copy('H5T_C_S1');
    H5T.set_size (datetype, 2);
    H5T.insert (typeID,'xunits',8,datetype);
    timetype = H5T.copy('H5T_C_S1');
    H5T.set_size (timetype, 2);
    H5T.insert (typeID, 'yunits',10,timetype);
    % create unlimited filespace
    H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
    maxdims = H5S_UNLIMITED;
    memspace = H5S.create_simple(1, 1, maxdims);
    % create data set
    dcpl = H5P.create('H5P_DATASET_CREATE');
    H5P.set_chunk (dcpl,10);
    dset = H5D.create(grpID, 'description',typeID ,memspace, dcpl);
    % create data
    data=struct;
    data.dt = xdiff;
    data.xunits = xunit;
    data.yunits = yunit;
    space = H5D.get_space(dset);
    H5S.select_all(space)
    H5D.write(dset,typeID, 'H5S_ALL', space, 'H5P_DEFAULT',data);
    % close stuff
    H5S.close (space);
    H5S.close (memspace);
    H5D.close (dset);
    H5T.close (datetype);
    H5T.close (timetype);
    H5T.close (typeID);
    H5G.close (grpID);
    % create attributes
    h5writeatt(filename,['/ch0/' section '/description'],'CLASS','TABLE');
    h5writeatt(filename,['/ch0/' section '/description'],'VERSION','3.0');
    if ispc; sl='\'; else; sl='/'; end
    fullpath = [pwd sl filename];
    title = ['Description of ' fullpath ', Section # ' num2str(i-1)];
    h5writeatt(filename,['/ch0/' section '/description'],'TITLE',title);
    h5writeatt(filename,['/ch0/' section '/description'],'FIELD_0_NAME','dt');
    h5writeatt(filename,['/ch0/' section '/description'],'FIELD_1_NAME','xunits');
    h5writeatt(filename,['/ch0/' section '/description'],'FIELD_2_NAME','yunits');
    % create data
    h5create(filename,['/ch0/' section '/data'], nPoints, 'Datatype', 'single');
    h5write(filename, ['/ch0/' section '/data'], single(array(:,i+1)));
  end

  % create '/channels/ch0'
  grpID = H5G.create(fileID,'channels','H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
  typeID = H5T.copy('H5T_C_S1');
  H5T.set_size(typeID,3);
  memspace = H5S.create_simple (1,1,1);
  dset = H5D.create(grpID,'ch0',typeID,memspace,'H5P_DEFAULT');
  space = H5D.get_space(dset);
  chData = 'ch0';
  H5D.write (dset,typeID,'H5S_ALL','H5S_ALL','H5P_DEFAULT',chData);
  % close stuff
  H5S.close (space);
  H5S.close (memspace);
  H5D.close (dset);
  H5T.close (typeID);
  H5G.close (grpID);

  % create data sets in '/comment/comment'
  grpID = H5G.create(fileID,'comment','H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
  typeID = H5T.copy('H5T_C_S1');
  H5T.set_size(typeID,11);
  memspace = H5S.create('H5S_SCALAR');
  dset = H5D.create(grpID,'comment',typeID,memspace,'H5P_DEFAULT');
  space = H5D.get_space(dset);
  comment = 'No comment ';
  H5D.write (dset,typeID,'H5S_ALL','H5S_ALL','H5P_DEFAULT',comment);
  % close stuff
  H5S.close (space);
  H5S.close (memspace);
  H5D.close (dset);
  H5T.close (typeID);

  % create data sets in '/comment/description'
  typeID = H5T.copy('H5T_C_S1');
  H5T.set_size(typeID,15);
  %encoding = H5ML.get_constant_value('H5T_NATIVE_INT');
  memspace = H5S.create('H5S_SCALAR');
  % create data set
  %dcpl = H5P.create('H5P_DATASET_CREATE');
  dset = H5D.create(grpID,'description',typeID,memspace,'H5P_DEFAULT');
  space = H5D.get_space(dset);
  comment = 'No description ';
  H5D.write (dset,typeID,'H5S_ALL','H5S_ALL','H5P_DEFAULT',comment);
  % close stuff
  H5S.close (space);
  H5S.close (memspace);
  H5D.close (dset);
  H5T.close (typeID);
  H5G.close (grpID);

  % close file
  H5F.close (fileID);

end

%--------------------------------------------------------------------------

function ABFsave (filename,array,xunit,yunit,names,notes)

  % Evaluate the x dimension
  dx = diff(array(:,1));
  if any(diff(dx) > 1.192093e-07)
    error('data is not evenly sampled')
  else
    xdiff = dx(1);
  end
  
  % Allocate y unit and scale data appropriately
  if strcmp(yunit,'A')
    array(:,2:end) = array(:,2:end)*1e+12;
    yunit = 'pA';
  elseif strcmp(yunit,'V')
    array(:,2:end) = array(:,2:end)*1e+3;
    yunit = 'mV';
  end

  % Remove time column from data matrix
  array(:,1)=[];
  
  % Header structure for for ABF 1.83 
  blocksize = 512;
  HEADER_BLOCKS = 12;
  header_bytes = blocksize * HEADER_BLOCKS;

  % Data block structure
  DATA_START = HEADER_BLOCKS;
  dataByteOffset = header_bytes;
  [sweepPointCount,sweepCount] = size(array);
  dataPointCount = numel(array);
  bytesPerPoint = 2; % 2 for int16 (short), 4 for float32 (float)
  DATA_BLOCKS = dataPointCount * bytesPerPoint / blocksize;
  if DATA_BLOCKS > fix(DATA_BLOCKS)
    DATA_BLOCKS = fix(DATA_BLOCKS) + 1;
  end
  data_bytes = blocksize * DATA_BLOCKS;

  % SynchArray structure
  SYNCH_START = HEADER_BLOCKS + DATA_BLOCKS;
  syncByteOffset = header_bytes + data_bytes;
  synch_bytes = sweepCount * 2 * 4;
  SYNCH_BLOCKS = synch_bytes / blocksize;
  if SYNCH_BLOCKS > fix(SYNCH_BLOCKS)
    SYNCH_BLOCKS = fix(SYNCH_BLOCKS) + 1;
  end
  
  % Preallocate 
  buffer = zeros(1, header_bytes + data_bytes + blocksize * SYNCH_BLOCKS, 'int8');
  %buffer = zeros(1, header_bytes + data_bytes, 'int8');

  % Open binary file for writing
  fid = fopen(filename,'w','ieee-le');
  fwrite(fid, buffer, 'int8');

  % Populate the header
  fseek(fid, 0, 'bof'); fwrite(fid, 'ABF ', 'schar');                  % fFileSignature
  fseek(fid, 4, 'bof'); fwrite(fid, 1.83, 'float');                    % fFileVersionNumber
  fseek(fid, 8, 'bof'); fwrite(fid, 5, 'short');                       % nOperationMode (5 is episodic)
  fseek(fid, 10, 'bof'); fwrite(fid, dataPointCount, 'long');          % lActualAcqLength
  fseek(fid, 16, 'bof'); fwrite(fid, sweepCount, 'long');              % lActualEpisodes
  fseek(fid, 40, 'bof'); fwrite(fid, DATA_START, 'long');              % lDataSectionPtr
  fseek(fid, 92, 'bof'); fwrite(fid, SYNCH_START, 'int32');            % lSynchArrayPtr
  fseek(fid, 96, 'bof'); fwrite(fid, sweepCount, 'int32');             % lSynchArraySize
  fseek(fid, 100, 'bof'); fwrite(fid, 0, 'short');                     % nDataFormat: 0 for int16, 1 for float32
  fseek(fid, 120, 'bof'); fwrite(fid, 1, 'short');                     % nADCNumChannels
  fseek(fid, 122, 'bof'); fwrite(fid, xdiff*1e6, 'float');             % fADCSampleInterval (in microseconds)
  fseek(fid, 130, 'bof'); fwrite(fid, 0, 'float');                     % fSynchTimeUnit (in microseconds, 0 = Value in sample intervals)
  fseek(fid, 138, 'bof'); fwrite(fid, sweepPointCount, 'long');        % lNumSamplesPerEpisode


  % ADC adjustments required for integer conversion.
  fSignalGain = 1;                                                     % must be 1
  fADCProgrammableGain = 1;                                            % must be 1
  fADCresolution = 2^15;                                               % 16-bit signed = +/- 32767
  fADCrange = 10;                                                      % +/- 10 V
  sADCUnits = pad(yunit,8,'right');                                    % Set y-units as a space-padded 8-byte string    


  % Add default scale data to the header
  fseek(fid, 244, 'bof'); fwrite(fid, fADCrange, 'float');             % fADCRange
  fseek(fid, 252, 'bof'); fwrite(fid, fADCresolution, 'long');         % 16-bit signed = +/- 32768
  fseek(fid, 268, 'bof'); fwrite(fid, 1, 'float');                     % _fAutosampleAdditGain
  fseek(fid, 272, 'bof'); fwrite(fid, 100000, 'float');                % _fAutosampleFilter (in Hz)
  for i = 0:15
    sADCChannelName = pad(sprintf('AI #%d',i),10,'right');
    fseek(fid, 442+i*10, 'bof'); fwrite(fid, sADCChannelName,'schar'); % sADCChannelName
    fseek(fid, 378+i*2, 'bof'); fwrite(fid, i, 'short');               % nADCPtoLChannelMap
    fseek(fid, 410+i*2, 'bof'); fwrite(fid, -1, 'short');              % nADCSamplingSeq
    fseek(fid, 922+i*4, 'bof'); fwrite(fid, 1, 'float');               % fInstrumentScaleFactor
    fseek(fid, 1050+i*4, 'bof'); fwrite(fid, 1, 'float');              % fSignalGain
    fseek(fid, 1178+i*4, 'bof'); fwrite(fid, 100000, 'float');         % fSignalLowpassFilter (in Hz)
    fseek(fid, 730+i*4, 'bof'); fwrite(fid, 1, 'float');               % fADCProgrammableGain
    fseek(fid, 4576+i*4, 'bof'); fwrite(fid, 1, 'float');              % fTelegraphAdditGain
    fseek(fid, 4640+i*4, 'bof'); fwrite(fid, 100000, 'float');         % fTelegraphFilter (in Hz)
    fseek(fid, 5934+i*4, 'bof'); fwrite(fid, 100000, 'float');         % fPostProcessLowpassFilter (in Hz)
    fseek(fid, 602+i*8, 'bof'); fwrite(fid, sADCUnits, 'schar');       % sADCUnits
  end
  
  % Scale the data, then convert to integer (int16)
  maxVal = max(abs(array(:)));
  fInstrumentOffset = 0;
  valueScale = (fADCresolution-2) / maxVal;
  fInstrumentScaleFactor = valueScale * fADCrange / fADCresolution;
  array = int16(array*valueScale);
  
  % Add scale information for the data (channel 1)
  fseek(fid, 410, 'bof'); fwrite(fid, 0, 'short');
  fseek(fid, 922, 'bof'); fwrite(fid, fInstrumentScaleFactor, 'float');

  % Write scaled data
  fseek(fid, dataByteOffset, 'bof'); fwrite(fid, array(:), 'short');

  % Write Sync array
  synchArr = [[0:sweepPointCount:dataPointCount-1];
               sweepPointCount*ones(1,sweepCount)];
  fseek(fid, syncByteOffset, 'bof'); fwrite(fid, synchArr(:), 'int32');
 
  % Close file
  fclose(fid);
  

end

%--------------------------------------------------------------------------

function NWB2save (filename,array,xunit,yunit,names,notes)

  % Save in Neurodata Without Borders (NWB) format (version 2)
  % Only basic metadata is currently written to file (plans to develop further)
  % Scales data, converts to int16 and applies maximal data compression on entire wave series
  % Waves defines using TimeIntervals type in intervals_epochs
  
  % If NWB file of filename already exists, remove it 
  if exist(sprintf('./%s',filename),'file')
    delete(sprintf('./%s',filename));
  end

  % Get data dimensions
  N = size(array,1);   % sweepPointCount
  n = size(array,2)-1; % sweepCount
  
  % Evaluate the x dimension
  dx = diff(array(:,1));
  if any(diff(dx) > 1.192093e-07)
    error('data is not evenly sampled')
  else
    xdiff = dx(1);
  end
  
  % Create blank yunits if is empty (prevents errors)
  if isempty(yunit)
    yunit = ' ';
  end

  % Create NWB file object
  nwb = NwbFile( ...
    'session_description', 'none', ...
    'identifier', fullfile(pwd, filename), ...
    'session_start_time', datetime, ... 
    'general_experimenter', char(java.lang.System.getProperty('user.name')));

  % Device and channel metadata
  channel_name = 'ch0';
  device_name = 'unknown';
  nwb.general_devices.set(device_name, types.core.Device());
  if any(strcmp(yunit, {'A','V'}))
    device_link = types.untyped.SoftLink(['/general/devices/' device_name]);
    ic_elec = types.core.IntracellularElectrode( ...
                                                'device', device_link, ...
                                                'description', 'none');
    nwb.general_intracellular_ephys.set(channel_name, ic_elec);
    ic_elec_link = types.untyped.SoftLink(['/general/intracellular_ephys/' channel_name]);
  end

  % Perform data scaling, conversion to 16-bit and then compression
  % Waves are concatenate waves for optimal data compression
  % Times corresponding to the start and end times of each wave will be placed in nwb.intervals_epochs
  data = array(:,2:end);
  maxVal = max(abs(data(:)));
  valueScale = (2^15-2) / maxVal; % 16-bit signed = +/- 32768 (2^15)
  data = int16(data*valueScale);
  chunkSize = 5e+05; % 1 Megabyte
  compressed_data = types.untyped.DataPipe('data', data(:)', ...
                                           'chunkSize', [1,5e+05], ... 
                                           'compressionLevel', 9);
                                
  % Assign data to a time series data object and add it to the NWB file object
  switch yunit
    case 'A'
      % Use voltage clamp time series data object
      data_object = types.core.VoltageClampSeries('electrode', ic_elec_link, ...
                                                  'gain', 1, ...
                                                  'stimulus_description', 'no stimulus', ...
                                                  'starting_time', 0, ... % in seconds
                                                  'starting_time_rate', 1/xdiff, ...
                                                  'description', 'Series of fixed-length waves', ...
                                                  'comments', ['Convert data to floating point ', ...
                                                               'and multiply by data_conversion'], ...
                                                  'data', compressed_data, ...
                                                  'data_unit', 'amperes', ...
                                                  'data_conversion', 1/valueScale);
    case 'V'
      % Use current clamp time series data object
      data_object = types.core.CurrentClampSeries('electrode', ic_elec_link, ...
                                                  'gain', 1, ...
                                                  'stimulus_description', 'no stimulus', ...
                                                  'starting_time', 0, ... % in seconds
                                                  'starting_time_rate', 1/xdiff, ...
                                                  'description', 'Series of fixed-length waves', ...
                                                  'comments', ['Convert data to floating point ', ...
                                                               'and multiply by data_conversion'], ...
                                                  'data', compressed_data, ...
                                                  'data_unit', 'volts', ...
                                                  'data_conversion', 1/valueScale);
    otherwise
      % Use generic time series data object if unit not recognised for electrophysiology
      data_object = types.core.TimeSeries('starting_time', 0, ... % in seconds
                                          'starting_time_rate', 1/xdiff, ...
                                          'description', 'Series of fixed-length waves', ...
                                          'comments', ['Convert data to floating point ', ...
                                                       'and multiply by data_conversion'], ...
                                          'data', compressed_data, ...
                                          'data_unit', yunit, ...
                                          'data_conversion', 1/valueScale);
  end
  nwb.acquisition.set('wave_series', data_object);

  % Define the start and stop time for each wave (epoch) with a time intervals object and add it to the NWB file object
  l = N*xdiff; % epoch length (in seconds)
  start = l*[0:n-1];
  stop = l*[1:n];
  epoch = types.core.TimeIntervals('colnames', {'start_time', 'stop_time'}, ...
                                   'description', ['Start and stop time for each wave in ', ... 
                                                   'the time series data (wave series)'], ...
                                   'id', types.hdmf_common.ElementIdentifiers('data', [0:n-1]), ...
                                     'start_time', types.hdmf_common.VectorData( ...
                                     'data', start, ...
   	                               'description','Start time of each wave in series (arbitrary)'), ...
                                     'stop_time', types.hdmf_common.VectorData( ...
                                     'data', stop, ...
   	                               'description','End time of each wave in series (arbitrary)')) ;
  nwb.intervals_epochs = epoch;


  % Add new metadata 
  nwb.general_source_script_file_name = 'ephysIO.m';
  nwb.general_source_script = 'https://github.com/acp29/eventer';
  
  % Write data to file
  nwbExport(nwb, filename);
  
end

%--------------------------------------------------------------------------