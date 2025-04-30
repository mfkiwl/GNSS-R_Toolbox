function [Data] = TroCor(IDofArc,data)
%get the     parameter (GPT2w)
T = 2.3;
P = 1007.6;
Data = data(IDofArc,:);
% elevation angle
Ele = Data(:,2);
% Tropospheric delay correction (GPT2w)
T = 2.3;
P = 1007.6;
RM1 = cotd(Ele+(7.31./(Ele+4.4)));
RM = RM1 -(0.06*sind(14.7.*(RM1/3600)+13));
R0 = (510/(460+T))*(P/29.83)*RM/3600;
% Data(:,2) = Data(:,2) + R0;
Data(:,2) = Data(:,2);
end

