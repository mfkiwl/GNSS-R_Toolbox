function [ len,file_name] = readingSNR(myfilepath , type) 
%   read all the *.type file
%   len:the number of *.type
%   file_name (cell) name list of *.type file
filepath =  [myfilepath '*.' type];
namelist  = dir(filepath);
len = length(namelist);
file_name=cell(1,len+1);
var=cell(1,len);
for i=1:len
    file_name{i}=namelist(i).name;         
end
end