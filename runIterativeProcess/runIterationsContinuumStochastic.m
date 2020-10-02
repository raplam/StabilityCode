function [finalState,history] = runIterationsContinuumStochastic(departureTimes,settings,congestion,population,revisionProtocol,R)
Nt=length(departureTimes);
Ns=length(congestion.S);
% memory allocation
history.TU=NaN(1,settings.maxIter);               % history of total utility
history.potGain=NaN(1,settings.maxIter);          % Potential Gain history
history.R=NaN(population.N,Nt,settings.maxIter);  % history of state variable
history.U=NaN(population.N,Nt,settings.maxIter);    % history of utilities
history.shifts=NaN(1,settings.maxIter);          % history of utilities
history.arrivalTimes=NaN(settings.maxIter,Nt,Ns);      % history of arrival times

if isempty(R)
    R=ones(population.N,Nt)/population.N/Nt; %matrix indicating which proportion of each of the N classes depart at each of the Nt times. Initially random (but normalized)
end
for iter=1:settings.maxIter
    %% Update
    history.R(:,:,iter)=R;
    % Run dynamics
    t=NaN(Ns,2*Nt);
    n=NaN(Ns,2*Nt);
    U=zeros(population.N,Nt,Ns);
    for inds=1:Ns
        [Utmp,ttmp,ntmp,arrivalTimes,~]=BottleneckDynamicsAndUtilityEvaluation(departureTimes,R,congestion.S(inds),population);
        t(inds,1:length(ttmp))=ttmp;
        n(inds,1:length(ntmp))=ntmp;
        U(:,:,inds)=reshape(Utmp,[population.N,Nt,1]);
        history.arrivalTimes(iter,:,inds)=reshape(arrivalTimes,[1,Nt,1]);
    end
    Utilities=mean(U,3);
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
finalState.n=n;
end
