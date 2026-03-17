function [SNR_Pk2NoiseRatio,SNR_Mp2SpRatio,Sig_Pk2NoiseRatio,Sig_Mp2SpRatio,...
    Tri_Pk2NoiseRatio,Tri_Mp2SpRatio,Dual_Pk2NoiseRatio,Dual_Mp2SpRatio] = QCofFreq(sat,Doy)
% QC parameters
if sat <= 32
    SNR_Pk2NoiseRatio = [7, 7, 7, 7, 7];
    SNR_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
%     Sig_Pk2NoiseRatio = [8, 8, 8, 8, 8];
        Sig_Pk2NoiseRatio = [8.5, 8.5, 8.5, 8.5, 8.5];
    Sig_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
    Tri_Pk2NoiseRatio  = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
    Tri_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    Dual_Pk2NoiseRatio = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
    Dual_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    return;
    
    % GLONASSϵͳ
elseif (sat <= 58 & sat > 32)
    SNR_Pk2NoiseRatio = [7, 7, 7, 7, 7];
    SNR_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
%     Sig_Pk2NoiseRatio = [8, 8, 8, 8, 8];
            Sig_Pk2NoiseRatio = [8.5, 8.5, 8.5, 8.5, 8.5];
    Sig_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
    Tri_Pk2NoiseRatio  = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
    Tri_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    Dual_Pk2NoiseRatio = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
    Dual_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    return;
    
    % Galileoϵͳ
elseif (sat <= 94 & sat > 58)
    SNR_Pk2NoiseRatio = [7, 7, 7, 7, 7];
    SNR_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
%     Sig_Pk2NoiseRatio = [8, 8, 8, 8, 8];
            Sig_Pk2NoiseRatio = [8.5, 8.5, 8.5, 8.5, 8.5];
    Sig_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
    Tri_Pk2NoiseRatio  = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
    Tri_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    Dual_Pk2NoiseRatio = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
    Dual_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    return;
    
    % BDSϵͳ
elseif (sat > 94)
    SNR_Pk2NoiseRatio = [7, 7, 7, 7, 7];
    SNR_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
%     Sig_Pk2NoiseRatio = [8, 8, 8, 8, 8];
            Sig_Pk2NoiseRatio = [8.5, 8.5, 8.5, 8.5, 8.5];
    Sig_Mp2SpRatio = [1.5, 1.5, 1.5, 1.5, 1.5];
    Tri_Pk2NoiseRatio  = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
    Tri_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    Dual_Pk2NoiseRatio = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
    Dual_Mp2SpRatio = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    return;
end
end



