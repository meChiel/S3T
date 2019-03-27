rr{1}='Y:\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921';
rr{2}='Y:\data\Rajiv\2018\02-03-2018\plate1\Protocol11420180302_113805_20180302_115053';
rr{3}='Y:\data\Rajiv\2018\02-03-2018\Plate2\Protocol11520180302_115839_20180302_122126';
rr{4}='Y:\data\Rajiv\2018\02-03-2018\Plate2\Protocol11620180302_123030_20180302_124317';
rr{5}='Y:\data\Rajiv\2018\07-03-2018\Plate1_Hip\Protocol1820180307_140741_20180307_143059';
rr{6}='Y:\data\Rajiv\2018\07-03-2018\Plate1_Hip\Protocol11120180307_145444_20180307_150734';

for i=2:length(rr)
    disp( ['processing: ' rr{i} ]);
    playPlateMovie(rr{i},1);
end
