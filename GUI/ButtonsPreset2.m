function varargout = ButtonsPreset2(varargin)
% BUTTONSPRESET2 MATLAB code for ButtonsPreset2.fig
%      BUTTONSPRESET2, by itself, creates a new BUTTONSPRESET2 or raises the existing
%      singleton*.
%
%      H = BUTTONSPRESET2 returns the handle to a new BUTTONSPRESET2 or the handle to
%      the existing singleton*.
%
%      BUTTONSPRESET2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUTTONSPRESET2.M with the given input arguments.
%
%      BUTTONSPRESET2('Property','Value',...) creates a new BUTTONSPRESET2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ButtonsPreset2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ButtonsPreset2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ButtonsPreset2

% Last Modified by GUIDE v2.5 03-Apr-2017 20:39:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ButtonsPreset2_OpeningFcn, ...
                   'gui_OutputFcn',  @ButtonsPreset2_OutputFcn, ...
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


% --- Executes just before ButtonsPreset2 is made visible.
function ButtonsPreset2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ButtonsPreset2 (see VARARGIN)

% Choose default command line output for ButtonsPreset2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ButtonsPreset2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global fs;
fs = 100;


% --- Outputs from this function are returned to the command line.
function varargout = ButtonsPreset2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%% THIS:
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global fs
customfs = str2double(get(hObject, 'String'));
fs = customfs;
if customfs <= 0 || isnan(customfs)
    set(hObject, 'String', 'Try Again');
    errordlg('Input must be a real positive number','Error');
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% THIS: 
% --- Executes when selected object is changed in samplingGroup.
function samplingGroup_SelectionChangedFcn(hObject, eventdata, handles)
global fs
if (hObject == handles.defaultbutton)
    set(handles.edit1, 'String', '');
    set(handles.edit1,'BackgroundColor','w');
    fs = 100;
else
    set(handles.edit1, 'String', 'Enter');
    set(handles.edit1,'BackgroundColor','y');
end

% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
global fs
set(handles.edit2,'String',fs);
axes(handles.axes1);
plot(linspace(0,1),fs*linspace(0,1))
grid on

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
