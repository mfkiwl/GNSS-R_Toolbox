function [P, f] = plombSimple(x, t)
%  simplified Lomb-Scargle 
%  Signal Processing Toolbox is advised to install 
%  to obtain full functions of 'plomb.m'
% Inputs and Outputs:
%   x is the input signal, which has been sampled at the instants
%   specified in t. t must increase monotonically.
%   P is thethe Lomb-Scargle power spectral density and 
%   P is evaluated at the frequencies returned in F.

valid_idx = ~(isnan(x) | isnan(t));
x = x(valid_idx);
t = t(valid_idx);

% 
x = x - mean(x);

N = length(t);
T = max(t) - min(t);
if N < 2 || T == 0
    error('insufficient data');
end


Ts = T / (N - 1);          
fmax = 1 / (2 * Ts);        
fmin = 1 / (4 * N * Ts);     
num_f = round(fmax / fmin);  


f = linspace(0, fmax, num_f)';

% Lomb-Scargle
P = zeros(size(f));
for k = 1:length(f)
    omega = 2 * pi * f(k);
    tau = atan2(sum(sin(2 * omega * t)), sum(cos(2 * omega * t))) / (2 * omega);

    cos_term = cos(omega * (t - tau));
    sin_term = sin(omega * (t - tau));

    P_cos = (sum(x .* cos_term))^2 / sum(cos_term.^2);
    P_sin = (sum(x .* sin_term))^2 / sum(sin_term.^2);

    P(k) = P_cos + P_sin;
end

P = P / (2 * var(x));

end
