function PlateLayout(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlateLayout_OpeningFcn, ...
                   'gui_OutputFcn',  @PlateLayout_OutputFcn, ...
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


% --- Executes just before guide22 is made visible.
function PlateLayout_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guide22 (see VARARGIN)

% Choose default command line output for guide22
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes guide22 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = PlateLayout_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%global plate wellData ptitle 
createUI(hObject);
createPlateUI([],[],handles);
    function createUI(f2)
      %  f2 = figure('Visible','on','name','Layout generator',...
      %      ...%'Color',[.95 .95 .95],...
      %      'NumberTitle','off');
        set(f2,'MenuBar', 'none');
        set(f2, 'ToolBar', 'auto');
        javaFrame = get(f2,'JavaFrame');
        javaFrame.setFigureIcon(javax.swing.ImageIcon('PlateLayout_icon.png'));
    end
    function createPlateUI(o,e,h)
        % H Labels
        for j=1:8
            h.textV{j} = uicontrol('Style', 'text', 'String', num2str(j),...
                'Position', [25*0+20 8*25-j*(25)+100 20 20]...
                );
        end
        % V Labels
        for i=1:12
            h.textH{i} = uicontrol('Style', 'text', 'String', num2str(i),...
                'Position', [25*i+20 8*25+100 20 20]...
                );
        end
        
        % Edit Fields
        for j=1:8            
            for (i = 1:12)
                h.plate{i}{j} = uicontrol('Style', 'edit', 'String', '0',...
                    'Position', [25*i+20 8*25-j*(25)+100 20 20]);
            end
        end
        
    end
createTitleUI()
    function createTitleUI()
        ptitle = uicontrol('Style', 'edit', 'String', 'Concentration',...
            'Position', [150 330 100 20]);
        
        
    end
createButtonsUI();
    function createButtonsUI()
        uicontrol('Style', 'pushbutton', 'String', 'Generate',...
            'Position', [350 30+100 150 100],...
            'Callback', @generate);
        uicontrol('Style', 'pushbutton', 'String', 'Load',...
            'Position', [350 30+200 150 20],...
            'Callback', @loadPlate);
        uicontrol('Style', 'pushbutton', 'String', 'Reset',...
            'Position', [350 30+300 150 20],...
            'Callback', @resetPlate);
        
    end
    function resetPlate(e,g,h)
        for ii=1:12
            for jj=1:8
                set(h.plate{ii}{jj},'String',num2str(0));
            end
        end
        
    end
    function loadPlate (e,g,h)        
        [filenm,dir]=uigetfile('*.csv',['Select Plate Layout File']);
        conc = csvread([dir '\' filenm ])
        id = strfind(filenm,'_');
        wellData = filenm(id+1:end-4);
        set(ptitle,'String',wellData);
        for ii=1:12
            for jj=1:8
                %text = [text ',' set(plate{ii}{jj},'String')];
                set(plate{ii}{jj},'String',num2str(conc(jj,ii)));
            end
        end
    end

    function generate(e,g,h)
        for ii=1:12
            for jj=1:8
                conc(jj,ii) = str2num(get(plate{ii}{jj},'String') );
            end
        end
        wellData = get(ptitle,'String');
        [FileName,PathName,FilterIndex] = uiputfile('*.csv','Save Plate Layout',['plateLayout_' wellData '.csv']);
        csvwrite([PathName FileName],conc);
        disp(['Layout writen to ' PathName FileName]);
    end

    function initialize_gui(fig_handle, handles, isreset)
        % If the metricdata field is present and the reset flag is false, it means
        % we are we are just re-initializing a GUI by calling it from the cmd line
        % while it is up. So, bail out as we dont want to reset the data.
        if isfield(handles, 'metricdata') && ~isreset
            return;
        end
        
        %handles.metricdata.density = 0;
        %handles.metricdata.volume  = 0;
        
%        set(handles.plate{i}{j}, 'String', handles.metricdata.density);
        set(handles.wellData,  'String', handles.metricdata.volume);
        set(handles.ptitle, 'String', 0);
        
        set(handles.unitgroup, 'SelectedObject', handles.english);
        
        set(handles.text4, 'String', 'lb/cu.in');
        set(handles.text5, 'String', 'cu.in');
        set(handles.text6, 'String', 'lb');
        
        % Update handles structure
        guidata(handles.figure1, handles);
    end
end
