function output(OutFileID,Sat,PkNoise,MeanSlOfMP,Mp2SpRatio,Year, Doy,...
    RefH, MeanAzm, DelTime, MaxEle, MinEle, MeanTime,MaxTime,...
    MaxHeight,MinHeight,SNR_Pk2NoiseRatio,SNR_Mp2SpRatio,type,Dyn,MaskPart)
% output result
for i = 1:length(PkNoise)
    % QC
    if strcmp(type,'Sig')
        IDofOBS = i + 10;
    elseif strcmp(type,'Tri')
        IDofOBS = i + 5;
    elseif strcmp(type,'SNR')
        IDofOBS = i;
    end
    if PkNoise(i) > 0
        if (PkNoise(i) > SNR_Pk2NoiseRatio(i) & Mp2SpRatio(i) > SNR_Mp2SpRatio(i)...
                & DelTime < MaxTime & MaxHeight > RefH(i)& RefH(i) > MinHeight)
            fprintf(OutFileID,'%4.0f  %3.0f  %7.2f  %7.2f  %3s  %4.0f  %6.2f  %6.2f  %5.2f  %3.0f  %6.3f %6.3f %3.0f\n', ...
                Year, Doy,RefH(i),MeanAzm,getSatName(Sat),DelTime*60, MaxEle, MinEle, MeanTime, IDofOBS, PkNoise(i),Dyn,MaskPart);
        end
    end
end
end

