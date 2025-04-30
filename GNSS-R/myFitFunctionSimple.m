function [fitresult, gof] = myFitFunctionSimple(x_raw, y_raw, len)
%  Simplified version of fit.m with no Toolbox dependency
%  Inputs:
%  x_raw   — variable values to be fitted , vector
%  y_raw   — variable values to be fitted , same size as x
%  len — length of the input data, used to select the fitting method
%  Output:
%   fitresult — fitted model or fitting coefficients
    
    x = 2 * pi * x_raw;
    y = y_raw / (max(y_raw) - min(y_raw));

    valid = ~(isnan(x) | isnan(y));
    x = x(valid);
    y = y(valid);
    x = x(:);
    y = y(:);

    if len >= 6
        X_design = [ones(size(x)), cos(x), sin(x), cos(2*x), sin(2*x)];
        coeffs = X_design \ y;

        fitresult = @(x_query) fourier2_model(x_query, coeffs);


    else
        x_ref = x;
        y_ref = y;
        fitresult = @(x_query) spline_model(x_query, x_ref, y_ref);

    end
    xq = x_raw(valid); 
    y_fit = fitresult(xq);
    gof.rsquare = 1 - sum((y - y_fit).^2) / sum((y - mean(y)).^2);

end

%
function y = fourier2_model(x_query, coeffs)
    x_query = 2 * pi * x_query;
    y = coeffs(1) + ...
        coeffs(2)*cos(x_query) + ...
        coeffs(3)*sin(x_query) + ...
        coeffs(4)*cos(2*x_query) + ...
        coeffs(5)*sin(2*x_query);
end

%
function y = spline_model(x_query, x_ref, y_ref)
    x_ref = x_ref(:);
    y_ref = y_ref(:);
    x_query = 2 * pi * x_query;
    y = interp1(x_ref, y_ref, x_query, 'spline', 'extrap');
end