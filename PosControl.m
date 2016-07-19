function[Fb,qd,ohmbd,e,psiprev,Fiprev] = PosControl(rdesired,psid,r,rdot,psiprev,Fiprev,mass,t,kp,kd,dt)
% feedback Acceleration controller  

%% compute error and find feedback acceleration


e = r - vertcat(polyval(rdesired(1,:),t),polyval(rdesired(2,:),t),polyval(rdesired(3,:),t));


xdotdesired = polyval(polyder(rdesired(1,:)),t);
ydotdesired = polyval(polyder(rdesired(2,:)),t);
zdotdesired = polyval(polyder(rdesired(3,:)),t);
rdotdesired = vertcat(xdotdesired,ydotdesired,zdotdesired);


edot = (rdot-rdotdesired);

xddotdesired = polyval(polyder(xdotdesired),t);
yddotdesired = polyval(polyder(ydotdesired),t);
zddotdesired = polyval(polyder(zdotdesired),t);
rddot_desired = vertcat(xddotdesired,yddotdesired,zddotdesired);


rddot_fb = -kp*e-kd*edot;
%% compute desired quaternion
Fi=mass*(rddot_desired + rddot_fb + [0;0;9.81]);


Fb=[0;0;norm(Fi)];
Ficap = Fi/norm(Fi);
Fbcap = Fb/norm(Fb);

C = dot(Ficap,Fbcap);

if C >= 0
    qd = (1/sqrt(2*(1+C)))*vertcat(cross(Ficap,Fbcap),(1+C));
elseif C < 0
    qd = (1/sqrt(2*(1-C)))*vertcat(cross(Ficap,Fbcap),(1-C));
end

qd = qmult(qd,[0;0;sin(psid/2);cos(psid/2)]);
qd = qnorm(qd);
%%

Fidot = (Fi-Fiprev);


Ficapdot = (Fidot/norm(Fi)) - (Fi*dot(Fi,Fidot)/(norm(Fi)^3));


ohmbdxy = cross(Fi,Ficapdot);
ohmbdz = (psid-psiprev); % use polyderv here
ohmbd = vertcat(ohmbdxy(1:2),ohmbdz);

Fiprev = Fi;
psiprev = psid;
% %%
% Quad.Fiprev = Fi;
% Quad.eprev = e;
% Quad.psidprev = psid;

end