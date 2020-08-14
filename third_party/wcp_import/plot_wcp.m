function plot_wcp(in,varargin)

% PLOT_WCP Plot two-channel data recorded with the WinWCP software.
%
%   PLOT_WCP(IN) plots WinWCP data, where IN can be a string containing the
%   filename or the output of the function IMPORT_WCP.
%
%   PLOT_WCP('',...) user inteface selection of the file.
%
%   PLOT_WCP(...,'recordings',R) define in R which recordings to plot.
%   
%   PLOT_WCP(...,'subplots_equal') use equally sized subplots.
%   
%   PLOT_WCP(...,'separate') use an individual window for each recording.
%   
%   PLOT_WCP(...,'title') define title.
%   
%   See also IMPORT_WCP

% Author: David Jäckel / jaeckeld@bsse.ethz.ch

% if input is ''
if strcmp(in,'')
    [FileName,PathName,FilterIndex] = uigetfile('*.wcp');
    in=[PathName FileName];
end

% if input is a filename
if ischar(in)
    fn = in;
    in=import_wcp(fn);
end


i=1;

recordings=[];
sp_equal=0;
separate=0;
title_up=[];


while i<=length(varargin)
    if not(isempty(varargin{i}))
        if strcmp(varargin{i}, 'recordings')
            i=i+1;
            recordings=varargin{i};   
        elseif strcmp(varargin{i}, 'title')
            i=i+1;
            title_up=varargin{i};   
        elseif strcmp(varargin{i}, 'subplots_equal')
            sp_equal=1;
        elseif strcmp(varargin{i}, 'separate')
            separate=1;
         else
            fprintf('unknown argument at pos %d\n', 1+i);
        end
    end
    i=i+1;
end




%% find number of records

if isempty(recordings)
    recordings=1:length(in.rec_index);
end

if separate
    for i=recordings
        plot_wcp(in,'recordings',i,'title',['Recording ' int2str(i)])
    end
    return
end

%% signals

T = in.T;
S = in.S;


%% plot 

ind=T*1000; % in [ms]
N=length(recordings);

if N<5
    cols=lines(N);
else
    cols=flipud(jet(N));
end
figure('color','white');

    
if sp_equal
    ax(1)=subplot(2,1,1);
else
    ax(1)=subplot(4,1,[1 2 3]);
end
set(gca,'ColorOrder',cols)
hold on

plot(ind,S{1}(:,recordings),'LineWidth',2)

if not(isempty(title_up))
    title(title_up)
end

% xlabel('Time [ms]')
if strcmp(in.channel_info{1}.unit,'mV')
    ylabel('Membrane potential [mV]')
elseif strcmp(in.channel_info{1}.unit,'pA')
    ylabel('Current [pA]')
end

set(gca,'XTickLabel','')

if sp_equal
    ax(2)=subplot(2,1,2);
else
    ax(2)=subplot(4,1,4);
end

set(gca,'ColorOrder',cols)
hold on

plot(ind,S{2}(:,recordings),'LineWidth',2)

if strcmp(in.channel_info{2}.unit,'mV')
    ylabel('Membrane potential [mV]')
elseif strcmp(in.channel_info{2}.unit,'pA')
    ylabel('Current [pA]')
end
xlabel('Time [ms]')
% xticks=get(gca, 'XTick');
% set(gca,'XTickLabel',xticks/sr*1000)

linkaxes(ax,'x')

