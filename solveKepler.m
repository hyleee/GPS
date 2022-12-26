function [Ekp1]=solveKepler(M,e)

% 초기값 정의
% M=0.5;
% e=0.005;

% 탈출조건 정의
eps=1e-10;

Ek=M;

for k=1:5
    fE=M-Ek+e*sin(Ek);
    fpE=-1 + e*cos(Ek);
    Ekp1=Ek-fE/fpE;
%     fprintf('%d %12.8f %12.8f\n',k,Ek,Ekp1);
    if abs(Ekp1-Ek)<eps
        break
    end
    Ek=Ekp1;
end