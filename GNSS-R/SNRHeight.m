function [RefH] = SNRHeight(H,LSP)
% Ref height of SNR
num = length(H);
for i = 1:num
    % reflected height
    if ~isempty(H{i})
        [MaxLSP{i},PosOfYmax{i}] = max(LSP{i});
        Xmax{i} = H{i}(PosOfYmax{i});
    else
        Xmax{i} = 0;
    end
    RefH = cell2mat(Xmax);
end
end

