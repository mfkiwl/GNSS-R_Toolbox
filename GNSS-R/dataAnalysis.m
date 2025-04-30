function dataAnalysis(rhsystype,rhobstype,startdoy,enddoy,step,len,rhpath,order)
%%High-resolution sea level estimation
% Inputs :
% rhsystype : satellite constellation : G R E C
% 'G' for GPS, 'R' for GLONASS, 'E' for Galileo, 'C' for BDS
% eg. systype = 'GREC'; /  systype = 'GRC';
% rhobstype : type of observation employed to calculate reflector height
% eg. rhsystype = 'SNR' / 'CMC' / 'SNRCMC';
% startdoy : start time of the processing period (DOY)
% enddoy : end time of the processing period (DOY)
% eg. startdoy = 352; enddoy = 358;
% step : window step of the sliding window (min)
% len : window length of the sliding window (h)
% rhpath : the path of reflector height files
% order : type of dynamic model
% 2 - first-order dynamic model(sea level and its velocity)
% 3 - second-order dynamic model(sea level ,its velocity, and  acceleration)
% eg.
% dataAnalysis('GREC','SNR',352,358,10,4,'..\Data\output\DataAnalysis\BRST\',3);
%%
% rhobstype
% SNR [6:15];CMC [1:10];combination [6:10]
if rhobstype == "SNR"
    myRange = [6:15];
else
    if rhobstype == "CMC"
        myRange = [1:10];
    else
        if rhobstype == "SNRCMC"
            myRange = [6:10];
        end
    end
end
numOfRange = 1;
startTime = startdoy; 
endTime = enddoy;
WinLenOfMed = 1;
% window step and window length (h)
winStep = (1/60)*step;  
winLen = len;
%  tolerance
Epsilon = 0.001;
%referencetime
tend = endTime+1- winStep;
winStephour = winStep/24;
reftime = [startTime:winStephour:tend];
%%% parameter configuration
%RHtxtfilepath
rhfilepath = rhpath;
% station name and year
[rhstationname,rhyear] = readrh(rhfilepath,'txt');
StaList = {rhstationname};
% system select
sys = rhsystype;
satList = getSatList(sys);
% select the num of files
SlcNum = 0;
% set the parameters
FreqSwitch = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
%% processing (station-by-station)
for StationNum = 1:length(StaList)
%     Sta = cell2mat(StaList(StationNum));   %%%Sta char
    [NumofFiles,FileList] = readFile(rhfilepath,'txt');
    RawDataX = [];RawDataY = [];SatNum = []; RawDataAzi = [];
    Type = []; Peaknoise = [];DynCor = []; MaskPart = [];
    for n = 1:SlcNum+1:NumofFiles
        %% read the data in the selcet file list
        [Data] = dataLoad(n,SlcNum,FileList,NumofFiles,rhfilepath,rhyear);
        %% Get the data of selected system
        SlcData = getSlcData(Data,satList,FreqSwitch);
        RawDataX = [RawDataX;SlcData(:,2)];
        RawDataY = [RawDataY;SlcData(:,3)];
        SatNum = [SatNum;SlcData(:,5)];
        RawDataAzi = [RawDataAzi;SlcData(:,4)];
        Type = [Type;SlcData(:,10)];
        Peaknoise = [Peaknoise;SlcData(:,11)];
        DynCor = [DynCor;SlcData(:,12)];
        MaskPart = [MaskPart;SlcData(:,13)];
    end
    DataBase = [RawDataX,RawDataY,SatNum,RawDataAzi,Type,Peaknoise,DynCor,zeros(length(Type),1)];
    % Normalization
    dataBase = Normalization(DataBase,MaskPart);
    %% outlier detection
    [rawX,rawY,rawtype,rawPkn,Dyn] = SlcDataBase(dataBase,myRange);
    [x,y,type,DynCor,pkn] = OutDect(dataBase,myRange,numOfRange,startTime,endTime);
    %% Robust regression
    if order == 2
        [FinX,FinY] = RobustRegression2(winStep,winLen,x,y,DynCor,pkn,Epsilon,reftime,1);
    else
        if order == 3
        [FinX,FinY] = RobustRegression3(winStep,winLen,x,y,DynCor,pkn,Epsilon,reftime,1);
        end
    end
    IDofNan = find(isnan(FinY(:,1)));
    FinY(IDofNan,:) = [];
    FinX(IDofNan) = [];
% if 'Signal Processing Toolbox' is installed :
%     Y = medfilt1(FinY(:,1),WinLenOfMed);
% if 'Signal Processing Toolbox' is not installed :
    Y =  mymedfilt1(FinY(:,1),WinLenOfMed);
 %%print RH
 outdectrh = -(mean(y) - y);
 outdectrhtime = x;
 len1 = length(outdectrhtime);
 fid1 = fopen([rhpath,'\' ,'outdectRH.txt'],'wt+');
 fprintf(fid1,'%-s   %-s\n','outdectrhtime','outdectrh');
 for i = 1:len1
 fprintf(fid1,'%-.4f   %-.4f\n',outdectrhtime(i),outdectrh(i));
 end
 fclose (fid1);
 
 winrh = -(mean(Y) - Y);
 winrhtime = FinX;
 len2 = length(winrhtime);
 fid2 = fopen([rhpath,'\' ,'winRH.txt'],'wt+');
 fprintf(fid2,'%-s   %-s\n','winrhtime','winrh');
 for i = 1:len2
     fprintf(fid2,'%-.4f   %-.4f\n',winrhtime(i),winrh(i));
 end
 fclose (fid2);
end
end
