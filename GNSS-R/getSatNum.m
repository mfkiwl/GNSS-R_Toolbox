function SatNum = getSatNum(SatName)
% get sat num:  sys + num -> PRN
sys = SatName(1);
SatLength = length(SatName);
SatNum = str2num(SatName(2:SatLength));
end