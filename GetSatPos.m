%% 출처: brdc0320.15n; PRN = 7; 2015년 2월 1일, 17시 45분 0초
%--------------------------------------------------------------------------------
% 7 15  2  1 16  0  0.0 0.436628237367D-03 0.329691829393D-11 0.000000000000D+00
%    0.530000000000D+02 0.115062500000D+03 0.395623622169D-08-0.108636423694D+01
%    0.582262873650D-05 0.799538625870D-02 0.100657343864D-04 0.515374286652D+04
%    0.576000000000D+05 0.214204192162D-06-0.304400989978D+01-0.122934579849D-06
%    0.971741397250D+00 0.192156250000D+03-0.275290280714D+01-0.774282251964D-08
%    0.964325882329D-11 0.000000000000D+00 0.183000000000D+04 0.000000000000D+00
%    0.200000000000D+01 0.000000000000D+00-0.111758708954D-07 0.530000000000D+02
%    0.504000000000D+05 0.400000000000D+01 0.000000000000D+00 0.000000000000D+00
%--------------------------------------------------------------------------------

function [SatVec]=GetSatPos(eph,colIndex,t)

%궤도정보
sqrtA = eph(colIndex,10);
delta_n = eph(colIndex,18);
toe = eph(colIndex,1);
M0 = eph(colIndex,15);
e = eph(colIndex,11);
omega = eph(colIndex,13);

%위도 인수, radius, 궤도 경사각 보정량 계산에 사용되는 값
Cuc = eph(colIndex,20);
Cus = eph(colIndex,21);
Crc = eph(colIndex,22);
Crs = eph(colIndex,23);
Cic = eph(colIndex,24);
Cis = eph(colIndex,25);

%위도인수, radius, 궤도경사각 계산에 사용되는 값
i0 = eph(colIndex,12);
i_dot = eph(colIndex,16);

%승교점 적경 및 보정량 
Omega0 = eph(colIndex,14);
Omega_dot = eph(colIndex,17);


% Step 1
mu = 3.986005e14;
omegaE = 7.2921151467e-5;

% Step 2
a = sqrtA^2;
n0 = sqrt(mu/a^3);

% Step 3
n = n0 + delta_n;

% Step 4
tk = t - toe;

% Step 5
Mk = M0 + n*tk;

% Step 6
Ek = solveKepler(Mk, e);

% Step 7 
fk =  atan2((sqrt(1 - e^2)*sin(Ek)), (cos(Ek) - e)); 
% 예각, 둔각 혼동 방지 -> atan2 사용
% atan2는 분모/분자를 , 로 구분

% Step 8
phik = fk + omega;

% Step 9 
delta_uk = Cus*sin(2*phik) + Cuc*cos(2*phik);
delta_rk = Crs*sin(2*phik) + Crc*cos(2*phik);
delta_ik = Cis*sin(2*phik) + Cic*cos(2*phik);

% Step 10
uk = phik + delta_uk;
rk = a*(1 - e*cos(Ek)) + delta_rk;
ik = i0 + delta_ik + i_dot*tk;

% Step 11
xkp = rk*cos(uk);
ykp = rk*sin(uk);

% Step 12
Omegak = Omega0 + (Omega_dot - omegaE)*tk - omegaE*toe;

% Step 13
xk = xkp*cos(Omegak) - ykp*cos(ik)*sin(Omegak);
yk = xkp*sin(Omegak) + ykp*cos(ik)*cos(Omegak);
zk = ykp*sin(ik);
SatVec=[xk yk zk];

% % 참값과 비교
% TrueSatPos = [-7035.740299  24953.277797  -4717.745887]*1000;
% CompSatPos = [xk, yk, zk];
% %sp3 파일의 단위는 km 이므로 m 로 단위 통일하기 위해 *1000
% 
% fprintf('===========================================================\n');
% fprintf('Computed X: %12.3f Y: %12.3f Z: %12.3f m\n', CompSatPos);
% fprintf('True SP3 X: %12.3f Y: %12.3f Z: %12.3f m\n', TrueSatPos);
% fprintf('===========================================================\n');
% fprintf('X Error :%6.2f m / ', abs(xk - TrueSatPos(1)));
% fprintf('Y Error :%6.2f m / ', abs(yk - TrueSatPos(2)));
% fprintf('Z Error :%6.2f m\n', abs(zk - TrueSatPos(3)));
% fprintf('3D Error:%6.2f m\n', norm(CompSatPos - TrueSatPos));
% fprintf('===========================================================\n');