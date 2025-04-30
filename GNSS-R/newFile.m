function [ station, year, doy, mynewfile ] = newFile( filename )
%create namelist
station = filename(1:4);
year = filename(10:11);
doy = filename(5:7);
mynewfile = [station, doy, '0.', year, 'd'];
end
