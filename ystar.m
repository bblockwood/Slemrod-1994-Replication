% Finds vector of agents' selected earnings, given some tax. 

function [yArray,cArray,uArray] = ystar(wArray, tax)

global A E;

nAgents = size(wArray,1);
g = tax(1);
t1 = tax(2);
t2 = tax(3);
yBar = tax(4);

Z = zeros(nAgents,1);

optset('bisect','check',1);

% Find optimal earnings in lower bracket
y1 = Z;
w1LB = -g/(1-t1) + sqrt(eps); % lowest wage at which pos labor supplied
isPos = (ycp1(Z,wArray,tax) > 0) & (w1LB < wArray);
y1(isPos) = bisect_bbl('ycp1',w1LB,wArray(isPos),wArray(isPos),tax);
y1 = min(y1,yBar*ones(nAgents,1)); % in lower bracket, make at most yBar

% Find optimal earnings in upper bracket
y2 = Z;
w2LB = -(g+(t2-t1)*yBar)/(1-t2) + sqrt(eps);
isPos = (ycp2(zeros(nAgents,1),wArray,tax) > 0) & (w2LB < wArray);
y2(isPos) = bisect_bbl('ycp2',w2LB,wArray(isPos),wArray(isPos),tax);
y2 = max(y2,yBar*ones(nAgents,1)); % in upper bracket, make at least yBar

c1 = g + (1 - t1)*y1;
c2 = g + (t2 - t1)*yBar + (1 - t2)*y2;

u1 = (A*(c1).^((E-1)/E) + ...
     (1-A)*(1 - y1./wArray).^((E-1)/E)).^(E/(E-1));
u2 = (A*(c2).^((E-1)/E) + ...
     (1-A)*(1 - min(y2,wArray)./wArray).^((E-1)/E)).^(E/(E-1));

chooses1 = u1 > u2; % 1 if agent chooses y in lower tax bracket
yArray = [y1(chooses1); y2(~chooses1)];
cArray = [c1(chooses1); c2(~chooses1)];
uArray = [u1(chooses1); u2(~chooses1)];
