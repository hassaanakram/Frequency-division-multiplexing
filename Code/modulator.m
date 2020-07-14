%% ________________________________________________________________________
%
%                          END OF TERM PROJECT
%                          SIGNALS AND SYSTEMS
%                               GROUP - E
% _________________________________________________________________________
% GROUP MEMBERS:
%               MUHAMMAD ADIL
%               MUHAMMAD ASAD KHALIL RAO
%               MUHAMMAD BILAL
%               MUHAMMAD HASEEB AKHLAQ
%               MUHAMMAD HASSAAN
%               MUSHARRAF QADIR
%
% WORK DISTRIBUTION: 
%__________________________________________________________________________
%                          |
% GROUP MEMBER             |           TASK(S) PERFORMED
% _________________________|_______________________________________________
% MUHAMMAD ADIL            | FILE INPUT, AUDIO SIGNAL READING, PADDING
%                          |
% MUHAMMAD ASAD KHALIL RAO | FILTER DESIGN (LOWPASS, BANDPASS)
%                          |              
% MUHAMMAD BILAL           | HELPER FUNCTIONS: fTransform, plotGraph,
%                          | bandpass
%                          |
% MUHAMMAD HASEEB AKHLAQ   | MODULATION ROUTINE, MULTIPLEXING ROUTINE
%                          | 
% MUHAMMAD HASSAAN         | GUI, JOINING INDIVIDUAL CODE COMPONENTS
%                          |
% MUSHARRAF QADIR          | AUDIO PLAYBACK ROUTINE
%__________________________________________________________________________

%% MAIN WINDOW FUNCTIONS
function varargout = modulator(varargin)
% MODULATOR MATLAB code for modulator.fig
%      MODULATOR, by itself, creates a new MODULATOR or raises the existing
%      singleton*.
%
%      H = MODULATOR returns the handle to a new MODULATOR or the handle to
%      the existing singleton*.
%v 
%      MODULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODULATOR.M with the given input arguments.
%
%      MODULATOR('Property','Value',...) creates a new MODULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before modulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to modulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help modulator

% Last Modified by GUIDE v2.5 08-Jul-2020 15:51:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @modulator_OpeningFcn, ...
                   'gui_OutputFcn',  @modulator_OutputFcn, ...
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


% --- Executes just before modulator is made visible.
function modulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.inputCount = 0; guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = modulator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%% MAIN WINDOW FUNCTIONS END

%% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FILE OPEN DIALOGUE BOX
[inputFiles, inputPaths] = uigetfile({'*.ogg'; '*.wav'; '*.mp3'}, ...
    'MultiSelect', 'on');

% NO FILE SELECTED
if (isequal(inputFiles, 0)),
    % UPDATE THE STATUS BAR WITH NO FILE SELECTED WARNING
    set(handles.statusText, 'String', 'No file selected');
    drawnow;
else
    % ONLY ONE FILE SELECTED: inputFiles IS A VECTOR
    if(~(iscell(inputFiles))),
        % CONVERTING INPUT FILES TO A CELL ARRAY 
        inputFiles = cellstr(inputFiles);
    end;
    
    n = length(inputFiles);
    if (n > 4)
        inputFiles = inputFiles{1:4};
        n = 4;
    end;
    
    % READ AUDIO FILES AND PROCESS, 
    audioData = cell(n,2);
    sampleRate = cell(n,1);
    fourierTransform = cell(n, 2); % Frequency axis, magnitude spectrum

    for i = 1 : n,
        % SET STATUS LABEL
        str = sprintf('Reading and taking Fourier Transform of signal %d', i);
        set(handles.statusText, 'String', str);
        drawnow;
        % READ AUDIO DATA
        fileName =  fullfile(inputPaths, inputFiles{i});
        [audioData{i, 2}, sampleRate{i, 1}] = audioread(fileName);
        Fs = sampleRate{i, 1};
        % STORING THE TIME AXIS
        audioData{i, 1} = 0 : 1/Fs : (length(audioData{i, 2})-1)/Fs;
        %TAKING FOURIER TRANSFORM AND NORMALIZING AXES
        [fourierTransform{i, 1}, fourierTransform{i, 2}] = fTransform(audioData{i, 2}, Fs);
    end;

    % PADDING THE SHORTER SIGNALS WITH ZEROS TO MATCH THE LONGEST
    % ONLY IF MORE THAN ONE SIGNALS WERE INPUT
    if(n > 1),
        lengths = zeros(1, n);
        for i = 1 : n,
            lengths(1,i) = length(audioData{i,1});
        end;
        maxLength = max(lengths);
        for i = 1 : n,
            audioData{i, 1} = [audioData{i,1}, zeros(1, maxLength-length(audioData{i,1}))];
            audioData{i, 2} = [audioData{i,2}; zeros(maxLength-length(audioData{i,2}), 1)];
        end;
    end;
    
    % SHARE TO APPDATA 
    handles.inputCount = handles.inputCount + 1; guidata(hObject, handles);
    str = sprintf('InputBatchTime%d', handles.inputCount);
    setappdata(handles.input, str, audioData);
    str = sprintf('sampleRate%d', handles.inputCount);
    setappdata(handles.input, str, sampleRate);
    str = sprintf('InputBatchFreq%d', handles.inputCount);
    setappdata(handles.input, str, fourierTransform);
    str = sprintf('n%d', handles.inputCount);
    setappdata(handles.input, str, n);
    
    % POPULATE POPUP LIST
    str1 = sprintf('InputBatchTime%d', handles.inputCount);
    str2 = sprintf('InputBatchFreq%d', handles.inputCount);
    current_entries = cellstr(get(handles.viewGraph, 'String'));
    current_entries{end+1} = str1;
    current_entries{end+1} = str2;
    set(handles.viewGraph, 'String', current_entries);
    set(handles.viewGraph, 'Value', length(current_entries)-1);
    % PLOT
    plotGraph(0, audioData, handles, n);
    % SET STATUS TEXT
    set(handles.statusText, 'String', 'Time Domain Graph plotted. You may change plot by selecting from the dropdown');

end;

%% --- Executes on button press in lpf.
function lpf_Callback(hObject, eventdata, handles)
% hObject    handle to lpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% CHECK FOR EMPTY CELLS
% GET SELECTION FROM DROP DOWN
idx = get(handles.viewGraph,'Value');
items = cellstr(get(handles.viewGraph,'String'));
str = items{idx};
j = str(end);

if (strcmp(str, 'Select Graph')),
    set(handles.statusText, 'String', 'No file loaded');
    drawnow;
else   
    % CHECK IF THE SELECTED SIGNAL IS IN TIME DOMAIN
    if (isempty(strfind(str, 'Freq'))),
        % ITS IN TIME DOMAIN, FETCH DATA
        %str = sprintf('InputBatchTime%c', j);
        audioData = getappdata(handles.input, str);
        str = sprintf('sampleRate%c', j);
        sampleRate = getappdata(handles.input, str);
        str = sprintf('n%c', j);
        n = getappdata(handles.input, str);
        
        fourierTransform = cell(n, 2); % Frequency axis, magnitude spectrum
        lowPassedSignal = cell(n,2);

        for i = 1 : n,
            str = sprintf('Applying 3kHz LPF & Fourier Transform on signal %d', i);
            set(handles.statusText, 'String', str);
            drawnow;
            % LPF
            lowPassedSignal{i, 2} = lowPass(audioData{i, 2});
            Fs = sampleRate{i, 1};
            % STORING THE TIME AXIS
            lowPassedSignal{i, 1} = audioData{i, 1};
            %TAKING FOURIER TRANSFORM AND NORMALIZING AXES
            [fourierTransform{i, 1}, fourierTransform{i, 2}] = fTransform(lowPassedSignal{i, 2}, Fs);
        end;
    
    % CHECK IF Demodulator is selected
    if(get(handles.mode, 'Value') == 0)
        subStr = '';
    else
        subStr = 'Demod';
        set(handles.mode, 'Value', 1);
    end;
        % SHARE TO APPDATA
        str = sprintf([subStr,'LPFBatchTime%c'], j);
        setappdata(handles.input, str, lowPassedSignal);
        str = sprintf([subStr,'LPFBatchFreq%c'], j);
        setappdata(handles.input, str, fourierTransform);

        % POPULATE POPUP LIST
        str1 = sprintf([subStr,'LPFBatchTime%c'], j);
        str2 = sprintf([subStr,'LPFBatchFreq%c'], j);
        current_entries = cellstr(get(handles.viewGraph, 'String'));
        current_entries{end+1} = str1;
        current_entries{end+1} = str2;
        set(handles.viewGraph, 'String', current_entries);
        set(handles.viewGraph, 'Value', length(current_entries)-1);
        % PLOT
        plotGraph(0, audioData, handles, n);
        
        set(handles.statusText, 'String', 'LPF Time Domain signal plotted. You may change by selecting from dropdown');
    else
        set(handles.statusText, 'String', 'You selected Frequency domain signal. Please select Time domain signal');
    end;  
end;

%% --- Executes on button press in mod.
function mod_Callback(hObject, eventdata, handles)
% hObject    handle to mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% MODULATION CALLBACK
% THE TRICK HERE IS THAT WE HAVE DEFINED A VECTOR WITH 4 HARD CODED
% MODULATION FREQUENCIES THAT WILL BE USED IN A SEQUENCE
set(handles.statusText, 'String', 'Modulating Signals');
drawnow;

modulationFreq = [3e3, 9e3, 15e3, 21e3];

% CHECK FOR EMPTY CELLS
% GET SELECTION FROM DROP DOWN
idx = get(handles.viewGraph,'Value');
items = cellstr(get(handles.viewGraph,'String'));
str = items{idx};
j = str(end);

if (strcmp(str, 'Select Graph')),
    set(handles.statusText, 'String', 'No file loaded');
    drawnow;
else
    % CHECK FOR FREQUENCY DOMAIN SELECTION
    if (isempty(strfind(str, 'Freq'))),
        %str = sprintf('LPFBatchTime%c', j);
        audioSignal = getappdata(handles.input, str);
        str = sprintf('sampleRate%c', j);
        sampleRate = getappdata(handles.input, str);
        str = sprintf('n%c', j);
        n = getappdata(handles.input, str);
        
        % DEFINE CONTAINERS
        cosines = cell(n, 1);
        modulatedSignals = cell(n, 2);
        fourierTransform = cell(n, 2);
    
        % CHECK IF Demodulator is selected
        if(get(handles.mode, 'Value') == 0)
        subStr = 'ModulationBatch';
        %multiplier = 1;
        else
            subStr = 'DemodBatch';
            set(handles.mode, 'Value', 1);
            %multiplier = 4;
        end;
        multiplier = 1;
        % CREATE COSINES AND MODULATE/DEMODULATE
        for i = 1 : n,
            Fs = sampleRate{i, 1};
            t = audioSignal{i,1};
            cosines{i, 1} = (cos(2*pi*modulationFreq(i).*t))';
            modulatedSignals{i, 2} = multiplier .* cosines{i, 1} .* audioSignal{i, 2};
            % STORING THE TIME AXIS
            modulatedSignals{i, 1} = audioSignal{i, 1};
            [fourierTransform{i, 1}, fourierTransform{i, 2}] = fTransform(modulatedSignals{i,2},...
                                                                Fs);
        end;
    
        % SHARE TO APPDATA
        str = sprintf([subStr,'Time%c'], j);
        setappdata(handles.input, str, modulatedSignals);
        str = sprintf([subStr,'Freq%c'], j);
        setappdata(handles.input, str, fourierTransform);

        % POPULATE POPUP LIST
        str1 = sprintf([subStr,'Time%c'], j);
        str2 = sprintf([subStr,'Freq%c'], j);
        current_entries = cellstr(get(handles.viewGraph, 'String'));
        current_entries{end+1} = str1;
        current_entries{end+1} = str2;
        set(handles.viewGraph, 'String', current_entries);
        set(handles.viewGraph, 'Value', length(current_entries)-1);
        % PLOT
        plotGraph(0, modulatedSignals, handles, n);
        
    set(handles.statusText, 'String', 'Modulated Time Domain signal plotted. You may change by selecting from dropdown');
else
    set(handles.statusText, 'String', 'You selected Frequency domain signal. Please select Time domain signal');

    end;
end;

%% --- Executes on button press in sum.
function sum_Callback(hObject, eventdata, handles)
% hObject    handle to sum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% THIS FUNCTION MULTIPLEXES MODULATED SIGNALS

% CHECK FOR EMPTY CELLS
% GET SELECTION FROM DROP DOWN
idx = get(handles.viewGraph,'Value');
items = cellstr(get(handles.viewGraph,'String'));
str = items{idx};
j = str(end);

if (strcmp(str, 'Select Graph')),
    set(handles.statusText, 'String', 'No file loaded');
    drawnow;
else
    fourierTransform = cell(1,3);
    fourierTransform{1, 3} = -1;
    % CHECK FOR FREQUENCY DOMAIN SELECTION
    if (isempty(strfind(str, 'Freq'))),

        audioSignal = getappdata(handles.input, str);
        str = sprintf('n%c', j);
        n = getappdata(handles.input, str);
        
        % CREATE SUMMED SIGNAL CELL ARRAY. FIRST DIMENSION BEING THE TIME AXIS
        summedSignal = {[0:1/48000:(length(audioSignal{1,1})-1)/48000], zeros(length(audioSignal{1,1}), 1), -1};
    
        for i = 1 : n,
            summedSignal{1,2} = audioSignal{i, 2} + summedSignal{1,2};
        end;
        [fourierTransform{1,1}, fourierTransform{1,2}] = fTransform(summedSignal{1,2}, 48000);
        
        % SHARE TO APPDATA
        str = sprintf('SumTime%c', j);
        setappdata(handles.input, str, summedSignal);
        str = sprintf('SumFreq%c', j);
        setappdata(handles.input, str, fourierTransform);
        % POPULATE POPUP LIST
        str1 = sprintf('SumTime%c', j);
        str2 = sprintf('SumFreq%c', j);
        current_entries = cellstr(get(handles.viewGraph, 'String'));
        current_entries{end+1} = str1;
        current_entries{end+1} = str2;
        set(handles.viewGraph, 'String', current_entries);
        set(handles.viewGraph, 'Value', length(current_entries)-1);
        % PLOT
        plotGraph(1, summedSignal, handles, 1);
        plotGraph(1, fourierTransform, handles, 2);
        set(handles.statusText, 'String', 'Multiplexed signal plotted. You may change by selecting from dropdown');
    else
        set(handles.statusText, 'String', 'You selected Frequency domain signal. Please select Time domain signal');    
    end;
end;

%% --- Executes on button press in bpf.
function bpf_Callback(hObject, eventdata, handles)
% hObject    handle to bpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% BAND PASS FILTERATION FUNCTION
bands = [3,9,15,21];

% CHECK FOR EMPTY CELLS
% GET SELECTION FROM DROP DOWN
idx = get(handles.viewGraph,'Value');
items = cellstr(get(handles.viewGraph,'String'));
str = items{idx};
j = str(end);
if (strcmp(str, 'Select Graph')),
    set(handles.statusText, 'String', 'No file loaded');
    drawnow;
else
    % CHECK FOR FREQUENCY DOMAIN SELECTION
    if (isempty(strfind(str, 'Freq'))),
        % FETCH APPDATA
        str = sprintf('SumTime%c', j);
        audioSignal = getappdata(handles.input, str);
        str = sprintf('InputBatchTime%c', j);
        inputAudio = getappdata(handles.input, str);
        str = sprintf('sampleRate%c', j);
        sampleRate = getappdata(handles.input, str);
        str = sprintf('n%c', j);
        n = getappdata(handles.input, str);
    
        % CREATE CELL ARRAYS TO HOLD SIGNALS AND FOURIER TRANSFORMS
        separatedSignals = cell(n, 2);
        fourierTransform = cell(n, 2);

        for i = 1 : n,
            % ITERATINIG n TIMES TO BANDPASS FILTER RECEIVED SIGNAL
            str = sprintf('Applying BPF to signal %d', i);
            drawnow;
            set(handles.statusText, 'String', str);
            separatedSignals{i, 2} = bandPass(audioSignal{1, 2}, bands(i));
            separatedSignals{i, 1} = inputAudio{i,1};
            [fourierTransform{i,1}, fourierTransform{i,2}] = fTransform(separatedSignals{i, 2}, ...
                                                        sampleRate{i,1});
        end;

        % SHARE TO APPDATA
        str = sprintf('SeparatedSignalTime%c', j);
        setappdata(handles.input, str, separatedSignals);
        str = sprintf('SeparatedSignalFreq%c', j);
        setappdata(handles.input, str, fourierTransform);

        % POPULATE POPUP LIST
        str1 = sprintf('SeparatedSignalTime%c', j);
        str2 = sprintf('SeparatedSignalFreq%c', j);
        current_entries = cellstr(get(handles.viewGraph, 'String'));
        current_entries{end+1} = str1;
        current_entries{end+1} = str2;
        set(handles.viewGraph, 'String', current_entries);
        set(handles.viewGraph, 'Value', length(current_entries)-1);
        % PLOT
        plotGraph(0, separatedSignals, handles, n);
        
        set(handles.statusText, 'String', 'Separated signals plotted. You may change by selecting from dropdown');
        drawnow;
    else
        set(handles.statusText, 'String', 'You selected Frequency domain signal. Please select Time domain signal');    
    end
end
    
%% --- Executes on button press in radiobutton2.
function timeDomain_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


%% --- Executes on button press in radiobutton3.
%function freqDomain_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


%% --- Executes on slider movement.
% function slider1_Callback(hObject, eventdata, handles)
% % hObject    handle to slider1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'Value') returns position of slider
% %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 
% %Slider step depends on how fast you want to scroll the bar. 
% set(handles.slider1, 'SliderStep', [1/5,2/5]); 
% %Get slider's position 
% sl_pos = get(hObject, 'Value'); 
% %Get uipanel1 position 
% panel_pos = get(handles.plotsPanel, 'Position'); 
% %Get uipanel2 
% fig_pos = get(handles.uipanel2, 'Position'); 
% %Set uipanel1 new position 
% set(handles.plotsPanel, 'Position', [panel_pos(1), -sl_pos*(panel_pos(4) - fig_pos(4)), panel_pos(3), panel_pos(4)]);

%% --- Executes during object creation, after setting all properties.
% function slider1_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to slider1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end


%% --- Executes when selected object is changed in radioPanel.
% function radioPanel_SelectionChangeFcn(hObject, eventdata, handles)
% % hObject    handle to the selected object in radioPanel 
% % eventdata  structure with the following fields (see UIBUTTONGROUP)
% %	EventName: string 'SelectionChanged' (read only)
% %	OldValue: handle of the previously selected object or empty if none was selected
% %	NewValue: handle of the currently selected object
% % handles    structure with handles and user data (see GUIDATA)
% % timeDom = get(handles.timeDomain, 'Value');
% % freqDom = get(handles.freqDomain, 'Value');
% % 
% % % RETRIEVE appdata
% % audioData = getappdata(handles.input, 'timeDomain');
% % fourierTransform = getappdata(handles.input, 'fourierTransform');
% % n = getappdata(handles.input, 'n');
% % 
% % if (timeDom == 1),
% %     plotGraph(0, audioData, handles, n);
% % elseif (freqDom == 1),
% %     plotGraph(1, fourierTransform, handles, n);
% % end;
% % set(handles.statusText, 'String', 'Done');

%% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % create the data cursor object
 handles.datacursor = datacursormode;
 % enable the data cursor object
 set(handles.datacursor,'Enable','on');
% Hint: place code in OpeningFcn to populate axes7


%% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % create the data cursor object
 handles.datacursor = datacursormode;
 % enable the data cursor object
 set(handles.datacursor,'Enable','on');
% Hint: place code in OpeningFcn to populate axes9


%% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % create the data cursor object
 handles.datacursor = datacursormode;
 % enable the data cursor object
 set(handles.datacursor,'Enable','on');
% Hint: place code in OpeningFcn to populate axes8


%% --- Executes during object creation, after setting all properties.
function axes10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % create the data cursor object
 handles.datacursor = datacursormode;
 % enable the data cursor object
 set(handles.datacursor,'Enable','on');
% Hint: place code in OpeningFcn to populate axes10


% --- Executes on selection change in viewGraph.
% function viewGraph_Callback(hObject, eventdata, handles)
% % hObject    handle to viewGraph (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns viewGraph contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from viewGraph


%% --- Executes during object creation, after setting all properties.
function viewGraph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes during object creation, after setting all properties.
function input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% timeDom = get(handles.timeDomain, 'Value');
% freqDom = get(handles.freqDomain, 'Value');

% RETRIEVE appdata
idx = get(handles.viewGraph,'Value');
items = cellstr(get(handles.viewGraph,'String'));
str = items{idx};
% CHECK IF SELECTION IS VALID
if(strcmp(str, 'Select Graph')),
    set(handles.statusText, 'String', 'No file loaded');
    drawnow;
else
  audioData = getappdata(handles.input, str);
  j = str(end);
  str = sprintf('n%c', j);
  n = getappdata(handles.input, str);
  % PLOT
  if(~(size(audioData, 2) == 3)),
    plotGraph(0, audioData, handles, n);
  else
      plotGraph(-1, audioData, handles, n);
  end;
  set(handles.statusText, 'String', 'Done');
end;


%% --- Executes on button press in mode.
% function mode_Callback(hObject, eventdata, handles)
% % hObject    handle to mode (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of mode


%% --- Executes on button press in closeSum.
% function closeSum_Callback(hObject, eventdata, handles)
% % hObject    handle to closeSum (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% cla(handles.sumAxes);
% set(handles.sumAxes, 'Visible', 'off');
% set(handles.closeSum, 'Visible', 'off');


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% TO PLAY SELECTED BATCH

% GET audioData
  idx = get(handles.viewGraph,'Value');
  items = cellstr(get(handles.viewGraph,'String'));
  str = items{idx};
% CHECK IF SELECTION IS NOT NULL (SELECT GRAPH)
if(strcmp(str, 'Select Graph')),
    set(handles.statusText, 'String', 'No file loaded');
    drawnow;
else
  % CONFIRM IF TIMEDOMAIN SELECTION IS MADE
  if (isempty(strfind(str, 'Freq'))),    
    audioData = getappdata(handles.input, str);
    j = str(end);
    str = sprintf('n%c', j);
    n = getappdata(handles.input, str);
    str = sprintf('sampleRate%c', j);
    sampleRate = getappdata(handles.input, str);
    
    % NOW PLAY ! !
    for i = 1 : n,
        str = sprintf('Playing audio clip %d', i);
        set(handles.statusText, 'String', str);
        duration = length(audioData{i,1})/sampleRate{i};
        drawnow();
        sound(audioData{i, 2}, sampleRate{i});
        pause(duration);
    end;
  else
      set(handles.statusText, 'String', 'Cannot play a frequency domain signal. Select Time domain');
  end;
end;


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
!notepad help.txt
