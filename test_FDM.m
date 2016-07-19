clear all;close all;clc;

M = zeros(3,1);
mass = 1.5;
J = [0.75,0,0;0,0.75,0;0,0,1.5];
dt = 0.001;
q = [0;0;0;1];
ohmb = zeros(3,1);
r = zeros(3,1);
rdot = zeros(3,1);

time = 0:dt:20;
F = zeros(3,length(time));
%F(2,dt/dt:5.5/dt) = 1.5*ones(1,length(dt/dt:5.5/dt));
F(3,dt/dt:10.5/dt) = mass*9.81*ones(1,length(dt/dt:10.5/dt))+2;



figure;
axesHandle = gca;
xlim(axesHandle, [-5 5]);
ylim(axesHandle, [-100 100]);
zlim(axesHandle, [5 100]); 

rectHandle = rectangle('Position',[r(2) r(3) 0.2 0.2],...
    'Curvature',[1,1],'FaceColor','g'); %Pendulum bob



for i = 1:length(time)
    drawnow;
    time(i)
    [r,rdot,a,q,ohmb] = FDM(F(:,i),M,mass,J,dt,q,ohmb,r,rdot);
    
    POS(:,i) = r;
    
    set(rectHandle,'Position',[r(2),r(3),0.2,0.2])
end


%plot3(POS(1,:),POS(2,:),POS(3,:))