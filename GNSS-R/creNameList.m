function creNameList(ofilepath,nfilepath,outputfilepath)
%% Create namelist files
% Inputs :
% ofilepath : the path of Obversation FILES(RINEX 3)
% nfilepath : the path of Navigation FILES(sp3)
% outputfilepath : the path of Output FILES(namelist files)
% the namelist files will be stored in 'outputfilepath'
% eg.
% ofilepath = '..\Data\o\';
% nfilepath = '..\Data\n\';
% outputfilepath = '..\Data\output\';
% creNameList(ofilepath,nfilepath,outputfilepath);
%%
    filepath = ofilepath;
%   the filenames of Obversation FILES should be short filenames
%   example filename : brst3650.21o
    type = '*o';
%   read files and return the number of files
    [numofFiles , filelist]=readingFile(filepath , type);
%   the output file
    snr = '.SlcData';
%   the Navigation FILES need precise ephemeris
%   eg. gbm21905.sp3
    org = 'gbm';
%%  
%   Read file and create output file
    InfileDir = [outputfilepath,'obsFile.txt'];
    fid1 = fopen(InfileDir,'at+');
    NavfileDir = [outputfilepath,'nnavFile.txt'];
    fid2 = fopen(NavfileDir,'at+');
    aNavfileDir = [outputfilepath,'anavFile.txt'];
    fid4 = fopen(aNavfileDir,'at+');
    bNavfileDir = [outputfilepath,'bnavFile.txt'];
    fid5 = fopen(bNavfileDir,'at+');
    OutfileDir = [outputfilepath,'outFile.txt'];
    fid3 = fopen(OutfileDir,'at+');
    
    for num = 1:numofFiles
        filename = cell2mat(filelist(num));
        [ station, year, doy, mynewfile ] = newFile( filename );
        infile = mynewfile(1:11);
        infile = [infile, 'o'];
        infile = [ofilepath,infile];
        if (num == numofFiles)
            count=fprintf(fid1,'%s',infile);
            count=fprintf(fid1,'\n%s','end');
        else
            count=fprintf(fid1,'%s\n',infile);
        end
        
        %DOY to GPS week
        cal = doy2cal(year,doy);
        [week, elapse] = cal2gps(cal);
        
        navfile = [org, num2str(week), num2str(elapse), '.sp3'];
        navfile = [nfilepath ,navfile];
        if (num == numofFiles)
            count1=fprintf(fid2,'%s',navfile);
            count1=fprintf(fid2,'\n%s','end');
        else
            count1=fprintf(fid2,'%s\n',navfile);
        end    
        
        if elapse < 6
            aelapse = elapse + 1;
            aweek = week;
        else
            aelapse = 0;
            aweek = week + 1;
        end
        
        navfile = [org, num2str(aweek), num2str(aelapse), '.sp3'];
        navfile = [nfilepath ,navfile];
        if (num == numofFiles)
            count1=fprintf(fid4,'%s',navfile);
            count1=fprintf(fid4,'\n%s','end');
        else
            count1=fprintf(fid4,'%s\n',navfile);
        end

        if elapse < 1
            belapse = 6;
            bweek = week - 1;
        else
            belapse = elapse - 1;
            bweek = week;
        end
        
        navfile = [org, num2str(bweek), num2str(belapse), '.sp3'];
        navfile = [nfilepath,navfile];
        if (num == numofFiles)
            count1=fprintf(fid5,'%s',navfile);
            count1=fprintf(fid5,'\n%s','end');
        else
            count1=fprintf(fid5,'%s\n',navfile);
        end
        
        outfile = mynewfile(1:8);
        snr2 = ['.',num2str(year), snr];
        outfile = [outfile,snr2];
        outfile = [outputfilepath ,outfile];
        if (num == numofFiles)
            count2=fprintf(fid3,'%s',outfile);
            count2=fprintf(fid3,'\n%s','end');
        else
            count2=fprintf(fid3,'%s\n',outfile);
        end
    end
fclose all;