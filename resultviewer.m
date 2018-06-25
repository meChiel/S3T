function resultviewer()
fg=figure;
subplot(1,3,1)


tableLables={'60X','40X','10X','100X'};

lstx = uicontrol('Style', 'popup', 'String',  {'60X','40X','10X','100X'},...                
'Position', [0 60 250 25], 'Callback', @xupdate );

lsty = uicontrol('Style', 'popup', 'String',  tableLables,...                
'Position', [0 40 250 25] , 'Callback', @yupdate);


    function yupdate(e,v,h)
        ylabel(tableLables{lsty.Value})
    end
    function xupdate(e,v,h)
        xlabel(tableLables{lstx.Value})
    end

end