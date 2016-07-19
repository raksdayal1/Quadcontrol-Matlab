
% make constarints accroding to cutlers paper
% give visual in multithread

clear all;close all;clc;

load('Environment.mat') % put this outside the loop
waypoint_last = [];

iFuel = 10000;
Fuel = iFuel;
% start loop  here
for my_test = 1:10 % set the crash predicate here
    inputwp = [];
    while isempty(inputwp)
        request = 'Input the Set of Waypoints \n';
        inputwp = input(request);
        if isempty(inputwp)
            disp('A set of inputs is required \n')
        end
        if size(inputwp,1) ~= 3
            disp('Please check the waypoints and enter them again \n')
            inputwp = [];
        end

    end

    ques = 'Do you wish to enter your set of gains?\n';
    answer = input(ques);
    if (answer ==  1);
        reqgain = 'Input the Gains';
        inga = input(reqgain); 
    else
        inga = [];
    end
    close all;
    inputwp = horzcat(waypoint_last,inputwp);
    
    if isempty(inga)
       [position,ANG,Fuel] =  Quadrotor_Simulator(Fuel, inputwp);

    else
        [position,ANG,Fuel] = Quadrotor_Simulator(Fuel, inputwp, inga);
    end

    len = size(position,2);

    waypoint_last = position(:,len);
    
    disp(['Last Position is x = ',num2str(waypoint_last(1)),' y = ',num2str(waypoint_last(2)),' z = ',num2str(waypoint_last(3))])
    
    
% My assumption is quad stabilizes itself through a machine learning method

clear inputwp


end

%%
% I think best to put the visualization ina seperate thread
 figure;
 axis([-2 10 -2 15 20 70]);
 view(3)

mesh(X,Y,Zt)
[xs,ys,zs] = sphere(20);
[xc,yc,zc] = cylinder([0.2,0.2]);



h(1) = surface(1.5*xc, 1.5*zc, -1.5*0.5*yc, 'Facecolor', 'yellow');
h(2) = surface(1.5*zc, 1.5*yc, 1.5*0.5*xc, 'Facecolor', 'blue');
h(3) = surface(-1.5*zc, 1.5*yc, 1.5*0.5*xc, 'Facecolor', 'blue');
h(4) = surface(1.5*xc, -1.5*zc, 1.5*0.5*yc, 'Facecolor', 'yellow');
h(5) = surface(0.4*xs, 0.4*ys, 0.4*zs, 'Facecolor', 'red');

 t = hgtransform('parent',gca);
 
set(h,'parent',t)
set(gcf,'Renderer','opengl')
drawnow

%ANG(3) is yawing,ANG(2) is rolling(i.e.about x) ANG(1) is pitching(i.e
%about y)
for i = 1:size(ANG,2)
    
    trans = makehgtform('translate',[position(1,i),position(2,i),position(3,i)]);
    rot = makehgtform('xrotate',ANG(2,i),'yrotate',ANG(1,i),'zrotate',ANG(3,i));
    set(t,'Matrix',trans*rot);
    pause(1e-10)
end


