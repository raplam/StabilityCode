function [Utilities,tin,T,cumUsers]=DynamicsWithParallelBottlenecks(departureTimes,R,S,population,Tf)
Ns=numel(S);
if Ns~=numel(Tf)
    error('S and Tf have the same number of elements');
end
if ~issorted(reshape(Tf,[],1)) || numel(unique(Tf))<numel(Tf)
    error('Tf should be sorted and only include unique elements');
end
Nt=length(departureTimes);
dT=unique(departureTimes(2:Nt)-departureTimes(1:(Nt-1)));
if length(dT)>1
    if max(dT)-min(dT)>10^-14 % this is not a numerical error.
        error('Departure Times are assumed to be uniformly spaced');
    else
        dT=mean(dT);
    end
end
r=sum(R,1)/dT;
% state variables
T=zeros(1,Nt*(Ns+1)); % queue for all bottlenecks at all times
tin=zeros(1,Nt*(Ns+1));% The final size is unknown (it depends on the number of transitions), so the memory allocation is overestimated. In the worst case, for every departure time, we have Ns transitions.
tin(1)=departureTimes(1)-dT/2;
T(1)=Tf(1);
ProportionOfDepartures=zeros(Nt,Nt*(Ns+1));
Utilities=zeros(population.N,Nt);
k=2; % index within tin.
indDep=1;
timeBeforeNewDep=dT;
while indDep<=Nt
    % Compute Tdot
    nb=sum(Tf<=T(k-1)); % how many bottlenecks can potentially be used. The last one is not necessarily used, if T=Tf T decreasing.
    if T(k-1)>Tf(nb)
        Tdot=r(indDep)-sum(S(1:nb));
    else
        if nb>1
            if r(indDep)>sum(S(1:(nb-1))) % the nb'th bottleneck will also be used.
                Tdot=max(r(indDep)-sum(S(1:nb)),0);
            else
                Tdot=r(indDep)-sum(S(1:(nb-1)));
            end
        else
            Tdot=max(r(indDep)-S(1),0);
        end
    end
    % Test for capacity transitions
    newT=T(k-1)+Tdot*timeBeforeNewDep;
    if sum(Tf<newT)>nb % an additional bottleneck should start getting used in the current departure interval
        T(k)=Tf(sum(Tf<newT));
        intervalDuration=(T(k)-T(k-1))/Tdot;
        tin(k)=tin(k-1)+intervalDuration;
        ProportionOfDepartures(indDep,k)=intervalDuration/dT;
        timeBeforeNewDep=timeBeforeNewDep-intervalDuration;
    elseif sum(Tf<newT)<sum(Tf<T(k-1)) % capacity should decrease earlier
        T(k)=Tf(sum(Tf<T(k-1)));
        intervalDuration=(T(k)-T(k-1))/Tdot;
        tin(k)=tin(k-1)+intervalDuration;
        ProportionOfDepartures(indDep,k)=intervalDuration/dT;
        timeBeforeNewDep=timeBeforeNewDep-intervalDuration;
    else % next event is a change in inflow
        T(k)=newT;
        tin(k)=departureTimes(indDep)+dT/2;
        ProportionOfDepartures(indDep,k)=timeBeforeNewDep/dT;
        timeBeforeNewDep=dT;
        indDep=indDep+1;
    end
    k=k+1;
end
tin=tin(1:k-1);
T=T(1:k-1);
for i=1:population.N
    avgUO=(population.intUO{i}(tin(2:end))-population.intUO{i}(tin(1:end-1)))./(tin(2:end)-tin(1:end-1));
    avgUD=(population.intUD{i}(tin(2:end)+T(2:end))-population.intUD{i}(tin(1:end-1)+T(1:end-1)))./(tin(2:end)+T(2:end)-tin(1:end-1)-T(1:end-1));
    Utilities(i,:)=ProportionOfDepartures(:,2:k-1)*(avgUO+avgUD)';
end
cumUsers=cumsum(R*ProportionOfDepartures(:,1:k-1),2);   
end