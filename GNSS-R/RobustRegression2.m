function [FinX,FinY] = RobustRegression2(winStep,winLen,RawX,RawY,DynCor,PkNoise,Epsilon,RefTime,Filtertype)
%Robust Regression strategy
n = 0;
FinX = []; FinY = [];
while 1
    LocOfTime = winStep/24 * n;
    if Filtertype == 1
        Time = LocOfTime + min(RefTime)
    else
        Time = LocOfTime + max(RefTime)
    end
    
    startTime = Time - winLen/48;
    endTime = Time + winLen/48;
    if Time > max(RefTime) || Time < min(RefTime)
        break;
    end
    ID = find(  RawX >= startTime & RawX < endTime);
    if Filtertype == 1
        n = n + 1;
    else
        n = n - 1;
    end
    if length(ID) == 0
        FinX = [FinX;nan];
        FinY = [FinY;[nan nan]];
        %         FinY = [FinY;nan];
        continue;
    end
    winX = RawX(ID); winY = RawY(ID); winDynCor = DynCor(ID);
    %% 1st iteration
    % initial matrix
    M1 = (winX - Time)*24  + winDynCor;
    P0 = diag(ones(1,length(M1(:,1))));
    Sum = 0;
    for i = 1:length(M1(:,1))
        P0(i,i) = sqrt(PkNoise(i));
        Sum = Sum + P0(i,i);
    end
    P0 = P0/Sum;
    A = [M1,ones(length(M1),1)];
    %     A = [ones(length(M1),1)];
    P = diag(ones(1,length(M1(:,1))));
    H = winY;
%     X1 = inv(A'*P0*P*A)*A'*P0*P*H;
    X1 = inv(A'*P*A)*A'*P*H;
    v1 = A*X1 - H;
    Xi = X1;
    Xip1 = [99,99];
    %     Xip1 = [99];
    %*******************9/29**********************%
    %% ist iteration
    vi = v1;
    Num = 0;
    while abs((Xip1(end,1) - Xi(end,1))) > Epsilon
        dif0 = Xip1(end,1) - Xi(end,1);
        Xi = Xip1;
        for i = 1:length(vi)
            if abs(vi(i)) > 1
                P(i,i) = 1;
            else
                P(i,i) = (1 - abs(vi(i)))^2;
            end
        end
        A = [M1,ones(length(M1),1)];
        %         A = [ones(length(M1),1)];
        Xip1 = [99,99];
        %         Xip1 = [99];
        %*******************9/29**********************%
        H = winY;
        Xip1 = inv(A'*P*A)*A'*P*H;
%         Xip1 = inv(A'*P0*P*A)*A'*P0*P*H;
        vi = A*Xip1 - H;
        dif1 = Xip1(end,1) - Xi(end,1);
        if abs(dif1 - dif0) < 10e-5
            break;
        end
        Num = Num + 1;
        if Num > 20
            break;
        end
    end
    if abs(Xip1(1,1)) > 2 || (Xip1(end,1) - max(RawY) > 0.15)...
            || (Xip1(end,1) - min(RawY) < -0.15)
        FinX = [FinX;nan];
        FinY = [FinY;[nan nan]];
        %         FinY = [FinY;nan];
        continue;
    end
    Xip1 = [Xip1(2,:),Xip1(1,:)];
    FinX = [FinX;Time];
    FinY = [FinY;Xip1];
end
end

