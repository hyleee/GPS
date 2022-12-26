function [az,el] = xyz2azel(xyz,lat,lon)
%
%function [az,el] = xyz2azel(xyz,lat,lon)
%
% DO: Convert (dX, dY, dZ) to (Azimuth, Elevation)
%
% <input>   xyz: 1X3 row vector
%           lat/lon: latitude and longitude at the user location [degrees]
%
% <output>  az/el: Azimuth and elevation angle [degrees]
%
% Copyright: Kwan-Dong Park; November 2011; Inha University
%

%% Conversion of dXYZ to dTopo
topo = xyz2topo(xyz,lat,lon);
N = topo(1);
E = topo(2);
V = topo(3);
%% Conversion of dN, dE, dV to AZ/EL angles
NE = sqrt(N^2 + E^2);
el = atan2(V, NE) * 180/pi;
az = angle(N + i * E) * 180/pi;
%% Solve the quadrant ambiguity
if az < 0
    az = 360 + az;
end