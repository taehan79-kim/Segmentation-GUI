function varargout = GUI_test(varargin)
% GUI_TEST MATLAB code for GUI_test.fig
%      GUI_TEST, by itself, creates a new GUI_TEST or raises the existing
%      singleton*.
%
%      H = GUI_TEST returns the handle to a new GUI_TEST or the handle to
%      the existing singleton*.
%
%      GUI_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST.M with the given input arguments.
%
%      GUI_TEST('Property','Value',...) creates a new GUI_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_test

% Last Modified by GUIDE v2.5 10-Apr-2020 15:27:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_test_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_test_OutputFcn, ...
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


% --- Executes just before GUI_test is made visible.
function GUI_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_test (see VARARGIN)

% Choose default command line output for GUI_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)                     %영상 불러오기
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearvars -global
global source img file
file = uigetfile('*.tiff');
source = imread(file);
file = erase(file,['.tiff']); %#ok<NASGU>
img = source;
imshow(source)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)                      %디노이징
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source source1
source = medfilt2(source);
source1 = source;
imshow(source)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)                      %대비조정
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global source I2 I3 background se img_bor
f = waitbar(0,'Operating Image..');
se = strel('disk',500);
source = im2double(source);
waitbar(0.2,f,'Operating Image..');
background = imopen(source,se);
waitbar(0.5,f,'Adjusting Image..');
% figure, imshow(background)
I2 = source - background;
% figure, imshow(I2)
I3 = adapthisteq(I2);
% imshow(I3)
waitbar(.67,f,'Edge Clearing..');
img_bor=imclearborder(I3);
close(f)
imshow(img_bor,[])

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)                         %roi 고르기
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source roi
roi = roipoly(source);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)                         %show mask
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global roi img_bor roi_img mask f1 f2 f3 BWfinal_tmp
roi_img = roi.*img_bor;
f1 = str2double(get(handles.F1,'String'));
f2 = str2double(get(handles.F2,'String'));
f3 = str2double(get(handles.F3,'String'));
mask = roi_img>f1 & roi_img<f2;
mask = imfill(mask,'holes');
BWfinal_tmp = logical(mask);
BWfinal_tmp =  bwareafilt(BWfinal_tmp,[20, f3]);
imshow(BWfinal_tmp)



function F1_Callback(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F1 as text
%        str2double(get(hObject,'String')) returns contents of F1 as a double


% --- Executes during object creation, after setting all properties.
function F1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F2_Callback(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F2 as text
%        str2double(get(hObject,'String')) returns contents of F2 as a double


% --- Executes during object creation, after setting all properties.
function F2_CreateFcn(hObject, eventdata, ~)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F3_Callback(hObject, eventdata, handles)
% hObject    handle to F3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F3 as text
%        str2double(get(hObject,'String')) returns contents of F3 as a double


% --- Executes during object creation, after setting all properties.
function F3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)                       %영상 저장하기
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c1 BWfinal Unique_Point file source1

mkdir ../goblet_cell/train
mkdir ../goblet_cell/masks

c1 = str2double(get(handles.C1,'String'));

[m,n] = size(BWfinal);
Repeat_Width = m/c1;
Repeat_Length = n/c1;

Doubl_Num = 256/c1;
Expanding_Point = zeros(Doubl_Num^2,2);
Concatenate_Point = zeros(Doubl_Num*length(Unique_Point),2);
Unique_Point(:,:) = Unique_Point(:,:)*Doubl_Num;

for i = 1 : length(Unique_Point)
    m = Unique_Point(i,1);
    n = Unique_Point(i,2);
    num = 1;
    for j = 1 : Doubl_Num
        for k = 1 : Doubl_Num
            Expanding_Point(num,:) = [m+1-j,n+1-k];
            num = num + 1;
        end
    end
    Concatenate_Point(i*(Doubl_Num^2)-Doubl_Num^2+1:i*(Doubl_Num^2),:) = Expanding_Point(:,:);
end

for i = 1 : Repeat_Width
    for j = 1 : Repeat_Length
        if ismember([j,i],Concatenate_Point,'rows') == 1
            continue
        end
        tmp = source1(c1*(i-1)+1:c1*i,c1*(j-1)+1:c1*j);
        fn = ['..\goblet_cell\train\',file,' - (',int2str(i),',',int2str(j),').png'];        
        imwrite(tmp,fn,'png')
        tmp = BWfinal(c1*(i-1)+1:c1*i,c1*(j-1)+1:c1*j);
        fn = ['..\goblet_cell\masks\',file,' - (',int2str(i),',',int2str(j),').png'];   
        imwrite(tmp,fn,'png')
    end
end




% --- Executes on button press in pushbutton9.   
function pushbutton9_Callback(hObject, eventdata, handles)                        %영상 겹치기
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source BWfinal BW 
BW = bwperim(BWfinal);
% img = source;
source(BW) = 255; 
imshow(source)


% --- Executes on button press in pushbutton10.   
function pushbutton10_Callback(hObject, eventdata, handles)                       %영상 합치기
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BWfinal BWfinal_tmp ad_thr3
if size(BWfinal,1)==2048
    BWfinal = BWfinal+BWfinal_tmp;
else
    BWfinal = BWfinal_tmp;
end
imshow(BWfinal)



function C1_Callback(hObject, eventdata, handles)
% hObject    handle to C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C1 as text
%        str2double(get(hObject,'String')) returns contents of C1 as a double


% --- Executes during object creation, after setting all properties.
function C1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c1 BWfinal Unique_Point PR_I m source

c1 = str2double(get(handles.C1,'String'));

[m,n] = size(BWfinal);
PR_I=zeros(m,n,3);
PR_I(:,:,1) = source;
PR_I(:,:,2) = source;
PR_I(:,:,3) = source;
Repeat_Width = m/c1;



for i = 1 : Repeat_Width
    PR_I(c1*i:c1*i+1,1:m,1)=1;
    PR_I(c1*i:c1*i+1,1:m,2:3)=0;
    PR_I(1:m,c1*i:c1*i+1,1)=1;
    PR_I(1:m,c1*i:c1*i+1,2:3)=0;
end
imshow(PR_I)
[xi,yi] = getpts;
p1=ceil(xi/c1);
p2=ceil(yi/c1);
Unique_Point = zeros(length(p1),2);

for i = 1 : length(p1)
    PR_I(c1*(p2(i)-1)+1:c1*(p2(i)),c1*(p1(i)-1)+1:c1*(p1(i)),2)= 0;
    Unique_Point(i,:) = [p1(i),p2(i)];
end

Unique_Point = unique(Unique_Point,'rows','stable');

imshow(PR_I)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source ad_thr;
[M,N]=size(source);
I=im2double(source);
source = im2double(source);
av_flt=fspecial('average',[7,7]);
f = waitbar(0,'Operating Image..');

ad_thr=zeros(M,N);
sum=0;

J=imfilter(I,av_flt,'symmetric','conv');
J2 = adapthisteq(J);
for i=1:1:M-32
    waitbar(i/(M-32),f,'Thresholding Image..');
    for j=1:1:N-32
        for a=1:32
            for b=1:32
                sum=sum+J2(i+a,j+b);
            end
        end
        mean = sum/(32*32);
        sum=0;
        for a=1:32
            for b=1:32
                if J2(i+a,j+b)>1*mean+0.04
                     ad_thr(i+a,j+b) = ad_thr(i+a,j+b)+1;
                end
            end
        end
    end
end
close(f)



function THR_Callback(hObject, eventdata, handles)
% hObject    handle to THR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ad_thr ad_thr3 roi;
[M,N]=size(ad_thr);
if isempty(roi)
    roi=ones(M,N);
end
ad_thr3=ad_thr;
ad_thr3(ad_thr<get(handles.THR,'Value'))=0;
ad_thr3(ad_thr>=get(handles.THR,'Value'))=1;
ad_thr3=bwareaopen(ad_thr3,30);
ad_thr3=ad_thr3.*roi;
imshow(ad_thr3);
% Hints: get(hObject,'String') returns contents of THR as text
%        str2double(get(hObject,'String')) returns contents of THR as a double


% --- Executes during object creation, after setting all properties.
function THR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BWfinal ad_thr3;
if size(BWfinal,1)==2048
    BWfinal = BWfinal+ad_thr3;
else
    BWfinal = ad_thr3;
end
