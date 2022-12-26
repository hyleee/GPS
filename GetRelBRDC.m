function[dRel] =GetRelBRDC(eph,i_row,tc)
F = -4.442807633e-10;
mu = 3.986005e+14;
e = eph(i_row,11);
a = eph(i_row,10);
M = eph(i_row,15);
toe = eph(i_row,1);
dn = eph(i_row,18);
n_0 = (sqrt(mu))/a^3;
n = n_0 + dn;
M_k = M + n*(tc - toe);

n_iter = 5;
E = ecce_anom(M_k,e,n_iter);

dRel = F * e * a * sin(E);
