function [position,ANG,Fuel,ERROR,time] =  Quadrotor_Simulator(Fuel,waypoints,K)

if nargin == 3
%% Floor and ceiling the gains
% need to make sure limits hold; done by repeated testing
% kpx = K(1,1)
if K(1,1) < 2 || K(1,1) > 4
    if K(1,1) < 2
        K(1,1) = 2;
    elseif K(1,1) > 4
        K(1,1) = 4;
    end
end
%kdx = K(2,1)

if K(2,1) < 2 || K(2,1) > 4
    if K(2,1) < 2
        K(2,1) = 2;
    elseif K(2,1) > 4
        K(2,1) = 4;
    end
end

%kpy = K(1,2)
if K(1,2) < 2 || K(1,2) > 4
    if K(1,2) < 2
        K(1,2) = 2;
    elseif K(1,2) > 4
        K(1,2) = 4;
    end
end

%kdy = K(2,2)
if K(2,2) < 2 || K(2,2) > 4
    if K(2,2) < 2
        K(2,2) = 2;
    elseif K(2,2) > 4
        K(2,2) = 4;
    end
end

%kpz = K(1,3)
if K(1,3) < 2 || K(1,3) > 4
    if K(1,3) < 2
        K(1,3) = 2;
    elseif K(1,3) > 4
        K(1,3) = 4;
    end
end

%kdz = K(2,3)
if K(2,3) < 2 || K(2,3) > 4
    if K(2,3) < 2
        K(2,3) = 2;
    elseif K(2,3) > 4
        K(2,3) = 4;
    end
end
%waypoints = [0 3 12 20;0 4 20 32;0 25 40 45];
%clear;clc;close all;
else
    
    K = [2.9 2.3 4.5;3.2 2.8 6.7];
end
%% 
%  Create the Quad Structure which acts like an instance of the Quadrotor
%  rigid body
mass = 1.5;
J=[0.75 0 0;0 0.75 0;0 0 1.5];
 arm_length = 0.2;
 drag_coeff = 3.7e-7;
 thrus_coeff = 5.1e-4;
dt = 1e-3;%time_step
q = [0;0;0;1];%qinit
ohmb = [0;0;0];%ohmbinit
r = waypoints(:,1);%[0;0;0]; %initial_position set this initial position velocity and angle accrodingly
rdot = [0;0;0]; %initial_velocity

%Quad = struct('mass',mass,'J',J,'l',arm_length,'d',drag_coeff,'b',thrus_coeff,'dt',time_step,'quatinit',qinit,'ohmbinit',ohmbinit,'rinit',initial_position,'rdotinit',initial_velocity,'quat',qinit,'ohmb',ohmbinit,'r',initial_position,'rdot',initial_velocity,'eprev',[0;0;0],'Fiprev',[0;0;0],'psiprev',0);
Fiprev  = [0;0;0];
psiprev =0;
%% define the gains

kpx = K(1,1);kpy = K(1,2);kpz = K(1,3);
kdx = K(2,1);kdy = K(2,2);kdz = K(2,3);

kp = [kpx 0   0;
      0   kpy 0;
      0   0   kpz];
  
kd = [kdx 0   0;
      0   kdy 0;
      0   0   kdz];

kpxat=190.2;kpyat=190;kpzat=190.8;
kdxat=2.7;kdyat=2.5;kdzat=2.9;

Kp = [kpxat 0     0;
       0    kpyat 0;
       0    0     kpzat];
   
Kd = [kdxat 0     0;
      0     kdyat 0;
      0     0     kdzat];


%% Simulation parameters
time = 0:dt:5;
l = arm_length; d = drag_coeff;b = thrus_coeff;

% preallocate 
position = zeros(3,length(time));
velocity = zeros(3,length(time));
ERROR = zeros(3,length(time));
ANG = zeros(3,length(time));


%%
%t = linspace(0,3,4);

x_wp = waypoints(1,:);
y_wp = waypoints(2,:);
z_wp = waypoints(3,:);

% if length(x_wp) == length(y_wp) && length(x_wp) == length(y_wp) && length(y_wp) == length(z_wp)
%     t_gp = linspace(min(time),max(time),length(x_wp));
% else
%     disp('Waypoints should be same length')
%     
% end


% % GP parameters
% sigma = 0.7;
% noise = 0.001;
% ncent = 20;
% tol = 1e-4;
% 
% 
% ogpx = onlineGP(sigma,noise,ncent,tol);
% ogpy = onlineGP(sigma,noise,ncent,tol);
% ogpz = onlineGP(sigma,noise,ncent,tol);
% 
% ogpx.process(t_gp(1),x_wp(1));
% ogpy.process(t_gp(1),y_wp(1));
% ogpz.process(t_gp(1),z_wp(1));
% 
% for i = 1:length(t_gp)
%     ogpx.process(t_gp(i),x_wp(i))
%     ogpy.process(t_gp(i),y_wp(i))
%     ogpz.process(t_gp(i),z_wp(i))
% end
% 
% mean_x = ogpx.predict(time);
% mean_y = ogpy.predict(time);
% mean_z = ogpz.predict(time); 
% 
% % 
% %define waypoints heres
% 
% x = mean_x';%9*cos((2*pi/12)*time);    % y = 10*ones(1,length(time));
% y = mean_y';%3*sin((2*pi/12)*time);    % z = 20*ones(1,length(time));          
% z = mean_z';%time; 
% 
 psid = 0;
% m = 9;
% % trajectory polynomials % this is the main problem...The trajectory
% % generation is not odne according to the constraints defined in cutlers
% % paper
% % for i = 1:10
% % S(1,i) = t^(i-1);
% % S(2,i) = (i-1)*t^(i-2);
% % S(3,i) = (i-1)*(i-2)*t^(i-3);
% % S(4,i) = (i-1)*(i-2)*(i-3)*t^(i-4);
% % S(5,i) = (i-1)*(i-2)*(i-3)*(i-4)*t^(i-5);
% % end
% 
% 
% %  px = polyfit(time,x,m);
% %  py = polyfit(time,y,m);
% %  pz = polyfit(time,z,m);
px = Polygen(time(1),time(length(time)),x_wp(1),x_wp(2));
py = Polygen(time(1),time(length(time)),y_wp(1),y_wp(2));
pz = Polygen(time(1),time(length(time)),z_wp(1),z_wp(2));
% form the desired trajectory
rdesired = vertcat(px,py,pz);


%type=2; % 1 include motor dynamics and saturation % 2 is direct force and moment transmission to FDM
%% SIMULATION
tic
for i = 1:length(time)
 
    t = time(i);
    
    [Fb,qd,ohmbd,e,psiprev,Fiprev] = PosControl(rdesired,psid,r,rdot,psiprev,Fiprev,mass,t,kp,kd,dt);
    
    M = AngControl(qd,ohmbd,q,ohmb,Kp,Kd);
    
    %motor_thrust = ([1 1 1 1;l 0 -l 0;0 l 0 -l;-d d -d d])\vertcat(Fb(3),M);
    
%    % m1 = sqrt(motor_thrust(1)/b);
%     m2 = sqrt(motor_thrust(2)/b);
%     m3 = sqrt(motor_thrust(3)/b);
%     m4 = sqrt(motor_thrust(4)/b);
%    
%     f1 = b*m1^2 % thrust on motor1
%     f2 = b*m2^2 % thrust on motor2
%     f3 = b*m3^2 % thrust on motor3 
%     f4 = b*m4^2 % thrust on motor4
%     
%     D = [1 1 1 1;l 0 -l 0;0 l 0 -l;-d d -d d]*[f1;f2;f3;f4]; % calculates the [ftotal;Mb] vector
%     ftotal = D(1); % returns the total thrust from all 4 motors
%     M = D(2:4); % returns the Moments of the Quadrotor along x y z
%     Fb=[0;0;ftotal];
%     
    
%     if Fb(3) > 50;
%         Fb(3) = 50;
%     elseif Fb < -10
%         Fb(3) = -10;
%     end
    
   [r,rdot,~,q,ohmb] = FDM(Fb,M,mass,J,dt,q,ohmb,r,rdot);
    
    [phi,theta,psi] = euler(q(4),q(1),q(2),q(3)); 
    
    
    
    
    position(:,i) = r;
    velocity(:,i) = rdot;
    ERROR(:,i)= e ;
    
    ANG(:,i) = [phi;theta;psi];
    
end
toc

Cd = 0.0005;rho = 2.73;

Fuel = Fuel - 0.35*((Cd*rho*norm(velocity*diag(velocity'*velocity)))...
    + mass*norm(velocity(3,:)))*(max(time)-min(time));


%figure;
%plot(1:length(time),ERROR)
end