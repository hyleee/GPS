%% Resize Vtec=============================================================================
% 원하는 지점(위도,경도)의 Final / Predict1 / Predict2 값에 대한 행렬을 반환하는 코드
% 출력 형태 : ( 하루 중 VTEC 제공 횟수 ) X ( GS, 위도, 경도, Vtec ) 으로 이루어진 행렬 형태
%% ========================================================================================
%% 원하는 지점의 위도 및 경도 설정

lon=35; % 해당 지점 위도
lat=135; % 해당 지점 경도

lon_index=(87.5-lon)/2.5+2; % Vtec 행렬에서의 위도 index 값
lat_index=((lat-(-180))/5)+2; % Vtec 행렬에서의 경도 index 값

GS_numP=25; % Predict 값에서 하루 중 GS 제공 횟수
GS_numF=13; % Final 값에서 하루 중 GS 제공 횟수
day=7; % 한달 당 관찰 일 수

%% ================================2월====================================================
%% 2월 Final 값에 대한 행렬

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\2월\final'
ionex = dir(['*.21i']);
final_files2 = vertcat(ionex.name);
Final2=zeros(GS_numF*day,4); % 91 X 4
time = -GS_numF;

for k=1:day
    FID_F2 = final_files2(k,:);
    [VtecF2,GS_F2] = Read_GIM(FID_F2);
    time=time+GS_numF; % 하루마다 13행씩 증가

    for i=1:GS_numF
        Final2(i+time,1)=GS_F2(i);
        Final2(i+time,2)=VtecF2(1,lat_index);
        Final2(i+time,3)=VtecF2(lon_index,1);
        Final2(i+time,4)=VtecF2(lon_index,lat_index,i);
    end
end

%% 2월 Predicted 값에 대한 행렬 (c1pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\2월\predict'
ionex = dir(['*.21i']);
predict_files2 = vertcat(ionex.name);
Predict1_2=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P2 = predict_files2(k,:);
    [VtecP1_2,GS_P1_2] = Read_GIM(FID_P2);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP
        Predict1_2(i+time,1)=GS_P1_2(i);
        Predict1_2(i+time,2)=VtecP1_2(1,lat_index);
        Predict1_2(i+time,3)=VtecP1_2(lon_index,1);
        Predict1_2(i+time,4)=VtecP1_2(lon_index,lat_index,i);
    end
end

%% 2월 Predicted2 값에 대한 행렬 (c2pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\2월\predict2'
ionex = dir(['*.21i']);
predict_files2 = vertcat(ionex.name);
Predict2_2=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P2 = predict_files2(k,:);
    [VtecP2_2,GS_P2_2] = Read_GIM(FID_P2);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP
        Predict2_2(i+time,1)=GS_P2_2(i);
        Predict2_2(i+time,2)=VtecP2_2(1,lat_index);
        Predict2_2(i+time,3)=VtecP2_2(lon_index,1);
        Predict2_2(i+time,4)=VtecP2_2(lon_index,lat_index,i);
    end
end
%% 2월 Predict 행렬에서 Final 행렬과 GS가 통일되는 행만 추출 : ResizePredict

index=0;
ResizePredict1_2=zeros(91,4);
ResizePredict2_2=zeros(91,4);

for k=1:7
    for i=1:13
        if Final2(i+index,1)==Predict1_2(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict1_2(i+index,:)=Predict1_2(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
        if Final2(i+index,1)==Predict2_2(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict2_2(i+index,:)=Predict2_2(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
    end
    index=index+13;
end

%% ================================5월====================================================
%% 5월 Final 값에 대한 행렬

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\5월\final'
ionex = dir(['*.21i']);
final_files5 = vertcat(ionex.name);
Final5=zeros(GS_numF*day,4); % 91 X 4
time = -GS_numF;

for k=1:day
    FID_F5 = final_files5(k,:);
    [VtecF5,GS_F5] = Read_GIM(FID_F5);
    time=time+GS_numF; % 하루마다 13행씩 증가

    for i=1:GS_numF % 1:13
        Final5(i+time,1)=GS_F5(i);
        Final5(i+time,2)=VtecF5(1,lat_index);
        Final5(i+time,3)=VtecF5(lon_index,1);
        Final5(i+time,4)=VtecF5(lon_index,lat_index,i);
    end
end

%% 5월 Predicted 값에 대한 행렬 (c1pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\5월\predict'
ionex = dir(['*.21i']);
predict_files5 = vertcat(ionex.name);
Predict1_5=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P5 = predict_files5(k,:);
    [VtecP1_5,GS_P1_5] = Read_GIM(FID_P5);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP % 1:25
        Predict1_5(i+time,1)=GS_P1_5(i);
        Predict1_5(i+time,2)=VtecP1_5(1,lat_index);
        Predict1_5(i+time,3)=VtecP1_5(lon_index,1);
        Predict1_5(i+time,4)=VtecP1_5(lon_index,lat_index,i);
    end
end

%% 5월 Predicted2 값에 대한 행렬 (c2pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\5월\predict2'
ionex = dir(['*.21i']);
predict_files5 = vertcat(ionex.name);
Predict2_5=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P5 = predict_files5(k,:);
    [VtecP2_5,GS_P2_5] = Read_GIM(FID_P5);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP % 1:25
        Predict2_5(i+time,1)=GS_P2_5(i);
        Predict2_5(i+time,2)=VtecP2_5(1,lat_index);
        Predict2_5(i+time,3)=VtecP2_5(lon_index,1);
        Predict2_5(i+time,4)=VtecP2_5(lon_index,lat_index,i);
    end
end

%% 5월 Predict 행렬에서 5월 Final 행렬과 GS가 통일되는 행만 추출 : ResizePredict

index=0;
ResizePredict1_5=zeros(91,4);
ResizePredict2_5=zeros(91,4);

for k=1:7
    for i=1:13
        if Final5(i+index,1)==Predict1_5(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict1_5(i+index,:)=Predict1_5(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
        if Final5(i+index,1)==Predict2_5(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict2_5(i+index,:)=Predict2_5(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
    end
    index=index+13;
end

%% ================================8월====================================================
%% 8월 Final 값에 대한 행렬

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\8월\final'
ionex = dir(['*.21i']);
final_files8 = vertcat(ionex.name);
Final8=zeros(GS_numF*day,4); % 91 X 4
time = -GS_numF;

for k=1:day % 1:7
    FID_F8 = final_files8(k,:);
    [VtecF8,GS_F8] = Read_GIM(FID_F8);
    time=time+GS_numF; % 하루마다 13행씩 증가

    for i=1:GS_numF % 1:13
        Final8(i+time,1)=GS_F8(i);
        Final8(i+time,2)=VtecF8(1,lat_index);
        Final8(i+time,3)=VtecF8(lon_index,1);
        Final8(i+time,4)=VtecF8(lon_index,lat_index,i);
    end
end


%% 8월 Predicted1 값에 대한 행렬 (c1pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\8월\predict'
ionex = dir(['*.21i']);
predict_files8 = vertcat(ionex.name);
Predict1_8=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P8 = predict_files8(k,:);
    [VtecP1_8,GS_P1_8] = Read_GIM(FID_P8);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP
        Predict1_8(i+time,1)=GS_P1_8(i);
        Predict1_8(i+time,2)=VtecP1_8(1,lat_index);
        Predict1_8(i+time,3)=VtecP1_8(lon_index,1);
        Predict1_8(i+time,4)=VtecP1_8(lon_index,lat_index,i);
    end
end

%% 8월 Predicted2 값에 대한 행렬 (c2pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\8월\predict2'
ionex = dir(['*.21i']);
predict_files8 = vertcat(ionex.name);
Predict2_8=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P8 = predict_files8(k,:);
    [VtecP2_8,GS_P2_8] = Read_GIM(FID_P8);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP % 1:25
        Predict2_8(i+time,1)=GS_P2_8(i);
        Predict2_8(i+time,2)=VtecP2_8(1,lat_index);
        Predict2_8(i+time,3)=VtecP2_8(lon_index,1);
        Predict2_8(i+time,4)=VtecP2_8(lon_index,lat_index,i);
    end
end

%% 8월 Predict 행렬에서 Final 행렬과 GS가 통일되는 행만 추출 : ResizePredict

index=0;
ResizePredict1_8=zeros(91,4);
ResizePredict2_8=zeros(91,4);

for k=1:7
    for i=1:13
        if Final8(i+index,1)==Predict1_8(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict1_8(i+index,:)=Predict1_8(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
        if Final8(i+index,1)==Predict2_8(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict2_8(i+index,:)=Predict2_8(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
    end
    index=index+13;
end

%% ================================11월====================================================
%% 11월 Final 값에 대한 행렬

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\11월\final'
ionex = dir(['*.21i']);
final_files11 = vertcat(ionex.name);
Final11=zeros(GS_numF*day,4); % 91 X 4
time = -GS_numF;

for k=1:day
    FID_F11 = final_files11(k,:);
    [VtecF11,GS_F11] = Read_GIM(FID_F11);
    time=time+GS_numF; % 하루마다 13행씩 증가

    for i=1:GS_numF
        Final11(i+time,1)=GS_F11(i);
        Final11(i+time,2)=VtecF11(1,lat_index);
        Final11(i+time,3)=VtecF11(lon_index,1);
        Final11(i+time,4)=VtecF11(lon_index,lat_index,i);
    end
end



%% 11월 Predicted 값에 대한 행렬 (c1pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\11월\predict'
ionex = dir(['*.21i']);
predict_files11 = vertcat(ionex.name);
Predict1_11=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P11 = predict_files11(k,:);
    [VtecP1_11,GS_P1_11] = Read_GIM(FID_P11);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP
        Predict1_11(i+time,1)=GS_P1_11(i);
        Predict1_11(i+time,2)=VtecP1_11(1,lat_index);
        Predict1_11(i+time,3)=VtecP1_11(lon_index,1);
        Predict1_11(i+time,4)=VtecP1_11(lon_index,lat_index,i);
    end
end

%% 11월 Predicted2 값에 대한 행렬 (c2pg)

cd 'C:\Users\GPSLAB\Desktop\To_혜윤\GIM\VtecData2021\11월\predict2'
ionex = dir(['*.21i']);
predict_files11 = vertcat(ionex.name);
Predict2_11=zeros(GS_numP*day,4); % 175 X 4
time = -GS_numP; %-25에서 시작

for k=1:day
    FID_P11 = predict_files11(k,:);
    [VtecP2_11,GS_P2_11] = Read_GIM(FID_P11);
    time=time+GS_numP; % 하루마다 25행씩 증가

    for i=1:GS_numP % 1:25
        Predict2_11(i+time,1)=GS_P2_11(i);
        Predict2_11(i+time,2)=VtecP2_11(1,lat_index);
        Predict2_11(i+time,3)=VtecP2_11(lon_index,1);
        Predict2_11(i+time,4)=VtecP2_11(lon_index,lat_index,i);
    end
end

%% 11월 Predict 행렬에서 Final 행렬과 GS가 통일되는 행만 추출 : ResizePredict

index=0;
ResizePredict1_11=zeros(91,4);
ResizePredict2_11=zeros(91,4);

for k=1:7
    for i=1:13
        if Final11(i+index,1)==Predict1_11(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict1_11(i+index,:)=Predict1_11(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
        if Final11(i+index,1)==Predict2_11(2*(i+index)-k,1) % 만약 GS가 같으면
           ResizePredict2_11(i+index,:)=Predict2_11(2*(i+index)-k,:); % 해당 행 전체를 추출하여 ResizePredict 행렬로 삽입
        end
    end
    index=index+13;
end

%% VTEC graph=================================================================================
%% VTEC 값에 대한 그래프 :2월
figure(1)

startDate=datenum('02-01-2021');
endDate=datenum('02-08-2021');
xData=linspace(startDate,endDate,91);


subplot(4,1,1);
x=xData;
y1=ResizePredict1_2(:,4); % Predict1(c1pg)
y2=ResizePredict2_2(:,4); % Predict2(c2pg)
y3=Final2(:,4);    % Final


plot(x,y1,'r',x,y2,'b',x,y3,'k')
legend('Predict1_2','Predict2_2','Final2','Location','Best')
title('2월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
ylim([0 30])
grid on;

%% VTEC 값에 대한 그래프 :5월
startDate=datenum('05-01-2021');
endDate=datenum('05-08-2021');
xData=linspace(startDate,endDate,91);

subplot(4,1,2);
x=xData;      
y1=ResizePredict1_5(:,4); % Predict1(c1pg)
y2=ResizePredict2_5(:,4); % Predict2(c2pg)
y3=Final5(:,4);     % Final

plot(x,y1,'r',x,y2,'b',x,y3,'k')
legend('Predict1_5','Predict2_5','Final5','Location','northeast')
title('5월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([0 30])

%% VTEC 값에 대한 그래프 :8월
startDate=datenum('08-01-2021');
endDate=datenum('08-08-2021');
xData=linspace(startDate,endDate,91);

subplot(4,1,3);
x=xData;      
y1=ResizePredict1_8(:,4); % Predict1(c1pg)
y2=ResizePredict2_8(:,4); % Predict2(c2pg)
y3=Final8(:,4);     % Final

plot(x,y1,'r',x,y2,'b',x,y3,'k')
legend('Predict1_8','Predict2_8','Final8','Location','Best')
title('8월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([0 30])

%% VTEC 값에 대한 그래프 :11월
startDate=datenum('11-01-2021');
endDate=datenum('11-08-2021');
xData=linspace(startDate,endDate,91);

subplot(4,1,4);
x=xData;
y1=ResizePredict1_11(:,4); % Predict1(c1pg)
y2=ResizePredict2_11(:,4); % Predict2(c2pg)
y3=Final11(:,4);      % Final

plot(x,y1,'r',x,y2,'b',x,y3,'k')
legend('Predict1__11','Predict2__11','Final11','Location','Best')
title('11월','FontSize',12,'FontWeight','bold')
axis tight;
xlabel('month/day')
ylabel('VTEC','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([0 30])

%% VTEC Variance Graph ============================================================
zero=zeros(91,1);
figure(2)

%% 2월 variance
startDate=datenum('02-01-2021');
endDate=datenum('02-08-2021');
xData=linspace(startDate,endDate,91);

C1pgVar2 = ResizePredict1_2(:,4)-Final2(:,4);
C2pgVar2 = ResizePredict2_2(:,4)-Final2(:,4);

subplot(4,1,1);
x=xData;

plot(x,C1pgVar2,'mx',x,C2pgVar2,'bo',x,zero,'r')
legend('c1pg_2','c2pg_2','Location','Best')
title('2월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC Variance','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([-10 10])

%% 5월 variance
startDate=datenum('05-01-2021');
endDate=datenum('05-08-2021');
xData=linspace(startDate,endDate,91);

C1pgVar5 = ResizePredict1_5(:,4)-Final5(:,4);
C2pgVar5 = ResizePredict2_5(:,4)-Final5(:,4);

subplot(4,1,2);
x=xData;
y1=ResizePredict1_5(:,4)-Final5(:,4);
y2=ResizePredict2_5(:,4)-Final5(:,4);

plot(x,C1pgVar5,'mx',x,C2pgVar5,'bo',x,zero,'r')
legend('c1pg_5','c2pg_5','Location','Best')
title('5월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC Variance','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([-10 10])

%% 8월 variance
startDate=datenum('08-01-2021');
endDate=datenum('08-08-2021');
xData=linspace(startDate,endDate,91);

C1pgVar8 = ResizePredict1_8(:,4)-Final8(:,4);
C2pgVar8 = ResizePredict2_8(:,4)-Final8(:,4);

subplot(4,1,3);
x=xData;

plot(x,C1pgVar8,'mx',x,C2pgVar8,'bo',x,zero,'r')
legend('c1pg_8','c2pg_8','Location','Best')
title('8월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC Variance','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([-10 10])

%% 11월 variance
startDate=datenum('11-01-2021');
endDate=datenum('11-08-2021');
xData=linspace(startDate,endDate,91);

C1pgVar11 = ResizePredict1_11(:,4)-Final11(:,4);
C2pgVar11 = ResizePredict2_11(:,4)-Final11(:,4);

subplot(4,1,4);
x=xData;

plot(x,C1pgVar11,'mx',x,C2pgVar11,'bo',x,zero,'r')
legend('c1pg_11','c2pg_11','Location','Best')
title('11월','FontSize',12,'FontWeight','bold')
axis tight;
ylabel('VTEC Variance','FontSize',10,'FontWeight','bold','Color','k')
datetick('x','mm/dd','keeplimits')
grid on;
ylim([-10 10])

%% Mean =================================================================================================
fprintf("Mean=================================\n")
%% 2월 평균
Mean_C1pg2=sum(ResizePredict1_2(:,4))/91;
Mean_C2pg2=sum(ResizePredict2_2(:,4))/91;
Mean_Final2=sum(Final2(:,4))/91;

fprintf("Feb Final Mean=%9.3f \n", Mean_Final2)
fprintf("Feb c1pg Mean=%10.3f \n", Mean_C1pg2)
fprintf("Feb c2pg Mean=%10.3f \n", Mean_C2pg2)
fprintf("===================================\n")

%% 5월 평균
Mean_C1pg5=sum(ResizePredict1_5(:,4))/91;
Mean_C2pg5=sum(ResizePredict2_5(:,4))/91;
Mean_Final5=sum(Final5(:,4))/91;

fprintf("May Final Mean=%9.3f \n", Mean_Final5)
fprintf("May c1pg Mean=%10.3f \n", Mean_C1pg5)
fprintf("May c2pg Mean=%10.3f \n", Mean_C2pg5)
fprintf("===================================\n")

%% 8월 평균
Mean_C1pg8=sum(ResizePredict1_8(:,4))/91;
Mean_C2pg8=sum(ResizePredict2_8(:,4))/91;
Mean_Final8=sum(Final8(:,4))/91;

fprintf("Aug Final Mean=%9.3f \n", Mean_Final8)
fprintf("Aug c1pg Mean=%10.3f \n", Mean_C1pg8)
fprintf("Aug c2pg Mean=%10.3f \n", Mean_C2pg8)
fprintf("===================================\n")

%% 11월 평균
Mean_C1pg11=sum(ResizePredict1_11(:,4))/91;
Mean_C2pg11=sum(ResizePredict2_11(:,4))/91;
Mean_Final11=sum(Final11(:,4))/91;

fprintf("Nov Final Mean=%9.3f \n", Mean_Final11)
fprintf("Nov c1pg Mean=%10.3f \n", Mean_C1pg11)
fprintf("Nov c2pg Mean=%10.3f \n", Mean_C2pg11)
fprintf("===================================\n")

%% RMS ==================================================================================================
fprintf("RMS==================================\n")
%% 2월 RMS
RMS_C1pg2=sqrt(sum(C1pgVar2.^2)/91);
RMS_C2pg2=sqrt(sum(C2pgVar2.^2)/91);
fprintf("Feb c1pg RMS=%10.3f \n", RMS_C1pg2)
fprintf("Feb c2pg RMS=%10.3f \n", RMS_C2pg2)
fprintf("===================================\n")
%% 5월 RMS
RMS_C1pg5=sqrt(sum(C1pgVar5.^2)/91);
RMS_C2pg5=sqrt(sum(C2pgVar5.^2)/91);
fprintf("May c1pg RMS=%10.3f \n", RMS_C1pg5)
fprintf("May c2pg RMS=%10.3f \n", RMS_C2pg5)
fprintf("===================================\n")
%% 8월 RMS
RMS_C1pg8=sqrt(sum(C1pgVar8.^2)/91);
RMS_C2pg8=sqrt(sum(C2pgVar8.^2)/91);
fprintf("Aug c1pg RMS=%10.3f \n", RMS_C1pg8)
fprintf("Aug c2pg RMS=%10.3f \n", RMS_C2pg8)
fprintf("===================================\n")
%% 11월 RMS
RMS_C1pg11=sqrt(sum(C1pgVar11.^2)/91);
RMS_C2pg11=sqrt(sum(C2pgVar11.^2)/91);
fprintf("Nov c1pg RMS=%10.3f \n", RMS_C1pg11)
fprintf("Nov c2pg RMS=%10.3f \n", RMS_C2pg11)
fprintf("===================================\n")
%% Max ========================================================================
MaxFinal2=max(Final2(:,4));
MaxFinal5=max(Final5(:,4));
MaxFinal8=max(Final8(:,4));
MaxFinal11=max(Final11(:,4));

fprintf("Max===================================\n")
fprintf("Feb Max : %4.3f \n",MaxFinal2)
fprintf("May Max : %4.3f \n",MaxFinal5)
fprintf("Aug Max : %4.3f \n",MaxFinal8)
fprintf("Nov Max : %4.3f \n",MaxFinal11)
fprintf("===================================\n")
