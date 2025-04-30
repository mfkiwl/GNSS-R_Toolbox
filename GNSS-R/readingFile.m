function [len,file_name] = readingFile(myfilepath, type) 
%   Inputs :
%   myfilepath : the path of Obversation FILES(RINEX 3)
%   type : the type of Obversation FILES('*o')
%   Outputs :
%   len : the number of Obversation FILES
%   filename :the namelist of Obversation FILES (cell)
filepath =  [myfilepath '*.' type];
namelist = dir(filepath);
%   
len = length(namelist);
file_name=cell(1,len+1);
 for i=1:len
        file_name{i}=namelist(i).name;   
 end
end




