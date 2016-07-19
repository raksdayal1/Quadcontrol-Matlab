clear all;close all;
clc;
x = 0:0.2:10;
y = (x).^3;


for ii = 1:length(x)
    if ii ~= 1
        dy = y(ii)-y(ii-1);
        dx = x(ii)-x(ii-1);
    else
        dy = y(ii);
        dx = x(ii);
    end
    m(ii) = dy/dx; %% this is the right way to do differentiation
    m2(ii) = dy;
end
plot(x,y)
title('Function')
figure;
plot(x,m,'r')
title('m')
figure;
plot(x,m2,'c')
