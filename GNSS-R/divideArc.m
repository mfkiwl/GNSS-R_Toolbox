function [Flag,numOfArc,IDofArc,MaskPart] = divideArc(sat,data,NumOfArea,EleMask,AziMask,EleDif,MinPoints)
%divide the arc of selected satellite into two parts: 'fall' and 'rise'
Flag = 1;
% Get the ID of appointed satellite
IDofSat = []; IDofPart = [];
for i = 1:NumOfArea
    IDofSat1 = find(data(:,2) < EleMask(i,2) & data(:,2) > EleMask(i,1) & data(:,1) == sat...
        & data(:,3) < AziMask(i,2) & data(:,3) > AziMask(i,1));
    if ~isempty(IDofSat1)
        IDofSat = [IDofSat;IDofSat1];
        IDofPart1 = ones(length(IDofSat1),1)*i;
        IDofPart = [IDofPart;IDofPart1];
    end
end
if length(IDofSat) < MinPoints
    numOfArc = 0;
    IDofArc = 0;
    Flag = 0;
    MaskPart = 0;
    return
end
% Divide the arc into 'rise' and  'fall'
% Get the location of turning point
numOfTurnP = 1;
LenOfSatID = length(IDofSat);
TurningPoint = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
Ele = data(IDofSat,2);
Time = data(IDofSat,4);
% rise / fall
for numofi = 2:LenOfSatID - 1
    % the observation break off more than 10 min or the arc change from
    % 'rise' to 'fall'%%%%%%
    if abs(Time(numofi + 1) - Time(numofi)) >600 ||...
            (~sign(Ele(numofi + 1) - Ele(numofi)) *  sign(Ele(numofi) - Ele(numofi - 1)) == 1)
        TurningPoint(numOfTurnP+1) = numofi;
        numOfTurnP = numOfTurnP +1;
    end
end

%%
% end of the arc record
TurningPoint(numOfTurnP+1) = LenOfSatID;
% Get the ID of each arc
numOfRemArc = 0;
for i = 1:numOfTurnP
    Start = int32(TurningPoint(i)) + 1;
    End = int32(TurningPoint(i + 1));
    MaskPart(i) = IDofPart(End,1);
    if End - Start < MinPoints || max(Ele) - min(Ele) < EleDif
        numOfRemArc = numOfRemArc + 1;
        continue;
    end
    IDofArc{i - numOfRemArc} = IDofSat(Start:End,1);
end
if numOfTurnP == numOfRemArc
    numOfArc = 0,IDofArc = 0;
    Flag = 0;
end
numOfArc = numOfTurnP - numOfRemArc;

%% winLSP
winLSP = 0;
if winLSP == 1 && (~numOfArc == 0)
    IDofArc2 = IDofArc;
    j = 1;
    for i = 1:numOfArc
        for ele = 5:2.5:22.5
            Ele = data(IDofArc2{i},2);
            ID = find(ele<Ele & Ele<ele+8);
            if(length(ID) > 15)
                IDofArc{j} = IDofArc2{i}(ID);
                j = j + 1;
            end
        end
    end
    numOfArc = j - 1;
end
end

