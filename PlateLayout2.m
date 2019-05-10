function PlateLayout2(varargin)

% Works but it is not allowed to open multiple windows.
% Only the last opened window is valid. Other windows can create garbage.
% PlateLAyout works internally with Handles and should allow in the future 
% to have multiple windows open.

global plate wellData ptitle 
createUI();
createPlateUI([],[],[]);
    function createUI()
        f2 = figure('Visible','on','name','Layout generator',...
            ...%'Color',[.95 .95 .95],...
            'NumberTitle','off');
       % set(f2,'MenuBar', 'none');
       % set(f2, 'ToolBar', 'auto');
        javaFrame = get(f2,'JavaFrame');
        javaFrame.setFigureIcon(javax.swing.ImageIcon('PlateLayout_icon.png'));
    end
    function createPlateUI(o,e,h)
        % H Labels
        for j=1:8
            textV{j} = uicontrol('Style', 'text', 'String', num2str(j),...
                'Position', [25*0+20 8*25-j*(25)+100 20 20]...
                );
        end
        % V Labels
        for i=1:12
            textH{i} = uicontrol('Style', 'text', 'String', num2str(i),...
                'Position', [25*i+20 8*25+100 20 20]...
                );
        end
        
        % Edit Fields
        for j=1:8            
            for (i = 1:12)
                plate{i}{j} = uicontrol('Style', 'edit', 'String', ' ',...
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
                set(plate{ii}{jj},'String',' ');
            end
        end
        
    end
    function loadPlate (e,g,h)        
        [filenm,dir]=uigetfile('*.csv',['Select Plate Layout File']);
        conc = csvread([dir '\' filenm ])
        id = strfind(filenm,'_');
        wellData = OKname2text(filenm(id+1:end-4));
        set(ptitle,'String',wellData);
        for ii=1:12
            for jj=1:8
                %text = [text ',' set(plate{ii}{jj},'String')];
                set(plate{ii}{jj},'String',num2str(conc(jj,ii)));
               % set(plate{ii}{jj},'Color','b');
                if isnan(conc(jj,ii))
                    set(plate{ii}{jj},'String',' ');
                end
            end
        end
    end

    function generate(e,g,h)
        for ii=1:12
            for jj=1:8
                if isempty(str2num(get(plate{ii}{jj},'String')))
                    conc(jj,ii)=nan;
                else
                    conc(jj,ii) = str2num(get(plate{ii}{jj},'String') );
                end
            end
        end
        wellData = get(ptitle,'String');
        [FileName,PathName,FilterIndex] = uiputfile('*.csv','Save Plate Layout',['plateLayout_' text2OKname(wellData) '.csv']);
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
        
        set(handles.plate{i}{j}, 'String', handles.metricdata.density);
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
