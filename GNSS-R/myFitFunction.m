function [fitresult, gof] = myFitFunction(x_raw, y_raw ,len)
%  if  'Curve Fitting Toolbox' is installed , the software will
%  call fit.m

    x = 2 * pi * x_raw;
    y = y_raw / (max(y_raw) - min(y_raw));
    valid = ~(isnan(x) | isnan(y));
    x = x(valid);
    y = y(valid);
    x = x(:);
    y = y(:);  
% [x, y] = prepareCurveData(x, y); %if 'Curve Fitting Toolbox' is installed
    if len >= 6
        ft = fittype( 'fourier2' );
        opts = fitoptions(ft); 
        opts.Algorithm = 'Levenberg-Marquardt';
        opts.Display = 'Off';
        opts.Normalize = 'on';
        opts.Robust = 'Bisquare';
    else
        ft = 'smoothingspline';
        opts = fitoptions(ft);
        opts.Normalize = 'on';
    end
    % 
    [fitresult, gof] = fit(x, y, ft,opts);
end