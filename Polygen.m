function alpha = Polygen(ti,tf,xi,xf)
t = ti;
S1 = zeros(5,10);
for i = 1:10
    S1(1,i) = t^(i-1);
    S1(2,i) = (i-1)*t^(i-2);
    S1(3,i) = (i-1)*(i-2)*t^(i-3);
    S1(4,i) = (i-1)*(i-2)*(i-3)*t^(i-4);
    S1(5,i) = (i-1)*(i-2)*(i-3)*(i-4)*t^(i-5);
end
S2 = zeros(5,10);
t = tf;
for i = 1:10
    S2(1,i) = t^(i-1);
    S2(2,i) = (i-1)*t^(i-2);
    S2(3,i) = (i-1)*(i-2)*t^(i-3);
    S2(4,i) = (i-1)*(i-2)*(i-3)*t^(i-4);
    S2(5,i) = (i-1)*(i-2)*(i-3)*(i-4)*t^(i-5);
end
D = vertcat(S1,S2);
D(isnan(D)) = 0;
D = D+0.0001*eye(10);

x = zeros(10,1);
x(1) = xi;
x(6) = xf;
alpha = fliplr((D\x)');