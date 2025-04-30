function [SigObs,IonCor] = singleFreqCom(C1,C2,C3,C4,C5,P1,P2,P3,P4,P5,Sys,HalfWaveLen,SinE,PolyOrder)
% set the triple-frequency combination
SigObs = [];
Carrier = [C1,C2,C3,C4,C5]; Pseudorange = [P1,P2,P3,P4,P5];
Lamda = HalfWaveLen(6:10);
for i = 1:5
    SigObs(:,i) = Pseudorange(:,i) - Carrier(:,i)*Lamda(:,i);
    if all(Pseudorange(:,i) == 0) | all(Carrier(:,i) == 0)
        SigObs(:,i) = 0;
    end
    %     Diff = diff(SigObs(:,i));
    %     meanDiff = mean(Diff);
    %     stdDiff = std(Diff);
    %     IDofDataLack0 = find(abs(Diff- meanDiff)>3*stdDiff);
    %     IDofDataLack1 = IDofDataLack0 + 1;
    %     IDofDataLack = intersect(IDofDataLack0,IDofDataLack1);
end
for i = 1:length(SigObs(i,:))
    IonCor(:,i) = movmean(SigObs(:,i),5);
    SigObs(:,i) = SigObs(:,i) - IonCor(:,i);
    % Obs = SigObs(:,i);
    % SigObs(:,i) = wdenoise(Obs);
    if max(SigObs(:,i)) - min(SigObs(:,i)) > 10
        SigObs(:,i) = 0;
    end
end
end

