clear all; close all; clc;
%% 변수값 설정
CCC=299792458;
f=1575.42*10^6; % 1575.42 MHz
wavelength=CCC./f; % CCC / 1575.42 MHz

%% AUSPOS 출처 SUWN 참값
TruePos=[-3062023.345 4055447.783 3841818.107];
TruePosgd=xyz2gd(TruePos);
TrueLat=TruePosgd(1); TrueLon=TruePosgd(2); TrueH=TruePosgd(3);

%% 데이터 파일
FileQM='QSUWN_21308';
SITE=FileQM(2:5); % SITE=SUWN

FileNav='brdc3080.21n';
eph=ReadEPH(FileNav);
% klobuchar Alpha, Beta.
[alpha,beta] = Readalbe(FileNav);

%% 날짜 판별
YY=FileQM(7:8); DOY=FileQM(9:11);
[gw,gwd]=ydoy2gwgd(str2num(YY),str2num(DOY)); 

% File_GIM='igsg0520.17i';
% [Lat Lon TEC]=ReadGIM(File_GIM); % GIM

%% QM 파일 읽고 원하는 ObsType을 만족하는 QM 행렬만 추출
ObsTypePR=120; % 원하는 ObsType
ObsTypeCP=111;
ObsTypeSNR=141;

QM=load(FileQM);
QM_sel=QM(QM(:,3)==ObsTypePR,:); % 원하는 ObsType을 만족하는 QM 행렬 select
QM_selCP=QM(QM(:,3)==ObsTypeCP,:);
QM_selSNR=QM(QM(:,3)==ObsTypeSNR,:);

GS = unique(QM_sel(:,1)); % QM_sel에서 GS만 추출

%% 추정과정 for문과 관련된 조건 설정
cdtr=1;
gs_index=0;

MaxIter=5;
stopCondition=1e-5;

x=[TruePos'; cdtr];
dXYZ=zeros(length(GS),3);
dNEV=zeros(length(GS),3);
dLLH=zeros(length(GS),3);
dTrop=zeros(length(GS),1);
dI=zeros(length(GS),1);
% SatNumlist=zeros(length(GS),1);


%% 추정과정 시작

for k=1:length(GS) % GS 기준으로 루프 설정
    gs_index=gs_index+1;
    gs=GS(gs_index); % gs는 GS 행렬의 특정 gps seconds

    %% Carrier Phase 

    QM_selGS_CP=QM_selCP(QM_selCP(:,1)==gs,:); % 원하는 GS를 가진 행 전체를 QM_selCP에서 추출
    SatNumCP=length(QM_selGS_CP(:,2)); % 원하는 GS에 해당하는 행의 수 (=PRN의 수)로 위성 개수 파악
    for j=1:SatNumCP
        prnCP=QM_selGS_CP(j,2);
        CP{prnCP}(k,:)=[gs prnCP QM_selGS_CP(QM_selGS_CP(:,2)==prnCP,4)];
        
    end


    
    %% SNR
    QM_selGS_SNR=QM_selSNR(QM_selSNR(:,1)==gs,:); % 원하는 GS를 가진 행 전체를 QM_selSNR에서 추출
    SatNumSNR=length(QM_selGS_SNR(:,2)); % 원하는 GS에 해당하는 행의 수 (=PRN의 수)로 위성 개수 파악
    for j=1:SatNumSNR
        prnSNR=QM_selGS_SNR(j,2);
        SNR{prnSNR}(k,:)=[gs prnSNR QM_selGS_SNR(QM_selGS_SNR(:,2)==prnSNR,4)];
    end

    %% Pseudo Range 
    QM_selGS=QM_sel(QM_sel(:,1)==gs,:); % 원하는 GS를 가진 행 전체를 QM_sel에서 추출
    SatNum=length(QM_selGS(:,2)); % 원하는 GS에 해당하는 행의 수 (=PRN의 수)로 위성 개수 파악

    clear H y W
    for Iter=1:MaxIter % 비선형최소제곱 반복루프
        SiteVec=x(1:3);
        CalLLH=xyz2gd(SiteVec);
        CalLat=CalLLH(1); CalLon=CalLLH(2); CalH=CalLLH(3);  

        for j=1:SatNum % 위성 개수 기준으로 루프 설정

            prn=QM_selGS(j,2);
            obs=QM_selGS(j,4);
            SatNumlist(k,1)=j;

            [col_index,dtMin] = PickEPH(eph, prn, gs); % PRN이 일치하고 원하는 GS와 가장 가까운 EPH select
            a=eph(col_index,3); b=eph(col_index,4); c=eph(col_index,5); toe=eph(col_index,1); Tgd=eph(col_index,6); % 위성시계오차 계산에 활용될 변수
            

            %% 신호전달시간 고려
            STT=obs/CCC;
            tc=gs-STT;

            %% 위성궤도 계산
            SatVec=GetSatPos(eph,col_index,tc);
            SatVec=RotSatPos(SatVec,STT);
            RhoVec=SatVec-SiteVec';
            Rho=norm(RhoVec);

            %% 방위각, 고도각 ( 미완성 )
            [Az,El]=xyz2azel(RhoVec,CalLat,CalLon);

            if El<15 % 임계고도각
                continue;
            end

            if El<30 % 고도각 가중치
                W(j,j)=sind(El);
            else
                W(j,j)=1;
            end

            %% 위성 시계 오차 계산
            dRel=GetRelBRDC(eph,col_index,tc); % 상대성 효과
            dtSat=a+b*(tc-toe)+c*(tc-toe)^2+dRel-Tgd; % 상대성 효과, GD 모두 고려 O
%             dtSat=a+b*(tc-toe)+c*(tc-toe)^2-Tgd; % 상대성 효과 고려 X
%             dtSat=a+b*(tc-toe)+c*(tc-toe)^2+dRel; % GroupDelay 고려 X

            %% 대류권 오차 계산 (미완성)
            ZHD=TropGPTh(SiteVec,gw,gs);
            dTropAtGs=ZHD2SHD(gw,gs,SiteVec,El,ZHD);
            dTrop(k,1)=dTropAtGs;
            
            %% 전리층 오차 계산
            dIAtGs = getdI(alpha,beta,CalLat,CalLon, El, Az,tc);
            dI(k,1)=dIAtGs;
         

            %% Pseudo Range (obs)
            PR{prn}(k,:)=[gs prn obs];
            

            %% Elevation
            elevation{prn}(k,:)=[gs prn El];

            %% dTrop & dI (slant)
            dTropPRN{prn}(k,:)=[gs prn dTropAtGs];
            dIPRN{prn}(k,:)=[gs prn dIAtGs];
            
            %% 최소자승법 계산
%           com=Rho+x(4)-CCC*dtSat;
%           com=Rho+x(4)-CCC*dtSat+dTrop(k);
%           com=Rho+x(4)-CCC*dtSat+dI(k);
            com=Rho+x(4)-CCC*dtSat+dI(k)+dTrop(k);
           

            y(j,:)=obs-com; % j = 1: SatNum
            H(j,:)=[-RhoVec(1)/Rho -RhoVec(2)/Rho -RhoVec(3)/Rho 1];

            
        end % for j=1:SatNum

        xhat=inv(H'*W*H)*(H'*W*y);
        x=x+xhat;

        if norm(xhat)<stopCondition
            estm(1)=gs;
            estm(2:5)=x(1:4)';
%             fprintf(" GS:%10.5f\n Xr:%10.5f\n Yr:%10.5f\n Zr:%10.5f\n cdtr:%10.5f\n ================\n",estm)
            %% 오차 계산
            dXYZ(k,:) = estm(2:4) - TruePos; % XYZ에 대한 오차 계산
            dNEV(k,:) = xyz2topo(dXYZ(k,:), TrueLat, TrueLon); % NEV에 대한 오차 계산
            dLLH(k,:) = xyz2gd(dXYZ(k,:));
            break;
        end

      

    end % for Iter=1:MaxIter
end % k=1:length(GS)

%% 그래프
% %% Horizontal / Vertical / 3D Error
% figure(1)
% subplot(3, 1, 1)
% HE = sqrt(dNEV(:,1).^2+dNEV(:,2).^2);  % y = dH (수평오차)
% plot(GS, HE, 'r*')
% xlabel('t')
% ylabel('dH')
% ylim([0 12])
% grid on
% 
% subplot(3, 1, 2)
% VE = dNEV(:, 3);  % y = dV
% plot(GS, VE, 'r*')
% xlabel('t')
% ylabel('dV')
% ylim([-5 41])
% grid on
% 
% subplot(3, 1, 3)
% D3E = sqrt(dNEV(:,1).^2+dNEV(:,2).^2+dNEV(:,3).^2);  % y = 3D error
% plot(GS, D3E, 'b*')
% xlabel('t')
% ylabel('3D')
% ylim([0 50])
% grid on
% 
% %% dE, dN
% figure(2)
% dE = dNEV(:,2);  % x = dE
% dN = dNEV(:,1);  % y = dN
% plot(dE, dN, 'b*')
% xline(0,'r-')
% yline(0,'r-')
% xlim([-6 8])
% ylim([-6 12])
% xlabel('dE')
% ylabel('dN')
% grid on
% 
% 
% %% dI, dTrop
% figure(3)
% subplot(2,1,1)
% plot(GS,dI,'k*')
% xlabel('t')
% ylabel('dI')
% 
% subplot(2,1,2)
% plot(GS,dTrop,'k*')
% xlabel('t')
% ylabel('dTrop')
% 
% 
% %% 통계값
% 
% RMS_HE= sqrt(sum(HE.^2)/size(HE,1));
% RMS_VE= sqrt(sum(VE.^2)/size(VE,1));
% RMS_3DE = sqrt(sum(D3E.^2)/size(D3E,1));
% fprintf("============RMS==============\n")
% fprintf("RMS_HE: %3.5f\n",RMS_HE)
% fprintf("RMS_VE: %3.5f\n",RMS_VE)
% fprintf("RMS_3DE: %3.5f\n",RMS_3DE)

%% diff(CP-PR)

for sat=1:32
    if isempty(PR{sat})==0
         PR{sat}(PR{sat}(:,2)==0,:)=[]; % prn==0 인 행 전체 삭제
    end

    if isempty(CP{sat})==0
        CP{sat}(CP{sat}(:,2)==0,:)=[]; % prn==0 인 행 전체 삭제
    end

    if isempty(elevation{sat})==0
        elevation{sat}(elevation{sat}(:,2)==0,:)=[];
    end

    if isempty(dIPRN{sat})==0
        dIPRN{sat}(dIPRN{sat}(:,2)==0,:)=[];
    end

    if isempty(dTropPRN{sat})==0
        dTropPRN{sat}(dTropPRN{sat}(:,2)==0,:)=[];
    end

    if isempty(CP{sat})==0 && isempty(PR{sat})==0
        interGS{sat}=intersect(CP{sat}(:,1),PR{sat}(:,1));
        for k=1:length(interGS{sat})
           interPR{sat}(k,:)=PR{sat}(PR{sat}(:,1)==interGS{sat}(k),:);
           interCP{sat}(k,:)=CP{sat}(CP{sat}(:,1)==interGS{sat}(k),:);
           CP_PR{sat}(k,:)=[interGS{sat}(k) sat wavelength*interCP{sat}(k,3)-interPR{sat}(k,3)];
        end % for k=1:length(interGS{sat})
    end % if isempty(CP{sat})==0 && isempty(PR{sat})==0

%% 위성 별 그래프
    if isempty(CP{sat})==0 && isempty(PR{sat})==0 && isempty(dTropPRN{sat})==0 && isempty(dIPRN{sat})==0 && isempty(elevation{sat})==0
        figure(sat) 
        
        subplot(3,2,1)
        plot( PR{sat}(:,1), PR{sat}(:,3), 'r*')
        xlabel('t')
        ylabel('PR')
        grid on
 
        subplot(3,2,3)
        plot( CP{sat}(:,1), CP{sat}(:,3), 'r*')
        xlabel('t')
        ylabel('CP')
        grid on
 
        subplot(3,2,5)
        intergs=CP_PR{sat}(:,1);
        plot( intergs(1:end-1), diff(CP_PR{sat}(:,3)), 'r*')
        xlabel('t')
        ylabel('diff(CP-PR)')
        grid on

        subplot(3,2,2)
        plot( dTropPRN{sat}(:,1), dTropPRN{sat}(:,3), 'r*')
        xlabel('t')
        ylabel('dTrop')
        grid on

        subplot(3,2,4)
        plot( dIPRN{sat}(:,1), dIPRN{sat}(:,3), 'r*')
        xlabel('t')
        ylabel('dI')
        grid on

        subplot(3,2,6)
        plot( elevation{sat}(:,1), elevation{sat}(:,3), 'r*')
        xlabel('t')
        ylabel('elevation')
        grid on
        
    end % if isempty(CP{sat})==0 && isempty(PR{sat})==0 && isempty(dTropPRN{sat})==0 && isempty(dIPRN{sat})==0 && isempty(elevation{sat})==0



   
   
end % for sat=1:32



