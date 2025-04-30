function rhCal(systype,path,elemask,azimmask,areatag,rhmin,rhmax,obstype)
%%Calculate Reflector Height
% Inputs :
% systype : satellite constellation : G R E C
% 'G' for GPS, 'R' for GLONASS, 'E' for Galileo, 'C' for BDS
% eg. systype = 'GREC'; /  systype = 'GRC';
% path : the path of namelist files
% eg. path = '..\Data\output\';
% elemask : elevation range (degrees)
% eg. elemask =  [5 , 20]; /  [5 , 20 ; 12 , 25] ; 
% azimmask : azimuth range (degrees)
% areatag : the composition of Reflection area : 1 & 2 
% eg. if areatag = 1   azimmask =  [130 , 165]  ; 
%     if areatag = 2   azimmask =  [130 , 165 ; 165 , 330]  ;
% rhmin : min Reflector height (m)
% rhmax : max Reflector height (m)
% eg. rhmin = 12 ; rhmin = 20;
% obstype : type of observation : SNR & CMC
% eg. obstype = 'SNR';  /  obstype = 'SNRCMC';
% eg.
% rhCal('GREC','..\Data\output\',[5,20;12,25],[130,165;165,330],2,12,20,'SNR');
%% define the constants
global pi;
global CLIGHT;
global FREQ1;
global FREQ2;
global FREQ5;
global FREQ6;
global FREQ7;
global FREQ8;
global FREQ1_GLO;
global DFRQ1_GLO;
global FREQ2_GLO;
global DFRQ2_GLO;
global FREQ3_GLO;
global FREQ4_GLO;
global FREQ6_GLO;
global FREQ1_CMP;
global FREQ2_CMP;
global FREQ6_CMP;
global FREQ7_CMP;
global FREQ5_CMP;
global FREQ8_CMP;

pi = 3.1415926;
CLIGHT = 299792458.0;       %speed of light
FREQ1 = 1.57542*10^9;       %L1/E1  frequency (Hz)
FREQ2 = 1.22760*10^9;       %L2     frequency (Hz)
FREQ5 = 1.17645*10^9;       %L5     frequency (Hz)
FREQ6 = 1.27875*10^9;       %E5a frequency (Hz)
FREQ7 = 1.20714*10^9;       %E5b frequency (Hz)
FREQ8 = 1.191795*10^9;      %E5a+b  frequency (Hz)
FREQ1_GLO = 1.60200*10^9;   %GLONASS G1 base frequency (Hz)
DFRQ1_GLO = 0.56250*10^6;   %GLONASS G1 bias frequency (Hz/n)
FREQ2_GLO = 1.24600*10^9;   %GLONASS G2 base frequency (Hz)
DFRQ2_GLO = 0.43750*10^6;   %GLONASS G2 bias frequency (Hz/n)
FREQ3_GLO = 1.202025*10^9;  %GLONASS G3 frequency (Hz)
FREQ4_GLO = 1.600995*10^9;  %GLONASS G4 frequency (Hz)
FREQ6_GLO = 1.24806*10^9;  %GLONASS G6 frequency (Hz)
FREQ1_CMP = 1.57542*10^9;  %BeiDou B1 frequency (Hz)
FREQ2_CMP = 1.561098*10^9;   %BeiDou B2 frequency (Hz)
FREQ6_CMP = 1.26852*10^9;   %BeiDou B3 frequency (Hz)
FREQ7_CMP = 1.207140*10^9;
FREQ5_CMP = 1.17645*10^9;
FREQ8_CMP = 1.191795*10^9;
%% parameter configuration
% system select  systype : GREC
sys = systype;
satlist = getSatList(sys);
% set the parameters (except QC parameters)
[LineWid,PolyOrder,type] = setParameters();
% the path of namelist files
MyFilePath = path;
% quality control parameters £¨time domain£©
[NumOfArea,EleMask,AziMask,EleDif,NoiseRange,MinPoints,MaxTime] = paraOfQC(elemask,azimmask,areatag);
% Reflector height (m)
MinHeight = rhmin;
MaxHeight = rhmax;
StructOfData = myGetstruct(MyFilePath);
%% get file list
% profile on                          
[NumofFiles1,DataFileList] = readingSNR(MyFilePath ,type);
%% processing (file-by-file)
for FileNum=1:NumofFiles1
    %% read data in¡®data¡¯
    [Year, Doy, OutFileID, Data] = getData(FileNum,MyFilePath,DataFileList);
    %% sat-by-sat
    for SatNum = satlist
        % quality control parameters
        [SNR_Pk2NoiseRatio,SNR_Mp2SpRatio,Sig_Pk2NoiseRatio,Sig_Mp2SpRatio,...
            Tri_Pk2NoiseRatio,Tri_Mp2SpRatio,Dual_Pk2NoiseRatio,Dual_Mp2SpRatio] = QCofFreq(SatNum,Doy);
        % Get the wave length and the column of data
        [Flag,numOfArc,IDofArc,MaskPart] = divideArc(SatNum,Data,NumOfArea,EleMask,AziMask,EleDif,MinPoints);
        % find the arc of the select sat
        [HalfWaveLen,IDofCol,Sys] = getWaveLen(SatNum,StructOfData);
        if Flag == 0
            continue;
        end
        %% arc-by-arc
        for ArcNum = 1:numOfArc
            % Tropospheric delay correction (sea surface)
            [data] = TroCor(IDofArc{ArcNum},Data);
            % get the observation of each arc
            [TimeHour,Ele,SinE,MaxEle,MinEle,MeanAzm,DelTime,MeanTime,LinS1,LinS2,LinS3,LinS4,LinS5,...
                C1,C2,C3,C4,C5,P1,P2,P3,P4,P5] = getRawObs(data,IDofCol);
            rawSNR = [LinS1,LinS2,LinS3,LinS4,LinS5];
            % sort and detrend
            [TimeHour,Ele,SorSinE,DetrendS1,DetrendS2,DetrendS3,DetrendS4,DetrendS5] = ...
                detrend(SinE,LinS1,LinS2,LinS3,LinS4,LinS5,TimeHour,Ele,PolyOrder);
            
            % dynamic correction parameters
            TanE = tand(Ele);
            myTime = [];
            for IDofTane = 1:length(TimeHour) - 1
                myTime(IDofTane,1) = sum(TimeHour(IDofTane:IDofTane+1,1))/2;
            end
            intTanE = interp1(TimeHour,tand(Ele),myTime,'spline');
            diffE = (diff(deg2rad(Ele))./diff(TimeHour));
            Dyn = mean(intTanE./diffE);
            detrendSNR = [DetrendS1,DetrendS2,DetrendS3,DetrendS4,DetrendS5];
            [~,j] = sort(SinE);
            C1 = C1(j);C2 = C2(j);C3 = C3(j);C4 = C4(j);C5 = C5(j);
            P1 = P1(j);P2 = P2(j);P3 = P3(j);P4 = P4(j);P5 = P5(j);
            if ~(all(diff(SorSinE)>0))
                continue;
            end
            % SNR obs
            [S1,S2,S3,S4,S5] = QCinTimeDom(SorSinE,DetrendS1,DetrendS2,DetrendS3,DetrendS4,DetrendS5);
            SNRObs = [S1,S2,S3,S4,S5];
            % Triple frequency
%             TriObs = TripleFreqCom(C1,C2,C3,C4,C5,Sys,HalfWaveLen,SinE,PolyOrder);
            % Single frequency
            [SigObs,IonCor] =singleFreqCom(C1,C2,C3,C4,C5,P1,P2,P3,P4,P5,Sys,HalfWaveLen,SinE,PolyOrder);
            % Combination of Pseudorange and Carrier Phase
            % LSP
%           %if 'Signal Processing Toolbox' is installed(which is recommended)
%           %toolboxFlag = 1 : the software will call 'plomb.m'
%           %if 'Signal Processing Toolbox' is not installed
%           %toolboxFlag = 2 : the software will run 'plombSimple.m'
%             toolboxFlag = 1 ;
            toolboxFlag = 2 ;
         if toolboxFlag == 1
            [H,LSP] = LOMBNEW(SNRObs,SorSinE,HalfWaveLen); 
            [snrH] = SNRHeight(H,LSP);
%             [Freq,TriLSP] = myLomb(TriObs,SorSinE);
%             [TriH,TriFreq] = TriHeight(Freq,TriLSP,LineWid,Sys);
            [SigFreq,SigLSP] = myLomb(SigObs,SorSinE);
            [SigH,SigFreq] = sigHeight(SigFreq,SigLSP,LineWid,Sys,MaskPart(ArcNum));
         else
            [H,LSP] = LOMBNEW(SNRObs,SorSinE,HalfWaveLen); %
            [snrH] = SNRHeight(H,LSP);
            [SigFreq,SigLSP] = myLombNEW(SigObs,SorSinE);%
            [SigH,SigFreq] = sigHeight(SigFreq,SigLSP,LineWid,Sys,MaskPart(ArcNum));   
         end
            % QC in frequency domain
            [PkNoise,MeanSlOfMP,Mp2SpRatio] = QcFreq(H,LSP,NoiseRange,MinHeight);
%             [TriPkNoise,TriMeanSlOfMP,TriMp2SpRatio] = QcFreq(TriFreq,TriLSP,NoiseRange,MinHeight);
            [SigPkNoise,SigMeanSlOfMP,SigMp2SpRatio] = QcFreq(SigFreq,SigLSP,NoiseRange,MinHeight);
            % plot figure
%             MyPlot(PlotSwitch,SinE,rawSNR,SorSinE,detrendSNR,SNRObs,H,LSP,SatNum,PkNoise,Mp2SpRatio);
%             MyPlot(PlotSwitch,SinE,SigObs,SorSinE,IonCor,SigObs,SigFreq,SigLSP,SatNum,SigPkNoise,SigMp2SpRatio);
%             close all;

            % OutPut the results in out file
            if contains(obstype,'SNR')
            methodtype = 'SNR';
            output(OutFileID,SatNum,PkNoise,MeanSlOfMP,Mp2SpRatio,Year, Doy, snrH,...
                MeanAzm, DelTime, MaxEle, MinEle, MeanTime, MaxTime,...
                MaxHeight,MinHeight,SNR_Pk2NoiseRatio,SNR_Mp2SpRatio,methodtype,Dyn,MaskPart(ArcNum));
            end
            %             type = 'Tri';
            %             Output(OutFileID,SatNum,TriPkNoise,TriMeanSlOfMP,TriMp2SpRatio,Year, Doy, TriH,...
            %                 MeanAzm, DelTime, MaxEle, MinEle, MeanTime, MaxTime,...
            %                 MaxHeight,MinHeight,Tri_Pk2NoiseRatio,Tri_Mp2SpRatio,type,Dyn);
            if contains(obstype,'CMC')
            methodtype = 'Sig';
            output(OutFileID,SatNum,SigPkNoise,SigMeanSlOfMP,SigMp2SpRatio,Year, Doy, SigH,...
                MeanAzm, DelTime, MaxEle, MinEle, MeanTime, MaxTime,...
                MaxHeight,MinHeight,Sig_Pk2NoiseRatio,Sig_Mp2SpRatio,methodtype,Dyn,MaskPart(ArcNum));
            end
        end
    end
    %% clear
    fclose(OutFileID);
end
end


