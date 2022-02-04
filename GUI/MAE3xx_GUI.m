function varargout = MAE3xx_GUI(varargin)
% MAE3xx_GUI MATLAB code for MAE3xx_GUI.fig
%      MAE3xx_GUI, by itself, creates a new MAE3xx_GUI or raises the existing
%      singleton*.
%
%      H = MAE3xx_GUI returns the handle to a new MAE3xx_GUI or the handle to
%      the existing singleton*.
%
%      MAE3xx_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAE3xx_GUI.M with the given input arguments.
%
%      MAE3xx_GUI('Property','Value',...) creates a new MAE3xx_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAE3xx_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAE3xx_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAE3xx_GUI

% Last Modified by GUIDE v2.5 02-Apr-2017 22:42:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAE3xx_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MAE3xx_GUI_OutputFcn, ...
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


% --- Executes just before MAE3xx_GUI is made visible.
function MAE3xx_GUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAE3xx_GUI (see VARARGIN)

% Choose default command line output for MAE3xx_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAE3xx_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clearvars -global a
global a; %Variable 'a' is available in all functions
a = arduino('com3','uno');
configurePin(a,'D13','DigitalOutput');
configurePin(a,'A5','AnalogInput');
configurePin(a,'A0','AnalogInput');
% Custom Photo
axes(handles.axes5)
matlabImage = imread('Trout.jpg');
image(matlabImage)
axis off
axis image


% --- Outputs from this function are returned to the command line.
function varargout = MAE3xx_GUI_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

function samplingRate_Callback(hObject, ~, handles)
% hObject    handle to samplingRate (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplingRate as text
%        str2double(get(hObject,'String')) returns contents of samplingRate as a double
handles.data1=get(hObject,'String');
handles.fs=str2double(handles.data1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function samplingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingRate (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a gate pulseArray;
pulseArray = 0;
gate = 1;
i = 1;
previ = 0;
x = 0;
while gate == 1
    pulseArray(1,i) = i*(1/(handles.fs)); 
    A = a.readVoltage('A5')*(1024/5);
    pulseArray(2,i) = A;
    B = a.readVoltage('A0')*(1024/5);
    pulseArray(3,i) = B;
    i = i + 1;
    % Plotting
    axes(handles.axesPhoto);
    plot(pulseArray(2,:),'b')
    title('Photodetection'); ylabel('Voltage Integer');
    if (i-previ) > 200  %Refresh x-axis
        x = x + 200; 
        previ = i;
    else
        axis([x 200+x 200 1000])
    end
    axes(handles.axesECG);
    plot(pulseArray(1,:),pulseArray(3,:),'r');
    title('ECG'); ylabel('Voltage Integer');
    axis([x 200+x 0 800])
    % Make pin 13 LED blink w/ heartbeat
    if A >= 600
        writeDigitalPin(a,'D13',1);
    else
        writeDigitalPin(a,'D13',0);
    end
    pause(1/handles.fs);
    string1 = 'bapple';
    set(handles.edit4,'String',string1);
end
    
% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, ~, handles)
% hObject    handle to stop_button (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
global gate pulseArray;
gate = 0;
pulseArray = pulseArray';
csvwrite('pulsefile.csv',pulseArray);



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5
