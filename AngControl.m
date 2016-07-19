function M = AngControl(qd,ohmbd,q,ohmb,Kp,Kd) 

qe = qmult(qconj(q),qd);
%qe = qmult(qd,qconj(q));

M = sign(qe(4))*Kp*qe(1:3) - Kd*(ohmb - ohmbd);