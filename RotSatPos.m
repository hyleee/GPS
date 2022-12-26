function RotPos = RotSatPos(SatPos,STT)
Ome = 7.2921151467e-5;
rota = Ome*STT; 
R_e = [ cos(rota) sin(rota) 0; -sin(rota) cos(rota) 0; 0 0 1]; % Z축에 대한 오일러 회전 행렬 적용
Pos = [SatPos(1); SatPos(2); SatPos(3)];
RotPos = R_e*Pos;
RotPos = RotPos';