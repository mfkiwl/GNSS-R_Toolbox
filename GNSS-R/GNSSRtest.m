%% Example
% extract the compressed file
% use the data provided in 'Data'folder
% test data: station : BRST  DOY : 342-348
% 
%% First step
% % Modify the input according to the path of test data
ofilepath = '..\Data\o\';
nfilepath = '..\Data\n\';
outputfilepath = '..\Data\output\';
creNameList(ofilepath,nfilepath,outputfilepath);

% Extract the selected signals : Produce '*.SlcData' files
% Run 'SNR.cpp'
% Run MEX file  (ensure the configuration file is in the input path)
namelistfilepath = '..\Data\output\';
mymex(namelistfilepath);

%% Second step
% Use the '*.SlcData' file generated in the first step
% Adjust the input according to your requirements
systype = 'GREC';
path = '..\Data\output\';
elemask = [5,20;12,25];
azimmask = [130,165;165,330];
areatag = 2;
rhmin = 12;
rhmax = 20;
obstype = 'SNRCMC';
rhCal(systype,path,elemask,azimmask,areatag,rhmin,rhmax,obstype);

%% Third step
% Use the reflector height file(txt) generated in the second step
% Adjust the input according to your requirements
rhsystyp = 'GREC';
rhobstype = 'SNRCMC';
startdoy = 342;
enddoy = 348;
step = 10;
len = 4;
rhpath = '..\Data\output\DataAnalysis\BRST\';
order = 2;
dataAnalysis(rhsystyp,rhobstype,startdoy,enddoy,step,len,rhpath,order);

