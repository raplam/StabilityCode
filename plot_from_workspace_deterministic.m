clear all
close all

% load('workspace_deterministe')
load('workspace_deterministe_light', 'AllCumShifts','AllLyap','AllIter','lambda','du')

screensize = get( groot, 'Screensize' );
figDelta=figure(1);
set(figDelta,'Position',[0,0,screensize(3)/2,screensize(4)]);

col=get(gca,'colororder');
longcol=parula(10);

for i=1:length(lambda)
    for indu=1:length(du)
        figure(figDelta)
        subplot(1,2,1) % Net gain
        if du(indu)>0
            semilogy(AllCumShifts{i,indu},AllLyap{i,indu},'--','Color',col(i,:));
        else
            semilogy(AllCumShifts{i,indu},AllLyap{i,indu},'-','Color',col(i,:));
        end
        hold on

        subplot(1,2,2) % Number of iterations
        if du(indu)>0
            semilogy(AllCumShifts{i,indu},AllIter{i,indu},'--','Color',col(i,:));
        else
            semilogy(AllCumShifts{i,indu},AllIter{i,indu},'-','Color',col(i,:));
        end
        hold on
    end
end
figure(figDelta)
subplot(1,2,1)
xlabel('Average number of updates (per user)');
ylabel('Net gain');
title('(a)');
xlim([0,5]);
ylim([10^(-8);10^(-1)])
set(gca, 'ytick', [10^(-8);10^(-6);10^(-4);10^(-2)]);
legend({'$\lambda=10^{-3}$ (PM) ',...
    '$\lambda=10^{-3}$ (AM)',...
    '$\lambda=10^{-2}$ (PM)',...
    '$\lambda=10^{-2}$ (AM)',...
    '$\lambda=10^{-1}$ (PM)',...
    '$\lambda=10^{-1}$ (AM)',...
    '$\lambda=1$ (PM)',...
    '$\lambda=1$ (AM)'},'fontsize',11,'NumColumns',2);

subplot(1,2,2)
xlim([0,5]);
ylim([1;10^8])
xlabel('Average number of updates (per user)');
ylabel('Number of iterations');
title('(b)');
set(gca, 'ytick', [1;10^2;10^4;10^6;10^8]);

savefig(figDelta,'figDelta.fig','compact');
saveas(figDelta,'figDelta','epsc');