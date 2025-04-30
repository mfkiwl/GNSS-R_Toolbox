function satlist = getSatList(sys)
%   obtain the satlist according to the selected system
%   G = GPS R = GLONASS E = Galileo C = BDS
%% GPS
if ~isempty(strfind(sys,'G')) 
    satlist1 = [1:32];
else 
    satlist1 = [];
end
%% GLONASS
if ~isempty(strfind(sys,'R')) 
    satlist2 = [33:58];
else 
    satlist2 = [];
end
%% Galileo 
if ~isempty(strfind(sys,'E')) 
    satlist3 = [59:94];
else 
    satlist3 = [];
end
%% BDS
if ~isempty(strfind(sys,'C')) 
    satlist4 = [95:180];
else 
    satlist4 = [];
end
%%
satlist = [satlist1 satlist2 satlist3 satlist4];
end

