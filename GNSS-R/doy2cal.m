function cal = doy2cal(year,doy)
% DOY to Calendar
cal = zeros(6);
tempday = str2num(doy);
year = ['20',year];
year = str2num(year);
% Leap year or no
dom = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
if (rem(year,4) == 0)
    dom(2) = 29;
    if rem(year,100) == 0
        if ~rem(year,400) == 0
         dom(2) = 28;
        end
    end
end 
i = 0;
while tempday > 0
    i = i+1;
    tempday = tempday -  dom(i);
end
month = i;
day = tempday + dom(i);
cal(1) = year;
cal(2) = month;
cal(3) = day;
end

