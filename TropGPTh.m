function [ZHD] = TropGPTh(vec_sta, gw, gs)
gd = xyz2gd(vec_sta); 
lat = gd(1); 
lon = gd(2); 
hgt = gd(3); % [m]
%% Convert GW/GS to MJD
mjd = gwgs2mjd(gw, gs);

%% GPT�� �з�(P) ����
[p, ~, ~] = gpt_v1(mjd, deg2rad(lat), deg2rad(lon), hgt); %: lat/lon[RAD], hgt[M]

%% �з±������ ZHD ���, �׸��� GMF ����Լ� 1/sin(el) ����
ZHD = (2.2779 * p) / (1 - 0.00266 * cosd(2*lat) - 0.00028 * hgt);
ZHD = ZHD/1000.;      %: Conversion to [METER]
end
