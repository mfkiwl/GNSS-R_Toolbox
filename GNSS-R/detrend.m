function [TimeHour,Ele,SorSinE,DetrendS1,DetrendS2,DetrendS3,DetrendS4,DetrendS5] = ...
    detrend(SinE,LinS1,LinS2,LinS3,LinS4,LinS5,TimeHour,Ele,PolyOrder)
%sort the data and detrend by poly fit

% sort the data
[SorSinE,j] = sort(SinE);
SorLinS1 = LinS1 (j);
SorLinS2 = LinS2 (j);
SorLinS3 = LinS3 (j);
SorLinS4 = LinS4 (j);
SorLinS5 = LinS5 (j);
% 2020/11/11
TimeHour = TimeHour;
Ele = Ele;

% poly fit parameters
PolParS1 = polyfit(SorSinE, SorLinS1,PolyOrder);
PolParS2 = polyfit(SorSinE, SorLinS2,PolyOrder);
PolParS3 = polyfit(SorSinE, SorLinS3,PolyOrder);
PolParS4 = polyfit(SorSinE, SorLinS4,PolyOrder);
PolParS5 = polyfit(SorSinE, SorLinS5,PolyOrder);

% polyfit
PolS1 = polyval(PolParS1, SorSinE);
PolS2 = polyval(PolParS2, SorSinE);
PolS3 = polyval(PolParS3, SorSinE);
PolS4 = polyval(PolParS4, SorSinE);
PolS5 = polyval(PolParS5, SorSinE);
% detrend 
DetrendS1 = (SorLinS1-PolS1);
DetrendS2 = (SorLinS2-PolS2);
DetrendS3 = (SorLinS3-PolS3);
DetrendS4 = (SorLinS4-PolS4);
DetrendS5 = (SorLinS5-PolS5);
end

