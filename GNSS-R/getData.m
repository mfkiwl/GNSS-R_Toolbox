function [Year, Doy, OutFileID,data] = getData(FileNum,MyFilePath,FileList)
%   get data from input file list and filepath
%   OutFileID: fid of out file
%   data: obs data 
FileName = FileList{FileNum} ;            
FullName = fullfile(MyFilePath,FileName);  
[Year, Doy, Station, OutFileName] = getFileInf(FileName);
data =load(FullName);
mkdir([MyFilePath '.\DataAnalysis\' Station]);
OutFileID = fopen([MyFilePath '.\DataAnalysis\' Station '\' OutFileName],'w');
if OutFileID < 0
    disp('problem with your output txt file');
    return
else
    % output header
    fprintf(OutFileID,'year  doy  maxRHL1  meanazm  sat   delT   minE    maxE  UTC  ObsType  p/k   DynCor  MaskPart\n');
    fprintf(OutFileID,'              m       deg           min   deg     deg   hr                        \n');
end
end            

