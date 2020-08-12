clc;

%Recreate needed property constants defined in nilibddc_m.h
DDC_FILE_DATETIME = 'datetime';

%Check if the paths to 'nilibddc.dll' and 'nilibddc_m.h' have been
%selected. If not, prompt the user to browse to each of the files.
if exist('NI_TDM_DLL_Path','var')==0
    [dllfile,dllfolder]=uigetfile('*dll','Select nilibddc.dll');
    libname=strtok(dllfile,'.');
    NI_TDM_DLL_Path=fullfile(dllfolder,dllfile);
end
if exist('NI_TDM_H_Path','var')==0
    [hfile,hfolder]=uigetfile('*h','Select nilibddc_m.h');
    NI_TDM_H_Path=fullfile(hfolder,hfile);
end

%Prompt the user to select the path of the TDM or TDMS file to create
[filepath,filefolder,FilterIndex] = uiputfile('*.tdm;*.tdms','Select a TDM or TDMS File');
Data_Path=fullfile(filefolder,filepath);

t=(0:0.1:200);
Amps=[1 2 3 4 5];
Freqs=[.2 .21 .22 .23 .24];

%Initialize Sine and Noise matrices
Sine=zeros(length(t),length(Amps));
Noise=zeros(length(t),length(Amps));

%Generate Sine and Noise values
for i=1:length(Amps)
    Sine(:,i)=Amps(i)*sin(t.*Freqs(i));
    Noise(:,i)=0.1*Amps(i)*rand(length(t),1)-0.05*Amps(i);
end
NoisySine=Sine+Noise;

%Plot the Sine, Noise, and NoisySine matrices. Each matrix will be
%saved as a a separate channel group in the file with each group
%containing several channels of data.
figure;plot(t,Sine);
figure;plot(t,Noise);
figure;plot(t,NoisySine);

%Load nilibddc.dll (Always call 'unloadlibrary(libname)' after finished using the library)
loadlibrary(NI_TDM_DLL_Path,NI_TDM_H_Path);

%Create the file (Always call 'DDC_CloseFile' when you are finished using a file)
filename = filepath;
filedesc = 'Example data file containing separate groups with multiple channels of sine, noise, and noisy sine data.';
filetitle = 'Example Data File';
fileauth = 'Me';
fileIn = 0;
[err,dummyVar,dummyVar,dummyVar,dummyVar,dummyVar,dummyVar,file] = calllib(libname,'DDC_CreateFile',Data_Path,'',filename,filedesc,filetitle,fileauth,fileIn);

%Set the file timestamp property
c=int32(clock);
[err,dummyVar] = calllib(libname,'DDC_SetFilePropertyTimestampComponents',file,DDC_FILE_DATETIME,c(1),c(2),c(3),c(4),c(5),c(6),0);

%Add Sine Data channel group to the file
grpname = 'Sine Data';
grpdesc = 'Sine data of various amplitudes and frequencies';
sinegrpIn = 0;
[err,dummyVar,dummyVar,sinegrp] = calllib(libname,'DDC_AddChannelGroup',file,grpname,grpdesc,sinegrpIn);

%Add Noise Data channel group to the file
grpname = 'Noise Data';
grpdesc = 'Randomly generated noise data';
noisegrpIn = 0;
[err,dummyVar,dummyVar,noisegrp] = calllib(libname,'DDC_AddChannelGroup',file,grpname,grpdesc,noisegrpIn);

%Add Noisy Sine Data channel group to the file
grpname = 'Noisy Sine Data';
grpdesc = 'Sine data with noise added';
noisysinegrpIn = 0;
[err,dummyVar,dummyVar,noisysinegrp] = calllib(libname,'DDC_AddChannelGroup',file,grpname,grpdesc,noisysinegrpIn);

%Add channels to channel groups
chanunitstring = 'Volts';
sinechanIn = 0;
noisechanIn = 0;
noisysinechanIn = 0;
for i=1:length(Amps) %For each channel to be added to each group
    
    %Add a new Sine Data channel
    channame = ['Sine Data ' num2str(i)];
    chandesc = ['A = ' num2str(Amps(i)) ', F = ' num2str(Freqs(i))];
    [err,dummyVar,dummyVar,dummyVar,sinechan] = calllib(libname,'DDC_AddChannel',sinegrp,'DDC_Double',channame,chandesc,chanunitstring,sinechanIn);
    %Write Sine Data channel values
    [err,dummyVar] = calllib(libname,'DDC_SetDataValues',sinechan,Sine(:,i),length(t));
    
    %Add a new Noise Data channel
    channame = ['Noise Data ' num2str(i)];
    chandesc = 'Randomly generated noise data';
    [err,dummyVar,dummyVar,dummyVar,noisechan] = calllib(libname,'DDC_AddChannel',noisegrp,'DDC_Double',channame,chandesc,chanunitstring,noisechanIn);
    %Write Noise Data channel values
    [err,dummyVar] = calllib(libname,'DDC_SetDataValues',noisechan,Noise(:,i),length(t));
    
    %Add a new Noisy Sine Data channel
    channame = ['Noisy Sine Data ',num2str(i)];
    chandesc = ['A = ' num2str(Amps(i)) ', F = ' num2str(Freqs(i)) 'with noise'];
    [err,dummyVar,dummyVar,dummyVar,noisysinechan] = calllib(libname,'DDC_AddChannel',noisysinegrp,'DDC_Double',channame,chandesc,chanunitstring,noisysinechanIn);
    %Write Noisy Sine Data channel values
    [err,dummyVar] = calllib(libname,'DDC_SetDataValues',noisysinechan,NoisySine(:,i),length(t));
end

%Save file
err = calllib(libname,'DDC_SaveFile',file);

%Close file
err = calllib(libname,'DDC_CloseFile',file);

%Unload nilibddc.dll
unloadlibrary(libname);