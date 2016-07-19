function [phi,theta,psi] = euler(a,b,c,d)

numphi = a*b + c*d;
denphi = a^2 - b^2 -c^2 +d^2;

phi = atan(2*numphi/denphi);

theta = -asin(2*(b*d - a*c));

numpsi = a*d + b*c;
denpsi = a^2 + b^2 - c^2 - d^2;

psi = atan(2*numpsi/denpsi);