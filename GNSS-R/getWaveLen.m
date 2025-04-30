function [ HalfWaveLen,IDofCol,Sys ] = getWaveLen( sat,StructOfData )
%input sat and returns wavelength factor
%% consatant
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
global FREQ1_CMP;
global FREQ2_CMP;
global FREQ6_CMP;
global FREQ7_CMP;
global FREQ5_CMP;

% It should be mentioned that the wave length of Glonass satellite is not a constant.
%% Get the half wave length
% if sat <= 32
%   HalfWaveLen(1)  = (CLIGHT/FREQ1)/2; IDofCol(1) = 5;
%   HalfWaveLen(2) = (CLIGHT/FREQ1)/2; IDofCol(2) = 6;
%   HalfWaveLen(3) = (CLIGHT/FREQ2)/2; IDofCol(3) = 7;
%   HalfWaveLen(4) = (CLIGHT/FREQ5)/2; IDofCol(4) = 8;
%   HalfWaveLen(5) = 0; IDofCol(5) = 9;
%   HalfWaveLen(6)  = (CLIGHT/FREQ1); IDofCol(6) = 10;
%   HalfWaveLen(7) = (CLIGHT/FREQ2); IDofCol(7) = 11;
%   HalfWaveLen(8) = (CLIGHT/FREQ2); IDofCol(8) = 12;
%   HalfWaveLen(9) = (CLIGHT/FREQ5); IDofCol(9) = 13;
%   HalfWaveLen(10) = 0; IDofCol(10) = 14;
%   Sys = 'G'; 
%   return;
% 
% % GLONASS
% elseif (sat <= 58 & sat > 32)
%   HalfWaveLen(1)  = (CLIGHT/FREQ1_GLO)/2; IDofCol(1) = 5;
%   HalfWaveLen(2) = (CLIGHT/FREQ1_GLO)/2; IDofCol(2) = 6;
%   HalfWaveLen(3) = (CLIGHT/FREQ2_GLO)/2; IDofCol(3) = 7;
%   HalfWaveLen(4) = (CLIGHT/FREQ2_GLO)/2; IDofCol(4) = 8;
%   HalfWaveLen(5) = 0; IDofCol(5) = 9;
%   HalfWaveLen(6)  = (CLIGHT/FREQ1_GLO); IDofCol(6) = 10;
%   HalfWaveLen(7) = (CLIGHT/FREQ1_GLO); IDofCol(7) = 11;
%   HalfWaveLen(8) = (CLIGHT/FREQ2_GLO); IDofCol(8) = 12;
%   HalfWaveLen(9) = (CLIGHT/FREQ2_GLO); IDofCol(9) = 13;
%   HalfWaveLen(10) = 0; IDofCol(10) = 14;
%   Sys = 'R'; 
%   return;
% 
% % Galileo
% elseif (sat <= 94 & sat > 58)
%   HalfWaveLen(1)  = (CLIGHT/FREQ1)/2; IDofCol(1) = 5;
%   HalfWaveLen(2) = (CLIGHT/FREQ6)/2; IDofCol(2) = 6;
%   HalfWaveLen(3) = (CLIGHT/FREQ5)/2; IDofCol(3) = 7;
%   HalfWaveLen(4) = (CLIGHT/FREQ7)/2; IDofCol(4) = 8;
%   HalfWaveLen(5) = (CLIGHT/FREQ8)/2; IDofCol(5) = 9;
%   HalfWaveLen(6)  = (CLIGHT/FREQ1); IDofCol(6) = 10;
%   HalfWaveLen(7) = (CLIGHT/FREQ6); IDofCol(7) = 11;
%   HalfWaveLen(8) = (CLIGHT/FREQ5); IDofCol(8) = 12;
%   HalfWaveLen(9) = (CLIGHT/FREQ7); IDofCol(9) = 13;
%   HalfWaveLen(10) = (CLIGHT/FREQ8); IDofCol(10) = 14;
%   Sys = 'E'; 
%   return;
% 
% % BDS
% elseif (sat > 94)
%   HalfWaveLen(1)  = (CLIGHT/FREQ1_CMP)/2; IDofCol(1) = 5; 
%   HalfWaveLen(2) = (CLIGHT/FREQ2_CMP)/2; IDofCol(2) = 6; 
%   HalfWaveLen(3) = (CLIGHT/FREQ6_CMP)/2; IDofCol(3) = 7; 
%   HalfWaveLen(4) = (CLIGHT/FREQ7_CMP)/2; IDofCol(4) = 8;
%   HalfWaveLen(5) = (CLIGHT/FREQ5_CMP)/2; IDofCol(5) = 9;
%   HalfWaveLen(6)  = (CLIGHT/FREQ1_CMP); IDofCol(6) = 10;
%   HalfWaveLen(7) = (CLIGHT/FREQ2_CMP); IDofCol(7) = 11;
%   HalfWaveLen(8) = (CLIGHT/FREQ6_CMP); IDofCol(8) = 12;
%   HalfWaveLen(9) = (CLIGHT/FREQ7_CMP); IDofCol(9) = 13;
%   HalfWaveLen(10) = (CLIGHT/FREQ5_CMP); IDofCol(10) = 14;
%   Sys = 'C'; 
%   return;
% end

%input sat and returns wavelength factor
%% consatant
% It should be mentioned that the wave length of Glonass satellite is not a constant.
%% Get the half wave length
IDofCol(1:15) = 4 + (1:15);
if sat <= 32
    for i = 1:15
        HalfWaveLen(1,1:15) = StructOfData(1,1:15);
    end
    Sys = 'G';
    return;
    
    % GLONASS
elseif (sat <= 58 & sat > 32)
    for i = 1:15
        HalfWaveLen(1,1:15) = StructOfData(2,1:15);
    end
    Sys = 'R';
    return;
    
    % Galileo
elseif (sat <= 94 & sat > 58)
    for i = 1:15
        HalfWaveLen(1,1:15) = StructOfData(3,1:15);
    end
    Sys = 'E';
    return;
    
    % BDS
elseif (sat > 94)
    for i = 1:15
        HalfWaveLen(1,1:15) = StructOfData(4,1:15);
    end
    Sys = 'C';
    return;
end


end

