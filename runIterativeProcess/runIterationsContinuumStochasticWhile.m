function [finalState,history] = runIterationsContinuumStochasticWhile(departureTimes,settings,congestion,population,revisionProtocol,R)
Nt=length(departureTimes);
Ns=length(congestion.S);
% memory allocation
history.TU=NaN(1,settings.maxIter);               % history of total utility
history.potGain=NaN(1,settings.maxIter);          % Potential Gain history
history.shifts=NaN(1,settings.maxIter);          % history of utilities
history.Lyap=NaN(1,settings.maxIter);

if isempty(R)
    R=ones(population.N,Nt)/population.N/Nt; %matrix indicating which proportion of each of the N classes depart at each of the Nt times. Initially random (but normalized)
end
iter=1;
cumShifts=0;
while cumShifts<=5 && iter<=settings.maxIter
    %% Update
    history.R(:,:,iter)=R;
    % Run dynamics
    t=NaN(Ns,2*Nt);
    n=NaN(Ns,2*Nt);
    ta=NaN(Ns,Nt);
    U=zeros(population.N,Nt,Ns);
    for inds=1:Ns
        [Utmp,ttmp,ntmp,avgArrivalTimes,CumUsers]=BottleneckDynamicsAndUtilityEvaluation(departureTimes,R,congestion.S(inds),population);
        ta(inds,:)=avgArrivalTimes;
        t(inds,1:length(ttmp))=ttmp;
        n(inds,1:length(ntmp))=ntmp;
        U(:,:,inds)=reshape(Utmp,[population.N,Nt,1]);
    end
    Utilities=mean(U,3);
    history.potGain(iter)=100*sum(sum(R.*(repmat(max(Utilities,[],2),1,Nt)-Utilities)./abs(Utilities),2));
    history.TU(iter)=sum(sum(R.*Utilities));
    psi=1/2*max(zeros(Nt,Nt),repmat(Utilities,Nt,1)-repmat(Utilities',1,Nt)).^2;
    history.Lyap(iter)=sum(sum(psi.*repmat(R',1,Nt)))/Nt;
    
    % Run_script_making_plots
    if strcmp(settings.display,'on')||(strcmp(settings.display,'final')&& iter==settings.maxIter)
        fprintf('iteration %i\n',iter);
        makePlotsContinuumStochastic;
    end
    % Compute new R
    [R,history.shifts(iter)] = updateDeparturesContinuum(R,Utilities,revisionProtocol);
    cumShifts=cumShifts+history.shifts(iter);
    iter=iter+1;
end
finalState.t=t;
finalState.n=n;
finalState.ta=ta;
if iter<=settings.maxIter
history.R=history.R(:,:,1:(iter-1));
end
