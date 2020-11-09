clear all
close all
load("workspace_stochasticity_light")
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
plot(t_stoch,n_stoch);
xlabel('Time');
ylabel('Queue length');

figure(4)
plot(departureTimes,cumsum(R_stoch),'r');
xlabel('Time');
ylabel('Cumulative departures');