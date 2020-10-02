function [finalState,history] = runIterationsContinuumStochasticParallel(departureTimes,settings,congestion,population,revisionProtocol,R)
Nt=length(departureTimes);
Ns=length(congestion.S);
% memory allocation
history.TU=NaN(1,settings.maxIter);               % history of total utility
history.potGain=NaN(1,settings.maxIter);          % Potential Gain history
history.R=NaN(population.N,Nt,settings.maxIter);  % history of state variable
history.U=NaN(population.N,Nt,settings.maxIter);    % history of utilities
history.shifts=NaN(1,settings.maxIter);          % history of utilities
history.arrivalTimes=NaN(settings.maxIter,Nt,Ns);      % history of arrival times

if ~isequal(size(R),[population.N,Nt])
     R=ones(population.N,Nt)/population.N/Nt; %matrix indicating which proportion of each of the N classes depart at each of the Nt times. Initially random (but normalized)
end

for iter=1:settings.maxIter
    %% Update
    history.R(:,:,iter)=R;
    % Run dynamics
    [Utilities,t,T,cumUsers]=DynamicsWithParallelBottlenecks(departureTimes,R,congestion.S,population,congestion.Tf);
    history.potGain(iter)=100*sum(sum(R.*(repmat(max(Utilities,[],2),1,Nt)-Utilities)./abs(Utilities),2));
    history.TU(iter)=sum(sum(R.*Utilities));

    % Run_script_making_plots
    if strcmp(settings.display,'on')||(strcmp(settings.display,'final')&& iter==settings.maxIter)
        fprintf('iteration %i\n',iter);
        makePlotsContinuumStochastic;
    end
    % Compute new R
    [R,history.shifts(iter)] = updateDeparturesContinuum(R,Utilities,revisionProtocol);

    % save history
    history.U(:,:,iter)=Utilities;
end
finalState.t=t;
finalState.T=T;
    function [Ut,t,T]=localDynamicFunction(R)
        [Ut,t,T,~]=DynamicsWithParallelBottlenecks(departureTimes,R,congestion.S,population,congestion.Tf);
    end
end