function [TimeHour,Ele,SinE,MaxEle,MinEle,MeanAzm,DelTime,MeanTime,...
LinS1,LinS2,LinS3,LinS4,LinS5,C1,C2,C3,C4,C5,P1,P2,P3,P4,P5] = getRawObs(data,IDofCol)
%get the raw obs
Obs = data;
Ele = Obs(:,2);
TimeHour = Obs(:,4)/3600;
% 1/h
MaxEle = max(Ele);
MinEle = min(Ele);
SinE = sind(Ele);
% mean azimuth
MeanAzm = mean(Obs(:,3));
% time: second->hour  
MyTime = Obs(:,4)/3600;
MeanTime = mean(MyTime);
MeanTime = median(MyTime);
DelTime = abs(MyTime(end) - MyTime(1));
% SNR observation 
S1 = Obs(:,IDofCol(1)); S2 = Obs(:,IDofCol(2)); S3 = Obs(:,IDofCol(3)); S4 = Obs(:,IDofCol(4)); S5 = Obs(:,IDofCol(5));
% linearization
LinS1 = S1; LinS2 = S2; LinS3 = S3; LinS4 = S4; LinS5 = S5;
LinS1 = 10.^(S1/20); LinS2 = 10.^(S2/20); LinS4 = 10.^(S4/20); LinS5 = 10.^(S5/20);
% Carrier observation
C1 = Obs(:,IDofCol(6)); C2 = Obs(:,IDofCol(7)); C3 = Obs(:,IDofCol(8)); C4 = Obs(:,IDofCol(9)); C5 = Obs(:,IDofCol(10));
% Carrier observation
P1 = Obs(:,15); P2 = Obs(:,16); P3 = Obs(:,17); P4 = Obs(:,18); P5 = Obs(:,19);

% outlier detection
% IDofOutlier = find(...
%     LinS1>mean(LinS1)+3*std(LinS1)|LinS1<mean(LinS1)-3*std(LinS1)|...
%     LinS2>mean(LinS2)+3*std(LinS2)|LinS2<mean(LinS2)-3*std(LinS2)|...
%     LinS5>mean(LinS5)+3*std(LinS5)|LinS5<mean(LinS5)-3*std(LinS5));
% LinS1(IDofOutlier) = [];
% LinS2(IDofOutlier) = [];
% LinS5(IDofOutlier) = [];
% SinE(IDofOutlier) = [];
end

