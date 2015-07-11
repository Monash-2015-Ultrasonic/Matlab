function varargout = UndersamplingGUI(varargin)
% UNDERSAMPLINGGUI M-file for UndersamplingGUI.fig
%      UNDERSAMPLINGGUI, by itself, creates a new UNDERSAMPLINGGUI or raises the existing
%      singleton*.
%
%      H = UNDERSAMPLINGGUI returns the handle to a new UNDERSAMPLINGGUI or the handle to
%      the existing singleton*.
%
%      UNDERSAMPLINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNDERSAMPLINGGUI.M with the given input arguments.
%
%      UNDERSAMPLINGGUI('Property','Value',...) creates a new UNDERSAMPLINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UndersamplingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UndersamplingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UndersamplingGUI

% Last Modified by GUIDE v2.5 25-Mar-2011 23:42:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UndersamplingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @UndersamplingGUI_OutputFcn, ...
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


% --- Executes just before UndersamplingGUI is made visible.
function UndersamplingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UndersamplingGUI (see VARARGIN)

% Choose default command line output for UndersamplingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UndersamplingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UndersamplingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function BandFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BandFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BandFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of BandFreqEdit as a double
set(hObject,'Value',str2double(get(hObject,'String'))); %set string data to value
calc_possible_fs(hObject,handles); % calculate all rates which will not cause alayasing
determine_SampleFreqEdit_clr(handles);
GUIsampling_theory_visualization(handles);

% --- Executes during object creation, after setting all properties.
function BandFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BandFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ChanBWEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ChanBWEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChanBWEdit as text
%        str2double(get(hObject,'String')) returns contents of ChanBWEdit as a double
set(hObject,'Value',str2double(get(hObject,'String'))); %set string data to value
calc_possible_fs(hObject,handles); % calculate all rates which will not cause alayasing
determine_SampleFreqEdit_clr(handles);
GUIsampling_theory_visualization(handles);


% --- Executes during object creation, after setting all properties.
function ChanBWEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanBWEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SampleFreqEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SampleFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SampleFreqEdit as text
%        str2double(get(hObject,'String')) returns contents of SampleFreqEdit as a double
f_s_candidate=str2double(get(hObject,'String'));
set(hObject,'Value',f_s_candidate); %set string data to value

determine_SampleFreqEdit_clr(handles);
GUIsampling_theory_visualization(handles);


% --- Executes during object creation, after setting all properties.
function SampleFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NFreqResEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NFreqResEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NFreqResEdit as text
%        str2double(get(hObject,'String')) returns contents of NFreqResEdit as a double
set(hObject,'Value',str2double(get(hObject,'String'))); %set string data to value
GUIsampling_theory_visualization(handles);


% --- Executes during object creation, after setting all properties.
function NFreqResEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NFreqResEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ResSpecTightCheckbox.
function ResSpecTightCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ResSpecTightCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ResSpecTightCheckbox
GUIsampling_theory_visualization(handles);


% --- Executes on button press in ResSpecWideCheckbox.
function ResSpecWideCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ResSpecWideCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ResSpecWideCheckbox
GUIsampling_theory_visualization(handles);


% --- Executes on button press in OrSpecPltCheckbox.
function OrSpecPltCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OrSpecPltCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrSpecPltCheckbox
GUIsampling_theory_visualization(handles);


function GUIsampling_theory_visualization(handles)

f_sample=get(handles.SampleFreqEdit,'Value')*1e6;
f_CF_sig_vec=get(handles.BandFreqEdit,'Value')*1e6;
f_BW_sig_vec=get(handles.ChanBWEdit,'Value')*1e6;
N=get(handles.NFreqResEdit,'Value');
N_of_sub_plots=get(handles.OrSpecPltCheckbox,'Value')+get(handles.ResSpecWideCheckbox,'Value')+get(handles.ResSpecTightCheckbox,'Value');
if (N_of_sub_plots==0) % no plots needed
    return
end
sub_plot_ind=0;


F_Nuiq=2*ceil(max(f_CF_sig_vec)+max(f_BW_sig_vec));
F_spec=3*F_Nuiq;
freq_line=linspace(-F_spec/2,F_spec/2,N+1);
freq_line_res=freq_line(2)-freq_line(1);
% freq_line(end)=[];
SIG=zeros(size(freq_line));

for ind=1:length(f_CF_sig_vec)
    N_in_BW=ceil(f_BW_sig_vec(ind)/freq_line_res);
    [~,f_CF_ind]=min(abs(freq_line-(f_CF_sig_vec(ind)+f_BW_sig_vec(ind)/2))); % first closest freqiency will be negative
    SIG(f_CF_ind-(1:N_in_BW))=linspace(2,1,N_in_BW);
    f_CF_ind=find(freq_line==-freq_line(f_CF_ind)); %find negative frequency
    SIG(f_CF_ind+(1:N_in_BW))=linspace(2,1,N_in_BW);
end

if (get(handles.OrSpecPltCheckbox,'Value'))
    sub_plot_ind=sub_plot_ind+1;

    F_Nuiq_ind=find((freq_line>=-F_Nuiq/2)&(freq_line<=F_Nuiq/2));
    subplot(N_of_sub_plots,1,sub_plot_ind);    
    plot(freq_line(F_Nuiq_ind),SIG(F_Nuiq_ind)); grid on;
end

smpl_iter=floor(F_Nuiq/f_sample);
out_SIG=SIG;

for iter_ind=1:smpl_iter
    desired_freq=-F_spec/2+iter_ind*f_sample;
    [~,shift_ind]=min(abs(freq_line-desired_freq));
    out_SIG=out_SIG+circshift(SIG,[0,shift_ind])+circshift(SIG,[0,-shift_ind]);
end

if (get(handles.ResSpecWideCheckbox,'Value'))
    sub_plot_ind=sub_plot_ind+1;

    if (exist('F_Nuiq_ind','var')~=1) %define variable if still doesn't exist
        F_Nuiq_ind=find((freq_line>=-F_Nuiq/2)&(freq_line<=F_Nuiq/2));
    end
    
    subplot(N_of_sub_plots,1,sub_plot_ind);
    plot(freq_line(F_Nuiq_ind),out_SIG(F_Nuiq_ind)); grid on;
    sample_range=zeros(size(SIG));
    sample_range((freq_line>=-f_sample/2)&(freq_line<=f_sample/2))=1.1*max(abs(out_SIG));
    hold on;
    plot(freq_line(F_Nuiq_ind),sample_range(F_Nuiq_ind),'-.r');
    hold off;
end

if (get(handles.ResSpecTightCheckbox,'Value'))
    sub_plot_ind=sub_plot_ind+1;

    F_Nuiq_ind=find((freq_line>=-f_sample/2)&(freq_line<=f_sample/2));
    subplot(N_of_sub_plots,1,sub_plot_ind);
    plot(freq_line(F_Nuiq_ind),out_SIG(F_Nuiq_ind)); grid on;    
end


% --- Executes during object creation, after setting all properties.
function AxesTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxesTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate AxesTag


% --- Executes on button press in Round_table_checkbox.
function Round_table_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Round_table_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Round_table_checkbox
calc_possible_fs(hObject,handles);


% --------------------------------------------------------------------
function About_menu_Callback(hObject, eventdata, handles)
% hObject    handle to About_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web 'UndersamplingGUIAbout.htm' -helpbrowser

% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web 'UndersamplingGUIHelp.htm' -helpbrowser


%% Servise functions
function determine_SampleFreqEdit_clr(handles)
f_s_candidate=str2double(get(handles.SampleFreqEdit,'String'))*1e6; %work in [Hz]
if ~isfield(handles,'fs_inervals_arr')
    calc_possible_fs(handles.fs_inervals_uitable,handles); % calculate all rates which will not cause alayasing
    handles=guidata(handles.SampleFreqEdit);
end

if isempty(find((handles.fs_inervals_arr(:,1)<=f_s_candidate)&(handles.fs_inervals_arr(:,2)>=f_s_candidate)))
    set(handles.SampleFreqEdit,'ForegroundColor',[1,0,0]); % alayasing accures- Red color
else
    set(handles.SampleFreqEdit,'ForegroundColor',[0,1,0]); % proper samling rate is chosen- Green color
end

function calc_possible_fs(hObject,handles)
sig_C_freq=get(handles.BandFreqEdit,'Value')*1e6;
sig_BW=get(handles.ChanBWEdit,'Value')*1e6;
% find_possible_fs(f_L,f_H)
fs_inervals_arr=find_possible_fs(sig_C_freq-sig_BW/2,sig_C_freq+sig_BW/2);
handles.fs_inervals_arr=fs_inervals_arr;
if strcmpi(get(handles.fs_inervals_uitable,'Visible'),'Off')
    set(handles.fs_inervals_uitable,'Visible','On');
end
%Present data in [MHz]
if get(handles.Round_table_checkbox,'Value')
    %round to 1 [MHz] 
    set(handles.fs_inervals_uitable,'Data',...
        round(handles.fs_inervals_arr/1e6)); 
else
    set(handles.fs_inervals_uitable,'Data',(handles.fs_inervals_arr)/1e6); 
end

% Save the change made to the structure
guidata(hObject,handles)


function fs_inervals_arr=find_possible_fs(f_L,f_H)
%function fs_inervals_arr=find_possible_fs(f_L,f_H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Nikolay S.
% Creation date: 26/05/2010
% Purpose:      The functions goal is to detect the minimal sampling rate which will
%               allow proper sampling (actually we hope to achive undersampling with
%               sampling rate much lower then Nyquist sampling rate.
%               Implementation of the  bandpass sampling is based on: 
%               http://en.wikipedia.org/wiki/Undersampling
% Side effects: None
% Input brief explanations:
%               f_L- low band limit of the bandpass (non-baseband) signal
%               f_H- high band limit of the bandpass (non-baseband) signal
% Output brief  explanations:
%               fs_inervals_arr- an array of [NX2] dimentions- each line consists of
%               lower and upper boung of possible sampling frequencies which will allow
%               proper undersampling. First column consits lover bands, Second column
%               consits of upper bands.
% Input special requirements: 
%               f_L>0,F_H>0- both frequencied are positive
%               f_L<F_H
% Last update date and author:  03/06/2010 by Nikolay S.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_max=floor(f_H/(f_H-f_L));

fs_inervals_arr=zeros(n_max,2);
fs_inervals_arr(1,1)=2*f_H; % Nyquist rate
fs_inervals_arr(1,2)=2*(f_H+f_H-f_L); % Nyquist rate with BW adition

for n=2:n_max
    fs_inervals_arr(n,1)=2*f_H/n; % Lower bound of sampling frequency 
    fs_inervals_arr(n,2)=2*f_L/(n-1); % Upper bound of sampling frequency
end
