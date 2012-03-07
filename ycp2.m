% Characterizes complementarity problem used to find yStar

function fval = ycp2(y,w,tax)

global A E;

g = tax(1);
t1 = tax(2);
t2 = tax(3);
yBar = tax(4);

c = g + (t2 - t1)*yBar + (1 - t2)*y;

fval = (1-t2)*A*(c).^(-1/E) - (1-A)*(1 - y./w).^(-1/E)./w;

% derivs = (-1/E)*(1-t2)^2*A*(c).^(-1/E-1) + ...
%          (-1/E)*(1-A)*(1 - y./w).^(-1/E)./w.^2;
% fjac = diag(derivs); 
