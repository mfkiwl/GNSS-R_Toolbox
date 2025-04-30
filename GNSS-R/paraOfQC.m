function [NumOfArea,EleMask,AziMask,EleDif,NoiseRange,MinPoints,MaxTime] = paraOfQC(elemask,azimmask,areatag)
%QC parameters
%   EleMask: elevation mask (¡ã)
%   AziMask: azimuth mask (¡ã)
%   PrecisionOfLSP£ºLomb Scargle Precision (m)
%   MaxHeight£ºmaximum of the reflect height (m)
%   NosieRange: range of calculate noise values (m)

EleDif = 5;  
NoiseRange = [10 20];
MinPoints = 20;
MaxTime = 2;

NumOfArea = areatag;
EleMask = elemask;
AziMask = azimmask;

%eg
% EleMask = [5,20;12,25];
% AziMask = [130,165;165,330];

end

