%% Running simulation
function RunGame()

clear all;close all;clc;

load('Environment.mat') % put this outside the loop
waypoint_last = [];

iFuel = 10000;
Fuel = iFuel;
% start loop  here
for my_test = 1:2 % set the crash predicate here
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

    inputwp = horzcat(waypoint_last,inputwp);
    
    if isempty(inga)
       [position,ANG,Fuel] =  Quadrotor_Simulator(Fuel, inputwp);

    else
        [position,ANG,Fuel] = Quadrotor_Simulator(Fuel, inputwp, inga);
    end

    len = size(position,2);

    waypoint_last = position(:,len);
    disp(['Last Position is x = ',num2str(waypoint_last(1)),'y = ',num2str(waypoint_last(2)),'z = ',num2str(waypoint_last(3))])
    
% My assumption is quad stabilizes itself through a machine learning method

clear inputwp


end
%%
% I think best to put the visualization ina seperate thread
 
% axis([-10 10 -10 10 -10 10]);
% view(3)
% 
% mesh(X,Y,Zt)
% [xc,yc,zc] = cylinder([0.1,0.0]);
% [x,y,z] = cylinder([0.2,0.2]);
% 
% 
% 
% h(1) = surface(xc, zc, -yc, 'Facecolor', 'red');
% h(2) = surface(z, y, 0.5*x, 'Facecolor', 'yellow');
% h(3) = surface(-z, y, 0.5*x, 'Facecolor', 'blue');
% h(4) = surface(x, -1.5*z, 0.5*y, 'Facecolor', 'red');
% h(5) = surface(xc, 1.5*yc-1.3, z, 'Facecolor', 'red');
% 
%  t = hgtransform('parent',gca);
%  
% set(h,'parent',t)
% set(gcf,'Renderer','opengl')
% drawnow
% 

% for i = 1:size(position,2)
%     
%     trans = makehgtform('translate',[position(1,i),position(2,i),position(3,i)]);
%     rot = makehgtform('xrotate',ANG(1,i),'yrotate',ANG(2,i),'zrotate',ANG(3,i));
%     set(t,'Matrix',trans);
%     pause(1e-1)
% end


end
    