function [rhstationname,rhyear] = readrh(myfilepath,type)
%read stationname and year
filepath =  [myfilepath ,'\' '*.' type];
namelist  = dir(filepath);
test = namelist(1).name;
rhstationname = test(1:4);
rhyear = str2double(test(5:8));
end