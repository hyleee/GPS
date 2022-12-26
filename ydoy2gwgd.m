function [gw, gwd] = ydoy2gwgd(yy, doy)
%
%function [gw, gd] = ydoy2gwgd(yy, doy)
%
% DO: Convert Year & DOY to GPS Week and GPS Week Day Number
%
% <input>   yy:  Year          eg) 14
%           doy: Day of Year   eg) 100
%
% <output>  gw/gd: GPS Week Number and GPS Week Day Number
%
% Copyright: Kwan-Dong Park, October 10, 2014@Jipyong Space
%            - ��̼� ����(10/9/14)�� �ణ ������
%

%% 2�ڸ� �⵵�� 4�ڸ� �⵵�� ����
if yy < 80
    y4 = 2000 + yy;
else
    y4 = 1900 + yy;
end
%% ���� ��� ���� - 10���Ŀ� ���� �ʿ�
switch (y4)
    case {1980,1984,1988,1992,1996,2000,2004,2008,2012,2016,2020,2024}
        days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    otherwise
        days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
end
%% Calendar Month/Day ����
tdays = 0;
for i = 1: 12
    tdays = tdays + days(i);
    if doy - tdays < 0
        break;
    end
end
mo = i;
dd = doy - sum(days(1:i-1));
%% JD ���: date2jd ���� h/m/s�� 12/0/0���� �����ϰ� ���
JD = 367*y4 - floor(7*(y4 + floor((mo + 9)/12))/4) + floor(275*mo/9) + dd + 1721013.5 + 0.5;
%% JD ������� GPS Week�� GPS Week Day ���: jd2gwgs Ȱ��
[gw, gs] = jd2gwgs(JD);
gwd = floor(gs/86400);