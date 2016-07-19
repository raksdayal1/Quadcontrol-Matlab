function [R,Vel,Acc,q,ohmb] = FDM(Fb,Mb,mass,J,dt,q,ohmb,r,rdot)  
% This is a + framed Quadrotor with m2-m4 on the vertical line and m1-m3 on the horizontal 
% Output is the state vector , inputs are the motor speeds
% Quad is a structure containing the Quadrotor paramters which includes inertial and aerodynamic properties 
% All vectors are column vectors ; quaternions are [q1;q2;q3;q0]


%% time parameters


%% Dynamic equation starts
intype = 2; % 1 for RK4 2 for euler


ohmbdot = (J)\(Mb-cross(ohmb,J*ohmb));%OHMB_DOT(Mb,ohmb,J);%inv(J)\(Mb-cross(ohmb,J*ohmb)); %%%%%%%%%%%%%%% OHMB_DOT

if intype == 1
    ohmb = Rungekutta4(ohmbdot,ohmb,dt); % current ang velocity
else
    ohmb = Eulerint(ohmbdot,ohmb,dt);
end



qdot = (0.5)*qmult(q,vertcat(ohmb,0));%Q_DOT(q,ohmb);%(0.5)*qmult(q,vertcat(ohmb,0));%%%%%%%%%%%%%%%%%%%%%  Q_DOT
if intype == 1
    q = Rungekutta4(qdot,q,dt);% current attitude 
else
    q = Eulerint(qdot,q,dt);
end
q = qnorm(q); % norm of quaternion
 

%a=qcvq(q,Fb);% sign error
rddot = (1/mass)*qcvq(q,Fb) - vertcat(0,0,9.81); % eq of motion  %%%%%%%%%%%%% R_DDOT % this is getting the right acceleration



if intype == 1
    
    rdot = Rungekutta4(rddot,rdot,dt); %%%%%%%%%% R_DOT %
else
    rdot = Eulerint(rddot,rdot,dt);
end

if intype == 1
    r = Rungekutta4(rdot,r,dt);%%%%%%%%%%%%%%%  
else
    r = Eulerint(rdot,r,dt);
end

Acc = rddot;Vel = rdot; R = r;


end


%% local functions
function f = Rungekutta4(fdot,f,dt)
% Rungekutta integration

k1 = fdot;
k2 = fdot+(dt/2)*k1;
k3 = fdot+(dt/2)*k2;
k4 = fdot+(dt)*k3;

f = f+(1.0/6)*dt*(k1+2*k2+2*k3+k4);

end
function f = Eulerint(fdot,f,dt)

f = f + fdot*dt;
end