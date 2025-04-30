function StructOfData = myGetstruct(MyFilePath) %2018/8/29
global CLIGHT;
global FREQ1;
global FREQ2;
global FREQ5;
global FREQ6;
global FREQ7;
global FREQ8;
global FREQ1_GLO;
global FREQ2_GLO;
global FREQ3_GLO;
global FREQ4_GLO;
global FREQ6_GLO;
global FREQ1_CMP;
global FREQ2_CMP;
global FREQ6_CMP;
global FREQ7_CMP;
global FREQ5_CMP;
global FREQ8_CMP;

FreqLib = ...
    [
    1,2,5,0,0,0;FREQ1,FREQ2,FREQ5,0,0,0;...
    1,4,2,6,3,0;FREQ1_GLO,FREQ4_GLO,FREQ2_GLO,FREQ6_GLO,FREQ3_GLO,0;...
    1,5,7,8,6,0;FREQ1,FREQ5,FREQ7,FREQ8,FREQ6,0;...
    2,1,5,7,8,6;FREQ2_CMP,FREQ1_CMP,FREQ5_CMP,FREQ7_CMP,FREQ8_CMP,FREQ6_CMP...
    ];

FileName = 'GNSSR.par';
InFileID = fopen([MyFilePath,FileName],'r');

if InFileID < 0
    disp('problem with your Data Struct file');
    return
else
end

    for i = 1:4
      str = fgetl(InFileID);
      tab = 0;
        for j = 1:15
            if strcmp(str(2+tab:2+tab),'x') || strcmp(str(2+tab:2+tab),'X')
                StructOfData(i,j) = 0;
            else
                Freq = str2num(str(2+tab:2+tab));
                ID = find(FreqLib(2*i-1,:) == Freq); 
                if j < 6
                    StructOfData(i,j) = (CLIGHT/FreqLib(2*i,ID))/2;
                else
                    StructOfData(i,j) = (CLIGHT/FreqLib(2*i,ID));
                end
            end
            tab = tab + 4;
        end
    end
    
fclose(InFileID);

end