function varargout = Spiker(varargin)
% SPIKER MATLAB code for Spiker.fig
%      SPIKER, by itself, creates a new SPIKER or raises the existing
%      singleton*.
%
%      H = SPIKER returns the handle to a new SPIKER or the handle to
%      the existing singleton*.
%
%      SPIKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPIKER.M with the given input arguments.
%
%      SPIKER('Property','Value',...) creates a new SPIKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Spiker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Spiker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Spiker

% Last Modified by GUIDE v2.5 15-Jun-2018 19:29:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Spiker_OpeningFcn, ...
                   'gui_OutputFcn',  @Spiker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Spiker is made visible.
function Spiker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Spiker (see VARARGIN)
% Choose default command line output for Spiker
handles.output = hObject;
set(handles.algorithmSelectionBG,'selectedobject',[]);
addpath(genpath(pwd));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Spiker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Spiker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in testSignalSelect.
function testSignalSelect_Callback(hObject, eventdata, handles)
str = get(hObject,'string');
val = get(hObject,'value');
handles.testsignaltype=str{val};
set(handles.generateTestSignalButton,'visible','on');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function testSignalSelect_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in generateTestSignalButton.
function generateTestSignalButton_Callback(hObject, eventdata, handles)
try [signal,handles.Fsample] = testSignal(handles.testsignaltype);
catch
    return
end

if ~isempty(get(handles.algorithmSelectionBG,'selectedobject'))
    set(handles.encodeButton,'visible','on')
end
handles.signal = signal;
guidata(hObject, handles);
set(handles.thresholdSlider,'Max',0.3*range(handles.signal));
set(handles.thresholdSearchButton,'visible','on');
plot(handles.signalPlot,handles.signal);
'Signal size'
size(handles.signal)
% --- Executes on button press in thresholdSearchButton.
function thresholdSearchButton_Callback(hObject, eventdata, handles)
signal=handles.signal;
switch handles.selectedAlgorithm
    case 'sfButton'
        i=1;
        clear search_snr search_rate search_t search_rmse search_r2
        for threshold = (0.001:0.001:0.8)*range(signal)
            [spikes, start]=SF(signal,threshold);
            recon = SF_de(spikes,threshold,start);
            search_snr(i)=snr(signal,recon-signal);
            search_rate(i)=mean(abs(spikes));
            search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
            search_t(i) = threshold;
            search_r2(i)=rsquared(signal,recon);
            if search_rate(i)<0.001
                break
            end    
            i=i+1;
        end
    case 'tbrButton'
        i=1;
        clear search_snr search_rate search_f search_t search_rmse search_r2
        bounds=[min(signal) max(signal)];
        for factor = 0.01:0.001:2
            search_f(i)=factor;
            [spikes, threshold, stpt]=TBR(signal,factor);
            recon = TBR_de(spikes,threshold,stpt);    %scaling here!!
        %     recon = TBR_de_sc(spikes,threshold,bounds,stpt);    %scaling here!!
            search_snr(i)=snr(signal,recon-signal);
            search_rate(i)=mean(abs(spikes));
            search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
            search_r2(i)=rsquared(signal,recon);
        %     if search_rate(i)<0.05
        %         break
        %     end
            i=i+1;
        end
        search_t=search_f; %renaming
    case 'mwButton'
        i=1;
        windowsize=handles.windowsize;
        clear search_snr search_rate search_t search_rmse search_r2
        for threshold = (0.002:0.001:0.8)*range(signal)
            search_t(i)=threshold;
            [spikes,stpt]=MW(signal,threshold,windowsize);
            recon = MW_de(spikes,threshold,windowsize,stpt); %scaling here!
        %     recon = MW_de_sc(spikes,threshold,windowsize,bounds,stpt); %scaling here!
            search_snr(i)=snr(signal,recon-signal);
            search_rate(i)=mean(abs(spikes));
            search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
            search_r2(i)=rsquared(signal,recon);
            if search_rate(i)<0.005
                break
            end
            i=i+1;
        end
    case 'bsaButton'
        i=1;
        clear search_snr search_rate search_t search_rmse search_r2
        shift = min(signal);
        signal=signal - min(signal); %shift to zero min
        Fs=handles.Fsample;
        cutoffN = handles.cutoff/(Fs/2); %normalizing cutoff
        fir=fir1(handles.windowsize,cutoffN);
        fir=fir*abs(max(signal)-0)*2; 
        for threshold = 0.8:0.001:1.1
            search_t(i)=threshold;
            spikes=BSAmult(signal,fir,threshold); % mult!!
            recon = conv(spikes,fir,'full');
            recon=recon(1:(min(length(recon),length(signal))));
%             recon = recon + shift;
            search_snr(i)=snr(signal(1:length(recon)),recon-signal(1:length(recon)));
            search_rate(i)=sum(spikes)/length(spikes);
            search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
            search_r2(i)=rsquared(signal,recon);
            i=i+1;
        end
end
%export to handles
handles.search_snr=search_snr;
handles.search_t=search_t;
set(handles.optimThresholdButton,'visible','on');
guidata(hObject,handles);
[m, i]=max(handles.search_snr);
optimthreshold=handles.search_t(i);
msgformat='Optimum @ threshold=%.4g with SNR=%.4g dB';
message=sprintf(msgformat,optimthreshold,m);

% axes(handles.optimizationPlot)
subplot(2,1,1,handles.optimizationPlot)
plot(search_t,search_snr)
title(handles.optimizationPlot,message)
xlim([min(search_t) max(search_t)])
ylabel('SNR')
% subplot(4,1,2)
% plot(search_t,search_rmse)
% xlim([min(search_t) max(search_t)])
% ylabel('RMSE')
% subplot(4,1,3)
% plot(search_t,search_r2)
% xlim([min(search_t) max(search_t)])
% % ylim([-1 1])
% ylabel('R2')
subplot(2,1,2)
plot(search_t,search_rate)
xlim([min(search_t) max(search_t)])
ylabel('firing rate')


% --- Executes during object creation, after setting all properties.
function algorithmSelectionBG_CreateFcn(hObject, eventdata, handles)
handles.selectedAlgorithm='sfButton'; %initialize
guidata(hObject, handles);



% --- Executes when selected object is changed in algorithmSelectionBG.
function algorithmSelectionBG_SelectionChangedFcn(hObject, eventdata, handles)
handles.selectedAlgorithm=get(get(handles.algorithmSelectionBG,'SelectedObject'),'Tag');
set(handles.thresholdSlider,'Min',0);
set(handles.thresholdSlider,'Value',0);
set(handles.gridSearchButton,'visible','off');
if isfield(handles,'signal')
    set(handles.encodeButton,'visible','on');
else
    errordlg('No signal loaded!')
    return
end

switch handles.selectedAlgorithm
    case 'tbrButton'
        set(handles.thresholdSlider,'Max',3);
        set(handles.windowsizeEdit,'visible','off');
        set(handles.cutoffEdit,'visible','off');
        handles.threshold = 1.5;  % default threshold value
        set(handles.checkFilterButton,'visible','off');
    case 'bsaButton'
        set(handles.thresholdSlider,{'Max','Min'},{1.15,0.85});
        set(handles.windowsizeEdit,'visible','on');
        set(handles.cutoffEdit,'visible','on');
        set(handles.checkFilterButton,'visible','on');
        handles.threshold = 0.95;  % default threshold value
        handles.windowsize = 24; % default windowsize value
        set(handles.gridSearchButton,'visible','on');
    case 'sfButton'
        set(handles.thresholdSlider,'Max',0.3*range(handles.signal));
        set(handles.windowsizeEdit,'visible','off');
        set(handles.cutoffEdit,'visible','off');
        set(handles.checkFilterButton,'visible','off');
    case 'mwButton'
        set(handles.thresholdSlider,'Max',0.3*range(handles.signal));
        set(handles.windowsizeEdit,'visible','on');
        set(handles.cutoffEdit,'visible','off');
        set(handles.checkFilterButton,'visible','on');
        handles.windowsize = 8; % default windowsize value
        set(handles.gridSearchButton,'visible','on');
end
guidata(hObject, handles);
set(handles.thresholdEdit,'String',num2str(handles.threshold));
set(handles.windowsizeEdit,'String',num2str(handles.windowsize));
set(handles.thresholdSlider,'Value',handles.threshold);

% --- Executes on button press in thresholdSearchButton.
function thresholdEdit_Callback(hObject, eventdata, handles)
handles.threshold=str2num(get(hObject,'String'));
set(handles.thresholdSlider,'Value',handles.threshold);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function thresholdEdit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.threshold=0;
set(hObject,'string',num2str(handles.threshold));
guidata(hObject,handles);




% --- Executes on button press in encodeButton.
function encodeButton_Callback(hObject, eventdata, handles)
if ~isfield(handles,'signal')
    errordlg('No signal loaded!')
    return
end
handles.threshold=str2double(get(handles.thresholdEdit,'string'));
handles.windowsize=str2double(get(handles.windowsizeEdit,'string'));
handles.cutoff=str2double(get(handles.cutoffEdit,'string'));
switch handles.selectedAlgorithm
    case {'sfButton','SF'}
        [spikes, start]=SF(handles.signal,handles.threshold);
        recon = SF_de(spikes,handles.threshold,start);
        rmse = sqrt(sum((handles.signal-recon).^2)/length(handles.signal));
        try currentSNR = snr(handles.signal(1:length(recon)),recon-handles.signal(1:length(recon)));
        catch %this is added for older matlab version compatibility (no snr)
        end
        msgformat='Results: encoded with %s \n threshold=%.4g \n RMSE=%.4g';
        message=sprintf(msgformat,'SF',handles.threshold,rmse);             
    case 'tbrButton'
        [spikes, thr,start]=TBR(handles.signal,handles.threshold);
        recon = TBR_de(spikes,thr,start);
        rmse = sqrt(sum((handles.signal-recon).^2)/length(handles.signal));
        try currentSNR = snr(handles.signal(1:length(recon)),recon-handles.signal(1:length(recon)));
        catch
        end
        msgformat='Results: encoded with %s \n threshold=%.4g \n RMSE=%.4g';
        message=sprintf(msgformat,'TBR',handles.threshold,rmse);
    case 'mwButton'
        [spikes,start]=MW(handles.signal,handles.threshold,handles.windowsize);
        recon = MW_de(spikes,handles.threshold,handles.windowsize,start); % no scaling here!
        rmse = sqrt(sum((handles.signal-recon).^2)/length(handles.signal));
        try currentSNR = snr(handles.signal(1:length(recon)),recon-handles.signal(1:length(recon)));
        catch
        end
        msgformat='Results: encoded with %s \n threshold=%.4g; window size=%d \n RMSE=%.4g';
        message=sprintf(msgformat,'MW',handles.threshold,handles.windowsize,rmse);
    case 'bsaButton'
        signal=handles.signal;
        shift=min(signal);
        signal=signal - min(signal);
        Fs=handles.Fsample;
        cutoffN = handles.cutoff/(Fs/2); %normalizing cutoff
        fir=fir1(handles.windowsize,cutoffN);
        fir=fir*abs(max(signal)-0)*2; 
        spikes=BSAmult(signal,fir,handles.threshold); % BSAmult here
        recon = conv(spikes,fir,'full');
        recon=recon(1:(min(length(recon),length(signal))));
        rmse = sqrt(sum((signal-recon).^2)/length(signal));
        try currentSNR = snr(signal(1:length(recon)),recon-signal(1:length(recon)));
        catch
        end
        msgformat='Results: encoded with %s \n threshold=%.4g; window size=%d; \n cutoff=%.4g; Fsample=%.4g \n RMSE=%.4g';
        message=sprintf(msgformat,'BSA',handles.threshold,handles.windowsize,handles.cutoff,Fs,rmse);
        recon=recon+shift;
end
handles.spikes=spikes;
handles.recon=recon;
set(handles.encodeDisplayText,'string',message);
guidata(hObject,handles);
%plot encoded signals
subplot(2,1,1,handles.signalPlot)
plot(handles.signal)
ylabel('signals')
hold on
plot(handles.recon)
hold off
legend('original','decoded')
subplot(2,1,2)
stem(handles.spikes)
ylabel('spikes')
%update title on optimizationPlot
msgformat='Encoded @ threshold=%.4g with SNR=%.4g dB';
try message=sprintf(msgformat,handles.threshold,currentSNR); %for old version compatibility without SNR function
catch
end
title(handles.optimizationPlot,message);


% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.threshold=get(handles.thresholdSlider,'Value');
set(handles.thresholdEdit,'String',num2str(handles.threshold));
guidata(hObject,handles)
encodeButton_Callback(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function thresholdSlider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in optimThresholdButton.
function optimThresholdButton_Callback(hObject, eventdata, handles)
[~, i]=max(handles.search_snr);
handles.threshold=handles.search_t(i);
guidata(hObject,handles);
set(handles.thresholdEdit,'String',num2str(handles.threshold));
set(handles.thresholdSlider,'Value',handles.threshold);
encodeButton_Callback(hObject,eventdata,handles);



function windowsizeEdit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of windowsizeEdit as text
%        str2double(get(hObject,'String')) returns contents of windowsizeEdit as a double
handles.windowsize=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function windowsizeEdit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.windowsize=8;
set(hObject,'String',num2str(handles.windowsize));
guidata(hObject,handles);



function cutoffEdit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of cutoffEdit as text
%        str2double(get(hObject,'String')) returns contents of cutoffEdit as a double
handles.cutoff=str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function cutoffEdit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.cutoff=50;
set(hObject,'string',num2str(handles.cutoff));
guidata(hObject,handles);


% --- Executes on button press in gridSearchButton.
function gridSearchButton_Callback(hObject, eventdata, handles)
signal=handles.signal;
if strcmp(handles.selectedAlgorithm,'mwButton')
    gridSearchMW(signal);
elseif strcmp(handles.selectedAlgorithm,'bsaButton')
    gridSearchBSA(signal,handles.Fsample);
end
guidata(hObject,handles);

% --- Executes on button press in fftButton.
function fftButton_Callback(hObject, eventdata, handles)
figure
subplot(3,1,1)
if isfield(handles,'signal')
    myfft(handles.signal,'input signal',handles.Fsample);
end
subplot(3,1,2)
if isfield(handles,'recon')
    myfft(handles.recon,'reconstructed signal',handles.Fsample);
end
subplot(3,1,3)
if isfield(handles,'spikes')
    myfft(handles.spikes,'spikes',handles.Fsample);
end

% --- Executes on button press in checkFilterButton.
function checkFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to checkFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.selectedAlgorithm
    case 'mwButton'
        mwfir=ones(handles.windowsize,1)/handles.windowsize;
        figure
        freqz(mwfir)
        title(sprintf('Window size = %d',handles.windowsize));
    case 'bsaButton'
        Fs=handles.Fsample;
        cutoffN = handles.cutoff/(Fs/2); %normalizing cutoff
        fir=fir1(handles.windowsize,cutoffN);
        fir=fir*abs(max(handles.signal)-0)*2;
        figure
        impz(fir);
        title(sprintf('Set cutoff frequency = %dHz; Window size = %d',handles.cutoff,handles.windowsize));
        figure
        freqz(fir);
        title(sprintf('Set cutoff frequency = %dHz; Window size = %d',handles.cutoff,handles.windowsize));
end
        
% --------------------------------------------------------------------
function dataMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function loadDataMenu_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.csv;*.xls;*.xlsx;*.txt');
if isequal(FileName,0) || isequal(PathName,0)
   return
else
    answer=inputdlg({'Sampling frequency (Hz)','Data column'},'',1,{'1000','1'});
    tmp=xlsread(strcat(PathName,FileName));
    if str2num(answer{2})>size(tmp,2)
        errordlg('Non-existing column in file')
        return
    end
    handles.signal=tmp(:,str2num(answer{2}));
    handles.Fsample=str2num(answer{1});
    %handles.signal=uiimport(strcat(PathName,FileName));
    set(handles.thresholdSlider,'Max',0.3*range(handles.signal));
    set(handles.thresholdSearchButton,'visible','on');
% Update handles structure
guidata(hObject, handles);
    plot(handles.signalPlot,handles.signal)
end

% --------------------------------------------------------------------
function workspaceMenu_Callback(hObject, eventdata, handles)
if isfield(handles,'signal')
    assignin('base','signal',handles.signal)
end
if isfield(handles,'spikes')
    assignin('base','spikes',handles.spikes)
end
if isfield(handles,'recon')
    assignin('base','recon',handles.recon)
end


% --------------------------------------------------------------------
function restartMenu_Callback(hObject, eventdata, handles)
answer = questdlg('Are you sure?','Restart','Yes','Cancel','Cancel');
answer=answer(1);
if answer == 'Y'
    close(gcbf)
    Spiker
end

% --------------------------------------------------------------------
function plotOriginalMenu_Callback(hObject, eventdata, handles)
try plot(handles.signalPlot,handles.signal)
    ylabel(handles.signalPlot,'signal')
catch
    msgbox('No signal to plot');
end



% --------------------------------------------------------------------
function aboutMenu_Callback(hObject, eventdata, handles)
aboutMessage = sprintf('First developed by Balint Petro from Budapest University of Technology and Economics \n Developed at AUT-KEDRI \n For licence, please see the corresponding licence file in repository. \n First published in 2018');
msgbox(aboutMessage,'About SNN Encoder tools','help');
