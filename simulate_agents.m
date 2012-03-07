function wArray = simulate_agents(nAgents,mu,sd)

stepsize = 1/nAgents;
draws = (stepsize/2:stepsize:1-stepsize/2)';
wArray = logninv(draws,mu,sd);
