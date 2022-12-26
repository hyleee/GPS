%% Main -------------------------------------------------------------------
% Copyright @ Bonggyu Park, Satellite Navigation LAB, Inha Univ.
% geek1206@gmail.com
% 서브 함수들을 실행하는 워크 프레임
% -------------------------------------------------------------------------

% Read Data File ===========
% 샘플 데이터를 읽고 Read_IONEX의 입력 변수 FID에 파일명을 할당하는 샘플코드
% 앞으로 연구 참여하면서, 본인 입맛에 맞게 변형하시면 됩니다.
dataset = dir('C:\Users\GPSLAB\Documents\MATLAB\GIM\SampleData\');
a = struct2cell(dataset); 
b = a(1,3:14); 
c = cell2mat(b');
FID = c(1,1:12);
% ==========================

% Read Ionex ===============
% GIM 읽고 VTEC 반환
Read_GIM(FID);
% ==========================

% Load VTEC ================
% .mat 파일을 변수에 할당
load(strcat(FID(1:8),'.mat'));
c1pg = VTEC;
% ==========================

% Resize VTEC ==============
% 원하는 구역 혹은 지점의 VTEC 추출

% ==========================

% UTC2KST ==================
% UTC를 KST로 변환

% ==========================

% Prediction GIM Sampling ==
% Final GIM과 같은 시각의 VTEC 추출
% 필요시 구현
% ==========================