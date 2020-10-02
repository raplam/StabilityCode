%% Context
% This function is called by runIterationsContinuumStochastic.m if settings.display is
% either 'on', or 'final'.

figure(1)
% Dynamics
subplot(311)
plot(t',n');
xlabel('Time');
ylabel('Travel time');
% xlim([t(1,1),t(1,end)]);
hold off

subplot(312)
plot(departureTimes,R);
xlabel('Time');
ylabel('departure rate');
% xlim([t(1,1),t(1,end)]);
hold off

% Convergence
subplot(313)
semilogy(1:iter,history.potGain(1:iter));
xlabel('Iterations');
ylabel('Potential gain');
pause(0.01)

% Plot externalities
dn=0.00001;
figure(2)
subplot(211)
hold off
subplot(212)
hold off
ind=round(Nt/30):round(Nt/30):Nt;
for i=1:length(ind)
    newR=R;
    newR(ind(i))=newR(ind(i))+dn;
    %
    t=NaN(Ns,2*Nt);
    Ttmp=NaN(Ns,2*Nt);
    U=zeros(population.N,Nt,Ns);
    arrivalTimesTmp=zeros(Ns,Nt);
    for inds=1:Ns
        [Utmp,ttmp,ntmp,arrivalTimesTmp(inds,:),~]=BottleneckDynamicsAndUtilityEvaluation(departureTimes,newR,congestion.S(inds),population);
        t(inds,1:length(ttmp))=ttmp;
        U(:,:,inds)=reshape(Utmp,[population.N,Nt,1]);
    end
    newUtilities=mean(U,3);
    avgArrivalTimes=mean(arrivalTimesTmp,1);
    subplot(211)
    plot(departureTimes,(avgArrivalTimes-reshape(mean(history.arrivalTimes(iter,:,:),3),1,[]))/dn);
    xlabel('Departure time');
    ylabel('Travel time difference');
    hold on
    subplot(212)
    plot(departureTimes,(newUtilities-Utilities)/dn);
    hold on
    xlabel('Departure time');
    ylabel('Utility difference');
end
