function varargout = step_2(varargin)
% STEP_2 M-file for step_2.fig
%      STEP_2, by itself, creates a new STEP_2 or raises the existing
%      singleton*.
%
%      H = STEP_2 returns the handle to a new STEP_2 or the handle to
%      the existing singleton*.
%
%      STEP_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEP_2.M with the given input arguments.
%
%      STEP_2('Property','Value',...) creates a new STEP_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before step_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to step_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help step_2

% Last Modified by GUIDE v2.5 13-Aug-2014 16:06:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @step_2_OpeningFcn, ...
                   'gui_OutputFcn',  @step_2_OutputFcn, ...
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


% --- Executes just before step_2 is made visible.
function step_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to step_2 (see VARARGIN)

if isstruct(varargin{1}) && isfield(varargin{1},'data')
    %Sharing descriptor with other callback functions
    setappdata(get(0,'CurrentFigure'),'descriptor',varargin{1});
    
    %Plot original measurement record
    axes(handles.axes_original_measurement_record);
    plot(varargin{1}.data)

    % Setting default values for edit fields
    set(handles.edit_first_valid,'String',sprintf('%d',1));
    set(handles.edit_last_valid,'String',sprintf('%d',length(varargin{1}.data)));
    set(handles.edit_lowest_valid,'String',sprintf('%d',round(min(varargin{1}.data))));
    set(handles.edit_highest_valid,'String',sprintf('%d',round(max(varargin{1}.data))));
    
    %Passing parameters to appdata
    cut_parameters.first_valid = 1;
    cut_parameters.last_valid = length(varargin{1}.data);
    cut_parameters.lowest_valid = round(min(varargin{1}.data));
    cut_parameters.highest_valid = round(max(varargin{1}.data));
    setappdata(get(0,'CurrentFigure'),'cut_parameters',cut_parameters);
    
end

% Choose default command line output for step_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes step_2 wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = step_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = getappdata(get(0,'CurrentFigure'),'descriptor');
varargout{2} = getappdata(get(0,'CurrentFigure'),'reduced_datavect');
varargout{3} = getappdata(get(0,'CurrentFigure'),'reduced_timevect');
close(get(0,'CurrentFigure'));


% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_adctest_Callback(hObject, eventdata, handles)
% hObject    handle to About_adctest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Getting_started_Callback(hObject, eventdata, handles)
% hObject    handle to Getting_started (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_first_valid_Callback(hObject, eventdata, handles)
% hObject    handle to edit_first_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_first_valid as text
%        str2double(get(hObject,'String')) returns contents of edit_first_valid as a double
cut_parameters = getappdata(get(0,'CurrentFigure'),'cut_parameters');
cut_parameters.first_valid = str2double(get(hObject,'String'));
setappdata(get(0,'CurrentFigure'),'cut_parameters',cut_parameters);


% --- Executes during object creation, after setting all properties.
function edit_first_valid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_first_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_last_valid_Callback(hObject, eventdata, handles)
% hObject    handle to edit_last_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cut_parameters = getappdata(get(0,'CurrentFigure'),'cut_parameters');
cut_parameters.last_valid = str2double(get(hObject,'String'));
setappdata(get(0,'CurrentFigure'),'cut_parameters',cut_parameters);

% Hints: get(hObject,'String') returns contents of edit_last_valid as text
%        str2double(get(hObject,'String')) returns contents of edit_last_valid as a double


% --- Executes during object creation, after setting all properties.
function edit_last_valid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_last_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lowest_valid_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lowest_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lowest_valid as text
%        str2double(get(hObject,'String')) returns contents of edit_lowest_valid as a double
cut_parameters = getappdata(get(0,'CurrentFigure'),'cut_parameters');
cut_parameters.lowest_valid = str2double(get(hObject,'String'));
setappdata(get(0,'CurrentFigure'),'cut_parameters',cut_parameters);


% --- Executes during object creation, after setting all properties.
function edit_lowest_valid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lowest_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_highest_valid_Callback(hObject, eventdata, handles)
% hObject    handle to edit_highest_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_highest_valid as text
%        str2double(get(hObject,'String')) returns contents of edit_highest_valid as a double
cut_parameters = getappdata(get(0,'CurrentFigure'),'cut_parameters');
cut_parameters.highest_valid = str2double(get(hObject,'String'));
setappdata(get(0,'CurrentFigure'),'cut_parameters',cut_parameters);



% --- Executes during object creation, after setting all properties.
function edit_highest_valid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_highest_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_preprocess.
function pushbutton_preprocess_record_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
descriptor = getappdata(get(0,'CurrentFigure'),'descriptor');
cut_parameters = getappdata(get(0,'CurrentFigure'),'cut_parameters');
reduced_length = cut_parameters.last_valid - cut_parameters.first_valid + 1;
timevect = (1:reduced_length).';
datavect = descriptor.data(cut_parameters.first_valid:cut_parameters.last_valid);
isvalid = zeros(reduced_length,1);
reduced_timevect = zeros(reduced_length,1);
reduced_datavect = zeros(reduced_length,1);
l = 1;
for k = 1:reduced_length
    if (datavect(k) >= cut_parameters.lowest_valid) && (datavect(k) <= cut_parameters.highest_valid)
        isvalid(k) = true;
        reduced_datavect(l) = datavect(k);
        reduced_timevect(l) = timevect(k);
        l = l + 1;
    else
        isvalid(k) = false;
    end
end
reduced_timevect = reduced_timevect(1:l-1);
reduced_datavect = reduced_datavect(1:l-1);
setappdata(get(0,'CurrentFigure'),'reduced_timevect',reduced_timevect);
setappdata(get(0,'CurrentFigure'),'reduced_datavect',reduced_datavect)

axes(handles.axes_preprocessed_measurement_record);
plot(reduced_timevect,reduced_datavect);


% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;


% --- Executes on button press in pushbutton_previous.
function pushbutton_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(get(0,'CurrentFigure'));
