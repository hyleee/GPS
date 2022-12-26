%% Read GIM -------------------------------------------------------------
% Copyright @ Bonggyu Park, Satellite Navigation LAB, Inha Univ.
% geek1206@gmail.com
% -------------------------------------------------------------------------

%% Read GIM -------------------------------------------------------------
% GIM Product를 구분하고, 읽어들이는 코드
% 출력 VTEC 형태 : Epoch별 위도 & 경도 격자 VTEC 3차원 배열
% -------------------------------------------------------------------------

function [VTEC,GS] = Read_GIM(FID)
%% Define Data File -------------------------------------------------------
% ---------------------------------------------------
% num_interval  : 하루 중 VTEC 제공 횟수
% time_interval : 하루 중 VTEC 제공 시간 간격(sec)
% ---------------------------------------------------

% ---------------------------------------------------
input = fopen(FID,'r');
GIM_Finals = ["igsg","codg","jplg","esag","casg","whug","upcg"];
GIM_Predictions = ["c1pg","c2pg"];

idx_final = find(GIM_Finals == FID(1:4));
idx_prediction = find(GIM_Predictions == FID(1:4));

if isempty(idx_final) == 0                   % GIM Final인 경우
    num_interval = 13; time_interval = 7200;
elseif isempty(idx_prediction) == 0          % GIM Prediction인 경우
    num_interval = 25; time_interval = 3600;
end
% ---------------------------------------------------
% -------------------------------------------------------------------------

%% Set Variables ------------------------------------------------
% ---------------------------------------------------
% num_lat : 위도 개수
% num_lon : 경도 개수
% lat_interval : 위도 간격
% lon_interval : 경도 간격
% lati :  위도 저장 행렬
% longi : 경도 저장 행렬
% num_line_per_epoch : 원본 파일의 epoch당 데이터 라인 수
% data_length_per_line1to4 : 원본 파일의 데이터 라인 1 ~ 4 의 데이터 수
% data_length_per_line5 : 원본 파일의 데이터 라인 5의 데이터 수
% Sub_VTEC : 한 Epoch의 VTEC을 저장하는 행렬
% ---------------------------------------------------

% ---------------------------------------------------
num_lat = 70; lat_interval = 2.5; lati = zeros(num_lat+1,1); lati(1) = 87.5;
num_lon = 72; lon_interval = 5; longi = zeros(1,74); longi(2) = -180;

num_line_per_epoch = 5; data_length_per_line1to4 = 16; data_length_per_line5 = 9;

Sub_VTEC = zeros(num_lat+1,num_lon+1);
% --------------------------------------------------
% -------------------------------------------------------------------------

%% Skip Header ------------------------------------------------------------
% --------------------------------------------------
ready = 0; 
while ~ready
    line = fgets(input); 
    if length(line) > 73
        if line(68:71) == 'HEAD'
        ready = 1;                
        end
    end
end
% -------------------------------------------------------------------------

%% Setting Epoch ----------------------------------------------------------
% --------------------------------------------------
% EPH : 원본 파일에 나타난 Epoch을 저장하는 행렬
% GS : GpsWeekSecond

EPH = zeros(num_interval,6);
LLLDH = zeros(1750,5);
GS = zeros(num_interval,1);
for k = 1 : 2
    line = fgets(input);
end

if length(line) > 80
    if line(61:76) == 'EPOCH OF CURRENT' 
        EPH(1,1:6) = sscanf(line,'%f',6);
        YYYY = EPH(1,1);
        MM = EPH(1,2);
        DD = EPH(1,3);
        HH = EPH(1,4);
        MIN = EPH(1,5);
        SS = EPH(1,6);
        [gw,gs] = date2gwgs(YYYY,MM,DD,HH,MIN,SS);

        
        line = fgets(input);
        LLLDH(1,1:5) = sscanf(line,'%f',5);
        LAT1 = LLLDH(1,1);
        LON1 = LLLDH(1,2);
        LON2 = LLLDH(1,3);
        DLON = LLLDH(1,4);
        H = LLLDH(1,5);
    end
end
line = fgets(input);
% ------------------------------------------------
% -------------------------------------------------------------------------

%% Set Epoch & Latitude, Longitude ----------------------------------------
% ------------------------------------------------
GS(1) = gs(1); 
for i = 1 : (num_interval-1)
    GS(i+1) = GS(i) + time_interval;
end

for i = 1 : num_lat
    lati(i+1) = lati(i) - lat_interval;
end

for i = 2 : (num_lon+1)
    longi(i+1) = longi(i) + lon_interval;
end
% ------------------------------------------------
% -------------------------------------------------------------------------

%% Read VTEC --------------------------------------------------------------
% ------------------------------------------------
% line_format : 원본 파일의 한 Epoch당 데이터 묶음(5 by 16)
% C : 위도 & Sub_VTEC 연결한 행렬
% D : C & 경도 연결한 행렬
% VTEC : 출력 VTEC
% ------------------------------------------------
% ------------------------------------------------
line_format = zeros(num_line_per_epoch,data_length_per_line1to4);
for a = 1 : num_interval
    for i = (1 : num_lat+1)
        if length(line) > 80
            for j = 1 : 4   
                line_format(j,1:data_length_per_line1to4) = sscanf(line,'%f',data_length_per_line1to4);  
                line = fgets(input);
            end
            line_format(5,1:data_length_per_line5) = sscanf(line,'%f',data_length_per_line5);
            line = fgets(input);
            for k = 1 : num_line_per_epoch
                switch k
                    case 1
                         % 첫번 째 데이터 라인 읽기
                        Sub_VTEC(i,1:data_length_per_line1to4) = line_format(k,1:data_length_per_line1to4).*0.1;
                    case 2
                         % 두번 째 데이터 라인 읽기
                        Sub_VTEC(i,(data_length_per_line1to4*1+1):(data_length_per_line1to4*2)) = line_format(k,1:data_length_per_line1to4).*0.1;
                    case 3
                         % 세번 째 데이터 라인 읽기
                        Sub_VTEC(i,(data_length_per_line1to4*2+1):(data_length_per_line1to4*3)) = line_format(k,1:data_length_per_line1to4).*0.1;
                    case 4
                         % 네번 째 데이터 라인 읽기
                        Sub_VTEC(i,(data_length_per_line1to4*3+1):(data_length_per_line1to4*4)) = line_format(k,1:data_length_per_line1to4).*0.1;
                    case 5
                         % 다섯번 째 데이터 라인 읽기
                        Sub_VTEC(i,(data_length_per_line1to4*4+1):(data_length_per_line1to4*4 + data_length_per_line5)) = line_format(k,1:data_length_per_line5).*0.1;
                end
            end
        end
        line = fgets(input);
    end
    C = [lati,Sub_VTEC]; % VTEC과 위도 정보 결합 (2차원)
    D = [longi; C];      % VTEC과 경도 정보 결합 (2차원)
    VTEC(:,:,a) = D;     % Epoch별 VTEC 행렬 결합 (3차원)
    

    line = fgets(input);
    line = fgets(input);
    line = fgets(input);
    OutputName = strcat(FID(1:8),'.mat');
    %save(OutputName,'VTEC');
end


 % OutputName = strcat(FID(1:8),'.mat',VTEC);
 % save(OutputName);
% ------------------------------------------------
% -------------------------------------------------------------------------
