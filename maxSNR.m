% Try to maximize the SNR of the total response by making a weighted
% average of the pixels.
%
% Dus amplitude/noise ratio:
% Bereken iedere keer de amplitude: maximum of integraal?
% Bereken de noise: std van het stuk waar er geen stimulus is.
% IQR max / iqr min
% Bereken de weighted average., geen negatieve weights want dan kan de
% noise 0 worden. Deel door 0=>....
%
% Bereken voor iedere punt de afgeleide, en zie zo of het gewicht hoger of
% lager moet worden.
%
% Doe dit zeer snel dmv de adjoint/backprop.










