% Ben Lockwood, lockwood@fas.harvard.edu
% This code replicates the results in Slemrod, Yitzhaki, Mayshar, and
% Lundholm (1994), "The optimal two-bracket linear income tax", Journal of
% Public Economics, 53(2). 

clear all;

global A E;
E = 0.2;

opts = optimset('display','off');

% Set parameters of skill distribution
mu = -1;
sd = 0.39;

% Set A so that agent with mean skill selects l=y/w=2/3, absent taxes
wMean = lognstat(mu,sd);
A = fsolve(@(A) wMean*A*(2/3*wMean)^(-1/E)-(1-A)*(1-2/3)^(-1/E),0.3,opts);

% Simulate agents
wArray = simulate_agents(50,mu,sd);

% Create arrays to perform grid search over
yBarArray = (0:0.1:.5)';
t1Array = (.1:0.05:.5)';
t2Array = (.1:0.05:0.5)';

nYBar = length(yBarArray);
nT1 = length(t1Array);
nT2 = length(t2Array);

swf = zeros(nT2,nT1,nYBar);     % matrix for storing social welfare
gBMat = zeros(nT2,nT1,nYBar);   % matrix for storing demogrant

gB = 0; % to start
i=1;
for iYBar=1:nYBar
    yBar = yBarArray(iYBar);
    for iT2=1:nT2
        t2 = t2Array(iT2);
        for iT1=1:nT1
            t1 = t1Array(iT1);
            
            % Find demogrant that balances budget
            gB = fsolve(@(g) deficit(wArray,[g;t1;t2;yBar]),gB,opts);

            tax = [gB;t1;t2;yBar];
                        
            [~,~,uArray] = ystar(wArray,tax);            
            swf(iT2,iT1,iYBar) = sum(uArray);   % utilitarian SWF
            gBMat(iT2,iT1,iYBar) = gB;
            i=i+1;
        end
        
        % Display progress
        disp([num2str(i) ' of ' num2str(nT1*nT2*nYBar)]);
    end
end

% Find optimal tax regime parameters
[~,idx] = max(swf(:));
[optT2idx optT1idx optYBaridx] = ind2sub(size(swf),idx);
optYBar = yBarArray(optYBaridx);
optT1 = t1Array(optT1idx);
optT2 = t2Array(optT2idx);
optG = gBMat(idx);

% Report optimal results from grid search
t2brGS = [optG;optT1;optT2;optYBar]

% Now use Nelder-Meade to find exact solution with more agents
wArray = simulate_agents(50000,mu,sd);
opts = optimset('display','iter');
t2br = fminsearch(@(sol) obj(wArray,sol),[optT1;optT2;optYBar],opts);
gB = fsolve(@(g) deficit(wArray,[g;t2br]),gB,opts);
tax = [gB;t2br]

surf(t1Array,t2Array,swf(:,:,3))
xlabel('t_1')
ylabel('t_2')
zlabel('social welfare')
