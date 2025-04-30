function y = mymedfilt1(x, N)
%  Simplified version of medfilt1.m with no Toolbox dependency.
% Inputs:
%   x — input signal, supports row or column vector
%   N — median filter window length
%
% Output:
%   y — filtered output, same size as x

    if ~isvector(x)
        error('Input x must be a vector.');
    end

    is_row = isrow(x);
    x = x(:);  
    L = length(x);
    y = NaN(size(x));

    if mod(N, 2) == 0
        pre = N / 2;
        post = N / 2 - 1;
    else
        pre = floor(N / 2);
        post = pre;
    end

    x_pad = [zeros(pre,1); x; zeros(post,1)];

  % Apply median filtering
    for i = 1:L
        window = x_pad(i : i + N - 1);
        window = window(~isnan(window));  % omitnan
        if isempty(window)
            y(i) = NaN;
        else
            y(i) = median(window);
        end
    end

    if is_row
        y = y.';
    end
end
