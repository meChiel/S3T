function h = ssubplot(moc,luc,iiii,sph)

% lbwh = get(3, 'position');
% figw = lbwh(3)-lbwh(1);
% figh = lbwh(4)-lbwh(2);
% Number of rows and columns of axes
ncols = luc;
nrows = moc;

% w and h of each axis in normalized units
axisw = (1 / (ncols+1)) * 1.05;
axish = (1/ (nrows+1)) * 1.05;

% calculate current row and column of the subplot
%iiii=(tt-1)*luc+t;

row = floor( (iiii-0.5)/ncols ) + 1;
col = mod(iiii-(row-1)*ncols, ncols+1);

% calculate the left, bottom coordinate of this subplot
axisl = (axisw+0.00) * (col-1)+axisw*0.25; % left
axisb = (axish+0.00) * (nrows-row+0)+axish*0.25; % below 

if nargin ==4
%     try
%         h=subplot(sph);%,'position', [axisl, axisb, axisw, axish*1.2] );
%         set(sph,'position', [axisl, axisb, axisw, axish*1.2] )
%     catch
         h=subplot('position', [axisl, axisb, axisw, axish*1.0] );
%         disp('something wrong with subplot figs?');
%     end
else
    h=subplot('position', [axisl, axisb, axisw, axish*1.0] );
end