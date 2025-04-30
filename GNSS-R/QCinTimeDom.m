function [S1,S2,S3,S4,S5] = QCinTimeDom(SorSinE,DetrendS1,DetrendS2,DetrendS3,DetrendS4,DetrendS5)
% QC control in time-domain
%% 
% S1 = wdenoise(DetrendS1,'Wavelet','sym3');
% S2 = wdenoise(DetrendS2,'Wavelet','sym3');
% S3 = wdenoise(DetrendS3,'Wavelet','sym3');
% S4 = wdenoise(DetrendS4,'Wavelet','sym3');
% S5 = wdenoise(DetrendS5,'Wavelet','sym3');
S1 = DetrendS1;
S2 = DetrendS2;
S3 = DetrendS3;
S4 = DetrendS4;
S5 = DetrendS5;
end

