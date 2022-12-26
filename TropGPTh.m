function [ZHD] = TropGPTh(vec_sta, gw, gs)
gd = xyz2gd(vec_sta); 
lat = gd(1); 
lon = gd(2); 
hgt = gd(3); % [m]
%% Convert GW/GS to MJD
mjd = gwgs2mjd(gw, gs);

%% GPT로 압력(P) 산출
[p, ~, ~] = gpt_v1(mjd, deg2rad(lat), deg2rad(lon), hgt); %: lat/lon[RAD], hgt[M]

%% 압력기반으로 ZHD 계산, 그리고 GMF 사상함수 1/sin(el) 적용
ZHD = (2.2779 * p) / (1 - 0.00266 * cosd(2*lat) - 0.00028 * hgt);
ZHD = ZHD/1000.;      %: Conversion to [METER]
end
