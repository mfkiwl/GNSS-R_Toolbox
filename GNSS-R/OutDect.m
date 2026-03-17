function [X,Y,type,DynCor,pkn] = OutDect(dataBase,myType,Num,startTime,endTime)
% outlier detection
X = [];Y = [];type = [];DynCor = [];pkn = [];
%% remove the outliers
for i = 1:Num
%     selectType = [1:15];
%     Range = [1:15];
%     ID = find( Range >= min(myType) & Range <= max(myType));
%     Range(ID) = [];
%     ID = find(selectType >=min(Range((i-1)*5+1:i*5)) & selectType <=max(Range((i-1)*5+1:i*5)));
%     selectType(ID) = [];
    [rawX,rawY,rawtype,rawPkn,Dyn] = SlcDataBase(dataBase,myType);
%     [rawX,rawY,rawtype,rawPkn,Dyn] = SlcDataBase(dataBase,selectType);
    myX = rawX;
    myY = rawY;
    mytype = rawtype;
    mypkn = rawPkn;
    myDynCor = Dyn;
    myflag = zeros(length(X),1);

    %%%%startdoy enddoy
    endTime2 = endTime+1;
    outselecttime =  find( myX < startTime | myX > endTime2 );
    myX(outselecttime,:) = [];
    myY(outselecttime,:) = [];
    mytype(outselecttime,:) = [];
    mypkn(outselecttime,:) = [];
    myDynCor(outselecttime,:) = [];
    
    
    for time = min(myX):24/24:max(myX)
        ID1 = find(time<myX & time+24/24>myX);
        if min(rawtype > 5)
            R = 0.2;
            minPoint = 3;
        else
            R = 0.2;
            minPoint = 3;
        end
%         [ IDX1 ] = myDBSCAN([2*3.14*myX(ID1),myY(ID1)/(max(myY(ID1))-min(myY(ID1)))],0,R,minPoint);
% %         [fitresult, gof] = createFit(2*3.14*myX(ID1),myY(ID1)/(max(myY(ID1))-min(myY(ID1))));
% %         FitY = fitresult(2*3.14*myX(ID1));
% %         Dif = FitY - myY(ID1)/(max(myY(ID1))-min(myY(ID1)));
%         [~,ID2] = filloutliers(Dif,'linear');
%         
         len = length(ID1);
         if len <=2
             FitY = myY(ID1)/(max(myY(ID1))-min(myY(ID1)));
             Dif = FitY - myY(ID1)/(max(myY(ID1))-min(myY(ID1)));
         else
%           %if 'Curve Fitting Toolbox' is installed(which is recommended)
%           %toolboxFlag_fit = 1 : the software will call 'fit.m'
%           %if 'Curve Fitting Toolbox' is not installed
%           %toolboxFlag_fit = 2 : the software will run 'myFitFunctionSimple.m'
            toolboxFlag_fit = 1 ;
           if toolboxFlag_fit == 1 
               [fitresult, gof] = myFitFunction(myX(ID1), myY(ID1),len);
               FitY = fitresult(2*pi*myX(ID1));
               Dif = FitY - myY(ID1)/(max(myY(ID1))-min(myY(ID1)));
           else
               [fitresult, gof] = myFitFunctionSimple(myX(ID1), myY(ID1),len);
               FitY = fitresult(2*pi*myX(ID1));
               Dif = FitY - myY(ID1)/(max(myY(ID1))-min(myY(ID1)));
           end
         end
         
        Std = std(Dif);
        ID2 = find(abs(Dif)>1.95*Std);



%         cftool(2*3.14*myX(ID1),myY(ID1)/(max(myY(ID1))-min(myY(ID1))));
%         ID2 = find(IDX1 == 0);
%         figure
%         plot(myX(ID1(ID2)),myY(ID1(ID2)),'*'); hold on;
%         plot(myX(ID1),myY(ID1),'.');
%         close
        myX(ID1(ID2)) = [];
        myY(ID1(ID2)) = [];
        mytype(ID1(ID2)) = [];
        mypkn(ID1(ID2)) = [];
        myDynCor(ID1(ID2)) = [];
    end
    X = [X;myX];Y = [Y;myY-mean(myY)+20];type = [type;mytype];DynCor = [DynCor;myDynCor];pkn = [pkn;mypkn];

end
end
