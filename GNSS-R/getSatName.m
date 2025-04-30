function [SatName]=GetSatName(Sat)
% get sat name = 'sys+PRN'
if Sat <= 32;
    SatName = num2str(Sat);
    SatName =['G',SatName];
    return;
elseif (Sat > 32 & Sat <= 58);
    SatName = num2str(Sat);
    SatName =['R',SatName];
    return;
elseif (Sat > 58 & Sat <= 94);
    SatName = num2str(Sat);
    SatName =['E',SatName];
    return;
elseif (Sat > 94);
    SatName = num2str(Sat);
    SatName =['C',SatName];
    return;
end
end
