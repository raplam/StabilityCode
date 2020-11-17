clear all
close all

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

load('workspace_deterministe_light2', 'AllCumShifts','AllLyap','AllIter','AllPotGain','lambda','du')

screensize = get( groot, 'Screensize' );
figDelta=figure(1);
set(figDelta,'Position',[0,0,screensize(3)/2,screensize(4)]);

col=get(gca,'colororder');
longcol=parula(10);

for i=1:length(lambda)
    for indu=1:length(du)
        figure(figDelta)
        subplot(3,1,1) % Net gain
        if du(indu)>0
            plot(AllCumShifts{i,indu},AllPotGain{i,indu},'--','Color',col(i,:));
        else
            plot(AllCumShifts{i,indu},AllPotGain{i,indu},'-','Color',col(i,:));
        end
        hold on
        
        subplot(3,1,2) % Net gain
        if du(indu)>0
            semilogy(AllCumShifts{i,indu},AllLyap{i,indu},'--','Color',col(i,:));
        else
            semilogy(AllCumShifts{i,indu},AllLyap{i,indu},'-','Color',col(i,:));
        end
        hold on

        subplot(3,1,3) % Number of iterations
        if du(indu)>0
            semilogy(AllCumShifts{i,indu},AllIter{i,indu},'--','Color',col(i,:));
        else
            semilogy(AllCumShifts{i,indu},AllIter{i,indu},'-','Color',col(i,:));
        end
        hold on
    end
end
figure(figDelta)
subplot(3,1,1)
xlabel('Average number of updates (per user)');
ylabel('Potential gain [\%]');
title('(a)');
xlim([0,5]);
legend({'$\lambda=10^{-3}$ (PM) ',...
    '$\lambda=10^{-3}$ (AM)',...
    '$\lambda=10^{-2}$ (PM)',...
    '$\lambda=10^{-2}$ (AM)',...
    '$\lambda=10^{-1}$ (PM)',...
    '$\lambda=10^{-1}$ (AM)',...
    '$\lambda=1$ (PM)',...
    '$\lambda=1$ (AM)'},'fontsize',11,'NumColumns',2);

subplot(3,1,2)
xlabel('Average number of updates (per user)');
ylabel('Net gain');
title('(b)');
xlim([0,5]);
ylim([10^(-8);10^(-1)])
set(gca, 'ytick', [10^(-8);10^(-6);10^(-4);10^(-2)]);

subplot(3,1,3)
xlim([0,5]);
ylim([1;10^8])
xlabel('Average number of updates (per user)');
ylabel('Number of iterations');
title('(c)');
set(gca, 'ytick', [1;10^2;10^4;10^6;10^8]);
