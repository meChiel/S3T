rawTraceTable = readtable('F:\share\toBeProcessed\1 NOW\2-10-2018\NS_2320181002_141908_20181002_144044\01AP_1st_Analysis\output\SynapseDetails\NS_2320181002_141908_e0012_RawSynTraces.csv');
avgTraceTable = readtable('F:\share\toBeProcessed\1 NOW\2-10-2018\NS_2320181002_141908_20181002_144044\01AP_1st_Analysis\output\NS_2320181002_141908_e0012_traces.csv');

figure;plot(avgTraceTable.rawAverageResponse)
rawTrace = table2array(rawTraceTable);

figure;plot(rawTrace(1:140,:));title('Raw Traces');
mr= mean(rawTrace(:,:),2);

figure;plot(mr(1:140,:));title('mean Trace');
rawTrace2 = rawTrace - mean(rawTrace(130:140,:)); 
nmr = mr-mean(mr(130:140,:));

figure;plot(nmr(1:140));
figure;plot(rawTrace2(1:140,:));title('Raw Traces');
figure;plot(mean(rawTrace2(1:140,:),2));title('mean Trace');
figure;plot(smoothM(rawTrace2(1:140,5),1));
