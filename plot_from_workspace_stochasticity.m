clear all
close all
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

load("workspace_stochasticity_light2")
for ind_std=1:length(std)
    for ind_w=1:length(w)
        figure(2)
        subplot(length(std),length(w),ind_w+(ind_std-1)*length(w))
        semilogy(AllCumShifts{ind_std,ind_w},AllLyap{ind_std,ind_w},'r');
        hold on
        xlabel('Average decision updates');
        ylabel('Net gain');
        xlim([0,5]);
        title(['$w=',num2str(w(ind_w)),', \Delta S=\pm',num2str(100*std(ind_std)),'\%$']);
        for i=1:10:length(Capacity)
            figure(2)
            subplot(length(std),length(w),ind_w+(ind_std-1)*length(w))
            semilogy(AllCumShiftsDet{ind_std,ind_w,i},AllLyapDet{ind_std,ind_w,i},'k');
            hold on
        end
    end
end
ylim([10^(-8);10^(-1)])
set(gca, 'ytick', [10^(-8);10^(-6);10^(-4);10^(-2)]);

subplot(length(std),length(w),1)
legend({'Stochastic','Deterministic'});

figure(3)
subplot(121)
plot(departureTimes,cumsum(R_stoch),'r');
hold on
plot(ta_stoch(:,[1,11,21]),cumsum(R_stoch),'k')
xlabel('Time [h]');
ylabel('Cumulative number of users');
title('(a)');
xlim([-1.5,1.5]);
 ylim([0,1]);
legend({'Departures','Arrivals'});
path(genpath(cd),path);

std=0.2;
w=1;
tstar=0;
Na=10^3;
population=generateSParctan(tstar,0.5,1.5,1,w);%
Capacity=0.5*(1-std:std:1+std);

for i=1:length(Capacity)
    congestion=generateBottleneck(Capacity(i));
    congestion=computeEquilibriumBottleneck(Na,congestion,population);
    figure(3)
    subplot(122)
    [t,ind]=sort(congestion.eqDepartures);
    plot(congestion.eqArrivals(ind),1/Na:1/Na:1,'-k');
    hold on
    plot(t,1/Na:1/Na:1,'-r');
end
 xlim([-1.5,1.5]);
 ylim([0,1]);
 xlabel('Time [h]');
ylabel('Cumulative number of users');
title('(b)');


