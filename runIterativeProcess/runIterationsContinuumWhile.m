function [finalState,history] = runIterationsContinuumWhile(departureTimes,settings,congestion,population,revisionProtocol,R)
% This function takes as input a population of individuals with their
% preferences (population), a congestion mechanism (congestion), the range of allowed departure times (departureTimes),
% an adjustment mechanism (revisionProtocol), an initial matrix of
% departure rates (R) and some settings.
% It then mimicks the day to day evolution.
%
% Ouvtputs:
% - finalState is a struct variable containing informations regarding the
% state on the last iteration of the simulation.
% - history is a struct variable containing informations for all days of
% the simulation.
%
% Last modified by Raphael Lamotte, on October 24, 2018.

Nt=length(departureTimes);

% memory allocation
history.TU=NaN(1,settings.maxIter);               % history of total utility
history.potGain=NaN(1,settings.maxIter);          % Potential Gain history
history.shifts=NaN(1,settings.maxIter);          % history of utilities
history.TotDelay=NaN(1,settings.maxIter);
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
    [Utilities,t,n,arrivalTimes,~]=BottleneckDynamicsAndUtilityEvaluation(departureTimes,R,congestion.S,population);
    
    history.potGain(iter)=100*sum(sum(R.*(repmat(max(Utilities,[],2),1,Nt)-Utilities)./abs(Utilities),2));
    psi=1/2*max(zeros(Nt,Nt),repmat(Utilities,Nt,1)-repmat(Utilities',1,Nt)).^2;
    history.Lyap(iter)=sum(sum(psi.*repmat(R',1,Nt)))/Nt;
    history.TU(iter)=sum(sum(R.*Utilities));
    history.TotDelay(iter)=sum(R,1)*(arrivalTimes'-departureTimes');
    % Compute new R
    [R,history.shifts(iter)] = updateDeparturesContinuum(R,Utilities,revisionProtocol);
    
    cumShifts=cumShifts+history.shifts(iter);
    iter=iter+1;
end
finalState.t=t;
finalState.n=n;
