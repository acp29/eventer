function out=import_wcp(fn, varargin)

%IMPORT_WCP  Import WinWCP files.
%  OUT=IMPORT_WCP(FN) imports data recorded with WinWCP, where FN is a
%  string containing the filename. OUT is the output struct containing the
%  following fields:
%  S             Cell with C elements, where C is the number of channels.
%                Each element of S is a matrix containing the loaded data
%                from all recordings for the individual channel.
%  T             Time index [s] for one recording.
%  time          Date and time the file was recorded
%  rec_index     Indicates which recordings were extracted
%  channel_no    Number of channels
%  t_intervall   Time intervall between two samples
%  channel_info  Cell containing unit and label information for each channel
%  rec_info      Cell containing information about each extracted recording
%  file_name     Filename
%
%  OUT=IMPORT_WCP user inteface selection of the file
%
%  OUT=IMPORT_WCP('',...) user inteface selection of the file
%
%  OUT=IMPORT_WCP(...,'recordings', R) specify in R which recordings should
%  be loaded.
%
%  OUT=IMPORT_WCP(...,'debug') output additional parameters for debugging
%
%  See also plot_wcp

% Author: David Jäckel / jaeckeld@bsse.ethz.ch


if nargin < 1 || strcmp(fn,'')
    [FileName,PathName,FilterIndex] = uigetfile('*.wcp');
    fn = [PathName FileName];
else
    FileName=fn;
end

recordings=[];
debug=0;
i=1;

while i<=length(varargin)
    if not(isempty(varargin{i}))
        if strcmp(varargin{i}, 'recordings')
            i=i+1;
            recordings=varargin{i};
        elseif strcmp(varargin{i}, 'debug')
            debug=1;
        else
            fprintf('unknown argument at pos %d\n', 1+i);
        end
    end
    i=i+1;
end


%% read HEADER info

wcp=[];

fid = fopen(fn);
tline = fgetl(fid);

while length(tline)<200 % better condition here?
    in=find(tline=='=');
    if not(isempty(in))
        pre=tline(1:in-1);
        post=tline(in+1:end);
        switch pre
            case('VER')
                wcp.version=str2num(post);
            case('CTIME')
                wcp.ctime=post;
            case('NC')
                wcp.nc=str2num(post);
            case('NR')
                wcp.nr=str2num(post);
            case('NBH')
                wcp.nbh=str2num(post);
            case('NBA')
                wcp.nba=str2num(post);
            case('NBD')
                wcp.nbd=str2num(post);
            case('AD')
                wcp.ad=str2num(post);
            case('ADCMAX')
                wcp.adcmax=str2num(post);
            case('NP')
                wcp.np=str2num(post);
            case('DT')
                wcp.dt=str2num(post);
            case('NZ')
                wcp.nz=str2num(post);
            case('TU')                 % Time units
                wcp.tu=post;
            case('ID')                 % Experiment identification line
                wcp.id=post;
        end
        switch(pre(1:2))
            case('YN')                 %  Channel X name
                N=str2double(pre(3));
                wcp.channel_info{N+1}.yn=post;
            case('YU')                 % Channel X units
                N=str2double(pre(3));
                wcp.channel_info{N+1}.yu=post;
            case('YG')                 %  Channel X gain factor mV/units
                N=str2double(pre(3));
                wcp.channel_info{N+1}.yg=str2double(post);
            case('YZ')                 %  Channel X zero level (A/D bits)
                N=str2double(pre(3));
                wcp.channel_info{N+1}.yz=str2double(post);
            case('YO')                 %  Channel X offset into sample group in data block
                N=str2double(pre(3));
                wcp.channel_info{N+1}.yo=str2double(post);
            case('YR')
                N=str2double(pre(3));
                wcp.channel_info{N+1}.yr=post;
        end
        % disp(tline)
        tline = fgetl(fid);
    end
end


%% Read recording blocks

% which recordings to extract
if isempty(recordings)
    recordings=1:wcp.nr;
else
    if find(recordings>wcp.nr)
        warning(['Maximum number of recordings in the file is ' num2str(wcp.nr) '!']);
        recordings(recordings>wcp.nr)=[];
    end
    if isempty(recordings)
        error('No valid recordings selected!!');
    end
end


clear RAB DAB
RAB=cell(1,length(recordings));
DAB=cell(1,length(recordings));

for i=1:length(recordings)

    % which recording number in the file
    rec_number=recordings(i);

    rec_index(i)=rec_number;

    % position i-th record analysis block
    rab_pos(i)=wcp.nbh+((rec_number-1)*(wcp.nba+wcp.nbd))*512;
    fseek(fid,rab_pos(i),'bof');

    % Record Analysis Block
    RAB{i}.status=sprintf(char(fread(fid,8)));
    RAB{i}.type=sprintf(char(fread(fid,4)));
    RAB{i}.group_no=fread(fid,1,'single');
    RAB{i}.time_rec=fread(fid,1,'single');
    RAB{i}.sampling_interval=fread(fid,1,'single');
    for j=1:wcp.nc
        RAB{i}.max_pos_voltage(j)=fread(fid,1,'single');
    end
    RAB{i}.marker=sprintf(char(fread(fid,16)));
    % RAB{i}.values=fread(fid,1,'single'); %TODO when needed

    % position i-th data block
    db_pos(i)=wcp.nbh+(wcp.nba+(rec_number-1)*(wcp.nba+wcp.nbd))*512;
    fseek(fid,db_pos(i),'bof');

    % Data Block
    DB=fread(fid,[wcp.nc,wcp.nbd*256/2],'*int16');
    DAB{i}=double(DB);

end

fclose(fid);

%% put data into format

% temporal index

T=(1:size(DAB{1},2))*wcp.dt; % [s]

clear S1 S2

% convert to physical units
S=cell(1,wcp.nc);
for i=1:length(recordings)
    for j=1:wcp.nc
        S{j}(:,i)=(RAB{i}.max_pos_voltage(j)/(wcp.adcmax*wcp.channel_info{j}.yg))*DAB{i}(j,:);
    end
end


%% output signal

out.S=S;
out.T=T;
out.time=wcp.ctime;
out.rec_index=rec_index;
out.channel_no=wcp.nc;
out.t_interval=wcp.dt;
out.file_name=FileName;

for i=1:wcp.nc
    out.channel_info{i}.unit=wcp.channel_info{i}.yu;
    out.channel_info{i}.name=wcp.channel_info{i}.yn;
end

for i=1:length(recordings)
    out.rec_info{i}.status=RAB{i}.status;
    out.rec_info{i}.type=RAB{i}.type;
    out.rec_info{i}.time_recorded=RAB{i}.time_rec;
    out.rec_info{i}.group_no=RAB{i}.group_no;
end

%% Optional outputs for debugging:
if debug
    out.wcp=wcp;
    out.RAB=RAB;
    out.rab_pos=rab_pos;
    out.db_pos=db_pos;
end
