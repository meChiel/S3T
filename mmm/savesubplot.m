function savesubplot(a,b,c,fname)
hax= subplot(a,b,c);
hfig = figure('visible','off');
hax_new = copyobj(hax, hfig);
set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
saveas(gca,[fname '.png'])
saveas(gca,[fname '.pdf'])
close(hfig)
end