function [Freq,LSP] = myLomb(Obs,SorSinE)
%Lomb normalized periodogram

for i =1:length(Obs(1,:))
    [LSP{i},Freq{i}] = plomb(Obs(:,i),SorSinE);
end
end

