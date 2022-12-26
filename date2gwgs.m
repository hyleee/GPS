%% 년, 월, 일, 시, 분, 초 를 입력하면 gw, gs를 출력하는 함수 선언
function [gw, gs] = date2gwgs(year, month, day, hh, mm, ss)

%% JD 계산에 필요한 y, m, UT 구하기
% month 가 2 이하일 때와 3 이상일 때 y,m 값이 다르다.
% year를 y으로, month을 m으로 변환하는 과정에서 각각 다른 계산과정 필요
% 조건문을 사용하여 두 가지 경우를 구분한다.

if month == 1 || month == 2
y = year - 1;
m = month + 12;
else
y = year; 
m = month;
end

% 시, 분, 초 형태 (hh,mm,ss) 를 모두 시간 (hour) 단위로 변환
UT = hh + mm/60 + ss/3600;

%% JD 계산
% 소수점을 버리는 계산(INT)은 fix 함수 사용
JD = fix(365.25*y) + fix(30.6001*(m+1)) + day + UT/24 + 1720981.5;

%% #1 GPS Week Number 
gww = (JD - 2444244.5)/7; 
gw = fix(gww);

%% #2 GPS Week Seconds 
w = gww - gw; % 입력 날짜 포함 주의 시작에 해당하는 일요일 자정부터 센 주의 수. 
d = w * 7; % 주(week) ->  일(day)
h = d * 24; % 일(day) -> 시간(hour)
m = h * 60; % 시간(hour) -> 분(min)
s = m * 60; % 분(min) -> 초(sec)
gs = round(s); % 토요일에서 해당 주 일요일로 변경되는 자정에서부터 센 초의 수

% gs에 반올림(round)를 해준 이유 :
% 1. 소수점 버림(fix)으로 인한 오차를 줄이기 위해
% 2. gs 를 정수로 표기하기 위해
end