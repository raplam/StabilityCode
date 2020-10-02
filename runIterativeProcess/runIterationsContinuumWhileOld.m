function [finalState,history] = runIterationsContinuumWhileOld(departureTimes,settings,congestion,population,revisionProtocol,R)
% This function takes as input a population of individuals with their
% preferences (population), a congestion mechanism (congestion), the range of allowed departure times (departureTimes),
% an adjustment mechanism (revisionProtocol), an initial matrix of
% departure rates (R) and some settings.
% It then mimicks the day to day evolution.
%
% Outputs:
% - finalState is a struct variable containing informations regarding the
% state on the last iteration of the simulation.
% - history is a struct variable containing informations for all days of
% the simulation.
%
% Last modified by Raphael Lamotte, on October 24, 2018.


Nt=length(departureTimes);

% Initial memory allocation
history.TU=NaN(1,settings.maxIter);               % history of total utility
history.potGain=NaN(1,settings.maxIter);          % Potential Gain history
% history.R=NaN(population.N,Nt,settings.maxIter);  % history of state variable
% history.U=NaN(population.N,Nt,settings.maxIter);    % history of utilities
history.shifts=NaN(1,settings.maxIter);          % history of utilities
history.Lyap=NaN(1,settings.maxIter);          % history of utilities
history.DLyap1=NaN(1,settings.maxIter);          % history of utilities
history.DLyap2=NaN(1,settings.maxIter);          % history of utilities

switch congestion.mechanism
    case 'MFD'
        % preliminary treatment of L
    case 'bottleneck'
        history.arrivalTimes=NaN(settings.maxIter,Nt);      % history of arrival times
end


if isempty(R)
    R=ones(population.N,Nt)/population.N/Nt; %matrix indicating which proportion of each of the N classes depart at each of the Nt times. Initially random (but normalized)
end
epoch=0;
iter=0;
while epoch<settings.maxEpoch
    iter=iter+1;
    if iter>settings.maxIter
        history.TU=[history.TU,NaN(1,settings.maxIter)];               % history of total utility
        history.potGain=[history.potGain,NaN(1,settings.maxIter)];          % Potential Gain history
%         tmp=history.R;
%         history.R=NaN(population.N,Nt,2*settings.maxIter);  % history of state variable
%         history.R(:,:,1:settings.maxIter)=tmp;  % history of state variable
%         tmp=history.U;
%         history.U=NaN(population.N,Nt,2*settings.maxIter);    % history of utilities
%         history.U(:,:,1:settings.maxIter)=tmp;
        history.shifts=[history.shifts,NaN(1,settings.maxIter)];          % history of utilities
        history.arrivalTimes=[history.arrivalTimes;NaN(settings.maxIter,Nt)];
        settings.maxIter=2*settings.maxIter;
        history.Lyap=[history.Lyap,NaN(1,settings.maxIter)];          % history of utilities
        history.DLyap1=[history.DLyap1,NaN(1,settings.maxIter)];          % history of utilities
        history.DLyap2=[history.DLyap2,NaN(1,settings.maxIter)];          % history of utilities
    end
    %% Update
%     history.R(:,:,iter)=R;
    % Run dynamics
    switch congestion.mechanism
        case 'MFD'
           %
        case 'bottleneck'
            [Utilities,t,n,history.arrivalTimes(iter,:),~]=BottleneckDynamicsAndUtilityEvaluation(departureTimes,R,congestion.S,population);
        otherwise
            error('unknown congestion mechanism');
    end
    history.potGain(iter)=100*sum(sum(R.*(repmat(max(Utilities,[],2),1,Nt)-Utilities)./abs(Utilities),2));
    history.TU(iter)=sum(sum(R.*Utilities));
    % Compute Lyapunov Function and the 2 components of its time derivative
    if population.N==1 % Otherwise, I should adapt the code.
        psi=revisionProtocol.rate/2*max(zeros(Nt,Nt),repmat(Utilities,Nt,1)-repmat(Utilities',1,Nt)).^2;
        history.Lyap(iter)=sum(sum(psi.*repmat(R',1,Nt)));
        proba=revisionProtocol.rate*max(zeros(Nt,Nt),repmat(Utilities,Nt,1)-repmat(Utilities',1,Nt));
        popMovements=proba.*repmat(R',1,Nt);
        xdot=-sum(popMovements,2)'+sum(popMovements,1);
        history.DLyap1(iter)=sum(sum(repmat(xdot',1,Nt).*psi)); 
        uD=population.uD{1}(history.arrivalTimes(iter,:));
        T=history.arrivalTimes(iter,:)-departureTimes;
        D=triu(cumprod(max(repmat(T>0,Nt,1),tril(ones(Nt),-1)),2),1);
        dU=(-D.*uD-diag((T>0).*uD/2))/congestion.S;
        history.DLyap2(iter)=xdot*dU*xdot';
    end
    
    % Compute new R
    [R,history.shifts(iter)] = updateDeparturesContinuum(R,Utilities,revisionProtocol);
    epoch=epoch+history.shifts(iter);
    % Run_script_making_plots
    if strcmp(settings.display,'on')||(strcmp(settings.display,'final')&& iter==settings.maxIter)
        fprintf('iteration %i\n',iter);
        makePlotsContinuum;
        if exist(settings.additionalPlots,'file')==2 % 2 is the code that exist returns when a file with this name exists
            run(settings.additionalPlots);
        end
    end
    % save history
%     history.U(:,:,iter)=Utilities;
if mod(iter,1000)==0
    fprintf('iter=%i,epoch=%i\n',iter,epoch);
end
end
history.TU=history.TU(1:iter);
history.potGain=history.potGain(1:iter);
% history.R=history.R(:,:,1:iter);  % history of state variable
% history.U=history.U(:,:,1:iter);
history.shifts=history.shifts(1:iter);          % history of utilities
history.arrivalTimes=history.arrivalTimes(1:iter,:);
history.Lyap=history.Lyap(1:iter);
history.DLyap1=history.DLyap1(1:iter);
history.DLyap2=history.DLyap2(1:iter);
finalState.t=t;
finalState.n=n;
