%% Context
% This function is called by runIterationsContinuumStochastic.m if settings.display is
% either 'on', or 'final'.

figure(1)
% Dynamics
subplot(311)
plot(t,T);
xlabel('Time');
ylabel('Travel time');
% xlim([t(1,1),t(1,end)]);
hold off

subplot(312)
plot(t,cumUsers);
xlabel('Time');
ylabel('cumUsers');
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
    [newUtilities,newt,newT,~]=DynamicsWithParallelBottlenecks(departureTimes,newR,congestion.S,population,congestion.Tf);
    subplot(211)
    newT2=interp1(newt,newT,t,'linear','extrap');
    plot(t,(newT2-T)/dn);
    xlabel('Departure time');
    ylabel('Travel time difference');
    hold on
    subplot(212)
    plot(departureTimes,(newUtilities-Utilities)/dn);
    hold on
    xlabel('Departure time');
    ylabel('Utility difference');
end
    