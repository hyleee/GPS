function [gmfh, gmfw] = GMF(gw, gs, pos, el)
%
%function [m_h, m_w] = GMF(gw, gs, pos, el)
%
% DO: Derive GMF hydrostatic and wet mapping function
%       - GMF: Global Mapping Function
%
% <input>   gw/gs: GPS Week Number and Weekk Seconds
%           pos: site position in ECEF [m]
%           el: elevation angle [DEG]
%
% <output>  gmfh/gmfw: GMF Hydrostatic/Wet mapping function
%
% Copyright: Kwan-Dong Park, January 23, 2014 @LDEO
%
% �⺻������ Boehm�� ���� gmf_f_hu�� �����ϱ� ���� ����� ��ɿ� ������ ����
%

%% MJD ȯ��
dmjd = gwgs2mjd(gw, gs);
%% ���浵-�� ȯ��(���� rad/rad/m)
llh = xyz2gd(pos);
dlat = deg2rad(llh(1));
dlon = deg2rad(llh(2));
dhgt = llh(3);
%% Zenith Distance ȯ��(���� rad)
zd = deg2rad(90 - el);
%% gmf_f_hu ȣ���ؼ� ����Լ� ����
[gmfh, gmfw] = gmf_f_hu (dmjd, dlat, dlon, dhgt, zd);
