function [H,LSP] = LOMB(Obs,SorSinE,HalfWaveLen)
%Lomb normalized periodogram
for i =1:length(Obs(1,:))
    [LSP{i},Freq{i}] = plomb0(Obs(:,i),SorSinE);
    if ~HalfWaveLen(i) == 0
        H{i} = HalfWaveLen(i)*Freq{i};
    else
        H{i} = [];
    end
end
end

