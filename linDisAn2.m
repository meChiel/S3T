meas=[tx0; tx1];
species=[repmat({N0},size(tx0,1),1); repmat({N1},size(tx1,1),1)];
MdlLinear  = fitcdiscr(meas,species);%,'DiscrimType','quadratic');
MdlLinear.ClassNames([2 3])
K = MdlLinear.Coeffs(1,2).Const;
L = MdlLinear.Coeffs(1,2).Linear;