function [Freq,LSP] = myLombNEW(Obs,SorSinE)
%Lomb normalized periodogram

for i =1:length(Obs(1,:))
    [LSP{i},Freq{i}] = plombSimple(Obs(:,i),SorSinE);
end
end

