function [rawX,rawY,rawtype,rawPkn,Dyn] = SlcDataBase(dataBase,selectType)
% Get the selected data
rawX = dataBase(:,1);
rawY = dataBase(:,2);
rawtype = dataBase(:,5);
rawPkn = dataBase(:,6);
Dyn = dataBase(:,7);
for i = 1:length(selectType)
    ID = find(rawtype == selectType(i));
    rawX(ID) = [];
    rawY(ID) = [];
    rawtype(ID) = [];
    rawPkn(ID) = [];
    Dyn(ID) = [];
end
end

