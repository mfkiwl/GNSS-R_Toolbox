function dataBase = Normalization(DataBase,MaskPart)
%data normalization
dataBase = DataBase;
n = 0;
for j = 1:max(MaskPart)
for i = 1:5:15
    n = n + 1;
    ID{n} = nan;
    ID{n} = find(DataBase(:,5) >= i & DataBase(:,5) <= i+4 & ...
        MaskPart == j);
%     ID{n} = find(DataBase(:,5) >= i & DataBase(:,5) <= i+4);
    refHeight(n,1) = mean(DataBase(ID{n},2),"omitnan");
end
end
Sum = 0;
NumOfRef = 0;
for i = 1:n
    if ~isnan(refHeight(i,1))
        Sum = refHeight(i,1) + Sum;
        NumOfRef = NumOfRef + 1;
    end
end
RefH = Sum/NumOfRef;
for i = 1:n
    dataBase(ID{i},2) = DataBase(ID{i},2) + 100 - refHeight(i,1);
%     temp = mean(DataBase(ID{i},2)) + RefH - refHeight(i,1)
end
end

