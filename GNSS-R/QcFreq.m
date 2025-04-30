function [PkNoise,MeanSlOfMP,Mp2SpRatio] = QcFreq(H,LSP,NoiseRange,MinHeight)
%QC (in frequency domain)
for i = 1:length(H)
    if ~isempty(H{i})
        % main peak power and secondary peak power + slope of main peak
        [MaxLSP(i),PosOfYmax(i)] = max(LSP{i});
        RefH = H{i}(PosOfYmax(i));
        [PkLSP,Locs] = findpeaks(LSP{i});
        if length(PkLSP) == 0
            PkNoise(i) = 0;
            MeanSlOfMP(i) = 0;
            Mp2SpRatio(i) = 0;
            continue;
        end
        % main peak
        LocOfMP = find(PkLSP == MaxLSP(i));
        % slope of main peak
        if ~(LocOfMP == length(Locs))
            LocAfMP = Locs(LocOfMP + 1);
            if ~LocOfMP == 1
                LocBfMP = Locs(LocOfMP - 1);
            else
                LocBfMP = 1;
            end
            PowOfLocAfMP = LSP{i}(LocAfMP);
            PowOfLocBfMP = LSP{i}(LocBfMP);
            FreqOfLocAfMP = H{i}(LocAfMP);
            FreqOfLocBfMP = H{i}(LocBfMP);
            SlOfLocAfMP(i) = abs((PowOfLocAfMP-MaxLSP(i))/(FreqOfLocAfMP-RefH));
            SlOfLocBfMP(i) = abs((PowOfLocBfMP-MaxLSP(i))/(FreqOfLocBfMP-RefH));
            MeanSlOfMP(i) = (SlOfLocAfMP(i) + SlOfLocBfMP(i))/2;
        else
            MeanSlOfMP(i) = 0;
        end
        % peak/noise
        ID  = find(H{i} > NoiseRange(1) & H{i} < NoiseRange(2) & ...
            MaxLSP(i)-0.25 < MaxLSP(i) & MaxLSP(i)+0.25 > MaxLSP(i));
        Noise = mean(LSP{i}(ID));
        PkNoise(i) = MaxLSP(i)/Noise;
        % secondary peak
        FreqofPeak = H{i}(Locs);
%         IDofRemove = find(FreqofPeak < MinHeight);
%         PkLSP(IDofRemove) = [];
        SorPkLSP = sort(PkLSP);
        if length(SorPkLSP)>1
            SecPK = SorPkLSP(end - 1);
            % main peak / secondary peak
            Mp2SpRatio(i) = MaxLSP(i)/SecPK;
        else
            Mp2SpRatio(i) = 0;
        end
    else
        PkNoise(i) = -1; MeanSlOfMP(i) = -1; Mp2SpRatio(i) = -1;
    end
end
end

