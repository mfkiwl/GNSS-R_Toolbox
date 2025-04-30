function SlcData = getSlcData(Data,satList,Freq)
SlcData = Data;
ID = [];
% sat list
for i = 1:length(satList)
ID1 = find(Data(:,5) == satList(i));
ID = [ID;ID1];
end
SlcData = SlcData(ID,:);
ID = [];

% Frequency
for j = 1:length(Freq)
ID2 = find(SlcData(:,10) == Freq(j));
ID = [ID;ID2];
end
SlcData = SlcData(ID,:);

% time
SlcData(:,2) = SlcData(:,2) + SlcData(:,9)/24;

% sort data
Time = SlcData(:,2);
[~,IdOfTime] = sort(Time);
SlcData = SlcData(IdOfTime,:);
end

