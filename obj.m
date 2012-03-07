% Function to be minimized to find optimal tax

function result = obj(wArray,sol)

disp(sol')

t1 = sol(1);
t2 = sol(2);
yBar = sol(3);

opts = optimset('display','off');
gB = fsolve(@(g) deficit(wArray,[g;t1;t2;yBar]),0,opts);

tax = [gB;t1;t2;yBar];

[~,~,uArray] = ystar(wArray,tax);

result = -sum(uArray);
