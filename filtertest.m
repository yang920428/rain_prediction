clc;clear;close all;
z = [1 -1 -1 -1 1 1 -1 -1 1];

T = [0.99 0.01; 0.01 0.99];
Z = [0.2280 , 0.0085; 0.7720 , 0.9915];

filter = [0.5 0.5]';
for i=1:length(z)
    if z(i) == 1
        Zi = [Z(1,1) 0 ; 0 Z(2,1)];
        filter = Zi*T'*filter;
        filter = (1/(filter(1)+filter(2)))*filter;
    else
        Zi = [Z(1,2) 0 ; 0 Z(2,2)];
        filter = Zi*T'*filter;
        filter = (1/(filter(1)+filter(2)))*filter;
    end
end

predict = T*filter;