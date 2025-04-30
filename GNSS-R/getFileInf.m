function [Year, Doy, Station, OutFileName] = GetFileInf(FileName)
% Get information from file name and creat out file name
% file information
Station = FileName(1:4);
Year = FileName(10:11);
Year = ['20' Year];
doy = FileName(5:7);
OutFileName = [Station Year doy '.txt'];
Year = str2num(Year);
Doy = str2num(doy);
end



