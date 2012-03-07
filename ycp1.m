% Characterizes complementarity problem used to find yStar

function fval = ycp1(y,w,tax)

global A E;

g = tax(1);
t1 = tax(2);

c = @(y) g + (1 - t1)*y;

fval = (1-t1)*A*(c(y)).^(-1/E) - (1-A)*(1 - y./w).^(-1/E)./w;

% derivs = (-1/E)*(1-t1)^2*A*(c(y)).^(-1/E-1) + ...
%          (-1/E)*(1-A)*(1 - y./w).^(-1/E)./w.^2;
% fjac = diag(derivs); 
