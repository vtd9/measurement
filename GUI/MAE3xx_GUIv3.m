function varargout = MAE3xx_GUIv3(varargin)
% MAE3xx_GUIV3 MATLAB code for MAE3xx_GUIv3.fig
%      MAE3xx_GUIV3, by itself, creates a new MAE3xx_GUIV3 or raises the existing
%      singleton*.
%
%      H = MAE3xx_GUIV3 returns the handle to a new MAE3xx_GUIV3 or the handle to
%      the existing singleton*.
%
%      MAE3xx_GUIV3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAE3xx_GUIV3.M with the given input arguments.
%
%      MAE3xx_GUIV3('Property','Value',...) creates a new MAE3xx_GUIV3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAE3xx_GUIv3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAE3xx_GUIv3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAE3xx_GUIv3

% Last Modified by GUIDE v2.5 07-Apr-2017 14:00:17
% Written by Vi Dang, for MAE 311
% Group 14: Juan Ramirez Garcia, Kimille Trott

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAE3xx_GUIv3_OpeningFcn, ...
                   'gui_OutputFcn',  @MAE3xx_GUIv3_OutputFcn, ...
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

% --- Executes just before MAE3xx_GUIv3 is made visible.
function MAE3xx_GUIv3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAE3xx_GUIv3 (see VARARGIN)

% Choose threshold command line output for MAE3xx_GUIv3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAE3xx_GUIv3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global a fs gate threshold choice; 
a = arduino()
fs = 100; gate = 1; threshold = 600;
choice = 1;

% --- Outputs from this function are returned to the command line.

function varargout = MAE3xx_GUIv3_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% ---------------------------------------------------------------------- %

function editSamp_Callback(hObject, eventdata, handles)
global fs
customfs = str2double(get(hObject,'String'));
fs = customfs;
if customfs <= 0 || isnan(customfs)
    set(hObject, 'String', 'Try Again');
    errordlg('Sampling rate must be a real positive number!','Error');
end

% --- Executes during object creation, after setting all properties.
function editSamp_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

% --- Executes when selected object is changed in groupSamp.
function groupSamp_SelectionChangedFcn(hObject, eventdata, handles)
global fs
if hObject == handles.buttonDefa
    set(handles.editSamp,'String','','BackgroundColor','w');
    fs = 100;
else
    set(handles.editSamp,'String','Enter','BackgroundColor',hex2rgb('#fbb256'));
end

% ---------------------------------------------------------------------- %
% --- Executes when selected object is changed in groupChoice.

function groupChoice_SelectionChangedFcn(hObject, eventdata, handles)
global choice
if hObject == handles.radiobutton11
    choice = 1;
else
    choice = 2;
end

% ---------------------------------------------------------------------- %

% --- Executes on button press in buttonStar.
function buttonStar_Callback(hObject, eventdata, handles)
global a choice fs gate pinPhot pinECG pulseArray reftime threshold;
pulseArray = zeros(1E3,3); i = 3; previ = 0; x = 0;
gate = 1; B = 100; 
reftime = 0; globalreftime = cputime;
counter = 1; pulsePhoto0 = 0;
counter2 = 1; pulseECG0 = 0;
while gate == 1
    currentTime = cputime;
        pulseArray(i,1) = currentTime - globalreftime;
    if choice == 1
        pulseArray(i,2) = readVoltage(a,pinPhot)*(1024/5);
        %axes(handles.axes1)
        plot(pulseArray(:,2))
        title('Photodetection'); grid on; 
        if pulseArray(i-1,2) > threshold
            if pulseArray(i-2,2) < pulseArray(i-1,2) && pulseArray(i,2) < pulseArray(i-1,2)
                if counter == 1
                    time1 = pulseArray(i-1,1);
                    counter = 2;
                elseif counter == 2
                    time2 = pulseArray(i-1,1);
                    T_photo = time2 - time1;
                    pulsePhoto = T_photo*60;
                    counter = 1;
                    if i <= 20 || (abs(pulsePhoto-pulsePhoto0)/pulsePhoto0) < 0.1
                        if pulsePhoto < 200 && pulsePhoto > 40
                        pulsePhoto0 = pulsePhoto;
                        set(handles.edit14,'String',pulsePhoto);
                        end
                    end  
                end
            end      
        end
    elseif choice == 2
        pulseArray(i,3) = readVoltage(a,pinECG)*(1024/5);
        plot(pulseArray(:,3))
        title('ECG'); grid on;
        axis([x x+B 0 1000])
        if pulseArray(i-1,3) < threshold
            if pulseArray(i-2,3) > pulseArray(i-1,3) && pulseArray(i,3) > pulseArray(i-1,3)
                if counter2 == 1
                    time1e = pulseArray(i-1,1);
                    counter2 = 2;
                elseif counter2 == 2
                    time2e = pulseArray(i-1,1);
                    T_ECG = time2e - time1e;
                    pulseECG = T_ECG*60;
                    counter2 = 1;
                    if i <= 20 || (abs(pulseECG-pulseECG0)/pulseECG0) < 0.1
                        if pulseECG < 200 && pulseECG > 40
                        pulseECG0 = pulseECG;
                        set(handles.edit14,'String',pulseECG);
                        end
                    end
                end
            end      
        end
    end
    
if (i-previ) > B
    x = x + B;
    previ = i;
else
    axis([x x+B 0 1000])
end 
    i = i + 1;
    pause(1/fs);
end

% --- Executes on button press in buttonStop.
function buttonStop_Callback(hObject, eventdata, handles)
global gate pulseArray;
gate = 2;
csvwrite('pulsefile.csv',pulseArray);

% ---------------------------------------------------------------------- %
function popupPhot_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupPhot_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
set(hObject,'String',{'A5','A0','A1','A2','A3','A4'})

function popupECG_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupECG_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
set(hObject,'String',{'A0','A1','A2','A3','A4','A5'});

% ---------------------------------------------------------------------- %
% buttonPins:
function buttonPins_Callback(hObject, eventdata, handles)
global a pinPhot pinECG
popup_sel_index1 = get(handles.popupPhot,'Value');
switch popup_sel_index1
    case 1
        pinPhot = 'A5';
    case 2
        pinPhot = 'A0';
    case 3
        pinPhot = 'A1';
    case 4 
        pinPhot = 'A2';
    case 5
        pinPhot = 'A3';
    case 6
        pinPhot = 'A4';
end
popup_sel_index2 = get(handles.popupECG,'Value');
switch popup_sel_index2
    case 1
        pinECG = 'A0';
    case 2
        pinECG = 'A1';
    case 3
        pinECG = 'A2';
    case 4
        pinECG = 'A3';
    case 5
        pinECG = 'A4';
    case 6
        pinECG = 'A5';
end
if pinPhot == pinECG
    errordlg('You can''t use the same input pins!') 
end
configurePin(a,pinPhot,'AnalogInput'); 
configurePin(a,pinECG,'AnalogInput');

% ---------------------------------------------------------------------- %
% groupBPM1:
%function buttonDefa2_Callback(hObject, eventdata, handles)
function groupBPM1_SelectionChangedFcn(hObject, eventdata, handles)
global threshold
if (hObject == handles.buttonDefa2)
    set(handles.edit5,'String','','BackgroundColor','w');
    threshold = 600;
else
    set(handles.edit5,'String','Enter','BackgroundColor',hex2rgb('#f7815b'));
end

function edit5_Callback(hObject, eventdata, handles)
global threshold
custthreshold = str2double(get(hObject,'String'));
threshold = custthreshold;
if custthreshold <= 0 || isnan(custthreshold)
    set(hObject, 'String', 'Try Again');
    errordlg('Threshold is a real positive number from 0 to 1024!','Error');
end

function edit5_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

% groupECG: 
function groupECG_SelectionChangedFcn(hObject, eventdata, handles)
global threshold2
if (hObject == handles.buttonDefa3)
    set(handles.edit6,'String','','BackgroundColor','w');
    threshold2 = 250;
else
    set(handles.edit6,'String','Enter','BackgroundColor',hex2rgb('#96d8e7'));
end

function buttonCust2_Callback(hObject, eventdata, handles)

function edit6_Callback(hObject, eventdata, handles)
global threshold2
custthreshold2 = str2double(get(hObject,'String'));
threshold2 = custthreshold2;
if custthreshold2 <= 0 || isnan(custthreshold2)
    set(hObject, 'String', 'Try Again');
    errordlg('Threshold is a real positive number from 0 to 1024!','Error');
end

function edit6_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% ---------------------------------------------------------------------- %

% --- Executes during object creation, after setting all properties.
function edit14_Callback(hObject, eventdata, handles)

function edit14_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

%function edit11_Callback(hObject, eventdata, handles)
%function edit11_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

%function edit12_Callback(hObject, eventdata, handles)
%function edit12_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

%function edit13_Callback(hObject, eventdata, handles)
%function edit13_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


%function edit15_Callback(hObject, eventdata, handles)
%function edit15_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

%function edit16_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
%function edit16_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'thresholdUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
