% visulization test
clear all;clc;close all;

load('pos_ang_test')
figure;
 axis([-2 10 -2 15 20 70]);
 view(3)

%mesh(X,Y,Zt)
[xs,ys,zs] = sphere(20);
[x,y,z] = cylinder([0.2,0.2]);



h(1) = surface(1.5*x, 1.5*z, -1.5*0.5*y, 'Facecolor', 'yellow');
h(2) = surface(1.5*z, 1.5*y, 1.5*0.5*x, 'Facecolor', 'blue');
h(3) = surface(-1.5*z, 1.5*y, 1.5*0.5*x, 'Facecolor', 'blue');
h(4) = surface(1.5*x, -1.5*z, 1.5*0.5*y, 'Facecolor', 'yellow');
h(5) = surface(0.4*xs, 0.4*ys, 0.4*zs, 'Facecolor', 'red');

 t = hgtransform('parent',gca);
 
set(h,'parent',t)
set(gcf,'Renderer','opengl')
drawnow

%ANG(3) is yawing,ANG(2) is rolling(i.e.about x) ANG(1) is pitching(i.e
%about y)
for i = 1:size(ANG,2)
    
    trans = makehgtform('translate',[position(1,i),position(2,i),position(3,i)]);
    rot = makehgtform('xrotate',ANG(1,i),'yrotate',ANG(2,i),'zrotate',ANG(3,i));
    set(t,'Matrix',trans*rot);
    
end


