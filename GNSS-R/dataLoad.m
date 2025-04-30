function [Data] = dataLoad(n,SlcNum,FileList,MaxLen,rhfilepath,rhyear)
% load all the data in a large matix
Data = [];
if n+SlcNum > MaxLen
    endOfDataRead = MaxLen;
else
    endOfDataRead = n+SlcNum;
end
for i =n:endOfDataRead
    FullName = [rhfilepath,'\',FileList{i}];
    % read the data from *.txt
    [Year,Doy,Height,Azm,Sat,Delt,MinE,MaxE,Time,Freq,PeakFreq,Dyn,MaskPart]...
        = textread ( FullName, '%f%f%f%f%s%f%f%f%f%f%f%f%f','headerlines', 2);
    if length(Year) == 0
        Year = [0],Doy = [0],Height = [0],Azm = [0],Sat = [0],Delt = [0],MinE = [0],MaxE = [0],Time = [0],...
            Freq = [0],PeakFreq = [],Dyn = [];
        return;
    end
    for j = 1:length(Year)
    SatNum(j,1) = getSatNum(char(Sat(j)));
    end
    Data = [Data;Year,Doy+(Year(1,1)-rhyear)*366,Height,Azm,SatNum,Delt,MinE,MaxE,Time,Freq,PeakFreq,Dyn,MaskPart];
    SatNum = [];
end
end


