function mjd=cal2mjd(cal)
% cal2mjd : Convert the Gregorian date (year, month, day, hour, minute, second) to the Simplified Julian Date.
%  mjd=cal2mjd(cal) : Return the Simplified Julian Date.
%  cal£ºA 1x6 matrix, with the six columns representing year, month, day, hour, minute, and second
jd = cal2jd(cal);
mjd = jd - 2400000.5;
