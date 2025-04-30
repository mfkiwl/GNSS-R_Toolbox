function [week, elapse]=cal2gps(cal)
%  convert Calendar GPS time to GPS weeks and seconds within GPS weeks
%  Inputs :
%  cal : Calendar GPS time
%  Outputs :
%  week : GPS week
%  elapse : seconds within GPS weeks

if length(cal) < 6
	cal(6)=0;
end
mjd=cal2mjd(cal);
elapse=mjd-44244;
week=floor(elapse/7);
elapse=elapse-week*7;

